package vn.iotstar.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import vn.iotstar.service.UserService;
import vn.iotstar.service.impl.UserServiceImpl;
import vn.iotstar.service.OtpService;
import vn.iotstar.service.impl.OtpServiceImpl;
import vn.iotstar.util.PasswordUtil;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.regex.Pattern;

@WebServlet(urlPatterns = "/register")
public class RegisterController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private static final Pattern USERNAME_PATTERN = Pattern.compile("^[a-zA-Z0-9_]{3,30}$");
    private static final Pattern EMAIL_PATTERN = Pattern.compile("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,6}$");
    private static final Pattern PHONE_PATTERN = Pattern.compile("^(0[35789])[0-9]{8}$");

    private final UserService userService;
    private final OtpService otpService;

    public RegisterController() {
        this.userService = new UserServiceImpl();
        this.otpService = new OtpServiceImpl();
    }

    public RegisterController(UserService userService, OtpService otpService) {
        this.userService = userService;
        this.otpService = otpService;
    }

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
        String fullname = req.getParameter("fullname");
        String phone = req.getParameter("phone");
        String password = req.getParameter("password");
        String confirmPassword = req.getParameter("confirmPassword");

        // Trim inputs safely
        username = username != null ? username.trim() : "";
        email = email != null ? email.trim() : "";
        fullname = fullname != null ? fullname.trim() : "";
        phone = phone != null ? phone.trim() : "";

        // Preserve input values for form redisplay
        req.setAttribute("username", username);
        req.setAttribute("email", email);
        req.setAttribute("fullname", fullname);
        req.setAttribute("phone", phone);

        // 1. Validate Username
        if (username.isEmpty()) {
            req.setAttribute("alert", "Tên đăng nhập không được để trống!");
            req.getRequestDispatcher("/views/register.jsp").include(req, resp);
            return;
        }
        if (!USERNAME_PATTERN.matcher(username).matches()) {
            req.setAttribute("alert", "Tên đăng nhập phải từ 3-30 ký tự, chỉ gồm chữ cái, số và dấu gạch dưới (_), không chứa khoảng trắng!");
            req.getRequestDispatcher("/views/register.jsp").include(req, resp);
            return;
        }

        // 2. Validate Email
        if (email.isEmpty()) {
            req.setAttribute("alert", "Địa chỉ email không được để trống!");
            req.getRequestDispatcher("/views/register.jsp").include(req, resp);
            return;
        }
        if (!EMAIL_PATTERN.matcher(email).matches()) {
            req.setAttribute("alert", "Địa chỉ email không đúng định dạng chuẩn (ví dụ: user@example.com)!");
            req.getRequestDispatcher("/views/register.jsp").include(req, resp);
            return;
        }

        // 3. Validate Phone (optional, but if entered must match VN phone pattern)
        if (!phone.isEmpty() && !PHONE_PATTERN.matcher(phone).matches()) {
            req.setAttribute("alert", "Số điện thoại không hợp lệ! Vui lòng nhập số điện thoại Việt Nam gồm 10 chữ số (đầu số 03, 05, 07, 08, 09).");
            req.getRequestDispatcher("/views/register.jsp").include(req, resp);
            return;
        }

        // 4. Validate Password & Confirm Password
        if (password == null || password.length() < 6) {
            req.setAttribute("alert", "Mật khẩu phải có độ dài tối thiểu 6 ký tự!");
            req.getRequestDispatcher("/views/register.jsp").include(req, resp);
            return;
        }
        if (!password.equals(confirmPassword)) {
            req.setAttribute("alert", "Mật khẩu xác nhận không khớp!");
            req.getRequestDispatcher("/views/register.jsp").include(req, resp);
            return;
        }

        // 5. Check Database Duplicates
        try {
            if (userService.get(username) != null) {
                req.setAttribute("alert", "Tên đăng nhập '" + username + "' đã được sử dụng. Vui lòng chọn tên khác!");
                req.getRequestDispatcher("/views/register.jsp").include(req, resp);
                return;
            }
            if (userService.getByEmail(email) != null) {
                req.setAttribute("alert", "Địa chỉ email '" + email + "' đã tồn tại trong hệ thống. Vui lòng sử dụng email khác hoặc Đăng nhập!");
                req.getRequestDispatcher("/views/register.jsp").include(req, resp);
                return;
            }

            // Construct pending user entity (DO NOT INSERT TO DB BEFORE OTP)
            vn.iotstar.entity.User pendingUser = new vn.iotstar.entity.User();
            pendingUser.setUserName(username);
            pendingUser.setEmail(email);
            pendingUser.setFullName(fullname.isEmpty() ? username : fullname);
            pendingUser.setPhone(phone);
            pendingUser.setPassWord(PasswordUtil.hash(password));

            req.getSession().setAttribute("PENDING_USER_" + email, pendingUser);

            // Send OTP via Brevo SMTP
            otpService.createAndSend(email, "REGISTER");

            String encodedEmail = URLEncoder.encode(email, StandardCharsets.UTF_8);
            resp.sendRedirect(req.getContextPath() + "/verify-otp?email=" + encodedEmail + "&purpose=REGISTER");
        } catch (Exception e) {
            req.setAttribute("alert", "Đã có lỗi xảy ra trong quá trình xử lý: " + e.getMessage());
            req.getRequestDispatcher("/views/register.jsp").include(req, resp);
        }
    }
}
