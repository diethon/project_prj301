
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



    <div id="chat-icon">
        <img src="img/OIP.jpg" alt="Chat Icon" />
    </div>


    <div id="webchat"></div>


    <script>

        function isUserLoggedIn() {
            var role = "${sessionScope.role}";
            console.log("Checking if user is logged in, role:", role);
            return role === 'admin' || role === 'customer';
        }



        document.getElementById("chat-icon").addEventListener("click", function () {
            console.log("Chat icon clicked");
            if (isUserLoggedIn()) {
                console.log("User is logged in, opening Webchat");
                window.botpress.open();
                document.getElementById("webchat").style.display = "block";
            } else {
                console.log("User is not logged in, redirecting to login");
                window.location.href = 'login.jsp';
            }
        });


        window.botpress.on("webchat:ready", () => {
            console.log("Webchat is ready!");
            if (isUserLoggedIn()) {
                window.botpress.open();
            }
        });

        // Khởi tạo Webchat Botpress
        window.botpress.init({
            "botId": "61e18103-c349-49b8-8c7c-f44ddcecf1b6",
            "configuration": {
                "botName": "Smart Care Bot",
                "color": "#3B82F6",
                "variant": "solid",
                "themeMode": "light",
                "fontFamily": "inter",
                "radius": 1,
                "allowFileUpload": false
            },
            "clientId": "51968a8d-f9ee-44d1-81f3-6f2c35889074",
            "selector": "#webchat"
        });

        function resetBotOnLogout() {

            sessionStorage.removeItem('userLoggedIn');
            localStorage.removeItem('userLoggedIn');


            window.botpress.reset();

            console.log("Bạn đã đăng xuất, cuộc trò chuyện đã được reset.");
        }


        document.getElementById("logout-button").addEventListener("click", function () {
            resetBotOnLogout();
            window.location.href = 'login.jsp';
        });

    </script>





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

        #webchat {
            position: fixed;  /* Đặt cố định trên màn hình */
            bottom: 80px;     /* Khoảng cách từ đáy màn hình */
            right: 20px;      /* Khoảng cách từ bên phải */
            width: 500px;     /* Chiều rộng của Webchat */
            height: 500px;    /* Chiều cao của Webchat */
            display: none;    /* Ẩn Webchat ban đầu */
            z-index: 9999;    /* Đảm bảo Webchat hiển thị trên các phần tử khác */
        }

        /* CSS cho biểu tượng chat */
        #chat-icon {
            position: fixed;  /* Đặt cố định */
            bottom: 20px;     /* Khoảng cách từ đáy màn hình */
            right: 20px;      /* Khoảng cách từ bên phải */
            cursor: pointer; /* Con trỏ chuột khi hover vào icon */
            z-index: 9999;    /* Đảm bảo icon luôn hiển thị trên màn hình */
        }

        /* Style cho nút icon */
        #chat-icon img {
            width: 50px;
            height: 50px;
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
                        <li class="nav-item">
                            <a class="nav-link" href="users">Quản lí người dùng</a>
                        </li>
                    </c:if>
                    <c:if test="${sessionScope.user != null}">
                        <li class="nav-item">
                            <a class="nav-link" href="#">Xin Chào ${sessionScope.user.username}</a>
                        </li>
                        <li class="nav-item">
                            <a id="logout-button"class="nav-link" href="logout">Đăng Xuất</a>
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
                    <a href="carts" id="loginBtn">Giỏ hàng:</a>
                </span>
                <span class="cart-count-text">
                    <span id="cart-count">${numberProduct}</span> sản phẩm
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
