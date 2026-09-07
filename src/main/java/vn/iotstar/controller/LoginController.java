package vn.iotstar.controller;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import vn.iotstar.entity.User;
import vn.iotstar.service.UserService;
import vn.iotstar.service.impl.UserServiceImpl;
import vn.iotstar.util.Constant;
import vn.iotstar.util.PasswordUtil;

@WebServlet(urlPatterns = { "/login" })
public class LoginController extends HttpServlet {

	private static final long serialVersionUID = 1L;
	private final UserService service = new UserServiceImpl();

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

		HttpSession session = req.getSession(false);

		if (session != null && session.getAttribute("account") != null) {
			User user = (User) session.getAttribute("account");
			if (user.getIsActive() != 0) {
				resp.sendRedirect(req.getContextPath() + "/waiting");
				return;
			}
		}

		// Check cookie
		Cookie[] cookies = req.getCookies();
		if (cookies != null) {
			for (Cookie cookie : cookies) {
				if (cookie.getName().equals(Constant.COOKIE_REMEMBER)) {
					session = req.getSession(true);
					session.setAttribute(Constant.SESSION_USERNAME, cookie.getValue());
					resp.sendRedirect(req.getContextPath() + "/waiting");
					return;
				}
			}
		}

		String msg = req.getParameter("msg");
		if ("activated".equals(msg)) {
			req.setAttribute("successMsg", "Tài khoản của bạn đã được kích hoạt thành công! Hãy đăng nhập ngay.");
		} else if ("resetOk".equals(msg)) {
			req.setAttribute("successMsg", "Đổi mật khẩu thành công! Hãy đăng nhập với mật khẩu mới.");
		}

		String alert = req.getParameter("alert");
		if ("inactive".equals(alert)) {
			req.setAttribute("alert", "Tài khoản của bạn chưa được kích hoạt!");
		}

		req.getRequestDispatcher("/views/login.jsp").include(req, resp);
	}

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

		resp.setContentType("text/html");
		resp.setCharacterEncoding("UTF-8");
		req.setCharacterEncoding("UTF-8");

		String username = req.getParameter("username");
		String password = req.getParameter("password");

		boolean isRememberMe = false;
		String remember = req.getParameter("remember");
		if ("on".equals(remember)) {
			isRememberMe = true;
		}

		if (username == null || username.trim().isEmpty() || password == null || password.trim().isEmpty()) {
			req.setAttribute("alert", "Tài khoản hoặc mật khẩu không được rỗng");
			req.setAttribute("username", username);
			req.getRequestDispatcher("/views/login.jsp").include(req, resp);
			return;
		}

		User user = service.login(username.trim(), password.trim());
		if (user != null) {
			HttpSession session = req.getSession(true);
			session.setAttribute("account", user);

			if (isRememberMe) {
				saveRememberMe(resp, username.trim());
			}

			resp.sendRedirect(req.getContextPath() + "/waiting");
		} else {
			// Check if user exists but is inactive
			User existing = service.get(username.trim());
			if (existing == null) {
				existing = service.getByEmail(username.trim());
			}

			if (existing != null && existing.getIsActive() == 0) {
				String hashed = existing.getPassWord();
				boolean passwordCorrect = false;
				if (hashed != null && hashed.startsWith("$2")) {
					passwordCorrect = PasswordUtil.check(password.trim(), hashed);
				} else {
					passwordCorrect = password.trim().equals(hashed);
				}

				if (passwordCorrect) {
					String encodedEmail = URLEncoder.encode(existing.getEmail(), StandardCharsets.UTF_8);
					req.setAttribute("alert", "Tài khoản chưa kích hoạt! Vui lòng kiểm tra email để xác thực OTP.");
					req.setAttribute("unactivatedEmail", existing.getEmail());
					req.setAttribute("verifyUrl", req.getContextPath() + "/verify-otp?email=" + encodedEmail + "&purpose=REGISTER");
					req.setAttribute("username", username);
					req.getRequestDispatcher("/views/login.jsp").include(req, resp);
					return;
				}
			}

			req.setAttribute("alert", "Tài khoản hoặc mật khẩu không đúng");
			req.setAttribute("username", username);
			req.getRequestDispatcher("/views/login.jsp").include(req, resp);
		}
	}

	private void saveRememberMe(HttpServletResponse response, String username) {
		Cookie cookie = new Cookie(Constant.COOKIE_REMEMBER, username);
		cookie.setMaxAge(30 * 60);
		response.addCookie(cookie);
	}
}
