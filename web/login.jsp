<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Đăng Nhập</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <link rel="Website Icon " type="png" href="img/logo.png">
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

    </style>
</head>
<body>
    <div class="auth-popup" id="loginPopup">
        <div class="popup-content">
            <span class="close-btn" id="closeLoginBtn">&times;</span>
            <h2>Đăng Nhập</h2>
            <form id="loginForm" action="login" method="POST">
                <div class="input-group">
                    <i class="fa-solid fa-envelope"></i>
                    <input type="email" name="email" placeholder="Nhập e-mail" required>
                </div>
                <div class="input-group">
                    <i class="fa-solid fa-lock"></i>
                    <input type="password" name="password" placeholder="Nhập mật khẩu" required>
                </div>
                <div>${loginError}</div>
                <button type="submit" class="auth-btn">ĐĂNG NHẬP</button>
            </form>
            <div class="forgot-password-container">
                <a href="forgot_password.jsp">Bạn quên mật khẩu?</a>
            </div>

            <div class="btn-container">
                <a href="register.jsp">Tạo tài khoản mới</a>
            </div>
        </div>
    </div>
</body>
</html>