package vn.iotstar.controller;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import vn.iotstar.entity.Category;
import vn.iotstar.service.ICategoryService;
import vn.iotstar.service.impl.CategoryServiceImpl;
import vn.iotstar.util.Constant;

@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,
    maxFileSize = 5 * 1024 * 1024,
    maxRequestSize = 10 * 1024 * 1024
)
@WebServlet(urlPatterns = { "/admin/categories", "/admin/category/add", "/admin/category/insert",
		"/admin/category/edit", "/admin/category/update", "/admin/category/delete" })
public class CategoryController extends HttpServlet {
	private static final long serialVersionUID = 1L;
	public ICategoryService cateService;

	public CategoryController() {
		this.cateService = new CategoryServiceImpl();
	}

	public CategoryController(ICategoryService cateService) {
		this.cateService = cateService;
	}

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		String url = req.getRequestURI();
		if (url.contains("/admin/categories")) {
			List<Category> list = cateService.findAll();
			req.setAttribute("listcate", list);
			req.getRequestDispatcher("/views/admin/category-list.jsp").include(req, resp);
		} else if (url.contains("/admin/category/add")) {
			req.getRequestDispatcher("/views/admin/category-add.jsp").include(req, resp);
		} else if (url.contains("/admin/category/edit")) {
			try {
				int id = Integer.parseInt(req.getParameter("id"));
				Category category = cateService.findById(id);
				if (category == null) {
					resp.sendRedirect(req.getContextPath() + "/admin/categories");
					return;
				}
				req.setAttribute("cate", category);
				req.getRequestDispatcher("/views/admin/category-edit.jsp").include(req, resp);
			} catch (Exception e) {
				resp.sendRedirect(req.getContextPath() + "/admin/categories");
			}
		} else if (url.contains("/admin/category/delete")) {
			try {
				int id = Integer.parseInt(req.getParameter("id"));
				cateService.delete(id);
			} catch (Exception e) {
				e.printStackTrace();
			}
			resp.sendRedirect(req.getContextPath() + "/admin/categories");
		}
	}

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		req.setCharacterEncoding("UTF-8");
		resp.setCharacterEncoding("UTF-8");

		String url = req.getRequestURI();
		if (url.contains("/admin/category/insert")) {
			String categoryname = req.getParameter("categoryname");
			String statusStr = req.getParameter("status");
			String images = req.getParameter("images");

			int status = "0".equals(statusStr) ? 0 : 1;

			// Server-side validation
			if (categoryname == null || categoryname.trim().isEmpty()) {
				req.setAttribute("alert", "Tên danh mục không được để trống!");
				req.setAttribute("categoryname", categoryname);
				req.setAttribute("images", images);
				req.setAttribute("status", status);
				req.getRequestDispatcher("/views/admin/category-add.jsp").include(req, resp);
				return;
			}

			categoryname = categoryname.trim();
			if (categoryname.length() < 2 || categoryname.length() > 50) {
				req.setAttribute("alert", "Tên danh mục phải có độ dài từ 2 đến 50 ký tự!");
				req.setAttribute("categoryname", categoryname);
				req.setAttribute("images", images);
				req.setAttribute("status", status);
				req.getRequestDispatcher("/views/admin/category-add.jsp").include(req, resp);
				return;
			}

			try {
				Category existing = cateService.findByCategoryname(categoryname);
				if (existing != null) {
					req.setAttribute("alert", "Tên danh mục '" + categoryname + "' đã tồn tại! Vui lòng chọn tên khác.");
					req.setAttribute("categoryname", categoryname);
					req.setAttribute("images", images);
					req.setAttribute("status", status);
					req.getRequestDispatcher("/views/admin/category-add.jsp").include(req, resp);
					return;
				}
			} catch (Exception ignored) {}

			Category category = new Category();
			category.setCategoryname(categoryname);
			category.setStatus(status);

			String fname = "";
			String uploadPath = Constant.DIR;
			File uploadDir = new File(uploadPath);
			if (!uploadDir.exists()) uploadDir.mkdirs();

			try {
				Part part = req.getPart("images1");
				if (part != null && part.getSize() > 0) {
					String filename = Paths.get(part.getSubmittedFileName()).getFileName().toString();
					int index = filename.lastIndexOf(".");
					String ext = index >= 0 ? filename.substring(index) : ".png";
					fname = "category_" + System.currentTimeMillis() + ext;
					part.write(uploadPath + File.separator + fname);
					category.setImages(fname);
				} else if (images != null && !images.trim().isEmpty()) {
					category.setImages(images.trim());
				} else {
					category.setImages("category_default.png");
				}
			} catch (Exception e) {
				category.setImages("category_default.png");
			}

			cateService.insert(category);
			resp.sendRedirect(req.getContextPath() + "/admin/categories");
			return;
		}

		if (url.contains("/admin/category/update")) {
			int categoryid = 0;
			try {
				categoryid = Integer.parseInt(req.getParameter("categoryid"));
			} catch (Exception e) {
				resp.sendRedirect(req.getContextPath() + "/admin/categories");
				return;
			}

			String categoryname = req.getParameter("categoryname");
			String statusStr = req.getParameter("status");
			String images = req.getParameter("images");
			int status = "0".equals(statusStr) ? 0 : 1;

			Category category = cateService.findById(categoryid);
			if (category == null) {
				resp.sendRedirect(req.getContextPath() + "/admin/categories");
				return;
			}

			// Server-side validation
			if (categoryname == null || categoryname.trim().isEmpty()) {
				req.setAttribute("alert", "Tên danh mục không được để trống!");
				req.setAttribute("cate", category);
				req.getRequestDispatcher("/views/admin/category-edit.jsp").include(req, resp);
				return;
			}

			categoryname = categoryname.trim();
			if (categoryname.length() < 2 || categoryname.length() > 50) {
				req.setAttribute("alert", "Tên danh mục phải có độ dài từ 2 đến 50 ký tự!");
				req.setAttribute("cate", category);
				req.getRequestDispatcher("/views/admin/category-edit.jsp").include(req, resp);
				return;
			}

			try {
				Category existing = cateService.findByCategoryname(categoryname);
				if (existing != null && existing.getCategoryid() != categoryid) {
					req.setAttribute("alert", "Tên danh mục '" + categoryname + "' đã trùng với danh mục khác!");
					req.setAttribute("cate", category);
					req.getRequestDispatcher("/views/admin/category-edit.jsp").include(req, resp);
					return;
				}
			} catch (Exception ignored) {}

			String fileold = category.getImages();
			category.setCategoryname(categoryname);
			category.setStatus(status);

			String uploadPath = Constant.DIR;
			File uploadDir = new File(uploadPath);
			if (!uploadDir.exists()) uploadDir.mkdirs();

			try {
				Part part = req.getPart("images1");
				if (part != null && part.getSize() > 0) {
					if (fileold != null && !fileold.startsWith("http")) {
						deleteFile(uploadPath + File.separator + fileold);
					}
					String filename = Paths.get(part.getSubmittedFileName()).getFileName().toString();
					int index = filename.lastIndexOf(".");
					String ext = index >= 0 ? filename.substring(index) : ".png";
					String fname = "category_" + System.currentTimeMillis() + ext;
					part.write(uploadPath + File.separator + fname);
					category.setImages(fname);
				} else if (images != null && !images.trim().isEmpty()) {
					category.setImages(images.trim());
				}
			} catch (Exception e) {
				e.printStackTrace();
			}

			cateService.update(category);
			resp.sendRedirect(req.getContextPath() + "/admin/categories");
		}
	}

	public static void deleteFile(String filePath) {
		try {
			Path path = Paths.get(filePath);
			Files.deleteIfExists(path);
		} catch (Exception ignored) {}
	}
}
