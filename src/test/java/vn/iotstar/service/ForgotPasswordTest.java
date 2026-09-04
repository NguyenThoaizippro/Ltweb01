package vn.iotstar.service;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import vn.iotstar.dao.UserDao;
import vn.iotstar.entity.User;
import vn.iotstar.service.impl.OtpServiceImpl;
import vn.iotstar.service.impl.UserServiceImpl;

import static org.junit.jupiter.api.Assertions.*;

public class ForgotPasswordTest {
    private UserService userService;
    private OtpService otpService;
    private UserServiceTest.InMemoryUserDao fakeUserDao;
    private OtpServiceTest.InMemoryOtpTokenDao fakeOtpDao;
    private OtpServiceTest.MockEmailService fakeEmailService;

    @BeforeEach
    void setup() {
        fakeUserDao = new UserServiceTest.InMemoryUserDao();
        fakeOtpDao = new OtpServiceTest.InMemoryOtpTokenDao();
        fakeEmailService = new OtpServiceTest.MockEmailService();

        otpService = new OtpServiceImpl(fakeOtpDao, fakeEmailService);
        userService = new UserServiceImpl(fakeUserDao, otpService);
    }

    @Test
    void forgotAndResetFlow() throws Exception {
        String u = "forgot_user";
        String e = "forgot@gmail.com";
        String oldPass = "old_password";
        String newPass = "new_secret_123";

        // Insert active user directly
        vn.iotstar.entity.User user = new vn.iotstar.entity.User();
        user.setUserName(u);
        user.setEmail(e);
        user.setPassWord(vn.iotstar.util.PasswordUtil.hash(oldPass));
        user.setIsActive(1);
        userService.insert(user);
        
        assertNotNull(userService.login(u, oldPass));

        // Trigger forgot password OTP
        otpService.createAndSend(e, "FORGOT");
        assertEquals("FORGOT", fakeEmailService.lastPurpose);
        assertEquals(e, fakeEmailService.lastEmail);
        assertNotNull(fakeEmailService.lastOtp);

        // Verify OTP
        assertTrue(otpService.verify(e, fakeEmailService.lastOtp, "FORGOT"));

        // Reset password
        userService.resetPassword(e, newPass);

        // Verify new password works and old password fails
        assertNotNull(userService.login(u, newPass), "Should be able to login with new password");
        assertNull(userService.login(u, oldPass), "Old password should no longer work");
    }

    @Test
    void resetPasswordNonExistentEmailThrows() {
        assertThrows(Exception.class, () -> userService.resetPassword("nonexistent@gmail.com", "pass"));
    }
}
