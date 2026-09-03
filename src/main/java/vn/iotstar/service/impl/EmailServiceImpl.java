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

        try {
            Properties props = new Properties();
            props.put("mail.smtp.host", EmailConfig.getSmtpHost());
            props.put("mail.smtp.port", String.valueOf(EmailConfig.getSmtpPort()));
            props.put("mail.smtp.auth", "true");
            props.put("mail.smtp.starttls.enable", "true");
            props.put("mail.smtp.ssl.protocols", "TLSv1.2");

            Session session = Session.getInstance(props, new Authenticator() {
                @Override
                protected PasswordAuthentication getPasswordAuthentication() {
                    return new PasswordAuthentication("apikey", apiKey);
                }
            });

            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(EmailConfig.getFromEmail(), EmailConfig.getFromName(), "UTF-8"));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            message.setSubject("[bt01] OTP " + purpose + " - " + otp);
            message.setText("Mã OTP của bạn là: " + otp + "\nHết hạn sau 120 giây.\nNếu không yêu cầu, bỏ qua email này.");

            Transport.send(message);
        } catch (Exception e) {
            System.out.println("=== [MOCK EMAIL FALLBACK] OTP " + otp + " to " + toEmail + " purpose " + purpose + " ===");
            System.out.println("Email send error: " + e.getMessage());
            // If strictly Brevo api key is provided in env and fails, rethrow
            if (System.getenv("BREVO_API_KEY") != null) {
                throw e;
            }
        }
    }
}
