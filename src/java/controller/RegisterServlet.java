/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.UsersDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.UUID;
import mailservice.EmailUtil;
import model.Users;


/**
 *
 * @author anhqu
 */
@WebServlet(name = "RegisterServlet", urlPatterns = {"/register"})
public class RegisterServlet extends HttpServlet {

   protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String username = request.getParameter("username");

        UsersDAO userDao = new UsersDAO();
        String token = UUID.randomUUID().toString();
        Users newUser = new Users(0, email, username, password, "user", token, false);

        if (userDao.insert(newUser)) {
            EmailUtil.sendEmail(email, "Verify your account", "Click this link to verify: http://localhost:9999/verify?token=" + token);
            response.sendRedirect("login.jsp");
        } else {
            response.sendRedirect("register.jsp?error=Email already exists");
        }
    }

}
