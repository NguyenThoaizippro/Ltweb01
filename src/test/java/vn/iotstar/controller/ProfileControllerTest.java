package vn.iotstar.controller;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.Mockito;
import vn.iotstar.entity.User;
import vn.iotstar.service.UserService;

import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

public class ProfileControllerTest {

    private UserService mockUserService;
    private ProfileController controller;
    private HttpServletRequest req;
    private HttpServletResponse resp;
    private HttpSession session;
    private RequestDispatcher dispatcher;

    @BeforeEach
    void setUp() {
        mockUserService = Mockito.mock(UserService.class);
        controller = new ProfileController(mockUserService);
        req = Mockito.mock(HttpServletRequest.class);
        resp = Mockito.mock(HttpServletResponse.class);
        session = Mockito.mock(HttpSession.class);
        dispatcher = Mockito.mock(RequestDispatcher.class);

        when(req.getRequestDispatcher(anyString())).thenReturn(dispatcher);
        when(req.getContextPath()).thenReturn("/bt01");
    }

    @Test
    void testDoGetNotLoggedInRedirectsToLogin() throws Exception {
        when(req.getSession(false)).thenReturn(null);

        controller.doGet(req, resp);

        verify(resp).sendRedirect("/bt01/login");
        verify(dispatcher, never()).forward(req, resp);
    }

    @Test
    void testDoGetLoggedInForwardsToProfileJsp() throws Exception {
        User user = new User();
        user.setId(10);
        user.setUserName("thoai");
        user.setFullName("Nguyen Thoai");

        when(req.getSession(false)).thenReturn(session);
        when(session.getAttribute("account")).thenReturn(user);
        when(mockUserService.findById(10)).thenReturn(user);

        controller.doGet(req, resp);

        verify(req).setAttribute(eq("user"), eq(user));
        verify(req).getRequestDispatcher("/views/profile.jsp");
        verify(dispatcher).forward(req, resp);
    }

    @Test
    void testDoPostNotLoggedInRedirectsToLogin() throws Exception {
        when(req.getSession(false)).thenReturn(null);

        controller.doPost(req, resp);

        verify(resp).sendRedirect("/bt01/login");
        verify(dispatcher, never()).forward(req, resp);
    }

    @Test
    void testDoPostUpdatesProfileAndSession() throws Exception {
        User user = new User();
        user.setId(10);
        user.setUserName("thoai");
        user.setAvatar("old.jpg");

        when(req.getSession(false)).thenReturn(session);
        when(session.getAttribute("account")).thenReturn(user);

        when(req.getParameter("fullname")).thenReturn("Nguyen Thoai Pro");
        when(req.getParameter("phone")).thenReturn("0987654321");
        when(req.getParameter("images")).thenReturn("https://example.com/avatar.jpg");
        when(req.getPart("images1")).thenReturn(null);

        User updatedUser = new User();
        updatedUser.setId(10);
        updatedUser.setUserName("thoai");
        updatedUser.setFullName("Nguyen Thoai Pro");
        updatedUser.setPhone("0987654321");
        updatedUser.setAvatar("https://example.com/avatar.jpg");

        when(mockUserService.updateProfile(eq(10), eq("Nguyen Thoai Pro"), eq("0987654321"), eq("https://example.com/avatar.jpg")))
                .thenReturn(updatedUser);

        controller.doPost(req, resp);

        verify(session).setAttribute("account", updatedUser);
        verify(req).setAttribute("user", updatedUser);
        verify(req).setAttribute(eq("msg"), anyString());
        verify(dispatcher).forward(req, resp);
    }
}
