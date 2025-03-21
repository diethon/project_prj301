package controller;

import dao.ProductCategoryDAO;
import dao.ProductDiscountDAO;
import dao.ProductOriginalDAO;
import dao.ProductsDAO;
import model.ProductCategory;
import model.ProductDiscount;
import model.ProductImages;

import model.ProductOriginal;
import model.Products;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.Date;
import java.util.List;
import java.util.Collection;
import java.util.ArrayList;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/products")
public class ProductServlet extends HttpServlet {
    private final ProductsDAO productsDAO = new ProductsDAO();
    private final ProductCategoryDAO categoryDAO = new ProductCategoryDAO();
    private final ProductDiscountDAO discountDAO = new ProductDiscountDAO();
    private final ProductOriginalDAO originDAO = new ProductOriginalDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        if (action == null) {
            action = "list";
        }

        switch (action) {
            case "list":
                listProducts(request, response);
                break;
            case "new":
                loadFormData(request);
                request.getRequestDispatcher("product/productForm.jsp").forward(request, response);
                break;
            case "edit":
                showEditForm(request, response);
                break;
            case "delete":
                deleteProduct(request, response);
                break;
            default:
                listProducts(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        switch (action) {
            case "insert":
                insertProduct(request, response);
                break;
            case "update":
                updateProduct(request, response);
                break;
            default:
                listProducts(request, response);
                break;
        }
    }

    private void listProducts(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<Products> products = productsDAO.findAll();
        request.setAttribute("products", products);
        request.getRequestDispatcher("product/productList.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        Products product = productsDAO.findById(id);

        if (product == null) {
            response.sendRedirect("products?action=list");
            return;
        }

        loadFormData(request);
        request.setAttribute("product", product);
        request.getRequestDispatcher("product/productForm.jsp").forward(request, response);
    }

    private void insertProduct(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        try {
            Products product = extractProductFromRequest(request);
            productsDAO.create(product);
            response.sendRedirect("products?action=list");
        } catch (Exception e) {
            request.setAttribute("errorMessage", "Lỗi khi thêm sản phẩm: " + e.getMessage());
            loadFormData(request);
            request.getRequestDispatcher("product/productForm.jsp").forward(request, response);
        }
    }

    private void updateProduct(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            Products product = extractProductFromRequest(request);
            product.setProductId(id);
            productsDAO.update(product);
            response.sendRedirect("products?action=list");
        } catch (Exception e) {
            request.setAttribute("errorMessage", "Lỗi khi cập nhật sản phẩm: " + e.getMessage());
            loadFormData(request);
            request.getRequestDispatcher("product/productForm.jsp").forward(request, response);
        }
    }

    private void deleteProduct(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        productsDAO.delete(id);
        response.sendRedirect("products?action=list");
    }

    private void loadFormData(HttpServletRequest request) {
        List<ProductCategory> categories = categoryDAO.findAll();
        List<ProductDiscount> discounts = discountDAO.findAll();
        List<ProductOriginal> origins = originDAO.findAll();

        request.setAttribute("categories", categories);
        request.setAttribute("discounts", discounts);
        request.setAttribute("origins", origins);
    }

    private Products extractProductFromRequest(HttpServletRequest request) {
        String nameProduct = request.getParameter("nameProduct");
        String description = request.getParameter("description");
        String sku = request.getParameter("sku");
        BigDecimal price = new BigDecimal(request.getParameter("price"));
        String ingredient = request.getParameter("ingredient");
        Boolean state = request.getParameter("state") != null;

        int categoryId = Integer.parseInt(request.getParameter("categoryId"));
        int discountId = Integer.parseInt(request.getParameter("discountId"));
        int originId = Integer.parseInt(request.getParameter("originId"));

        Products product = new Products();
        product.setNameProduct(nameProduct);
        product.setDescription(description);
        product.setSku(sku);
        product.setPrice(price);
        product.setIngredient(ingredient);
        product.setState(state);
        product.setCreatedAt(new Date());
        product.setModifiedAt(new Date());

        product.setCategoryId(new ProductCategory(categoryId));
        product.setDiscountId(new ProductDiscount(discountId));
        product.setOriginId(new ProductOriginal(originId));

        // Tạo danh sách ảnh sản phẩm rỗng (nếu cần)
        Collection<ProductImages> imagesCollection = new ArrayList<>();
        product.setProductImagesCollection(imagesCollection);

        return product;
    }
}
