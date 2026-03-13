<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // If admin already logged in redirect to dashboard
    if (session.getAttribute("admin") != null) {
        response.sendRedirect("adminDashboard.jsp");
        return;
    }
    String error = (String) request.getAttribute("error");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Admin Login - SecureBank</title>
    <link rel="stylesheet" href="style.css" />
    <style>
        .admin-login { width:380px; margin:100px auto; background:white; padding:35px; border-radius:12px; box-shadow:0 8px 30px rgba(0,0,0,0.15); }
        .admin-login h2 { text-align:center; color:#0a3d62; margin-bottom:20px; }
        .admin-login label { display:block; font-weight:600; margin-bottom:5px; font-size:14px; }
        .admin-login input[type=text],
        .admin-login input[type=password] { width:100%; padding:10px; border:1px solid #ccc; border-radius:7px; margin-bottom:15px; font-size:14px; box-sizing:border-box; }
        .admin-login input[type=text]:focus,
        .admin-login input[type=password]:focus { border-color:#0a3d62; outline:none; }
        .btn-admin { width:100%; background:#0a3d62; color:white; border:none; padding:12px; border-radius:8px; font-size:16px; cursor:pointer; }
        .btn-admin:hover { background:#1e3799; }
        .error { background:#f8d7da; color:#721c24; padding:10px; border-radius:5px; text-align:center; margin-bottom:15px; font-size:14px; }
        .back-link { text-align:center; margin-top:15px; font-size:13px; }
        .back-link a { color:#0a3d62; font-weight:600; }
    </style>
</head>
<body style="background:#f5f6fa;">

    <div class="admin-login">
        <h2>🔐 Admin Login</h2>

        <% if (error != null) { %>
            <div class="error"><%= error %></div>
        <% } %>

        <form action="adminLogin" method="post">
            <label>Username</label>
            <input type="text" name="username" placeholder="Enter admin username" required />

            <label>Password</label>
            <input type="password" name="password" placeholder="Enter admin password" required />

            <button type="submit" class="btn-admin">Login as Admin</button>
        </form>

        <div class="back-link">
            <a href="index.jsp">← Back to User Login</a>
        </div>
    </div>

</body>
</html>
