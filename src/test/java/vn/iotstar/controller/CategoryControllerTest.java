package vn.iotstar.controller;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.Mockito;
import vn.iotstar.entity.Category;
import vn.iotstar.service.ICategoryService;

import java.util.ArrayList;
import java.util.List;

import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

public class CategoryControllerTest {

    private ICategoryService mockCateService;
    private CategoryController controller;
    private HttpServletRequest req;
    private HttpServletResponse resp;
    private RequestDispatcher dispatcher;

    @BeforeEach
    void setUp() {
        mockCateService = Mockito.mock(ICategoryService.class);
        controller = new CategoryController(mockCateService);
        req = Mockito.mock(HttpServletRequest.class);
        resp = Mockito.mock(HttpServletResponse.class);
        dispatcher = Mockito.mock(RequestDispatcher.class);

        when(req.getRequestDispatcher(anyString())).thenReturn(dispatcher);
        when(req.getContextPath()).thenReturn("/bt01");
    }

    @Test
    void testDoGetCategoriesListsAll() throws Exception {
        when(req.getRequestURI()).thenReturn("/bt01/admin/categories");
        List<Category> list = new ArrayList<>();
        when(mockCateService.findAll()).thenReturn(list);

        controller.doGet(req, resp);

        verify(req).setAttribute(eq("listcate"), eq(list));
        verify(req).getRequestDispatcher("/views/admin/category-list.jsp");
        verify(dispatcher).include(req, resp);
    }

    @Test
    void testDoPostInsertEmptyNameReturnsAlert() throws Exception {
        when(req.getRequestURI()).thenReturn("/bt01/admin/category/insert");
        when(req.getParameter("categoryname")).thenReturn("");
        when(req.getParameter("status")).thenReturn("1");

        controller.doPost(req, resp);

        verify(req).setAttribute(eq("alert"), contains("không được để trống"));
        verify(dispatcher).include(req, resp);
        verify(mockCateService, never()).insert(any());
    }

    @Test
    void testDoPostInsertShortNameReturnsAlert() throws Exception {
        when(req.getRequestURI()).thenReturn("/bt01/admin/category/insert");
        when(req.getParameter("categoryname")).thenReturn("A");
        when(req.getParameter("status")).thenReturn("1");

        controller.doPost(req, resp);

        verify(req).setAttribute(eq("alert"), contains("từ 2 đến 50 ký tự"));
        verify(dispatcher).include(req, resp);
        verify(mockCateService, never()).insert(any());
    }

    @Test
    void testDoPostInsertDuplicateNameReturnsAlert() throws Exception {
        when(req.getRequestURI()).thenReturn("/bt01/admin/category/insert");
        when(req.getParameter("categoryname")).thenReturn("Laptop");
        when(req.getParameter("status")).thenReturn("1");

        Category existing = new Category();
        existing.setCategoryid(1);
        existing.setCategoryname("Laptop");
        when(mockCateService.findByCategoryname("Laptop")).thenReturn(existing);

        controller.doPost(req, resp);

        verify(req).setAttribute(eq("alert"), contains("đã tồn tại"));
        verify(dispatcher).include(req, resp);
        verify(mockCateService, never()).insert(any());
    }

    @Test
    void testDoPostInsertValidCategoryRedirects() throws Exception {
        when(req.getRequestURI()).thenReturn("/bt01/admin/category/insert");
        when(req.getParameter("categoryname")).thenReturn("Phụ kiện");
        when(req.getParameter("status")).thenReturn("1");
        when(req.getParameter("images")).thenReturn("https://example.com/phukien.jpg");
        when(req.getPart("images1")).thenReturn(null);

        when(mockCateService.findByCategoryname("Phụ kiện")).thenReturn(null);

        controller.doPost(req, resp);

        verify(mockCateService).insert(any(Category.class));
        verify(resp).sendRedirect("/bt01/admin/categories");
    }

    @Test
    void testDoPostUpdateEmptyNameReturnsAlert() throws Exception {
        when(req.getRequestURI()).thenReturn("/bt01/admin/category/update");
        when(req.getParameter("categoryid")).thenReturn("5");
        when(req.getParameter("categoryname")).thenReturn("   ");

        Category existing = new Category();
        existing.setCategoryid(5);
        existing.setCategoryname("Old Name");
        when(mockCateService.findById(5)).thenReturn(existing);

        controller.doPost(req, resp);

        verify(req).setAttribute(eq("alert"), contains("không được để trống"));
        verify(dispatcher).include(req, resp);
        verify(mockCateService, never()).update(any());
    }
}
