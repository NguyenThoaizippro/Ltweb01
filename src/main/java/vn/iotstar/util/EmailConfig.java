package vn.iotstar.util;

import java.nio.file.Files;
import java.nio.file.Path;
import java.util.Properties;

public class EmailConfig {

    public static String getApiKey() {
        String v = System.getenv("BREVO_API_KEY");
        if (v != null && !v.isBlank()) {
            return v.trim();
        }

        try {
            Properties p = new Properties();
            var is = EmailConfig.class.getResourceAsStream("/brevo.properties");
            if (is != null) {
                p.load(is);
                String k = p.getProperty("brevo.api.key");
                if (k != null && !k.isBlank() && !k.contains("xxx")) {
                    return k.trim();
                }
            }
        } catch (Exception ignored) {}

        // Fallback: read from local untracked file D:/upload/brevo.key (dev only)
        try {
            Path path = Path.of("D:/upload/brevo.key");
            if (Files.exists(path)) {
                String k = Files.readString(path).trim();
                if (!k.isBlank()) {
                    return k;
                }
            }
        } catch (Exception ignored) {}

        return null;
    }

    public static String getSmtpLogin() {
        String v = System.getenv("BREVO_SMTP_LOGIN");
        if (v != null && !v.isBlank()) {
            return v.trim();
        }

        try {
            Properties p = new Properties();
            var is = EmailConfig.class.getResourceAsStream("/brevo.properties");
            if (is != null) {
                p.load(is);
                String login = p.getProperty("brevo.smtp.login");
                if (login != null && !login.isBlank()) {
                    return login.trim();
                }
            }
        } catch (Exception ignored) {}

        // Fallback: read from local untracked file D:/upload/brevo.login (dev only)
        try {
            Path path = Path.of("D:/upload/brevo.login");
            if (Files.exists(path)) {
                String login = Files.readString(path).trim();
                if (!login.isBlank()) {
                    return login;
                }
            }
        } catch (Exception ignored) {}

        // Default to Brevo SMTP Login
        return "ae9a68001@smtp-brevo.com";
    }

    public static String getFromEmail() {
        return "thoain.n2006@gmail.com";
    }

    public static String getFromName() {
        return "TOIDIBANHANG";
    }

    public static String getSmtpHost() {
        return "smtp-relay.brevo.com";
    }

    public static int getSmtpPort() {
        return 587;
    }
}
