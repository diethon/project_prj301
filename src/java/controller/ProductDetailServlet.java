/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller;

import dao.ProductsDAO;
import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import model.Products;

/**
 *
 * @author 84395
 */
@WebServlet(name="ProductDetailServlet", urlPatterns={"/productDetail"})
public class ProductDetailServlet extends HttpServlet {
   
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
        // Lấy id sản phẩm từ URL
        int id = Integer.parseInt(request.getParameter("id"));
        
        // Tạo đối tượng DAO để lấy thông tin sản phẩm theo id
        ProductsDAO productsDAO = new ProductsDAO();
        Products product = productsDAO.findById(id); // Giả sử findById trả về đối tượng sản phẩm

        // Nếu sản phẩm không tìm thấy, có thể chuyển đến trang lỗi
        if (product == null) {
            response.sendRedirect("errorPage.jsp");
            return;
        }

        // Truyền thông tin sản phẩm và danh sách ảnh cho JSP
        request.setAttribute("product", product);
        request.setAttribute("productImages", product.getProductImagesCollection());
        
        // Chuyển hướng đến trang productDetail.jsp
        request.getRequestDispatcher("productDetail.jsp").forward(request, response);
    } 

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Product detail servlet";
    }
}
