package vn.iotstar.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import vn.iotstar.service.OtpService;
import vn.iotstar.service.UserService;
import vn.iotstar.service.impl.OtpServiceImpl;
import vn.iotstar.service.impl.UserServiceImpl;

import java.io.IOException;

@WebServlet(urlPatterns = {"/verify-otp", "/resend-otp"})
public class VerifyOtpController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final OtpService otpService = new OtpServiceImpl();
    private final UserService userService = new UserServiceImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String email = req.getParameter("email");
        String purpose = req.getParameter("purpose");
        if (purpose == null || purpose.trim().isEmpty()) {
            purpose = "REGISTER";
        }
        req.setAttribute("email", email);
        req.setAttribute("purpose", purpose);
        req.getRequestDispatcher("/views/verify-otp.jsp").include(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");

        String email = req.getParameter("email");
        String purpose = req.getParameter("purpose");
        if (purpose == null || purpose.trim().isEmpty()) {
            purpose = "REGISTER";
        }
        req.setAttribute("email", email);
        req.setAttribute("purpose", purpose);

        String uri = req.getRequestURI();
        if (uri.contains("resend-otp")) {
            try {
                otpService.createAndSend(email, purpose);
                req.setAttribute("msg", "Đã gửi lại mã OTP mới qua email!");
            } catch (Exception e) {
                req.setAttribute("alert", e.getMessage());
            }
            req.getRequestDispatcher("/views/verify-otp.jsp").include(req, resp);
            return;
        }

        // Verify OTP action
        String otp = req.getParameter("otp");
        if (otpService.verify(email, otp, purpose)) {
            if ("REGISTER".equalsIgnoreCase(purpose)) {
                vn.iotstar.entity.User pendingUser = (vn.iotstar.entity.User) req.getSession().getAttribute("PENDING_USER_" + email);
                if (pendingUser != null) {
                    try {
                        pendingUser.setIsActive(1);
                        pendingUser.setCreatedDate(new java.sql.Date(System.currentTimeMillis()));
                        userService.insert(pendingUser);
                        req.getSession().removeAttribute("PENDING_USER_" + email);
                        resp.sendRedirect(req.getContextPath() + "/login?msg=activated");
                    } catch (Exception e) {
                        req.setAttribute("alert", "Lỗi tạo tài khoản: " + e.getMessage());
                        req.getRequestDispatcher("/views/verify-otp.jsp").include(req, resp);
                    }
                } else {
                    // Backward compatibility cho những tài khoản cũ đã lỡ insert với isActive=0
                    userService.activate(email);
                    resp.sendRedirect(req.getContextPath() + "/login?msg=activated");
                }
            } else if ("FORGOT".equalsIgnoreCase(purpose)) {
                req.getSession().setAttribute("resetEmail", email);
                resp.sendRedirect(req.getContextPath() + "/reset-password");
            } else {
                resp.sendRedirect(req.getContextPath() + "/login");
            }
        } else {
            req.setAttribute("alert", "Mã OTP không đúng, đã quá số lần thử hoặc đã hết hạn (120 giây)!");
            req.getRequestDispatcher("/views/verify-otp.jsp").include(req, resp);
        }
    }
}
