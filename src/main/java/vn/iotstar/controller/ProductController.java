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

            String keyword = req.getParameter("keyword");
            String catIdStr = req.getParameter("categoryId");

            List<Category> categories = cateService.findAll();
            req.setAttribute("categories", categories);

            int pageSize = 6; // Yêu cầu hiển thị 6 sản phẩm 1 trang
            int total = 0;
            List<Product> list;

            if (keyword != null && !keyword.trim().isEmpty()) {
                String kw = keyword.trim();
                total = productService.countSearch(kw);
                list = productService.searchByName(kw, page, pageSize);
                req.setAttribute("keyword", kw);
            } else if (catIdStr != null && !catIdStr.trim().isEmpty()) {
                try {
                    int catId = Integer.parseInt(catIdStr.trim());
                    total = productService.countByCategory(catId);
                    list = productService.findByCategory(catId, page, pageSize);
                    req.setAttribute("selectedCatId", catId);
                } catch (Exception e) {
                    total = productService.count();
                    list = productService.findAll(page, pageSize);
                }
            } else {
                total = productService.count();
                list = productService.findAll(page, pageSize);
            }

            int totalPages = (int) Math.ceil((double) total / pageSize);
            if (totalPages == 0) totalPages = 1;

            req.setAttribute("listProduct", list);
            req.setAttribute("currentPage", page);
            req.setAttribute("totalPages", totalPages);
            req.setAttribute("totalCount", total);
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
            String statusStr = req.getParameter("status");
            String categoryIdStr = req.getParameter("categoryId");
            String linkImages = req.getParameter("images");

            int status = "0".equals(statusStr) ? 0 : 1;
            int categoryId = 0;
            try {
                if (categoryIdStr != null) categoryId = Integer.parseInt(categoryIdStr);
            } catch (Exception ignored) {}

            // Server-side validation
            if (name == null || name.trim().isEmpty()) {
                forwardAddWithError(req, resp, "Tên sản phẩm không được để trống!", name, desc, priceStr, status, categoryId, linkImages);
                return;
            }
            name = name.trim();
            if (name.length() < 2 || name.length() > 255) {
                forwardAddWithError(req, resp, "Tên sản phẩm phải có độ dài từ 2 đến 255 ký tự!", name, desc, priceStr, status, categoryId, linkImages);
                return;
            }

            if (priceStr == null || priceStr.trim().isEmpty()) {
                forwardAddWithError(req, resp, "Giá sản phẩm không được để trống!", name, desc, priceStr, status, categoryId, linkImages);
                return;
            }

            BigDecimal price;
            try {
                price = new BigDecimal(priceStr.trim());
                if (price.compareTo(BigDecimal.ZERO) < 0) {
                    forwardAddWithError(req, resp, "Giá sản phẩm phải lớn hơn hoặc bằng 0!", name, desc, priceStr, status, categoryId, linkImages);
                    return;
                }
            } catch (Exception e) {
                forwardAddWithError(req, resp, "Giá sản phẩm phải là một số hợp lệ!", name, desc, priceStr, status, categoryId, linkImages);
                return;
            }

            Category category = categoryId > 0 ? cateService.findById(categoryId) : null;
            if (category == null) {
                forwardAddWithError(req, resp, "Vui lòng chọn danh mục hợp lệ!", name, desc, priceStr, status, categoryId, linkImages);
                return;
            }

            Part part = req.getPart("images1");
            String filename;
            try {
                filename = handleUpload(part, linkImages);
            } catch (Exception e) {
                forwardAddWithError(req, resp, e.getMessage(), name, desc, priceStr, status, categoryId, linkImages);
                return;
            }

            Product product = new Product();
            product.setProductName(name);
            product.setDescription(desc);
            product.setPrice(price);
            product.setStatus(status);
            product.setCategory(category);
            product.setImages(filename);

            productService.insert(product);
            resp.sendRedirect(req.getContextPath() + "/admin/products");

        } else if (url.contains("/admin/product/update")) {
            int id = 0;
            try {
                id = Integer.parseInt(req.getParameter("productId"));
            } catch (Exception e) {
                resp.sendRedirect(req.getContextPath() + "/admin/products");
                return;
            }

            Product product = productService.findById(id);
            if (product == null) {
                resp.sendRedirect(req.getContextPath() + "/admin/products");
                return;
            }

            String name = req.getParameter("productName");
            String desc = req.getParameter("description");
            String priceStr = req.getParameter("price");
            String statusStr = req.getParameter("status");
            String categoryIdStr = req.getParameter("categoryId");
            String linkImages = req.getParameter("images");

            int status = "0".equals(statusStr) ? 0 : 1;
            int categoryId = 0;
            try {
                if (categoryIdStr != null) categoryId = Integer.parseInt(categoryIdStr);
            } catch (Exception ignored) {}

            // Server-side validation
            if (name == null || name.trim().isEmpty()) {
                forwardEditWithError(req, resp, product, "Tên sản phẩm không được để trống!");
                return;
            }
            name = name.trim();
            if (name.length() < 2 || name.length() > 255) {
                forwardEditWithError(req, resp, product, "Tên sản phẩm phải có độ dài từ 2 đến 255 ký tự!");
                return;
            }

            if (priceStr == null || priceStr.trim().isEmpty()) {
                forwardEditWithError(req, resp, product, "Giá sản phẩm không được để trống!");
                return;
            }

            BigDecimal price;
            try {
                price = new BigDecimal(priceStr.trim());
                if (price.compareTo(BigDecimal.ZERO) < 0) {
                    forwardEditWithError(req, resp, product, "Giá sản phẩm phải lớn hơn hoặc bằng 0!");
                    return;
                }
            } catch (Exception e) {
                forwardEditWithError(req, resp, product, "Giá sản phẩm phải là một số hợp lệ!");
                return;
            }

            Category category = categoryId > 0 ? cateService.findById(categoryId) : null;
            if (category == null) {
                forwardEditWithError(req, resp, product, "Vui lòng chọn danh mục hợp lệ!");
                return;
            }

            String oldFile = product.getImages();
            Part part = req.getPart("images1");
            if (part != null && part.getSize() > 0) {
                try {
                    String filename = handleUpload(part, null);
                    if (oldFile != null && !oldFile.startsWith("http")) {
                        deleteFile(Constant.DIR + "/" + oldFile);
                    }
                    product.setImages(filename);
                } catch (Exception e) {
                    forwardEditWithError(req, resp, product, e.getMessage());
                    return;
                }
            } else if (linkImages != null && !linkImages.trim().isEmpty()) {
                product.setImages(linkImages.trim());
            }

            product.setProductName(name);
            product.setDescription(desc);
            product.setPrice(price);
            product.setStatus(status);
            product.setCategory(category);

            productService.update(product);
            resp.sendRedirect(req.getContextPath() + "/admin/products");
        }
    }

    private void forwardAddWithError(HttpServletRequest req, HttpServletResponse resp, String alertMsg,
                                     String name, String desc, String priceStr, int status, int categoryId, String linkImages)
            throws ServletException, IOException {
        req.setAttribute("alert", alertMsg);
        req.setAttribute("productName", name);
        req.setAttribute("description", desc);
        req.setAttribute("price", priceStr);
        req.setAttribute("status", status);
        req.setAttribute("categoryId", categoryId);
        req.setAttribute("images", linkImages);
        try {
            req.setAttribute("categories", cateService.findAll());
        } catch (Exception ignored) {}
        req.getRequestDispatcher("/views/admin/product-add.jsp").forward(req, resp);
    }

    private void forwardEditWithError(HttpServletRequest req, HttpServletResponse resp, Product product, String alertMsg)
            throws ServletException, IOException {
        req.setAttribute("alert", alertMsg);
        req.setAttribute("product", product);
        try {
            req.setAttribute("categories", cateService.findAll());
        } catch (Exception ignored) {}
        req.getRequestDispatcher("/views/admin/product-edit.jsp").forward(req, resp);
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

            String fname = "prod_" + System.currentTimeMillis() + ext;
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

    public static void deleteFile(String filePath) {
        try {
            File file = new File(filePath);
            if (file.exists()) {
                file.delete();
            }
        } catch (Exception ignored) {}
    }
}
