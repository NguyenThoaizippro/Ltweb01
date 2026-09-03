package vn.iotstar.service.impl;

import jakarta.mail.Authenticator;
import jakarta.mail.Message;
import jakarta.mail.PasswordAuthentication;
import jakarta.mail.Session;
import jakarta.mail.Transport;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;
import vn.iotstar.service.EmailService;
import vn.iotstar.util.EmailConfig;

import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.nio.charset.StandardCharsets;
import java.util.Properties;

public class EmailServiceImpl implements EmailService {

    @Override
    public void sendOtp(String toEmail, String otp, String purpose) throws Exception {
        if (toEmail == null || toEmail.trim().isEmpty()) {
            throw new IllegalArgumentException("Recipient email must not be empty");
        }

        String apiKey = EmailConfig.getApiKey();
        if (apiKey == null || apiKey.trim().isEmpty() || apiKey.contains("xxx")) {
            System.out.println("=== [MOCK EMAIL] OTP " + otp + " to " + toEmail + " purpose " + purpose + " ===");
            return;
        }

        String subject = "[bt01] OTP " + purpose + " - " + otp;
        String contentText = "Mã OTP của bạn là: " + otp + "\nHết hạn sau 120 giây.\nNếu không yêu cầu, bỏ qua email này.";
        String contentHtml = "<div style='font-family:Arial,sans-serif;padding:20px;max-width:500px;border:1px solid #e2e8f0;border-radius:8px;'>"
                + "<h2 style='color:#2563eb;margin-bottom:12px;'>Mã xác thực OTP</h2>"
                + "<p>Xin chào,</p>"
                + "<p>Mục đích: <strong>" + purpose + "</strong></p>"
                + "<div style='background:#f1f5f9;padding:16px;text-align:center;border-radius:6px;margin:20px 0;'>"
                + "<span style='font-size:32px;font-weight:bold;letter-spacing:8px;color:#1e293b;'>" + otp + "</span>"
                + "</div>"
                + "<p style='color:#ef4444;font-size:13px;'>Mã có hiệu lực trong vòng 120 giây (2 phút). Vui lòng không chia sẻ mã này cho bất kỳ ai.</p>"
                + "<hr style='border:none;border-top:1px solid #e2e8f0;margin:20px 0;'>"
                + "<p style='font-size:12px;color:#94a3b8;'>Email tự động từ hệ thống TOIDIBANHANG - BT01 Shopping.</p>"
                + "</div>";

        try {
            // Mode 1: Brevo REST API (if key starts with xkeysib-)
            if (apiKey.startsWith("xkeysib-")) {
                sendViaRestApi(toEmail, subject, contentHtml, apiKey);
                System.out.println("=== [BREVO REST API SUCCESS] OTP " + otp + " sent to " + toEmail + " ===");
                return;
            }

            // Mode 2: Brevo SMTP Relay (if key starts with xsmtpsib- or standard SMTP key)
            sendViaSmtp(toEmail, subject, contentText, contentHtml, apiKey);
            System.out.println("=== [BREVO SMTP SUCCESS] OTP " + otp + " sent to " + toEmail + " ===");

        } catch (Exception e) {
            System.out.println("=== [EMAIL SEND ERROR] ===");
            System.out.println("Error details: " + e.getMessage());
            System.out.println("=== [MOCK EMAIL FALLBACK] OTP " + otp + " to " + toEmail + " purpose " + purpose + " ===");

            // If user explicitly configured key in env, rethrow so caller is aware
            if (System.getenv("BREVO_API_KEY") != null) {
                throw e;
            }
        }
    }

    private void sendViaRestApi(String toEmail, String subject, String htmlContent, String apiKey) throws Exception {
        HttpClient client = HttpClient.newHttpClient();
        String jsonBody = String.format(
                "{\"sender\":{\"name\":\"%s\",\"email\":\"%s\"},\"to\":[{\"email\":\"%s\"}],\"subject\":\"%s\",\"htmlContent\":%s}",
                escapeJson(EmailConfig.getFromName()),
                escapeJson(EmailConfig.getFromEmail()),
                escapeJson(toEmail),
                escapeJson(subject),
                quoteJson(htmlContent)
        );

        HttpRequest request = HttpRequest.newBuilder()
                .uri(URI.create("https://api.brevo.com/v3/smtp/email"))
                .header("accept", "application/json")
                .header("api-key", apiKey)
                .header("content-type", "application/json")
                .POST(HttpRequest.BodyPublishers.ofString(jsonBody, StandardCharsets.UTF_8))
                .build();

        HttpResponse<String> response = client.send(request, HttpResponse.BodyHandlers.ofString());
        if (response.statusCode() < 200 || response.statusCode() >= 300) {
            throw new RuntimeException("Brevo API HTTP " + response.statusCode() + ": " + response.body());
        }
    }

    private void sendViaSmtp(String toEmail, String subject, String textContent, String htmlContent, String smtpKey) throws Exception {
        Properties props = new Properties();
        props.put("mail.smtp.host", EmailConfig.getSmtpHost());
        props.put("mail.smtp.port", String.valueOf(EmailConfig.getSmtpPort()));
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.ssl.protocols", "TLSv1.2");

        String smtpLogin = EmailConfig.getSmtpLogin();

        Session session = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(smtpLogin, smtpKey);
            }
        });

        Message message = new MimeMessage(session);
        message.setFrom(new InternetAddress(EmailConfig.getFromEmail(), EmailConfig.getFromName(), "UTF-8"));
        message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
        message.setSubject(subject);
        message.setContent(htmlContent, "text/html; charset=UTF-8");

        Transport.send(message);
    }

    private static String escapeJson(String s) {
        if (s == null) return "";
        return s.replace("\\", "\\\\").replace("\"", "\\\"");
    }

    private static String quoteJson(String s) {
        if (s == null) return "\"\"";
        StringBuilder sb = new StringBuilder("\"");
        for (char c : s.toCharArray()) {
            switch (c) {
                case '"': sb.append("\\\""); break;
                case '\\': sb.append("\\\\"); break;
                case '\b': sb.append("\\b"); break;
                case '\f': sb.append("\\f"); break;
                case '\n': sb.append("\\n"); break;
                case '\r': sb.append("\\r"); break;
                case '\t': sb.append("\\t"); break;
                default:
                    if (c < ' ') {
                        sb.append(String.format("\\u%04x", (int) c));
                    } else {
                        sb.append(c);
                    }
            }
        }
        sb.append("\"");
        return sb.toString();
    }
}
