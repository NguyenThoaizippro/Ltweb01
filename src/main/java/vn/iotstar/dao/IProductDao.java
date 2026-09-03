package vn.iotstar.dao;

import vn.iotstar.entity.Product;

import java.util.List;

public interface IProductDao {
    void insert(Product product);
    void update(Product product);
    void delete(int productId) throws Exception;
    Product findById(int productId);
    List<Product> findAll();
    List<Product> findAll(int page, int pageSize);
    List<Product> findTopN(int n);
    List<Product> searchByName(String keyword);
    int count();
}
