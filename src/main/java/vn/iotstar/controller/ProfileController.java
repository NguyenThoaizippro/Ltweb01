package vn.iotstar.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import vn.iotstar.entity.User;
import vn.iotstar.service.UserService;
import vn.iotstar.service.impl.UserServiceImpl;
import vn.iotstar.util.Constant;

import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;

@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,
    maxFileSize = 5 * 1024 * 1024,       // 5MB max file size
    maxRequestSize = 10 * 1024 * 1024     // 10MB total request
)
@WebServlet(urlPatterns = {"/profile", "/profile/update"})
public class ProfileController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private final UserService userService;

    public ProfileController() {
        this.userService = new UserServiceImpl();
    }

    public ProfileController(UserService userService) {
        this.userService = userService;
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("account") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        User currentUser = (User) session.getAttribute("account");
        User freshUser = null;
        try {
            freshUser = userService.findById(currentUser.getId());
        } catch (Exception ignored) {}

        if (freshUser == null) {
            freshUser = currentUser;
        }

        req.setAttribute("user", freshUser);
        req.getRequestDispatcher("/views/profile.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("account") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        User currentUser = (User) session.getAttribute("account");
        String fullname = req.getParameter("fullname");
        String phone = req.getParameter("phone");
        String imagesLink = req.getParameter("images");

        String avatar = currentUser.getAvatar();

        try {
            Part part = req.getPart("images1");
            if (part != null && part.getSize() > 0) {
                String submittedFileName = Paths.get(part.getSubmittedFileName()).getFileName().toString();
                String ext = "";
                int dotIndex = submittedFileName.lastIndexOf(".");
                if (dotIndex >= 0) {
                    ext = submittedFileName.substring(dotIndex).toLowerCase();
                }

                if (!ext.matches("(?i)\\.(jpg|jpeg|png|gif|webp)")) {
                    req.setAttribute("alert", "Định dạng file không hợp lệ! Chỉ cho phép JPG, JPEG, PNG, GIF, WEBP.");
                    req.setAttribute("user", currentUser);
                    req.getRequestDispatcher("/views/profile.jsp").forward(req, resp);
                    return;
                }

                // Delete old local avatar file
                if (avatar != null && !avatar.startsWith("http")) {
                    deleteFile(Constant.DIR + "/" + avatar);
                }

                String fname = "avatar_" + System.currentTimeMillis() + ext;
                File dir = new File(Constant.DIR);
                if (!dir.exists()) {
                    dir.mkdirs();
                }
                part.write(Constant.DIR + "/" + fname);
                avatar = fname;
            } else if (imagesLink != null && !imagesLink.trim().isEmpty()) {
                avatar = imagesLink.trim();
            }

            User updated = userService.updateProfile(currentUser.getId(), fullname, phone, avatar);
            session.setAttribute("account", updated);
            req.setAttribute("user", updated);
            req.setAttribute("msg", "Cập nhật hồ sơ cá nhân thành công!");
        } catch (Exception e) {
            req.setAttribute("alert", "Lỗi: " + e.getMessage());
            req.setAttribute("user", currentUser);
        }

        req.getRequestDispatcher("/views/profile.jsp").forward(req, resp);
    }

    private static void deleteFile(String filePath) {
        try {
            File file = new File(filePath);
            if (file.exists()) {
                file.delete();
            }
        } catch (Exception ignored) {}
    }
}
