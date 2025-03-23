
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
        
        <script src="https://cdn.botpress.cloud/webchat/v2.3/inject.js"></script>
<script src="https://files.bpcontent.cloud/2025/03/22/11/20250322114328-667C9IUQ.js"></script>

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
            .logo-search {
                display: flex;
                align-items: center;
                justify-content: space-between;
                padding: 30px 0px;
                gap: 20px;
            }

            .logo-search img{
                height: 50px;
            }

            .search-container {
                display: flex;
                align-items: center;
                background-color: #f7f7f7;
                border-radius: 25px;
                padding: 10px 15px;
                width: 500px;
            }

            .search-container input {
                border: none;
                outline: none;
                background: transparent;
                padding: 8px;
                font-size: 16px;
                flex: 1;
            }

            .search-container .search-btn {
                background: none;
                border: none;
                cursor: pointer;
                color: #12afa3;
                display: flex;
                align-items: center;
                justify-content: center;
            }

            .search-container .search-btn i {
                font-size: 18px;
            }
            .cart {
                display: flex;
                align-items: flex-end; /* Căn text nằm thấp hơn icon */
                font-size: 16px;
                font-weight: bold;
                color: #12afa3; /* Mặc định màu xanh */
                cursor: pointer;
                gap: 5px;
                transition: color 0.2s ease-in-out;
            }

            .cart-icon-text {
                color: #12afa3; /* Màu xanh */
                display: flex;
                align-items: flex-end; /* Căn text nằm thấp hơn icon */
                gap: 5px;
            }

            .cart-icon-text i {
                font-size: 40px; /* Kích thước icon */
                transform: scaleX(0.85); /* Thu hẹp chiều rộng icon */
                display: inline-block;
            }

            .cart-count-text {
                color: gray; /* Số lượng có màu xám */
                font-size: 16px;
                line-height: 1.2;
                align-self: flex-end; /* Đảm bảo căn ở đáy */
                transition: color 0.2s ease-in-out;
            }

            .cart:hover .cart-count-text {
                color: black; /* Hover đổi màu số lượng */
            }

            /* -------------------- MAIN NAV -------------------- */
            .main-nav {
                background-color: #12afa3; /* Nền xanh */
                padding: 12px 0; /* Thêm khoảng cách trên dưới */
                text-align: center; /* Căn giữa các link */
                width: 100%;
            }

            .main-nav a {
                color: white; /* Chữ trắng */
                text-decoration: none; /* Loại bỏ gạch chân */
                font-size: 18px;
                font-weight: bold;
                padding: 10px 15px; /* Thêm khoảng cách giữa các mục */
                display: inline-block; /* Giúp padding có hiệu lực */
                transition: color 0.2s ease-in-out;
            }

            .main-nav a:hover {
                /* background-color: rgba(255, 255, 255, 0.2);  */
                color: black;
                border-radius: 5px; /* Bo góc khi hover */
            }

            .right-links {
                display: flex;
                align-items: center;
                gap: 20px;
            }

            .right-links .nav-item {
                display: inline-block;
            }

            .nav-link {
                text-decoration: none;
                color: #000; /* Change this color as per your theme */
                font-size: 16px;
            }

            .nav-link:hover {
                color: #007bff; /* Change this to the color you want on hover */
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
