package vn.iotstar.controller;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.Mockito;
import vn.iotstar.entity.User;
import vn.iotstar.service.OtpService;
import vn.iotstar.service.UserService;

import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

public class RegisterControllerTest {

    private UserService mockUserService;
    private OtpService mockOtpService;
    private RegisterController controller;
    private HttpServletRequest req;
    private HttpServletResponse resp;
    private HttpSession session;
    private RequestDispatcher dispatcher;

    @BeforeEach
    void setUp() {
        mockUserService = Mockito.mock(UserService.class);
        mockOtpService = Mockito.mock(OtpService.class);
        controller = new RegisterController(mockUserService, mockOtpService);
        req = Mockito.mock(HttpServletRequest.class);
        resp = Mockito.mock(HttpServletResponse.class);
        session = Mockito.mock(HttpSession.class);
        dispatcher = Mockito.mock(RequestDispatcher.class);

        when(req.getRequestDispatcher(anyString())).thenReturn(dispatcher);
        when(req.getSession()).thenReturn(session);
        when(req.getContextPath()).thenReturn("/bt01");
    }

    @Test
    void testDoGetIncludesRegisterJsp() throws Exception {
        controller.doGet(req, resp);
        verify(req).getRequestDispatcher("/views/register.jsp");
        verify(dispatcher).include(req, resp);
    }

    @Test
    void testDoPostEmptyUsernameReturnsAlert() throws Exception {
        when(req.getParameter("username")).thenReturn("");
        when(req.getParameter("email")).thenReturn("test@gmail.com");
        when(req.getParameter("password")).thenReturn("123456");
        when(req.getParameter("confirmPassword")).thenReturn("123456");

        controller.doPost(req, resp);

        verify(req).setAttribute(eq("alert"), contains("không được để trống"));
        verify(dispatcher).include(req, resp);
    }

    @Test
    void testDoPostInvalidUsernameCharactersReturnsAlert() throws Exception {
        when(req.getParameter("username")).thenReturn("admin user@123");
        when(req.getParameter("email")).thenReturn("test@gmail.com");
        when(req.getParameter("password")).thenReturn("123456");
        when(req.getParameter("confirmPassword")).thenReturn("123456");

        controller.doPost(req, resp);

        verify(req).setAttribute(eq("alert"), contains("3-30 ký tự"));
        verify(dispatcher).include(req, resp);
    }

    @Test
    void testDoPostInvalidEmailFormatReturnsAlert() throws Exception {
        when(req.getParameter("username")).thenReturn("testuser");
        when(req.getParameter("email")).thenReturn("invalid-email-format");
        when(req.getParameter("password")).thenReturn("123456");
        when(req.getParameter("confirmPassword")).thenReturn("123456");

        controller.doPost(req, resp);

        verify(req).setAttribute(eq("alert"), contains("định dạng"));
        verify(dispatcher).include(req, resp);
    }

    @Test
    void testDoPostInvalidPhoneNumberReturnsAlert() throws Exception {
        when(req.getParameter("username")).thenReturn("testuser");
        when(req.getParameter("email")).thenReturn("test@gmail.com");
        when(req.getParameter("phone")).thenReturn("123456"); // Invalid VN phone
        when(req.getParameter("password")).thenReturn("123456");
        when(req.getParameter("confirmPassword")).thenReturn("123456");

        controller.doPost(req, resp);

        verify(req).setAttribute(eq("alert"), contains("Số điện thoại không hợp lệ"));
        verify(dispatcher).include(req, resp);
    }

    @Test
    void testDoPostShortPasswordReturnsAlert() throws Exception {
        when(req.getParameter("username")).thenReturn("testuser");
        when(req.getParameter("email")).thenReturn("test@gmail.com");
        when(req.getParameter("password")).thenReturn("123");
        when(req.getParameter("confirmPassword")).thenReturn("123");

        controller.doPost(req, resp);

        verify(req).setAttribute(eq("alert"), contains("tối thiểu 6 ký tự"));
        verify(dispatcher).include(req, resp);
    }

    @Test
    void testDoPostPasswordMismatchReturnsAlert() throws Exception {
        when(req.getParameter("username")).thenReturn("testuser");
        when(req.getParameter("email")).thenReturn("test@gmail.com");
        when(req.getParameter("password")).thenReturn("123456");
        when(req.getParameter("confirmPassword")).thenReturn("654321");

        controller.doPost(req, resp);

        verify(req).setAttribute(eq("alert"), contains("không khớp"));
        verify(dispatcher).include(req, resp);
    }

    @Test
    void testDoPostDuplicateUsernameReturnsAlert() throws Exception {
        when(req.getParameter("username")).thenReturn("admin");
        when(req.getParameter("email")).thenReturn("admin@gmail.com");
        when(req.getParameter("password")).thenReturn("123456");
        when(req.getParameter("confirmPassword")).thenReturn("123456");

        User existingUser = new User();
        existingUser.setUserName("admin");
        when(mockUserService.get("admin")).thenReturn(existingUser);

        controller.doPost(req, resp);

        verify(req).setAttribute(eq("alert"), contains("đã được sử dụng"));
        verify(dispatcher).include(req, resp);
    }

    @Test
    void testDoPostValidRegistrationSendsOtpAndRedirects() throws Exception {
        when(req.getParameter("username")).thenReturn("validuser");
        when(req.getParameter("email")).thenReturn("valid@example.com");
        when(req.getParameter("fullname")).thenReturn("Nguyen Van A");
        when(req.getParameter("phone")).thenReturn("0912345678");
        when(req.getParameter("password")).thenReturn("secret123");
        when(req.getParameter("confirmPassword")).thenReturn("secret123");

        when(mockUserService.get("validuser")).thenReturn(null);
        when(mockUserService.getByEmail("valid@example.com")).thenReturn(null);

        controller.doPost(req, resp);

        verify(session).setAttribute(eq("PENDING_USER_valid@example.com"), any(User.class));
        verify(mockOtpService).createAndSend(eq("valid@example.com"), eq("REGISTER"));
        verify(resp).sendRedirect(contains("/bt01/verify-otp"));
    }
}
