package vn.iotstar.service;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import vn.iotstar.dao.UserDao;
import vn.iotstar.entity.User;
import vn.iotstar.service.impl.UserServiceImpl;
import vn.iotstar.util.PasswordUtil;

import java.util.HashMap;
import java.util.Map;

import static org.junit.jupiter.api.Assertions.*;

public class UserServiceTest {
    private UserService userService;
    private InMemoryUserDao fakeUserDao;
    private MockOtpService fakeOtpService;

    static class InMemoryUserDao implements UserDao {
        Map<String, User> byUsername = new HashMap<>();
        Map<String, User> byEmail = new HashMap<>();
        Map<Integer, User> byId = new HashMap<>();
        int idSeq = 1;

        @Override
        public User findById(int id) {
            return byId.get(id);
        }

        @Override
        public User get(String username) {
            return byUsername.get(username);
        }

        @Override
        public User getByEmail(String email) {
            return byEmail.get(email);
        }

        @Override
        public void insert(User user) {
            user.setId(idSeq++);
            byId.put(user.getId(), user);
            byUsername.put(user.getUserName(), user);
            byEmail.put(user.getEmail(), user);
        }

        @Override
        public void update(User user) {
            byId.put(user.getId(), user);
            if (user.getUserName() != null) byUsername.put(user.getUserName(), user);
            if (user.getEmail() != null) byEmail.put(user.getEmail(), user);
        }

        @Override
        public void updateActiveByEmail(String email, int isActive) {
            User u = byEmail.get(email);
            if (u != null) {
                u.setIsActive(isActive);
            }
        }

        @Override
        public void updatePassword(User user) {
            User u = byUsername.get(user.getUserName());
            if (u != null) {
                u.setPassWord(user.getPassWord());
            }
        }
    }

    static class MockOtpService implements OtpService {
        String lastEmail;
        String lastPurpose;
        boolean verifyResult = true;

        @Override
        public void createAndSend(String email, String purpose) {
            this.lastEmail = email;
            this.lastPurpose = purpose;
        }

        @Override
        public boolean verify(String email, String otp, String purpose) {
            return verifyResult;
        }

        @Override
        public vn.iotstar.entity.OtpToken findLatest(String email, String purpose) {
            return null;
        }
    }

    @BeforeEach
    void setup() {
        fakeUserDao = new InMemoryUserDao();
        fakeOtpService = new MockOtpService();
        userService = new UserServiceImpl(fakeUserDao, fakeOtpService);
    }

    @Test
    void registerDoesNotSaveToDbButSendsOtp() throws Exception {
        String u = "testuser";
        String e = "testuser@gmail.com";
        String p = "123456";

        userService.register(u, e, p);

        User saved = userService.get(u);
        assertNull(saved, "Registration should not save to DB immediately");
        assertEquals(e, fakeOtpService.lastEmail);
        assertEquals("REGISTER", fakeOtpService.lastPurpose);
    }

    @Test
    void registerDuplicateUsernameThrows() throws Exception {
        User u = new User(); u.setUserName("duplicate"); u.setEmail("dup1@gmail.com"); u.setPassWord("pass"); u.setIsActive(1);
        userService.insert(u);
        Exception ex = assertThrows(Exception.class, () -> userService.register("duplicate", "dup2@gmail.com", "pass"));
        assertTrue(ex.getMessage().contains("Username"));
    }

    @Test
    void registerDuplicateEmailThrows() throws Exception {
        User u = new User(); u.setUserName("user1"); u.setEmail("dup@gmail.com"); u.setPassWord("pass"); u.setIsActive(1);
        userService.insert(u);
        Exception ex = assertThrows(Exception.class, () -> userService.register("user2", "dup@gmail.com", "pass"));
        assertTrue(ex.getMessage().contains("Email"));
    }

    @Test
    void activateChangesStatusToActive() throws Exception {
        User u = new User(); u.setUserName("user_act"); u.setEmail("act@gmail.com"); u.setPassWord("pass"); u.setIsActive(0);
        userService.insert(u);
        assertEquals(0, userService.get("user_act").getIsActive());

        userService.activate("act@gmail.com");
        assertEquals(1, userService.get("user_act").getIsActive());
    }

    @Test
    void loginBlockInactiveAndAllowsActive() throws Exception {
        User u = new User(); u.setUserName("inactive_user"); u.setEmail("inactive@gmail.com"); u.setPassWord(PasswordUtil.hash("pass123")); u.setIsActive(0);
        userService.insert(u);

        // Before activation, login should return null
        assertNull(userService.login("inactive_user", "pass123"), "Inactive user should not be able to login");

        // Activate user
        userService.activate("inactive@gmail.com");

        // After activation, login should succeed
        User loggedIn = userService.login("inactive_user", "pass123");
        assertNotNull(loggedIn, "Active user should be able to login");
        assertEquals("inactive_user", loggedIn.getUserName());

        // Wrong password should fail
        assertNull(userService.login("inactive_user", "wrong_pass"));

        // Login using email should also succeed
        User loggedInByEmail = userService.login("inactive@gmail.com", "pass123");
        assertNotNull(loggedInByEmail, "Should be able to login using email");
    }

    @Test
    void loginLegacyPlaintextPasswordUpgradesHash() {
        User legacy = new User();
        legacy.setUserName("legacy");
        legacy.setEmail("legacy@gmail.com");
        legacy.setPassWord("plain123");
        legacy.setIsActive(1);
        fakeUserDao.insert(legacy);

        User loggedIn = userService.login("legacy", "plain123");
        assertNotNull(loggedIn);

        // Verify password was auto-migrated to BCrypt
        User updated = fakeUserDao.get("legacy");
        assertTrue(updated.getPassWord().startsWith("$2"), "Legacy password should be upgraded to BCrypt");
    }

    @Test
    void testUpdateProfileSuccess() throws Exception {
        User u = new User();
        u.setUserName("profileuser");
        u.setEmail("profile@gmail.com");
        u.setPassWord("pass123");
        fakeUserDao.insert(u);

        int userId = u.getId();
        User updated = userService.updateProfile(userId, "Nguyen Van A", "0912345678", "avatar123.jpg");

        assertNotNull(updated);
        assertEquals("Nguyen Van A", updated.getFullName());
        assertEquals("0912345678", updated.getPhone());
        assertEquals("avatar123.jpg", updated.getAvatar());
        assertEquals("avatar123.jpg", updated.getImages());

        // Verify retrieval via findById
        User reloaded = userService.findById(userId);
        assertNotNull(reloaded);
        assertEquals("Nguyen Van A", reloaded.getFullName());
    }

    @Test
    void testUpdateProfileUserNotFound() {
        assertThrows(Exception.class, () -> {
            userService.updateProfile(9999, "Name", "0900000000", "pic.jpg");
        });
    }
}
