package com.eighttea.controller;

import com.eighttea.dao.UserDao;
import com.eighttea.dao.impl.UserDaoImpl;
import com.eighttea.model.User;
import com.eighttea.util.EmailUtil;
import com.eighttea.util.Passwords;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.security.SecureRandom;
import java.util.Optional;

@WebServlet(name = "PasswordResetController",
        urlPatterns = {"/forgot-password", "/verify-otp", "/resend-otp", "/reset-password"})
public class PasswordResetController extends HttpServlet {

    private static final long OTP_TTL_MS = 5L * 60 * 1000;
    private static final long RESEND_COOLDOWN_MS = 60L * 1000;
    private static final SecureRandom RANDOM = new SecureRandom();

    private UserDao userDao;

    @Override
    public void init() {
        userDao = new UserDaoImpl();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String path = req.getServletPath();
        HttpSession session = req.getSession();

        switch (path) {
            case "/forgot-password" -> {
                clearResetSession(session);
                req.getRequestDispatcher("/WEB-INF/views/forgot-password.jsp").forward(req, resp);
            }
            case "/verify-otp" -> {
                if (session.getAttribute("reset_email") == null) {
                    resp.sendRedirect(req.getContextPath() + "/forgot-password");
                    return;
                }
                Long expiresAt = (Long) session.getAttribute("reset_otp_expires");
                long remaining = (expiresAt != null) ? expiresAt - System.currentTimeMillis() : 0;
                req.setAttribute("remainingMs", Math.max(remaining, 0));
                req.setAttribute("resetEmail", session.getAttribute("reset_email"));
                req.setAttribute("step", "otp");
                req.getRequestDispatcher("/WEB-INF/views/forgot-password.jsp").forward(req, resp);
            }
            case "/reset-password" -> {
                Boolean verified = (Boolean) session.getAttribute("reset_otp_verified");
                if (verified == null || !verified) {
                    resp.sendRedirect(req.getContextPath() + "/forgot-password");
                    return;
                }
                req.getRequestDispatcher("/WEB-INF/views/reset-password.jsp").forward(req, resp);
            }
            default -> resp.sendRedirect(req.getContextPath() + "/forgot-password");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String path = req.getServletPath();

        switch (path) {
            case "/forgot-password" -> handleForgot(req, resp);
            case "/verify-otp"     -> handleVerifyOtp(req, resp);
            case "/resend-otp"     -> handleResend(req, resp);
            case "/reset-password" -> handleReset(req, resp);
        }
    }

    private void handleForgot(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        boolean ajax = isAjax(req);
        String email = req.getParameter("email");
        if (email != null) email = email.trim().toLowerCase();

        if (email == null || email.isEmpty()) {
            if (ajax) { writeJson(resp, false, "Vui lòng nhập địa chỉ email.", null); return; }
            req.setAttribute("errorMessage", "Vui lòng nhập địa chỉ email.");
            req.getRequestDispatcher("/WEB-INF/views/forgot-password.jsp").forward(req, resp);
            return;
        }

        Optional<User> userOpt = userDao.findByEmail(email);

        if (userOpt.isEmpty()) {
            if (ajax) { writeJson(resp, false, "Email này chưa được đăng ký tài khoản.", null); return; }
            req.setAttribute("errorMessage", "Email này chưa được đăng ký tài khoản.");
            req.getRequestDispatcher("/WEB-INF/views/forgot-password.jsp").forward(req, resp);
            return;
        }

        User user = userOpt.get();
        HttpSession session = req.getSession();
        String otp = generateOtp();
        long expiresAt = System.currentTimeMillis() + OTP_TTL_MS;

        session.setAttribute("reset_email", user.getEmail());
        session.setAttribute("reset_user_id", user.getUserId());
        session.setAttribute("reset_user_name", user.getFullName());
        session.setAttribute("reset_otp", otp);
        session.setAttribute("reset_otp_expires", expiresAt);
        session.setAttribute("reset_otp_sent_at", System.currentTimeMillis());
        session.setAttribute("reset_otp_verified", false);
        session.setAttribute("reset_attempts", 0);

        sendOtpEmail(user.getEmail(), user.getFullName(), otp);

        if (ajax) { writeJson(resp, true, null, "\"remainingMs\":" + OTP_TTL_MS); return; }
        resp.sendRedirect(req.getContextPath() + "/verify-otp");
    }

    private void handleVerifyOtp(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        boolean ajax = isAjax(req);
        HttpSession session = req.getSession();
        String sessionEmail = (String) session.getAttribute("reset_email");
        if (sessionEmail == null) {
            if (ajax) { writeJson(resp, false, "Phiên đã hết hạn, vui lòng yêu cầu lại.", null); return; }
            resp.sendRedirect(req.getContextPath() + "/forgot-password");
            return;
        }

        String d1 = req.getParameter("d1");
        String d2 = req.getParameter("d2");
        String d3 = req.getParameter("d3");
        String d4 = req.getParameter("d4");
        String d5 = req.getParameter("d5");
        String d6 = req.getParameter("d6");

        if (d1 == null || d2 == null || d3 == null || d4 == null || d5 == null || d6 == null) {
            if (ajax) { writeJson(resp, false, "Vui lòng nhập đủ 6 chữ số.", null); return; }
            req.setAttribute("errorMessage", "Vui lòng nhập đủ 6 chữ số.");
            forwardToOtpPage(req, resp, session);
            return;
        }

        String inputOtp = d1 + d2 + d3 + d4 + d5 + d6;

        Integer attempts = (Integer) session.getAttribute("reset_attempts");
        if (attempts == null) attempts = 0;
        attempts++;
        session.setAttribute("reset_attempts", attempts);

        if (attempts > 5) {
            clearResetSession(session);
            if (ajax) { writeJson(resp, false, "Bạn đã nhập sai quá nhiều lần. Vui lòng yêu cầu mã mới.", null); return; }
            req.setAttribute("errorMessage", "Bạn đã nhập sai quá nhiều lần. Vui lòng yêu cầu mã mới.");
            req.getRequestDispatcher("/WEB-INF/views/forgot-password.jsp").forward(req, resp);
            return;
        }

        String storedOtp = (String) session.getAttribute("reset_otp");
        Long expiresAt = (Long) session.getAttribute("reset_otp_expires");

        if (expiresAt == null || System.currentTimeMillis() > expiresAt) {
            if (ajax) { writeJson(resp, false, "Mã OTP đã hết hạn. Vui lòng yêu cầu gửi lại mã.", null); return; }
            req.setAttribute("errorMessage", "Mã OTP đã hết hạn. Vui lòng yêu cầu gửi lại mã.");
            forwardToOtpPage(req, resp, session);
            return;
        }

        if (!inputOtp.equals(storedOtp)) {
            String msg = "Mã OTP không chính xác. Còn " + (5 - attempts) + " lần thử.";
            if (ajax) { writeJson(resp, false, msg, null); return; }
            req.setAttribute("errorMessage", msg);
            forwardToOtpPage(req, resp, session);
            return;
        }

        session.setAttribute("reset_otp_verified", true);
        session.removeAttribute("reset_otp");
        session.removeAttribute("reset_attempts");

        if (ajax) { writeJson(resp, true, null, null); return; }
        resp.sendRedirect(req.getContextPath() + "/reset-password");
    }

    private void handleResend(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        boolean ajax = isAjax(req);
        HttpSession session = req.getSession();
        String email = (String) session.getAttribute("reset_email");
        Integer userId = (Integer) session.getAttribute("reset_user_id");
        String fullName = (String) session.getAttribute("reset_user_name");

        if (email == null || userId == null) {
            if (ajax) { writeJson(resp, false, "Phiên đã hết hạn, vui lòng yêu cầu lại.", null); return; }
            resp.sendRedirect(req.getContextPath() + "/forgot-password");
            return;
        }

        Long sentAt = (Long) session.getAttribute("reset_otp_sent_at");
        if (sentAt != null && System.currentTimeMillis() - sentAt < RESEND_COOLDOWN_MS) {
            if (ajax) { writeJson(resp, false, "Vui lòng đợi trước khi gửi lại mã.", null); return; }
            resp.sendRedirect(req.getContextPath() + "/verify-otp");
            return;
        }

        String otp = generateOtp();
        long expiresAt = System.currentTimeMillis() + OTP_TTL_MS;

        session.setAttribute("reset_otp", otp);
        session.setAttribute("reset_otp_expires", expiresAt);
        session.setAttribute("reset_otp_sent_at", System.currentTimeMillis());
        session.setAttribute("reset_otp_verified", false);
        session.setAttribute("reset_attempts", 0);

        sendOtpEmail(email, fullName, otp);

        if (ajax) { writeJson(resp, true, null, "\"remainingMs\":" + OTP_TTL_MS); return; }
        resp.sendRedirect(req.getContextPath() + "/verify-otp");
    }

    private void handleReset(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        boolean ajax = isAjax(req);
        HttpSession session = req.getSession();
        Boolean verified = (Boolean) session.getAttribute("reset_otp_verified");
        Integer userId = (Integer) session.getAttribute("reset_user_id");

        if (verified == null || !verified || userId == null) {
            if (ajax) { writeJson(resp, false, "Phiên đã hết hạn, vui lòng yêu cầu lại.", null); return; }
            resp.sendRedirect(req.getContextPath() + "/forgot-password");
            return;
        }

        String password = req.getParameter("password");
        String confirm = req.getParameter("confirmPassword");

        if (password == null || !password.equals(confirm)) {
            if (ajax) { writeJson(resp, false, "Mật khẩu xác nhận không khớp.", null); return; }
            req.setAttribute("errorMessage", "Mật khẩu xác nhận không khớp.");
            req.getRequestDispatcher("/WEB-INF/views/reset-password.jsp").forward(req, resp);
            return;
        }
        if (!password.matches("^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d).{6,}$")) {
            String msg = "Mật khẩu phải có ít nhất 6 ký tự, gồm chữ hoa, chữ thường và số.";
            if (ajax) { writeJson(resp, false, msg, null); return; }
            req.setAttribute("errorMessage", msg);
            req.getRequestDispatcher("/WEB-INF/views/reset-password.jsp").forward(req, resp);
            return;
        }

        boolean ok = userDao.updatePassword(userId, Passwords.hash(password));
        clearResetSession(session);

        if (ajax) {
            writeJson(resp, ok, ok ? null : "Có lỗi hệ thống, vui lòng thử lại.", null);
            return;
        }

        if (ok) {
            resp.sendRedirect(req.getContextPath() + "/login?reset=success");
        } else {
            req.setAttribute("errorMessage", "Có lỗi hệ thống, vui lòng thử lại.");
            req.getRequestDispatcher("/WEB-INF/views/reset-password.jsp").forward(req, resp);
        }
    }

    private void forwardToOtpPage(HttpServletRequest req, HttpServletResponse resp, HttpSession session)
            throws ServletException, IOException {
        Long expiresAt = (Long) session.getAttribute("reset_otp_expires");
        long remaining = (expiresAt != null) ? expiresAt - System.currentTimeMillis() : 0;
        req.setAttribute("remainingMs", Math.max(remaining, 0));
        req.setAttribute("resetEmail", session.getAttribute("reset_email"));
        req.setAttribute("step", "otp");
        req.getRequestDispatcher("/WEB-INF/views/forgot-password.jsp").forward(req, resp);
    }

    private String generateOtp() {
        int code = RANDOM.nextInt(900000) + 100000;
        return String.valueOf(code);
    }

    private void sendOtpEmail(String toEmail, String fullName, String otp) {
        String html = "<!DOCTYPE html>"
            + "<html><head><meta charset='UTF-8'></head><body style='margin:0;padding:0;background:#FDFBF7;font-family:Arial,Helvetica,sans-serif'>"
            + "<table width='100%' cellpadding='0' cellspacing='0' style='background:#FDFBF7;padding:40px 20px'><tr><td align='center'>"
            + "<table width='520' cellpadding='0' cellspacing='0' style='background:#FFFFFF;border-radius:24px;overflow:hidden;box-shadow:0 8px 30px rgba(30,63,39,.08)'>"
            + "<tr><td style='background:linear-gradient(135deg,#2A5C38,#1E3F27);padding:36px 40px;text-align:center'>"
            + "<div style='font-size:28px;margin-bottom:8px'>🍊</div>"
            + "<h1 style='margin:0;color:#fff;font-size:22px;font-weight:600'>Mã xác thực OTP</h1>"
            + "<p style='margin:8px 0 0;color:rgba(255,255,255,.8);font-size:14px'>Đặt lại mật khẩu tài khoản Nhiệt Đới Xanh</p>"
            + "</td></tr>"
            + "<tr><td style='padding:36px 40px'>"
            + "<p style='margin:0 0 16px;font-size:15px;color:#1A2E1A'>Xin chào <b>" + fullName + "</b>,</p>"
            + "<p style='margin:0 0 28px;font-size:14.5px;color:#7A8D7A;line-height:1.6'>Chúng tôi nhận được yêu cầu đặt lại mật khẩu cho tài khoản của bạn. Sử dụng mã OTP bên dưới để tiếp tục:</p>"
            + "<div style='text-align:center;margin:0 0 28px'>"
            + "<div style='display:inline-block;background:#FDFBF7;border:2px dashed #2A5C38;border-radius:16px;padding:20px 36px'>"
            + "<span style='font-size:36px;font-weight:700;letter-spacing:12px;color:#2A5C38;font-family:monospace'>" + otp + "</span>"
            + "</div>"
            + "<p style='margin:12px 0 0;font-size:13px;color:#D9534F;font-weight:600'>⏱ Mã có hiệu lực trong 5 phút</p>"
            + "</div>"
            + "<div style='background:#FBE3E1;border-radius:12px;padding:14px 18px;margin:0 0 24px'>"
            + "<p style='margin:0;font-size:13px;color:#8E1F1F;font-weight:600'>⚠️ Không chia sẻ mã này với bất kỳ ai.</p>"
            + "</div>"
            + "<p style='margin:0;font-size:13.5px;color:#7A8D7A;line-height:1.5'>Nếu bạn không yêu cầu đặt lại mật khẩu, hãy bỏ qua email này.</p>"
            + "</td></tr>"
            + "<tr><td style='background:#F5F0E8;padding:20px 40px;text-align:center;border-top:1px solid rgba(42,92,56,.08)'>"
            + "<p style='margin:0;font-size:12px;color:#7A8D7A'>© 2026 Nhiệt Đới Xanh — Trọn vị thanh mát 🍃</p>"
            + "</td></tr>"
            + "</table></td></tr></table></body></html>";

        EmailUtil.sendEmail(toEmail, "Nhiệt Đới Xanh — Mã xác thực OTP", html);
    }

    private boolean isAjax(HttpServletRequest req) {
        return "XMLHttpRequest".equals(req.getHeader("X-Requested-With"));
    }

    private void writeJson(HttpServletResponse resp, boolean success, String message, String extraJsonField)
            throws IOException {
        resp.setContentType("application/json;charset=UTF-8");
        StringBuilder json = new StringBuilder("{\"success\":").append(success);
        if (message != null) json.append(",\"message\":\"").append(escapeJson(message)).append('"');
        if (extraJsonField != null) json.append(',').append(extraJsonField);
        json.append('}');
        resp.getWriter().write(json.toString());
    }

    private String escapeJson(String s) {
        return s.replace("\\", "\\\\").replace("\"", "\\\"")
                .replace("\n", "\\n").replace("\r", "");
    }

    private void clearResetSession(HttpSession session) {
        session.removeAttribute("reset_email");
        session.removeAttribute("reset_user_id");
        session.removeAttribute("reset_user_name");
        session.removeAttribute("reset_otp");
        session.removeAttribute("reset_otp_expires");
        session.removeAttribute("reset_otp_sent_at");
        session.removeAttribute("reset_otp_verified");
        session.removeAttribute("reset_attempts");
    }
}
