package vn.iotstar.service;

import org.junit.jupiter.api.Test;
import vn.iotstar.service.impl.EmailServiceImpl;

import static org.junit.jupiter.api.Assertions.*;

public class EmailServiceTest {
    @Test
    void sendOtpEmptyEmailThrows() {
        EmailService emailService = new EmailServiceImpl();
        assertThrows(IllegalArgumentException.class, () -> emailService.sendOtp("", "123456", "REGISTER"));
        assertThrows(IllegalArgumentException.class, () -> emailService.sendOtp(null, "123456", "REGISTER"));
    }

    @Test
    void sendOtpValidEmailDoesNotThrowOrLogs() {
        EmailService emailService = new EmailServiceImpl();
        assertDoesNotThrow(() -> emailService.sendOtp("test@example.com", "654321", "REGISTER"));
    }
}
