
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html lang="vi">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Header</title>
        <link rel="stylesheet" href="css/header.css">
        <link rel="Website Icon" type="png" href="img/logo.png">

        <style>
            /* Style for the horizontal navigation links */
            .top-bar .right-links {
                display: flex;
                justify-content: flex-end;
                align-items: center;
            }

            .top-bar .right-links .nav-item {
                margin-right: 20px;  /* Adjust space between links */
            }

            .top-bar .right-links .nav-link {
                text-decoration: none;
                color: #333;
                font-size: 16px;
                padding: 10px;
                transition: color 0.3s ease;
            }

            .top-bar .right-links .nav-link:hover {
                color: #007bff;
            }
        </style>
    </head>

    <body>

        <div class="container">
            <div class="top-bar">
                <div class="left-links">
                    <div class="select-wrapper">
                        <select>
                            <option value="1">Tiếng Việt</option>
                            <option value="2">English</option>
                        </select>
                    </div>
                    <div class="select-wrapper">
                        <select>
                            <option value="1">VNĐ</option>
                            <option value="2">USD</option>
                        </select>
                    </div>
                </div>
                <div class="right-links">
                    <ul class="justify-content-end">
                        <c:if test="${sessionScope.user.role == 'admin'}">
                            <li class="nav-item">
                                <a class="nav-link" href="products">Quản Lí Sản Phẩm</a>
                            </li>
                        </c:if>
                        <c:if test="${sessionScope.user != null}">
                            <li class="nav-item">
                                <a class="nav-link" href="#">Xin Chào ${sessionScope.user.username}</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="logout">Đăng Xuất</a>
                            </li>
                        </c:if>
                        <c:if test="${sessionScope.user == null}">
                            <li class="nav-item">
                                <a class="nav-link" href="register.jsp">Đăng Ký</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="login.jsp">Đăng Nhập</a>
                            </li>
                        </c:if>
                    </ul>
                </div>
            </div>

            <div class="logo-search">
                <img src="img/logo.png" alt="SmartCare Logo">
                <div class="search-container">
                    <input type="text" placeholder="Tìm kiếm...">
                    <button class="search-btn">
                        <i class="fa-solid fa-magnifying-glass"></i>
                    </button>
                </div>
                <div class="cart">
                    <span class="cart-icon-text">
                        <a href="cart.jsp" id="loginBtn">Giỏ hàng:</a>
                    </span>
                    <span class="cart-count-text">
                        <span id="cart-count">0</span> sản phẩm
                    </span>
                </div>
            </div>
        </div>

        <nav class="main-nav">
            <a href="home">Trang chủ</a>
            <a href="category?id=1">Thực phẩm chức năng</a>
            <a href="category?id=2">Thiết bị y tế</a>
            <a href="category?id=3">Dược mỹ phẩm</a>
            <a href="category?id=4">Chăm sóc cá nhân</a>
            <a href="category?id=5">Thuốc</a>
        </nav>

    </body>

</html>
