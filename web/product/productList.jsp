<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Danh sách sản phẩm</title>
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
        <style>
            body {
                background-color: #f8f9fa;
            }
            .container {
                background: #fff;
                padding: 20px;
                border-radius: 10px;
                box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            }
            h2 {
                color: #343a40;
                font-weight: bold;
                margin-bottom: 20px;
            }
            .table {
                border-radius: 10px;
                overflow: hidden;
            }
            .table thead {
                background-color: #343a40;
                color: white;
            }
            .table tbody tr:hover {
                background-color: #f1f1f1;
                transition: 0.3s;
            }
            .btn-primary {
                background-color: #007bff;
                border: none;
            }
            .btn-warning, .btn-danger {
                font-weight: bold;
            }
            .btn-sm {
                margin-right: 5px;
            }
        </style>
    </head>
    <body>
        <div class="container mt-4">
            <h2 class="text-center">Danh sách sản phẩm</h2>
            <a href="products?action=new" class="btn btn-primary mb-3">Thêm sản phẩm mới</a>

            <table class="table table-bordered text-center">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Tên sản phẩm</th>
                        <th>SKU</th>
                        <th>Giá</th>
                        <th>Trạng thái</th>
                        <th>Hành động</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="product" items="${products}">
                        <tr>
                            <td>${product.productId}</td>
                            <td>${product.nameProduct}</td>
                            <td>${product.sku}</td>
                            <td>${product.price} $</td>
                            <td>${product.state ? 'Còn hàng' : 'Hết hàng'}</td>
                            <td>
                                <a href="products?action=edit&id=${product.productId}" class="btn btn-warning btn-sm">Sửa</a>
                                <a href="products?action=delete&id=${product.productId}" class="btn btn-danger btn-sm" onclick="return confirm('Bạn có chắc muốn xóa sản phẩm này?')">Xóa</a>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </body>
</html>
