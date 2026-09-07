package vn.iotstar.controller;

import java.io.IOException;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import vn.iotstar.entity.Product;
import vn.iotstar.service.IProductService;
import vn.iotstar.service.impl.ProductServiceImpl;

@WebServlet(urlPatterns = "/home")
public class HomeController extends HttpServlet {

	private static final long serialVersionUID = 1L;
	private final IProductService productService;
	private final vn.iotstar.service.ICategoryService cateService;

	public HomeController() {
		this.productService = new ProductServiceImpl();
		this.cateService = new vn.iotstar.service.impl.CategoryServiceImpl();
	}

	public HomeController(IProductService productService, vn.iotstar.service.ICategoryService cateService) {
		this.productService = productService;
		this.cateService = cateService;
	}

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		HttpSession session = req.getSession(false);
		if (session == null || session.getAttribute("account") == null) {
			resp.sendRedirect(req.getContextPath() + "/login");
			return;
		}

		try {
			List<Product> top6 = productService.findTopN(6);
			req.setAttribute("top10", top6);
			req.setAttribute("top6", top6);
			req.setAttribute("categories", cateService.findAll());
		} catch (Exception e) {
			e.printStackTrace();
		}

		req.getRequestDispatcher("/views/home.jsp").forward(req, resp);
	}
}
