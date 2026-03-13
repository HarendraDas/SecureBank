<%@page import="Entity.User"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("index.jsp"); // FIX: was index.html
        return;
    }
    String error = request.getParameter("error");
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Make Payment - SecureBank</title>
    <link rel="stylesheet" href="style.css" />
    <style>
        .pay-container { width:400px; margin:60px auto; background:white; padding:30px; border-radius:10px; box-shadow:0 0 10px #ccc; }
        h2 { color:#0078d7; text-align:center; }
        input[type=text], input[type=number] { width:100%; padding:10px; margin:8px 0 15px 0; border:1px solid #ccc; border-radius:6px; box-sizing:border-box; }
        button { background:#0078d7; color:white; border:none; padding:12px; width:100%; border-radius:6px; font-size:16px; cursor:pointer; }
        button:hover { background:#005fa3; }
        .error-msg { color:red; text-align:center; margin-bottom:10px; font-weight:bold; }
        a.back { display:block; margin-top:15px; text-align:center; color:#0078d7; text-decoration:none; }
    </style>
</head>
<body>

<header class="navbar">
    <div class="container">
        <h1 class="logo">💳 SecureBank</h1>
        <nav>
            <ul>
                <li><a href="dashboard.jsp">Dashboard</a></li>
                <li><a href="Transaction.jsp">Transactions</a></li>
                <li><a href="profile.jsp">Profile</a></li>
                <li><a href="SendMoney.jsp">Send Money</a></li>
                <li><a href="ApplyLoan.jsp">Apply Loan</a></li>
                <li><a href="logout" class="logout-btn">Logout</a></li>
            </ul>
        </nav>
    </div>
</header>

<div class="pay-container">
    <h2>Make a Payment</h2>

    <% if (error != null) { %>
        <p class="error-msg">❌ <%= error %></p>
    <% } %>

    <!-- FIX: Action points to TransferServlet which now has @WebServlet annotation -->
    <form action="TransferServlet" method="post">
        <label>Sender Account:</label>
        <input type="text" value="<%= user.getAccountNumber() %>" readonly />

        <label>Receiver Account:</label>
        <input type="text" name="receiverAccount" placeholder="Enter receiver account number" required />

        <label>Amount (₹):</label>
        <input type="number" step="0.01" name="amount" min="1" required />

        <button type="submit">Transfer</button>
    </form>

    <a href="dashboard.jsp" class="back">⬅ Back to Dashboard</a>
</div>

</body>
</html>
