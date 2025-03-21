<%@ page import="model.Products" %>
<%@ page import="dao.ProductsDAO" %>
<%@ page import="java.util.List" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<jsp:useBean id="productDAO" class="dao.ProductsDAO" scope="page"/>
<jsp:useBean id="products" class="java.util.ArrayList" scope="request"/>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<%
    // Lấy danh sách sản phẩm từ cơ sở dữ liệu
    List<Products> productList = productDAO.findAll();
    request.setAttribute("products", productList); 
%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Nhà Thuốc Long Châu - Danh Sách Sản Phẩm</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        /* Custom Navbar Styles */
        .navbar {
            background-color: #0083b0;
        }

        .navbar-brand {
            color: white !important;
            font-size: 30px;
            font-weight: bold;
        }

        .navbar-nav .nav-link {
            color: white !important;
            font-size: 16px;
        }

        .navbar-nav .nav-link:hover {
            color: #ffd700 !important;
        }

        .navbar .search-bar {
            width: 300px;
            border-radius: 25px;
        }

        .cart-icon {
            font-size: 20px;
            color: white;
        }

        .cart-btn {
            background-color: #ffd700;
            color: black;
            border-radius: 20px;
            padding: 5px 15px;
        }

        .cart-btn:hover {
            background-color: #e6c300;
            color: white;
        }

        .search-btn {
            background-color: #ffd700;
            border-radius: 25px;
            padding: 5px 15px;
            border: none;
        }

        .search-btn:hover {
            background-color: #e6c300;
        }

        /* Product Container Styles */
        .product-container {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
            gap: 20px;
            padding: 20px;
            justify-items: center;
        }

        .product-card {
            background-color: white;
            padding: 15px;
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            text-align: center;
        }

        .product-card img {
            width: 100%;
            height: 200px;
            object-fit: cover;
            border-radius: 10px;
            margin-bottom: 15px;
        }

        .product-card h3 {
            font-size: 18px;
            margin-bottom: 10px;
        }

        .product-card p {
            color: #888;
            font-size: 14px;
            margin-bottom: 10px;
        }

        .price {
            font-size: 18px;
            color: #28a745;
            font-weight: bold;
            margin-top: 10px;
        }

        .product-card button {
            background-color: #007bff;
            color: white;
            padding: 10px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            width: 100%;
            margin-top: 15px;
        }

        .product-card button:hover {
            background-color: #0056b3;
        }

        /* Ensure product cards stack on small screens */
        @media screen and (max-width: 768px) {
            .product-container {
                grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
            }

            .product-card {
                width: 100%; /* Ensure each card fills the grid column */
            }
        }
    </style>
</head>

<body>

<!-- Navbar Section -->
<nav class="navbar navbar-expand-lg navbar-light">
    <div class="container-fluid">
        <a class="navbar-brand" href="#">Nhà Thuốc Long Châu</a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav ms-auto">
                <li class="nav-item">
                    <a class="nav-link" href="#">Trang Chủ</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="#">Sản Phẩm</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="#">Khuyến Mãi</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link cart-btn" href="#">Giỏ Hàng</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="#">Đăng Nhập</a>
                </li>
            </ul>
        </div>
        <div class="d-flex">
            <input class="form-control search-bar" type="search" placeholder="Tìm tên thuốc, bệnh lý..." aria-label="Search">
            <button class="search-btn" type="submit">Tìm Kiếm</button>
        </div>
    </div>
</nav>

<!-- Banner or Promo Section -->
<div class="container mt-4 text-center">
    <h2>Giảm giá đặc biệt cho bạn!</h2>
</div>

<!-- Product Display Section -->
<div class="product-container">
    <!-- Loop through the products -->
    <c:choose>
        <c:when test="${not empty products}">
            <c:forEach var="product" items="${products}">
                <div class="product-card">
                    <!-- Display Product Image -->
                    <img src="${product.imageUrl}" alt="${product.nameProduct}">
                    <h3>${product.nameProduct}</h3>
                    
                    <!-- Format the price with dots for thousands separator and add 'VND' -->
                    <div class="price">
                        <fmt:formatNumber value="${product.price}" pattern="#,### VND" />
                    </div>

                    <!-- Add to Cart Form -->   
                    <form action="<%= request.getContextPath() %>/cart" method="post" class="add-to-cart">
                        <input type="hidden" name="action" value="add">
                        <input type="hidden" name="productId" value="${product.productId}">
                        <input type="number" name="quantity" value="1" min="1" style="width: 50px; text-align: center;">
                        <button type="submit">Thêm vào Giỏ</button>
                    </form>

                    <!-- Product Detail Link -->
                    <a href="<%= request.getContextPath() %>/productDetail?id=${product.productId}">Xem chi tiết</a>
                </div>
            </c:forEach>
        </c:when>
        <c:otherwise>
            <p>Không có sản phẩm nào.</p>
        </c:otherwise>
    </c:choose>
</div>

<!-- Footer Section -->
<footer class="footer text-center py-3">
    <p>Nhà Thuốc Long Châu | Chăm sóc sức khỏe cho mọi nhà</p>
</footer>

<!-- Bootstrap JS and Popper -->
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.10.2/dist/umd/popper.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.min.js"></script>

</body>
</html>
