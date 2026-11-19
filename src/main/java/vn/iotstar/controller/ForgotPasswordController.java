package vn.iotstar.controller;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import vn.iotstar.service.IUserService;
import vn.iotstar.service.impl.UserServiceImpl;
import vn.iotstar.util.ValidationUtil;

@WebServlet(urlPatterns = { "/forgot-password", "/reset-password" })
public class ForgotPasswordController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private IUserService service = new UserServiceImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        if (req.getRequestURI().contains("/reset-password")) {
            req.setAttribute("email", req.getParameter("email"));
            req.getRequestDispatcher("/views/reset-password.jsp").forward(req, resp);
        } else {
            req.getRequestDispatcher("/views/forgot-password.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        if (req.getRequestURI().contains("/reset-password")) {
            resetPassword(req, resp);
        } else {
            sendCode(req, resp);
        }
    }

    private void sendCode(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String email = req.getParameter("email");
        String alert = null;

        if (isBlank(email)) {
            alert = "Vui lòng nhập email";
        } else if (!ValidationUtil.isValidEmail(email)) {
            alert = "Email không hợp lệ"; 
        } else if (!service.checkExistEmail(email)) {
            alert = "Email chưa được đăng ký";
        } else if (!service.sendOtp(email, "Đặt lại mật khẩu ShoppingJPA")) {
            alert = "Không gửi được email, vui lòng thử lại";
        }

        if (alert != null) {
            req.setAttribute("alert", alert);
            req.getRequestDispatcher("/views/forgot-password.jsp").forward(req, resp);
            return;
        }

        String encoded = URLEncoder.encode(email, StandardCharsets.UTF_8);
        resp.sendRedirect(req.getContextPath() + "/reset-password?email=" + encoded);
    }

    private void resetPassword(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String email = req.getParameter("email");
        String otp = req.getParameter("otp");
        String password = req.getParameter("password");
        String repassword = req.getParameter("repassword");

        String alert = null;
        if (isBlank(otp) || isBlank(password) || isBlank(repassword)) {
            alert = "Vui lòng nhập đầy đủ thông tin";
        } else if (!ValidationUtil.isValidOtp(otp)) {
            alert = "Mã OTP gồm 6 chữ số";
        } else if (!ValidationUtil.isValidPassword(password)) {
            alert = "Mật khẩu từ 6 đến 50 ký tự";
        } else if (!password.equals(repassword)) {
            alert = "Mật khẩu nhập lại không khớp";
        } else if (!service.resetPassword(email, otp.trim(), password)) {
            alert = "Mã OTP không đúng hoặc đã hết hạn";
        }

        if (alert != null) {
            req.setAttribute("email", email);
            req.setAttribute("alert", alert);
            req.getRequestDispatcher("/views/reset-password.jsp").forward(req, resp);
            return;
        }

        resp.sendRedirect(req.getContextPath() + "/login?reset=true");
    }

    private boolean isBlank(String s) {
        return s == null || s.trim().isEmpty();
    }
}