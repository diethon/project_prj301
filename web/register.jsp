<%-- 
    Document   : dangki
    Created on : Mar 16, 2025, 11:56:16 PM
    Author     : 84395
--%>

<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link rel="Website Icon " type="png" href="img/logo.png">
        <title>Đăng Ký</title>

        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
        <style>
            body {
                font-family: Arial, sans-serif;
                background: linear-gradient(135deg, #ff9a9e, #fad0c4, #fad0c4, #fbc2eb, #a18cd1);
                background-size: cover;
                background-position: center;
                display: flex;
                justify-content: center;
                align-items: center;
                height: 100vh;
                margin: 0;
            }

            .auth-popup {
                background-color: rgba(255, 255, 255, 0.9);
                border-radius: 15px;
                padding: 30px;
                box-shadow: 0 10px 20px rgba(0, 0, 0, 0.2);
                width: 380px;
                position: relative;
            }

            .popup-content {
                text-align: center;
            }

            .close-btn {
                position: absolute;
                top: 10px;
                right: 15px;
                font-size: 24px;
                cursor: pointer;
                color: #888;
                transition: color 0.3s;
            }

            .close-btn:hover {
                color: #e74c3c;
            }

            .input-group {
                background: rgba(0, 0, 0, 0.7);
                border-radius: 25px;
                padding: 12px;
                margin-bottom: 15px;
                display: flex;
                align-items: center;
            }

            .input-group i {
                color: #ffffff;
                margin-right: 10px;
            }

            .input-group input {
                background: transparent;
                border: none;
                outline: none;
                color: #ffffff;
                width: 100%;
            }

            ::placeholder {
                color: #ddd;
            }

            .auth-btn {
                padding: 10px;
                width: 100%;
                border-radius: 6px;
                font-size: 16px;
                cursor: pointer;
                transition: background-color 0.3s;
                border: none;
                margin-top: 10px;
                background-color: #ff6a8e;
                color: white;
            }

            .auth-btn:hover {
                background-color: #ff527d;
            }

            .forgot-password-container, .btn-container {
                text-align: center;
                margin-top: 10px;
            }

            .forgot-password-container a, .btn-container a {
                font-size: 14px;
                color: #333;
                text-decoration: none;
                transition: color 0.3s;
            }

            .forgot-password-container a:hover, .btn-container a:hover {
                color: #ff6a8e;
            }

            .login-link {
                font-size: 14px;
                color: #333;
                text-decoration: none;
                font-weight: bold;
                display: block;
                margin-top: 10px;
                transition: color 0.3s ease-in-out;
            }

            .login-link:hover {
                color: #ff6a8e;
            }


        </style>
    </head>
    <body>

        <div class="auth-popup" id="registerPopup">
            <div class="popup-content">
                <span class="close-btn" id="closeRegisterBtn">&times;</span>
                <h2>Đăng Ký</h2>
                <form id="registerForm" action="${pageContext.request.contextPath}/register" method="POST">
                    <div class="input-group">
                        <i class="fa-solid fa-envelope"></i>
                        <input type="email" name="email" placeholder="Nhập e-mail" required />
                    </div>
                    <div class="input-group">
                        <i class="fa-solid fa-lock"></i>
                        <input type="password" name="password" placeholder="Nhập mật khẩu" required />
                    </div>
                    <div class="input-group">
                        <i class="fa-solid fa-lock"></i>
                        <input type="password" name="confirmPassword" placeholder="Xác nhận mật khẩu" required />
                    </div>
                    <button type="submit" class="auth-btn">REGISTER</button>

                </form>

                <p>Bạn đã có tài khoản? <a href="login.jsp" class="login-link">Đăng nhập ngay</a></p>

                <c:if test="${not empty requestScope.registerError}">
                    <p class="error">${requestScope.registerError}</p>
                    <c:remove var="registerError" scope="request"/>
                </c:if>

                <form action="google_register" method="GET">
                    <button type="submit" class="auth-btn" 
                            style="background-color: white; color: black; display: flex; align-items: center; justify-content: center; transition: background-color 0.3s;"
                            onmouseover="this.style.backgroundColor = '#f0f0f0';" 
                            onmouseout="this.style.backgroundColor = 'white';">
                        <img src="https://developers.google.com/identity/images/g-logo.png" width="20px" style="margin-right: 10px;">
                        Đăng ký bằng Google
                    </button>
                </form>



            </div>
        </div>


    </body>
</html>
