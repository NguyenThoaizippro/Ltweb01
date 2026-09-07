package vn.iotstar.service;

import vn.iotstar.entity.Product;

import java.util.List;

public interface IProductService {
    void insert(Product product);
    void update(Product product);
    void delete(int productId) throws Exception;
    Product findById(int productId);
    List<Product> findAll();
    List<Product> findAll(int page, int pageSize);
    List<Product> findTopN(int n);
    List<Product> searchByName(String keyword);
    List<Product> searchByName(String keyword, int page, int pageSize);
    int countSearch(String keyword);
    List<Product> findByCategory(int categoryId);
    List<Product> findByCategory(int categoryId, int page, int pageSize);
    int countByCategory(int categoryId);
    int count();
}
