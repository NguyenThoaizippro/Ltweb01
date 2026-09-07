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

    @Test
    void insertProductBlankNameFailsValidation() throws Exception {
        when(request.getRequestURI()).thenReturn("/bt01/admin/product/insert");
        when(request.getParameter("productName")).thenReturn("");
        when(request.getParameter("price")).thenReturn("500000");

        controller.doPost(request, response);

        verify(request).setAttribute(eq("alert"), contains("không được để trống"));
        verify(request).getRequestDispatcher(eq("/views/admin/product-add.jsp"));
        verify(dispatcher).forward(request, response);
        verify(productService, never()).insert(any(Product.class));
    }

    @Test
    void insertProductInvalidPriceFailsValidation() throws Exception {
        when(request.getRequestURI()).thenReturn("/bt01/admin/product/insert");
        when(request.getParameter("productName")).thenReturn("iPhone 15 Pro");
        when(request.getParameter("price")).thenReturn("-1000");

        controller.doPost(request, response);

        verify(request).setAttribute(eq("alert"), contains("lớn hơn hoặc bằng 0"));
        verify(request).getRequestDispatcher(eq("/views/admin/product-add.jsp"));
        verify(dispatcher).forward(request, response);
        verify(productService, never()).insert(any(Product.class));
    }

    @Test
    void insertProductSuccess() throws Exception {
        when(request.getRequestURI()).thenReturn("/bt01/admin/product/insert");
        when(request.getContextPath()).thenReturn("/bt01");
        when(request.getParameter("productName")).thenReturn("Samsung Galaxy S24");
        when(request.getParameter("description")).thenReturn("Flagship phone");
        when(request.getParameter("price")).thenReturn("20000000");
        when(request.getParameter("status")).thenReturn("1");
        when(request.getParameter("categoryId")).thenReturn("2");
        when(request.getParameter("images")).thenReturn("https://example.com/s24.jpg");
        when(request.getPart("images1")).thenReturn(null);

        vn.iotstar.entity.Category mockCategory = new vn.iotstar.entity.Category();
        mockCategory.setCategoryid(2);
        when(categoryService.findById(2)).thenReturn(mockCategory);

        controller.doPost(request, response);

        verify(productService).insert(any(Product.class));
        verify(response).sendRedirect("/bt01/admin/products");
    }
}
