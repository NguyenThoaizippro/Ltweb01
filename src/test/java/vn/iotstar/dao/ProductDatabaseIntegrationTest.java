package vn.iotstar.dao;

import org.junit.jupiter.api.Test;
import vn.iotstar.dao.impl.ProductDaoImpl;
import vn.iotstar.entity.Product;
import vn.iotstar.service.IProductService;
import vn.iotstar.service.impl.ProductServiceImpl;

import java.util.List;

import static org.junit.jupiter.api.Assertions.*;

public class ProductDatabaseIntegrationTest {

    private final IProductService productService = new ProductServiceImpl(new ProductDaoImpl());

    @Test
    void testDatabaseHas50Products() {
        int count = productService.count();
        assertEquals(50, count, "Cơ sở dữ liệu phải có chính xác 50 sản phẩm điện thoại");
    }

    @Test
    void testTop10ProductsForHome() {
        List<Product> top10 = productService.findTopN(10);
        assertNotNull(top10);
        assertEquals(10, top10.size(), "Trang chủ phải lấy được đúng 10 sản phẩm mới nhất");

        for (Product p : top10) {
            assertNotNull(p.getProductName(), "Tên sản phẩm không được rỗng");
            assertNotNull(p.getPrice(), "Giá sản phẩm không được rỗng");
            assertNotNull(p.getCategory(), "Danh mục sản phẩm phải liên kết qua FK");
            assertNotNull(p.getCategory().getCategoryname(), "Tên danh mục không được rỗng");
            assertTrue(p.getStatus() == 1, "Sản phẩm phải ở trạng thái hoạt động");
        }
    }

    @Test
    void testBrandSearch() {
        List<Product> iphones = productService.searchByName("iPhone");
        assertEquals(15, iphones.size(), "Phải tìm thấy đủ 15 dòng iPhone");

        List<Product> samsungs = productService.searchByName("Samsung");
        assertEquals(15, samsungs.size(), "Phải tìm thấy đủ 15 dòng Samsung");

        List<Product> xiaomis = productService.searchByName("Xiaomi");
        assertTrue(xiaomis.size() >= 4, "Phải tìm thấy các dòng Xiaomi");
    }

    @Test
    void testPagination() {
        // 50 sản phẩm với pageSize = 6 => page 0: 6 items, page 8: 2 items
        List<Product> page0 = productService.findAll(0, 6);
        assertEquals(6, page0.size());

        List<Product> page8 = productService.findAll(8, 6);
        assertEquals(2, page8.size());
    }
}
