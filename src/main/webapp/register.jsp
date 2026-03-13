<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>SecureBank | Register</title>
  <style>
    body { font-family: "Segoe UI", Tahoma, Geneva, Verdana, sans-serif; margin:0; background:#f5f6fa; color:#333; }
    header { background:#0a3d62; color:#fff; padding:15px 0; box-shadow:0 2px 5px rgba(0,0,0,0.1); }
    .container { width:90%; max-width:1100px; margin:auto; display:flex; justify-content:space-between; align-items:center; }
    .logo { font-size:1.5em; font-weight:bold; }
    nav ul { list-style:none; margin:0; padding:0; display:flex; }
    nav ul li { margin-left:20px; }
    nav ul li a { color:white; text-decoration:none; font-weight:500; transition:0.3s; }
    nav ul li a:hover { text-decoration:underline; }
    .register-section { display:flex; justify-content:center; align-items:center; padding:60px 20px; }
    .register-box { background:#fff; width:100%; max-width:450px; padding:30px; border-radius:12px; box-shadow:0 4px 15px rgba(0,0,0,0.1); }
    .register-box h2 { text-align:center; color:#0a3d62; }
    .register-box p  { text-align:center; color:#555; font-size:14px; margin-bottom:20px; }
    .form-group { margin-bottom:15px; }
    .form-group label { display:block; margin-bottom:6px; font-weight:600; }
    .form-group input { width:100%; padding:10px; border-radius:6px; border:1px solid #ccc; outline:none; font-size:14px; box-sizing:border-box; }
    .form-group input:focus { border-color:#0a3d62; }
    .terms { font-size:13px; margin:10px 0; }
    .terms a { color:#0a3d62; text-decoration:none; }
    .btn-register { width:100%; background:#0a3d62; color:white; border:none; padding:12px; border-radius:8px; font-size:16px; cursor:pointer; transition:0.3s; }
    .btn-register:hover { background:#1e3799; }
    .login-link { text-align:center; margin-top:15px; font-size:14px; }
    .login-link a { color:#0a3d62; text-decoration:none; font-weight:600; }
    footer { text-align:center; background:#0a3d62; color:white; padding:12px 0; position:fixed; width:100%; bottom:0; font-size:13px; }
    .msg   { text-align:center; font-size:14px; color:green; margin-bottom:10px; }
    .error { text-align:center; font-size:14px; color:red;   margin-bottom:10px; }
  </style>
</head>
<body>

  <header>
    <div class="container">
      <h1 class="logo">💳 SecureBank</h1>
      <nav>
        <ul>
          <li><a href="index.jsp">Login</a></li>  <!-- FIX: was index.html -->
          <li><a href="#">Support</a></li>
        </ul>
      </nav>
    </div>
  </header>

  <section class="register-section">
    <div class="register-box">
      <h2>Create Your SecureBank Account</h2>
      <p>Join our secure banking platform today.</p>

      <%
          String msg   = request.getParameter("msg");
          String error = (String) request.getAttribute("error");
          if (msg != null) { %>
              <div class="msg"><%= msg %></div>
      <% } else if (error != null) { %>
              <div class="error"><%= error %></div>
      <% } %>

      <form action="RegisterServlet" method="post">
        <div class="form-group">
          <label>Full Name</label>
          <input type="text" name="fullName" placeholder="Enter your full name" required />
        </div>
        <div class="form-group">
          <label>Email Address</label>
          <input type="email" name="email" placeholder="Enter your email" required />
        </div>
        <div class="form-group">
          <label>Phone Number</label>
          <input type="tel" name="phone" placeholder="Enter your phone number" required />
        </div>
        <div class="form-group">
          <label>Username</label>
          <input type="text" name="username" placeholder="Choose a username" required />
        </div>
        <div class="form-group">
          <label>Password</label>
          <input type="password" name="password" placeholder="Create password" required />
        </div>
        <div class="form-group">
          <label>Confirm Password</label>
          <input type="password" name="confirmPassword" placeholder="Confirm password" required />
        </div>
        <div class="terms">
          <label>
            <input type="checkbox" required />
            I agree to the <a href="#">Terms &amp; Conditions</a>
          </label>
        </div>
        <button type="submit" class="btn-register">Register</button>
        <p class="login-link">Already have an account?
          <a href="index.jsp">Login here</a>  <!-- FIX: was index.html -->
        </p>
      </form>
    </div>
  </section>

  <footer>
    <p>© 2025 SecureBank. All rights reserved.</p>
  </footer>
</body>
</html>
