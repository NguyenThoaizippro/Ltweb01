package vn.iotstar.util;

import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

import java.time.Instant;
import java.util.Date;

public class OtpUtilTest {
    @Test
    void generate6Digits() {
        String otp = OtpUtil.generate();
        assertNotNull(otp);
        assertTrue(otp.matches("\\d{6}"), "OTP should be exactly 6 digits");
    }

    @Test
    void expiry120s() {
        Date now = new Date();
        Date expiredTime = new Date(now.getTime() - 1000); // 1s ago
        Date futureTime = new Date(now.getTime() + 120000); // 120s future

        assertTrue(OtpUtil.isExpired(expiredTime), "Past time should be expired");
        assertFalse(OtpUtil.isExpired(futureTime), "Future time should not be expired");
    }

    @Test
    void canResend60s() {
        Date justCreated = new Date(); // now
        Date created65sAgo = new Date(System.currentTimeMillis() - 65000);

        assertFalse(OtpUtil.canResend(justCreated, 60), "Should not allow resend immediately");
        assertTrue(OtpUtil.canResend(created65sAgo, 60), "Should allow resend after 60s");
    }

    @Test
    void otpRandom() {
        String otp1 = OtpUtil.generate();
        String otp2 = OtpUtil.generate();
        // Since it's random 6 digits, 2 consecutive calls should almost never be equal
        // but just to be safe in rare cases:
        if (otp1.equals(otp2)) {
            String otp3 = OtpUtil.generate();
            assertNotEquals(otp1, otp3);
        } else {
            assertNotEquals(otp1, otp2);
        }
    }
}
