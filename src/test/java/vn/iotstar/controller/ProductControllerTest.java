package vn.iotstar.controller;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.Mockito;
import vn.iotstar.entity.Product;
import vn.iotstar.service.ICategoryService;
import vn.iotstar.service.IProductService;

import java.util.List;

import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.*;

public class ProductControllerTest {
    private IProductService productService;
    private ICategoryService categoryService;
    private ProductController controller;
    private HttpServletRequest request;
    private HttpServletResponse response;
    private RequestDispatcher dispatcher;

    @BeforeEach
    void setup() {
        productService = mock(IProductService.class);
        categoryService = mock(ICategoryService.class);
        controller = new ProductController(productService, categoryService);
        request = mock(HttpServletRequest.class);
        response = mock(HttpServletResponse.class);
        dispatcher = mock(RequestDispatcher.class);

        when(request.getRequestDispatcher(anyString())).thenReturn(dispatcher);
    }

    @Test
    void adminProductListForward() throws Exception {
        when(request.getRequestURI()).thenReturn("/bt01/admin/products");
        List<Product> products = List.of(new Product());
        when(productService.findAll()).thenReturn(products);

        controller.doGet(request, response);

        verify(request).setAttribute(eq("listProduct"), eq(products));
        verify(request).getRequestDispatcher(eq("/views/admin/product-list.jsp"));
        verify(dispatcher).forward(request, response);
    }

    @Test
    void productPaginationForward() throws Exception {
        when(request.getRequestURI()).thenReturn("/bt01/product");
        when(request.getParameter("page")).thenReturn("1");
        when(productService.count()).thenReturn(15);
        List<Product> pageProducts = List.of(new Product());
        when(productService.findAll(1, 6)).thenReturn(pageProducts);

        controller.doGet(request, response);

        verify(request).setAttribute(eq("listProduct"), eq(pageProducts));
        verify(request).setAttribute(eq("currentPage"), eq(1));
        verify(request).setAttribute(eq("totalPages"), eq(3)); // 15 items / 6 = 3 pages
        verify(request).getRequestDispatcher(eq("/views/product-list.jsp"));
        verify(dispatcher).forward(request, response);
    }

    @Test
    void productDetailForward() throws Exception {
        when(request.getRequestURI()).thenReturn("/bt01/product/detail");
        when(request.getParameter("id")).thenReturn("5");
        Product p = new Product();
        when(productService.findById(5)).thenReturn(p);

        controller.doGet(request, response);

        verify(request).setAttribute(eq("product"), eq(p));
        verify(request).getRequestDispatcher(eq("/views/product-detail.jsp"));
        verify(dispatcher).forward(request, response);
    }
}
