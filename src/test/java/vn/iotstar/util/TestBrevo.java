package vn.iotstar.util;

import vn.iotstar.service.EmailService;
import vn.iotstar.service.impl.EmailServiceImpl;

public class TestBrevo {
    public static void main(String[] args) {
        String targetEmail = args.length > 0 ? args[0] : EmailConfig.getFromEmail();
        System.out.println("=== BAT DAU KIEM TRA GUI EMAIL BREVO ===");
        System.out.println("Nguoi gui (From): " + EmailConfig.getFromEmail() + " (" + EmailConfig.getFromName() + ")");
        System.out.println("Nguoi nhan (To): " + targetEmail);
        
        String key = EmailConfig.getApiKey();
        if (key == null || key.isBlank()) {
            System.err.println("LOI: Chua tim thay API Key hay SMTP Key trong D:/upload/brevo.key hoac env BREVO_API_KEY!");
            return;
        }

        System.out.println("Loai Key phat hien: " + (key.startsWith("xkeysib-") ? "Brevo REST API Key (xkeysib-...)" : "Brevo SMTP Key (xsmtpsib-...)"));
        if (!key.startsWith("xkeysib-")) {
            System.out.println("SMTP Login duoc su dung: " + EmailConfig.getSmtpLogin());
        }

        try {
            EmailService emailService = new EmailServiceImpl();
            emailService.sendOtp(targetEmail, "888999", "TEST_BREVO");
            System.out.println("=== KET QUA: LENH GUI DA DUOC THUC HIEN! Kiem tra hop thu (hoac Spam) cua " + targetEmail + " ===");
        } catch (Exception e) {
            System.err.println("=== LOI GUI EMAIL: " + e.getMessage() + " ===");
            e.printStackTrace();
        }
    }
}
