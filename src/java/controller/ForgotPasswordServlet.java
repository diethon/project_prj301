package controller;

import dao.UsersDAO;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.UUID;
import mailservice.EmailUtil;

@WebServlet("/forgot-password")
public class ForgotPasswordServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = request.getParameter("email");

        UsersDAO userDao = new UsersDAO();
        if (!userDao.emailExists(email)) {
            response.sendRedirect("forgot_password.jsp?error=Email not found");
            return;
        }

        String newPassword = UUID.randomUUID().toString().substring(0, 8);
        userDao.resetPassword(email, newPassword);
        EmailUtil.sendEmail(email, "Password Reset", "Your new password is: " + newPassword);

        response.sendRedirect("login.jsp?message=Password reset successfully. Check your email.");
    }
}
