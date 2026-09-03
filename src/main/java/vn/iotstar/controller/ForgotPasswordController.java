package vn.iotstar.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import vn.iotstar.entity.User;
import vn.iotstar.service.OtpService;
import vn.iotstar.service.UserService;
import vn.iotstar.service.impl.OtpServiceImpl;
import vn.iotstar.service.impl.UserServiceImpl;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

@WebServlet(urlPatterns = {"/forgot-password", "/reset-password"})
public class ForgotPasswordController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final UserService userService = new UserServiceImpl();
    private final OtpService otpService = new OtpServiceImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String uri = req.getRequestURI();
        if (uri.contains("/reset-password")) {
            HttpSession session = req.getSession(false);
            if (session == null || session.getAttribute("resetEmail") == null) {
                resp.sendRedirect(req.getContextPath() + "/forgot-password");
                return;
            }
            req.getRequestDispatcher("/views/reset-password.jsp").forward(req, resp);
        } else {
            req.getRequestDispatcher("/views/forgot-password.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");

        String uri = req.getRequestURI();
        if (uri.contains("/forgot-password")) {
            String email = req.getParameter("email");
            if (email == null || email.trim().isEmpty()) {
                req.setAttribute("alert", "Vui lòng nhập địa chỉ email!");
                req.getRequestDispatcher("/views/forgot-password.jsp").forward(req, resp);
                return;
            }

            email = email.trim();
            User user = userService.getByEmail(email);
            if (user == null) {
                user = userService.get(email);
            }

            if (user == null) {
                req.setAttribute("alert", "Email không tồn tại trong hệ thống!");
                req.setAttribute("email", email);
                req.getRequestDispatcher("/views/forgot-password.jsp").forward(req, resp);
                return;
            }

            try {
                otpService.createAndSend(email, "FORGOT");
                String encodedEmail = URLEncoder.encode(email, StandardCharsets.UTF_8);
                resp.sendRedirect(req.getContextPath() + "/verify-otp?email=" + encodedEmail + "&purpose=FORGOT");
            } catch (Exception e) {
                req.setAttribute("alert", e.getMessage());
                req.setAttribute("email", email);
                req.getRequestDispatcher("/views/forgot-password.jsp").forward(req, resp);
            }
        } else {
            // /reset-password
            HttpSession session = req.getSession(false);
            if (session == null || session.getAttribute("resetEmail") == null) {
                resp.sendRedirect(req.getContextPath() + "/forgot-password");
                return;
            }

            String email = (String) session.getAttribute("resetEmail");
            String password = req.getParameter("password");
            String confirmPassword = req.getParameter("confirmPassword");

            if (password == null || password.trim().isEmpty() || confirmPassword == null || confirmPassword.trim().isEmpty()) {
                req.setAttribute("alert", "Mật khẩu không được để trống!");
                req.getRequestDispatcher("/views/reset-password.jsp").forward(req, resp);
                return;
            }

            if (!password.equals(confirmPassword)) {
                req.setAttribute("alert", "Mật khẩu xác nhận không khớp!");
                req.getRequestDispatcher("/views/reset-password.jsp").forward(req, resp);
                return;
            }

            try {
                userService.resetPassword(email, password);
                session.removeAttribute("resetEmail");
                resp.sendRedirect(req.getContextPath() + "/login?msg=resetOk");
            } catch (Exception e) {
                req.setAttribute("alert", e.getMessage());
                req.getRequestDispatcher("/views/reset-password.jsp").forward(req, resp);
            }
        }
    }
}
