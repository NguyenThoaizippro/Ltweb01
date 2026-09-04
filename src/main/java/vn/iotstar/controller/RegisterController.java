package vn.iotstar.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import vn.iotstar.service.UserService;
import vn.iotstar.service.impl.UserServiceImpl;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

@WebServlet(urlPatterns = "/register")
public class RegisterController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final UserService userService = new UserServiceImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("/views/register.jsp").include(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");

        String username = req.getParameter("username");
        String email = req.getParameter("email");
        String password = req.getParameter("password");
        String confirmPassword = req.getParameter("confirmPassword");

        if (password != null && confirmPassword != null && !password.equals(confirmPassword)) {
            req.setAttribute("alert", "Mật khẩu xác nhận không khớp!");
            req.setAttribute("username", username);
            req.setAttribute("email", email);
            req.getRequestDispatcher("/views/register.jsp").include(req, resp);
            return;
        }

        try {
            if (userService.get(username) != null) {
                throw new Exception("Username đã tồn tại");
            }
            if (userService.getByEmail(email) != null) {
                throw new Exception("Email đã tồn tại");
            }

            vn.iotstar.entity.User pendingUser = new vn.iotstar.entity.User();
            pendingUser.setUserName(username.trim());
            pendingUser.setEmail(email.trim());
            pendingUser.setPassWord(vn.iotstar.util.PasswordUtil.hash(password));
            req.getSession().setAttribute("PENDING_USER_" + email.trim(), pendingUser);

            vn.iotstar.service.OtpService otpService = new vn.iotstar.service.impl.OtpServiceImpl();
            otpService.createAndSend(email.trim(), "REGISTER");

            String encodedEmail = URLEncoder.encode(email, StandardCharsets.UTF_8);
            resp.sendRedirect(req.getContextPath() + "/verify-otp?email=" + encodedEmail + "&purpose=REGISTER");
        } catch (Exception e) {
            req.setAttribute("alert", e.getMessage());
            req.setAttribute("username", username);
            req.setAttribute("email", email);
            req.getRequestDispatcher("/views/register.jsp").include(req, resp);
        }
    }
}
