package vn.iotstar.controller;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import vn.iotstar.entity.Product;
import vn.iotstar.entity.User;
import vn.iotstar.service.IProductService;

import java.util.List;

import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.*;

public class HomeControllerTest {
    private IProductService productService;
    private HomeController controller;
    private HttpServletRequest request;
    private HttpServletResponse response;
    private HttpSession session;
    private RequestDispatcher dispatcher;

    @BeforeEach
    void setup() {
        productService = mock(IProductService.class);
        controller = new HomeController(productService);
        request = mock(HttpServletRequest.class);
        response = mock(HttpServletResponse.class);
        session = mock(HttpSession.class);
        dispatcher = mock(RequestDispatcher.class);

        when(request.getRequestDispatcher(anyString())).thenReturn(dispatcher);
    }

    @Test
    void unauthenticatedRedirectsToLogin() throws Exception {
        when(request.getSession(false)).thenReturn(null);

        controller.doGet(request, response);

        verify(response).sendRedirect(contains("/login"));
        verify(dispatcher, never()).forward(request, response);
    }

    @Test
    void authenticatedLoadsTop10AndForwards() throws Exception {
        when(request.getSession(false)).thenReturn(session);
        when(session.getAttribute("account")).thenReturn(new User());
        List<Product> top10 = List.of(new Product(), new Product());
        when(productService.findTopN(10)).thenReturn(top10);

        controller.doGet(request, response);

        verify(request).setAttribute(eq("top10"), eq(top10));
        verify(request).getRequestDispatcher(eq("/views/home.jsp"));
        verify(dispatcher).forward(request, response);
    }
}
