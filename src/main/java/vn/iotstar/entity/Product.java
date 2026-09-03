package vn.iotstar.entity;

import jakarta.persistence.*;
import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Date;

@Entity
@Table(name = "products")
@NamedQueries({
    @NamedQuery(name = "Product.findAll", query = "SELECT p FROM Product p ORDER BY p.createDate DESC"),
    @NamedQuery(name = "Product.count", query = "SELECT COUNT(p) FROM Product p")
})
public class Product implements Serializable {
    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "productId")
    private int productId;

    @Column(name = "productName", nullable = false, columnDefinition = "nvarchar(200)")
    private String productName;

    @Column(columnDefinition = "nvarchar(1000)")
    private String description;

    @Column(nullable = false)
    private BigDecimal price;

    @Column(columnDefinition = "nvarchar(500)")
    private String images;

    @Column(name = "status")
    private int status = 1;

    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "createDate")
    private Date createDate = new Date();

    @ManyToOne
    @JoinColumn(name = "categoryId", nullable = false)
    private Category category;

    public Product() {
    }

    public Product(String productName, String description, BigDecimal price, String images, int status, Category category) {
        this.productName = productName;
        this.description = description;
        this.price = price;
        this.images = images;
        this.status = status;
        this.category = category;
        this.createDate = new Date();
    }

    public int getProductId() {
        return productId;
    }

    public void setProductId(int productId) {
        this.productId = productId;
    }

    public String getProductName() {
        return productName;
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public BigDecimal getPrice() {
        return price;
    }

    public void setPrice(BigDecimal price) {
        this.price = price;
    }

    public String getImages() {
        return images;
    }

    public void setImages(String images) {
        this.images = images;
    }

    public int getStatus() {
        return status;
    }

    public void setStatus(int status) {
        this.status = status;
    }

    public Date getCreateDate() {
        return createDate;
    }

    public void setCreateDate(Date createDate) {
        this.createDate = createDate;
    }

    public Category getCategory() {
        return category;
    }

    public void setCategory(Category category) {
        this.category = category;
    }
}
