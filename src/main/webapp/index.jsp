<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="javax.servlet.*, javax.servlet.http.*" %>

<%
    // If user is already logged in, redirect to dashboard
    HttpSession session1 = request.getSession(false);
    if (session1 != null && session1.getAttribute("user") != null) {
        response.sendRedirect("dashboard.jsp");
        return;
    }

    String msg = (String) request.getAttribute("msg");
    if (msg == null) {
        msg = request.getParameter("msg");
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>SecureBank | Login</title>
    <link rel="stylesheet" href="style.css" />
</head>
<body>

    <!-- Header -->
    <header>
        <div class="container">
            <h1 class="logo">💳 SecureBank</h1>
            <nav>
                <ul>
                    <li><a href="index.jsp">Home</a></li>
                    <li><a href="#">About</a></li>
                    <li><a href="#">Support</a></li>
                </ul>
            </nav>
        </div>
    </header>

    <!-- Hero Section -->
    <section class="hero">
        <div class="hero-content">
            <h2>Welcome to SecureBank</h2>
            <p>Manage your money safely and securely — anytime, anywhere.</p>
            <a href="#" class="btn">Learn More</a>
        </div>

        <!-- Login Box -->
        <div class="login-box">
            <h3>Login to Your Account</h3>

            <!-- Success message (e.g. after registration) -->
            <% if (msg != null && !msg.isEmpty()) { %>
                <div style="background-color:#d4edda; color:#155724; padding:10px;
                            border-radius:5px; text-align:center; margin-bottom:12px;">
                    <%= msg %>
                </div>
            <% } %>

            <!-- Error message (e.g. wrong password) -->
            <%
                String error = (String) request.getAttribute("error");
                if (error != null && !error.isEmpty()) {
            %>
                <div style="background-color:#f8d7da; color:#721c24; padding:10px;
                            border-radius:5px; text-align:center; margin-bottom:12px;">
                    <%= error %>
                </div>
            <% } %>

            <form action="login" method="post">
                <label>Username</label>
                <input type="text" name="username" placeholder="Enter username" required />

                <label>Password</label>
                <input type="password" name="password" placeholder="Enter password" required />

                <div class="remember">
                    <label><input type="checkbox" /> Remember me</label>
                    <a href="#">Forgot Password?</a>
                </div>

                <button type="submit" class="btn-login">Login</button>

                <p class="signup">Don't have an account? <a href="register.jsp">Register</a></p>

                <!-- Admin Login Link -->
                <hr style="border:none; border-top:1px solid #eee; margin:15px 0;" />
                <p style="text-align:center; font-size:13px; color:#888;">
                    Are you an Admin?
                    <a href="adminLogin.jsp" style="color:#0a3d62; font-weight:600;">Admin Login</a>
                </p>

            </form>
        </div>
    </section>

    <!-- Footer -->
    <footer>
        <p>© 2025 SecureBank. All rights reserved.</p>
    </footer>

</body>
</html>
