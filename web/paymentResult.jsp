<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Thanh toán kết quả</title>
    <link href="//maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css" rel="stylesheet" id="bootstrap-css">
    <link href="https://maxcdn.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css" rel="stylesheet" integrity="sha384-wvfXpqpZZVQGK6TAh5PVlGOfQNHSoD2xbE+QkPxCAFlNEevoEH3Sl0sibVcOQVnN" crossorigin="anonymous">
    <link rel="Website Icon" type="png" href="img/logo.png">
    <style>
        .message-box {
            padding: 20px;
            border-radius: 10px;
            text-align: center;
            font-size: 18px;
        }
        .success {
            background-color: #d4edda;
            color: #155724;
        }
        .failure {
            background-color: #f8d7da;
            color: #721c24;
        }
        .message-box i {
            font-size: 40px;
        }
    </style>
</head>
<body>
    <div class="container mt-5">
        <c:choose>
            <c:when test="${transResult == true}">
                <div class="message-box success">
                    <i class="fa fa-check-circle"></i>
                    <h2>Thanh toán thành công!</h2>
                    <p>Cảm ơn bạn đã mua hàng. Đơn hàng của bạn đã được xử lý thành công.</p>
                    <a href="home" class="btn btn-outline-secondary mt-3">
                        <i class="fa fa-arrow-left mr-2"></i>Tiếp tục mua sắm
                    </a>
                </div>
            </c:when>
            <c:otherwise>
                <div class="message-box failure">
                    <i class="fa fa-times-circle"></i>
                    <h2>Thanh toán thất bại!</h2>
                    <p>Đã có lỗi xảy ra trong quá trình thanh toán. Vui lòng thử lại sau.</p>
                    <a href="carts" class="btn btn-danger mt-3">Quay lại giỏ hàng</a>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</body>
</html>
