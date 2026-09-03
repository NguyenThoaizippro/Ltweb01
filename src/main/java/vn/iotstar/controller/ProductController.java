package vn.iotstar.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import vn.iotstar.entity.Category;
import vn.iotstar.entity.Product;
import vn.iotstar.service.ICategoryService;
import vn.iotstar.service.IProductService;
import vn.iotstar.service.impl.CategoryServiceImpl;
import vn.iotstar.service.impl.ProductServiceImpl;
import vn.iotstar.util.Constant;

import java.io.File;
import java.io.IOException;
import java.math.BigDecimal;
import java.nio.file.Paths;
import java.util.List;

@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,
    maxFileSize = 5 * 1024 * 1024,       // 5MB max file size
    maxRequestSize = 10 * 1024 * 1024     // 10MB total request
)
@WebServlet(urlPatterns = {
    "/admin/products",
    "/admin/product/add",
    "/admin/product/insert",
    "/admin/product/edit",
    "/admin/product/update",
    "/admin/product/delete",
    "/product",
    "/product/detail"
})
public class ProductController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private final IProductService productService;
    private final ICategoryService cateService;

    public ProductController() {
        this.productService = new ProductServiceImpl();
        this.cateService = new CategoryServiceImpl();
    }

    public ProductController(IProductService productService, ICategoryService cateService) {
        this.productService = productService;
        this.cateService = cateService;
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String url = req.getRequestURI();

        if (url.contains("/admin/products")) {
            List<Product> list = productService.findAll();
            req.setAttribute("listProduct", list);
            req.getRequestDispatcher("/views/admin/product-list.jsp").forward(req, resp);
        } else if (url.contains("/admin/product/add")) {
            List<Category> categories = cateService.findAll();
            req.setAttribute("categories", categories);
            req.getRequestDispatcher("/views/admin/product-add.jsp").forward(req, resp);
        } else if (url.contains("/admin/product/edit")) {
            int id = Integer.parseInt(req.getParameter("id"));
            Product product = productService.findById(id);
            List<Category> categories = cateService.findAll();
            req.setAttribute("product", product);
            req.setAttribute("categories", categories);
            req.getRequestDispatcher("/views/admin/product-edit.jsp").forward(req, resp);
        } else if (url.contains("/admin/product/delete")) {
            int id = Integer.parseInt(req.getParameter("id"));
            try {
                Product product = productService.findById(id);
                if (product != null && product.getImages() != null && !product.getImages().startsWith("http")) {
                    deleteFile(Constant.DIR + "/" + product.getImages());
                }
                productService.delete(id);
            } catch (Exception e) {
                e.printStackTrace();
            }
            resp.sendRedirect(req.getContextPath() + "/admin/products");
        } else if (url.contains("/product/detail")) {
            try {
                int id = Integer.parseInt(req.getParameter("id"));
                Product product = productService.findById(id);
                req.setAttribute("product", product);
                req.getRequestDispatcher("/views/product-detail.jsp").forward(req, resp);
            } catch (Exception e) {
                resp.sendRedirect(req.getContextPath() + "/product");
            }
        } else if (url.endsWith("/product") || url.contains("/product?")) {
            int page = 0;
            try {
                String pageParam = req.getParameter("page");
                if (pageParam != null) {
                    page = Math.max(0, Integer.parseInt(pageParam));
                }
            } catch (Exception ignored) {}

            int pageSize = 6;
            int total = productService.count();
            int totalPages = (int) Math.ceil((double) total / pageSize);
            if (totalPages == 0) totalPages = 1;

            List<Product> list = productService.findAll(page, pageSize);
            req.setAttribute("listProduct", list);
            req.setAttribute("currentPage", page);
            req.setAttribute("totalPages", totalPages);
            req.getRequestDispatcher("/views/product-list.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");

        String url = req.getRequestURI();

        if (url.contains("/admin/product/insert")) {
            String name = req.getParameter("productName");
            String desc = req.getParameter("description");
            String priceStr = req.getParameter("price");
            int status = Integer.parseInt(req.getParameter("status"));
            int categoryId = Integer.parseInt(req.getParameter("categoryId"));
            String linkImages = req.getParameter("images");

            Part part = req.getPart("images1");
            String filename = handleUpload(part, linkImages);

            Category category = cateService.findById(categoryId);
            Product product = new Product();
            product.setProductName(name);
            product.setDescription(desc);
            product.setPrice(new BigDecimal(priceStr));
            product.setStatus(status);
            product.setCategory(category);
            product.setImages(filename);

            productService.insert(product);
            resp.sendRedirect(req.getContextPath() + "/admin/products");

        } else if (url.contains("/admin/product/update")) {
            int id = Integer.parseInt(req.getParameter("productId"));
            String name = req.getParameter("productName");
            String desc = req.getParameter("description");
            String priceStr = req.getParameter("price");
            int status = Integer.parseInt(req.getParameter("status"));
            int categoryId = Integer.parseInt(req.getParameter("categoryId"));
            String linkImages = req.getParameter("images");

            Product product = productService.findById(id);
            String oldFile = product.getImages();

            Part part = req.getPart("images1");
            if (part != null && part.getSize() > 0) {
                // Delete old file if local
                if (oldFile != null && !oldFile.startsWith("http")) {
                    deleteFile(Constant.DIR + "/" + oldFile);
                }
                String filename = handleUpload(part, null);
                product.setImages(filename);
            } else if (linkImages != null && !linkImages.trim().isEmpty()) {
                product.setImages(linkImages.trim());
            }

            Category category = cateService.findById(categoryId);
            product.setProductName(name);
            product.setDescription(desc);
            product.setPrice(new BigDecimal(priceStr));
            product.setStatus(status);
            product.setCategory(category);

            productService.update(product);
            resp.sendRedirect(req.getContextPath() + "/admin/products");
        }
    }

    private String handleUpload(Part part, String fallbackLink) throws IOException, ServletException {
        if (part != null && part.getSize() > 0) {
            String submittedFileName = Paths.get(part.getSubmittedFileName()).getFileName().toString();
            String ext = "";
            int dotIndex = submittedFileName.lastIndexOf(".");
            if (dotIndex >= 0) {
                ext = submittedFileName.substring(dotIndex).toLowerCase();
            }

            if (!ext.matches("(?i)\\.(jpg|jpeg|png|gif|webp)")) {
                throw new ServletException("Định dạng file không hợp lệ! Chỉ cho phép JPG, JPEG, PNG, GIF, WEBP.");
            }

            String fname = System.currentTimeMillis() + ext;
            File dir = new File(Constant.DIR);
            if (!dir.exists()) {
                dir.mkdirs();
            }
            part.write(Constant.DIR + "/" + fname);
            return fname;
        } else if (fallbackLink != null && !fallbackLink.trim().isEmpty()) {
            return fallbackLink.trim();
        }
        return "avatar.png";
    }

    private static void deleteFile(String filePath) {
        try {
            File file = new File(filePath);
            if (file.exists()) {
                file.delete();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
