<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>

<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>SmartCare - Trang chủ</title>
    <link href="//maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css" rel="stylesheet" id="bootstrap-css">
    <link href="https://maxcdn.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css" rel="stylesheet" integrity="sha384-wvfXpqpZZVQGK6TAh5PVlGOfQNHSoD2xbE+QkPxCAFlNEevoEH3Sl0sibVcOQVnN" crossorigin="anonymous">
    <link href="css/index.css" rel="stylesheet">
    <link rel="Website Icon" type="png" href="img/logo.png">

    <style>
        #chatButtonImage {
            position: fixed;
            bottom: 20px;
            right: 20px;
            width: 100px; /* Điều chỉnh kích thước hình ảnh */
            height: 100px;
            border-radius: 50%;
            cursor: pointer;
            transition: transform 0.3s ease-in-out;
        }

        #chatButtonImage:hover {
            transform: scale(1.1); /* Hiệu ứng phóng to khi hover */
        }
    </style>
</head>

<body>
    <jsp:include page="Header.jsp"></jsp:include>

    <jsp:include page="productList.jsp"></jsp:include>

    <jsp:include page="Footer.jsp"></jsp:include>

   
    <img id="chatButtonImage" src="img/OIP.jpg" alt="Chat with Admin" onclick="window.location.href='chat.jsp'">

</body>

</html>
