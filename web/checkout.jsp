<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Kết quả thanh toán</title>
        <style>
            body {
                font-family: Arial, sans-serif;
                text-align: center;
                margin: 50px;
            }
            .container {
                width: 50%;
                margin: auto;
                padding: 20px;
                border: 1px solid #ddd;
                box-shadow: 2px 2px 10px rgba(0, 0, 0, 0.1);
            }
            h1 {
                color: green;
            }
            .error {
                color: red;
            }
            .btn {
                display: inline-block;
                margin-top: 20px;
                padding: 10px 20px;
                text-decoration: none;
                background-color: blue;
                color: white;
                border-radius: 5px;
            }
        </style>
    </head>
    <body>
        <div class="container">
            <h1>Đặt hàng thành công!</h1>
            <p>Cảm ơn bạn đã đặt hàng. Chúng tôi sẽ xử lý đơn hàng của bạn sớm nhất có thể.</p>
            <a href="home" class="btn">Tiếp tục mua hàng</a>


        </div>
    </body>
</html>
