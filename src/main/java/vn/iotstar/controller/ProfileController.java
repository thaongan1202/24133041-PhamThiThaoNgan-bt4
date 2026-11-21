package vn.iotstar.controller;

import java.io.IOException;
import java.io.InputStream;
import java.util.Locale;
import java.util.Set;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import vn.iotstar.entity.User;
import vn.iotstar.service.IUserService;
import vn.iotstar.service.impl.UserServiceImpl;
import vn.iotstar.util.CloudinaryUtil;
import vn.iotstar.util.Constant;
import vn.iotstar.util.ValidationUtil;

@MultipartConfig(fileSizeThreshold = 1024 * 1024, maxFileSize = 5 * 1024 * 1024, maxRequestSize = 6 * 1024 * 1024)
@WebServlet(urlPatterns = { "/profile", "/profile/verify" })
public class ProfileController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Set<String> IMAGE_EXT = Set.of("jpg", "jpeg", "png", "gif", "webp");

    private final IUserService service = new UserServiceImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User current = currentUser(req);
        if (current == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }
        User fresh = service.findById(current.getId());
        req.setAttribute("profile", fresh);

        if ("/profile/verify".equals(req.getServletPath())) {
            if (fresh.getPendingEmail() == null) {
                resp.sendRedirect(req.getContextPath() + "/profile");
                return;
            }
            if ("true".equals(req.getParameter("resend"))) {
                boolean ok = service.requestEmailChange(fresh.getId(), fresh.getPendingEmail());
                resp.sendRedirect(req.getContextPath() + "/profile/verify?" + (ok ? "resent=true" : "sent=false"));
                return;
            }
            req.getRequestDispatcher("/views/verify-email.jsp").forward(req, resp);
        } else {
            req.getRequestDispatcher("/views/profile.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        User current = currentUser(req);
        if (current == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }
        if ("/profile/verify".equals(req.getServletPath())) {
            verifyEmail(req, resp, current);
        } else {
            updateProfile(req, resp, current);
        }
    }

    private void updateProfile(HttpServletRequest req, HttpServletResponse resp, User current)
            throws ServletException, IOException {
        String error = null;
        Part part = null;
        try {
            part = req.getPart("avatarFile");
        } catch (IllegalStateException e) {
            error = "Ảnh tối đa 5 MB";
        }

        String fullname = trim(req.getParameter("fullname"));
        String phone = trim(req.getParameter("phone"));
        String email = trim(req.getParameter("email"));
        User fresh = service.findById(current.getId());

        if (error == null) {
            if (!ValidationUtil.isValidFullname(fullname)) {
                error = "Họ tên từ 2 đến 100 ký tự";
            } else if (!ValidationUtil.isValidPhone(phone)) {
                error = "Số điện thoại phải gồm 10 chữ số và bắt đầu bằng 0";
            } else if (!ValidationUtil.isValidEmail(email)) {
                error = "Email không hợp lệ";
            } else {
                User byPhone = service.findByPhone(phone);
                User byEmail = service.findByEmail(email);
                if (byPhone != null && byPhone.getId() != fresh.getId()) {
                    error = "Số điện thoại đã được tài khoản khác sử dụng";
                } else if (byEmail != null && byEmail.getId() != fresh.getId()) {
                    error = "Email đã được tài khoản khác sử dụng";
                }
            }
        }

        String avatarUrl = null;
        if (error == null && part != null && part.getSize() > 0) {
            try {
                avatarUrl = uploadAvatar(part);
            } catch (IllegalArgumentException e) {
                error = e.getMessage();
            } catch (Exception e) {
                e.printStackTrace();
                error = "Upload ảnh lên Cloudinary thất bại, hãy kiểm tra cấu hình";
            }
        }

        if (error != null) {
            req.setAttribute("profile", fresh);
            req.setAttribute("error", error);
            req.getRequestDispatcher("/views/profile.jsp").forward(req, resp);
            return;
        }

        User updated = service.updateProfile(fresh.getId(), fullname, phone, avatarUrl);
        req.getSession().setAttribute(Constant.SESSION_ACCOUNT, updated);

        if (!email.equalsIgnoreCase(fresh.getEmail())) {
            boolean sent = service.requestEmailChange(fresh.getId(), email);
            resp.sendRedirect(req.getContextPath() + "/profile/verify" + (sent ? "" : "?sent=false"));
            return;
        }
        resp.sendRedirect(req.getContextPath() + "/profile?success=true");
    }

    private void verifyEmail(HttpServletRequest req, HttpServletResponse resp, User current)
            throws ServletException, IOException {
        String otp = trim(req.getParameter("otp"));
        if (service.confirmEmailChange(current.getId(), otp)) {
            req.getSession().setAttribute(Constant.SESSION_ACCOUNT, service.findById(current.getId()));
            resp.sendRedirect(req.getContextPath() + "/profile?emailChanged=true");
            return;
        }
        req.setAttribute("profile", service.findById(current.getId()));
        req.setAttribute("error", "Mã OTP không đúng hoặc đã hết hạn");
        req.getRequestDispatcher("/views/verify-email.jsp").forward(req, resp);
    }

    private String uploadAvatar(Part part) throws IOException {
        String name = part.getSubmittedFileName() == null ? "" : part.getSubmittedFileName().toLowerCase(Locale.ROOT);
        int dot = name.lastIndexOf('.');
        String ext = dot < 0 ? "" : name.substring(dot + 1);
        String type = part.getContentType() == null ? "" : part.getContentType().toLowerCase(Locale.ROOT);
        if (!IMAGE_EXT.contains(ext) || !type.startsWith("image/")) {
            throw new IllegalArgumentException("Avatar phải là ảnh jpg, jpeg, png, gif hoặc webp");
        }
        try (InputStream in = part.getInputStream()) {
            return CloudinaryUtil.upload(in.readAllBytes(), "shoppingjpa/avatars");
        }
    }

    private User currentUser(HttpServletRequest req) {
        HttpSession session = req.getSession(false);
        return session == null ? null : (User) session.getAttribute(Constant.SESSION_ACCOUNT);
    }

    private String trim(String s) {
        return s == null ? "" : s.trim();
    }
}