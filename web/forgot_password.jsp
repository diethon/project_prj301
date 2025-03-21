<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Quên mật khẩu</title>
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

        form {
            background-color: rgba(255, 255, 255, 0.9);
            border-radius: 15px;
            padding: 30px;
            box-shadow: 0 10px 20px rgba(0, 0, 0, 0.2);
            width: 380px;
            display: flex;
            flex-direction: column;
        }

        label {
            color: #333;
            font-weight: bold;
            margin-bottom: 10px;
        }

        input[type="text"], input[type="email"] {
            background: rgba(0, 0, 0, 0.7);
            border-radius: 25px;
            padding: 12px;
            margin-bottom: 15px;
            border: none;
            color: #fff;
        }

        ::placeholder {
            color: #ffffff;
            opacity: 0.8;
        }

        input[type="submit"] {
            padding: 10px;
            width: 100%;
            border-radius: 6px;
            font-size: 16px;
            cursor: pointer;
            background-color: #ff6a8e;
            color: white;
            border: none;
            transition: background-color 0.3s;
        }

        input[type="submit"]:hover {
            background-color: #e8597f;
        }

        label {
            color: #333;
            font-weight: bold;
            margin-bottom: 10px;
        }

        ::placeholder {
            color: #ffffff;
            opacity: 0.8;
        }
    </style>
</head>
<body>
    <form method="POST">
        <label for="gmail">Nhập gmail để lấy lại mật khẩu:</label>
        <input type="email" name="email" id="gmail" placeholder="Enter email" required>
        <input type="submit" value="Gửi mã">
    </form>
</body>
</html>