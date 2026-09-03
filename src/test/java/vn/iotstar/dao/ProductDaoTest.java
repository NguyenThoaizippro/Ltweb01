package vn.iotstar.dao;

import org.junit.jupiter.api.Test;
import vn.iotstar.dao.impl.ProductDaoImpl;
import vn.iotstar.entity.Category;
import vn.iotstar.entity.Product;
import vn.iotstar.service.IProductService;
import vn.iotstar.service.impl.ProductServiceImpl;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;

public class ProductDaoTest {

    // Test service validations
    @Test
    void productServiceValidation() {
        IProductService service = new ProductServiceImpl(new IProductDao() {
            @Override public void insert(Product product) {}
            @Override public void update(Product product) {}
            @Override public void delete(int productId) {}
            @Override public Product findById(int productId) { return null; }
            @Override public List<Product> findAll() { return List.of(); }
            @Override public List<Product> findAll(int page, int pageSize) { return List.of(); }
            @Override public List<Product> findTopN(int n) { return List.of(); }
            @Override public List<Product> searchByName(String keyword) { return List.of(); }
            @Override public int count() { return 0; }
        });

        // Null product throws
        assertThrows(IllegalArgumentException.class, () -> service.insert(null));

        // Missing category throws
        Product pWithoutCat = new Product();
        pWithoutCat.setProductName("Test");
        pWithoutCat.setPrice(new BigDecimal("100"));
        assertThrows(IllegalArgumentException.class, () -> service.insert(pWithoutCat));

        // Negative price throws
        Product pNegativePrice = new Product();
        pNegativePrice.setProductName("Test");
        pNegativePrice.setCategory(new Category());
        pNegativePrice.setPrice(new BigDecimal("-10"));
        assertThrows(IllegalArgumentException.class, () -> service.insert(pNegativePrice));
    }

    // In-memory / Mock test for pagination logic
    @Test
    void paginationLogic() {
        List<Product> mockList = new ArrayList<>();
        for (int i = 0; i < 15; i++) {
            Product p = new Product();
            p.setProductId(i + 1);
            p.setProductName("Product " + (i + 1));
            p.setPrice(BigDecimal.valueOf(100 + i));
            mockList.add(p);
        }

        IProductDao fakeDao = new IProductDao() {
            @Override public void insert(Product product) { mockList.add(product); }
            @Override public void update(Product product) {}
            @Override public void delete(int productId) { mockList.removeIf(p -> p.getProductId() == productId); }
            @Override public Product findById(int productId) {
                return mockList.stream().filter(p -> p.getProductId() == productId).findFirst().orElse(null);
            }
            @Override public List<Product> findAll() { return mockList; }
            @Override public List<Product> findAll(int page, int pageSize) {
                int from = page * pageSize;
                int to = Math.min(from + pageSize, mockList.size());
                if (from >= mockList.size()) return List.of();
                return mockList.subList(from, to);
            }
            @Override public List<Product> findTopN(int n) {
                return mockList.subList(0, Math.min(n, mockList.size()));
            }
            @Override public List<Product> searchByName(String keyword) {
                return mockList.stream().filter(p -> p.getProductName().contains(keyword)).toList();
            }
            @Override public int count() { return mockList.size(); }
        };

        IProductService service = new ProductServiceImpl(fakeDao);

        assertEquals(15, service.count());
        assertEquals(10, service.findTopN(10).size());
        assertEquals(6, service.findAll(0, 6).size());
        assertEquals(6, service.findAll(1, 6).size());
        assertEquals(3, service.findAll(2, 6).size());
        assertEquals(0, service.findAll(3, 6).size());

        assertNotNull(service.findById(1));
        assertNull(service.findById(999));
    }
}
