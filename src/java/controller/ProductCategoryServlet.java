package controller;

import dao.ProductCategoryDAO;
import dao.ProductsDAO;
import model.ProductCategory;
import model.Products;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "ProductCategoryServlet", urlPatterns = {"/category"})
public class ProductCategoryServlet extends HttpServlet {

    private ProductsDAO productsDAO = new ProductsDAO();  // DAO để truy vấn sản phẩm
    private ProductCategoryDAO productCategoryDAO = new ProductCategoryDAO();  // DAO để truy vấn danh mục

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Lấy tham số categoryId từ URL
        String categoryIdParam = request.getParameter("id");
        if (categoryIdParam != null && !categoryIdParam.isEmpty()) {
            int categoryId = Integer.parseInt(categoryIdParam);

            // Lấy danh mục sản phẩm theo categoryId
            ProductCategory category = productCategoryDAO.findById(categoryId);
            if (category != null) {
                // Tìm các sản phẩm thuộc danh mục này
                List<Products> products = productsDAO.findByCategory(category);
                // Đặt danh sách sản phẩm và danh mục vào request để truyền cho JSP
                 request.setAttribute("isHomePage", false);
                request.setAttribute("products", products);
                request.setAttribute("category", category);
            } else {
                request.setAttribute("errorMessage", "Danh mục không tồn tại!");
            }
        } else {
            request.setAttribute("errorMessage", "Không có tham số danh mục!");
        }

        // Chuyển tiếp yêu cầu tới trang JSP
        request.getRequestDispatcher("Home.jsp").forward(request, response);
    }

    @Override
    public String getServletInfo() {
        return "ProductCategoryServlet";
    }
}