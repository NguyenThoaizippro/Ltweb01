package vn.iotstar.service;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import vn.iotstar.dao.OtpTokenDao;
import vn.iotstar.entity.OtpToken;
import vn.iotstar.service.impl.OtpServiceImpl;

import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import static org.junit.jupiter.api.Assertions.*;

public class OtpServiceTest {
    private OtpService otpService;
    private InMemoryOtpTokenDao fakeDao;
    private MockEmailService fakeEmailService;

    // In-memory fake DAO for fast, robust isolated testing
    static class InMemoryOtpTokenDao implements OtpTokenDao {
        Map<String, OtpToken> storage = new HashMap<>();
        int idGen = 1;

        @Override
        public void save(OtpToken token) {
            token.setId(idGen++);
            storage.put(token.getEmail() + "#" + token.getPurpose(), token);
        }

        @Override
        public OtpToken findLatest(String email, String purpose) {
            return storage.get(email + "#" + purpose);
        }

        @Override
        public void delete(int id) {
            storage.entrySet().removeIf(e -> e.getValue().getId() == id);
        }

        @Override
        public void incrementAttempts(int id) {
            storage.values().stream()
                    .filter(t -> t.getId() == id)
                    .findFirst()
                    .ifPresent(t -> t.setAttempts(t.getAttempts() + 1));
        }
    }

    static class MockEmailService implements EmailService {
        String lastEmail;
        String lastOtp;
        String lastPurpose;

        @Override
        public void sendOtp(String toEmail, String otp, String purpose) {
            this.lastEmail = toEmail;
            this.lastOtp = otp;
            this.lastPurpose = purpose;
        }
    }

    @BeforeEach
    void setup() {
        fakeDao = new InMemoryOtpTokenDao();
        fakeEmailService = new MockEmailService();
        otpService = new OtpServiceImpl(fakeDao, fakeEmailService);
    }

    @Test
    void createAndVerifyOk() throws Exception {
        String email = "test@gmail.com";
        otpService.createAndSend(email, "REGISTER");

        assertNotNull(fakeEmailService.lastOtp);
        assertEquals(email, fakeEmailService.lastEmail);
        assertEquals("REGISTER", fakeEmailService.lastPurpose);

        OtpToken token = otpService.findLatest(email, "REGISTER");
        assertNotNull(token);
        assertEquals(fakeEmailService.lastOtp, token.getOtp());

        // Verify with correct OTP
        assertTrue(otpService.verify(email, token.getOtp(), "REGISTER"));

        // After successful verify, token should be deleted
        assertNull(otpService.findLatest(email, "REGISTER"));
    }

    @Test
    void verifyWrongOtpFailsAndIncrementsAttempts() throws Exception {
        String email = "wrong@gmail.com";
        otpService.createAndSend(email, "REGISTER");

        assertFalse(otpService.verify(email, "000000", "REGISTER"));
        OtpToken token = otpService.findLatest(email, "REGISTER");
        assertNotNull(token);
        assertEquals(1, token.getAttempts());
    }

    @Test
    void resendCooldown60s() throws Exception {
        String email = "cooldown@gmail.com";
        otpService.createAndSend(email, "REGISTER");

        // Immediately resend must throw cooldown exception
        Exception ex = assertThrows(Exception.class, () -> otpService.createAndSend(email, "REGISTER"));
        assertTrue(ex.getMessage().contains("Vui lòng đợi"));
    }

    @Test
    void expiredOtpFails() {
        String email = "expired@gmail.com";
        // Create an already expired token
        Date expiredAt = new Date(System.currentTimeMillis() - 5000);
        OtpToken token = new OtpToken(email, "123456", "REGISTER", expiredAt);
        fakeDao.save(token);

        assertFalse(otpService.verify(email, "123456", "REGISTER"));
    }

    @Test
    void maxAttemptsFails() throws Exception {
        String email = "maxattempts@gmail.com";
        otpService.createAndSend(email, "REGISTER");
        OtpToken token = otpService.findLatest(email, "REGISTER");
        token.setAttempts(5);

        assertFalse(otpService.verify(email, token.getOtp(), "REGISTER"));
    }
}
