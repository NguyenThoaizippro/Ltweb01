package vn.iotstar.service.impl;

import vn.iotstar.dao.IProductDao;
import vn.iotstar.dao.impl.ProductDaoImpl;
import vn.iotstar.entity.Product;
import vn.iotstar.service.IProductService;

import java.math.BigDecimal;
import java.util.List;

public class ProductServiceImpl implements IProductService {
    private final IProductDao productDao;

    public ProductServiceImpl() {
        this.productDao = new ProductDaoImpl();
    }

    public ProductServiceImpl(IProductDao productDao) {
        this.productDao = productDao;
    }

    @Override
    public void insert(Product product) {
        if (product == null) {
            throw new IllegalArgumentException("Sản phẩm không thể là null");
        }
        if (product.getCategory() == null) {
            throw new IllegalArgumentException("Sản phẩm phải thuộc một danh mục");
        }
        if (product.getPrice() == null || product.getPrice().compareTo(BigDecimal.ZERO) < 0) {
            throw new IllegalArgumentException("Giá sản phẩm phải lớn hơn hoặc bằng 0");
        }
        productDao.insert(product);
    }

    @Override
    public void update(Product product) {
        if (product == null) {
            throw new IllegalArgumentException("Sản phẩm không thể là null");
        }
        if (product.getCategory() == null) {
            throw new IllegalArgumentException("Sản phẩm phải thuộc một danh mục");
        }
        if (product.getPrice() == null || product.getPrice().compareTo(BigDecimal.ZERO) < 0) {
            throw new IllegalArgumentException("Giá sản phẩm phải lớn hơn hoặc bằng 0");
        }
        productDao.update(product);
    }

    @Override
    public void delete(int productId) throws Exception {
        productDao.delete(productId);
    }

    @Override
    public Product findById(int productId) {
        return productDao.findById(productId);
    }

    @Override
    public List<Product> findAll() {
        return productDao.findAll();
    }

    @Override
    public List<Product> findAll(int page, int pageSize) {
        return productDao.findAll(page, pageSize);
    }

    @Override
    public List<Product> findTopN(int n) {
        return productDao.findTopN(n);
    }

    @Override
    public List<Product> searchByName(String keyword) {
        return productDao.searchByName(keyword);
    }

    @Override
    public List<Product> searchByName(String keyword, int page, int pageSize) {
        return productDao.searchByName(keyword, page, pageSize);
    }

    @Override
    public int countSearch(String keyword) {
        return productDao.countSearch(keyword);
    }

    @Override
    public List<Product> findByCategory(int categoryId) {
        return productDao.findByCategory(categoryId);
    }

    @Override
    public List<Product> findByCategory(int categoryId, int page, int pageSize) {
        return productDao.findByCategory(categoryId, page, pageSize);
    }

    @Override
    public int countByCategory(int categoryId) {
        return productDao.countByCategory(categoryId);
    }

    @Override
    public int count() {
        return productDao.count();
    }
}
