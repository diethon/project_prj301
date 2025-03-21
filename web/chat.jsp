<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chat with Admin</title>
    <style>
        body { font-family: Arial, sans-serif; }
        .chat-box { width: 100%; height: 300px; border: 1px solid black; overflow-y: auto; padding: 10px; margin-top: 20px; }
        #messageInput { width: 80%; padding: 10px; }
        #sendButton { padding: 10px; margin-top: 10px; cursor: pointer; }
        .chat-container { margin-bottom: 20px; }
    </style>
</head>
<body>

<h2>Cuộc trò chuyện với Admin</h2>

<%-- Lấy tên người dùng từ session --%>
<%
    String username = (String) session.getAttribute("username");
    if (username == null) {
        response.sendRedirect("login.jsp");  // Nếu không có session, chuyển hướng về trang đăng nhập
        return;
    }
%>

<h3>Chào, <%= username %>! Bạn đang trò chuyện với Admin.</h3>

<div id="chatSection" style="display: block;">
    <div id="chatContainer"></div>
    <input type="text" id="messageInput" placeholder="Nhập tin nhắn...">
    <button id="sendButton">Gửi</button>
</div>

<script>
    // WebSocket để giao tiếp với admin
    let ws = new WebSocket("ws://localhost:8080/Room/chat");
    let username = "<%= username %>";  // Lấy username từ session và gán vào JavaScript

    // Khi nhận tin nhắn từ server (admin)
    ws.onmessage = function(event) {
        const messageData = event.data.split(":");
        const user = messageData[0].trim();
        const message = messageData[1].trim();

        let chatBox = document.getElementById(user);

        if (!chatBox) {
            // Tạo hộp chat mới nếu chưa có
            chatBox = document.createElement('div');
            chatBox.id = user;
            chatBox.className = 'chat-box username-chat-box';
            chatBox.innerHTML = `<strong>${user}:</strong><br>`;
            document.getElementById("chatContainer").appendChild(chatBox);
        }

        chatBox.innerHTML += `<p>${message}</p>`;
        chatBox.scrollTop = chatBox.scrollHeight; // Scroll xuống dưới
    };

    // Khi nhấn nút Gửi
    document.getElementById("sendButton").onclick = function() {
        let message = document.getElementById("messageInput").value.trim();
        if (message !== "") {
            // Gửi tin nhắn với định dạng "username: nội dung"
            ws.send(username + ": " + message);
            document.getElementById("messageInput").value = ""; // Xóa nội dung nhập vào
        }
    };
</script>

</body>
</html>
