<%@page import="Entity.User"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("index.jsp"); // FIX: was index.html
        return;
    }
    // FIX: Read msg as a request parameter properly — ${msg} EL was unreliable
    String msg = request.getParameter("msg");
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Apply Loan</title>
<link rel="stylesheet" href="style.css" />
<style>
    body { background: #eef3f8; font-family: Arial, sans-serif; }
    .loan-box { width:400px; margin:60px auto; background:white; padding:25px; border-radius:10px; box-shadow:0 0 15px rgba(0,0,0,0.1); }
    .loan-box h3 { text-align:center; margin-bottom:20px; color:#004aad; }
    label { font-weight:bold; }
    select, input[type=number] { width:100%; padding:8px; margin-bottom:15px; border:1px solid #ccc; border-radius:5px; box-sizing:border-box; }
    .btn { width:100%; background:#004aad; border:none; padding:12px; color:white; border-radius:7px; cursor:pointer; }
    .btn:hover { background:#003580; }
    .msg-success { text-align:center; margin-top:10px; color:green; font-weight:bold; }
    .msg-error   { text-align:center; margin-top:10px; color:red;   font-weight:bold; }
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
                <li><a href="ApplyLoan.jsp" class="active">Apply Loan</a></li>
                <li><a href="logout" class="logout-btn">Logout</a></li>
            </ul>
        </nav>
    </div>
</header>

<div class="loan-box">
    <h3>Apply for Loan</h3>

    <form action="ApplyLoanServlet" method="post">
        <input type="hidden" name="customerId" value="<%= user.getUserId() %>">

        <label>Loan Amount (₹)</label>
        <input type="number" name="amount" required>

        <label>Loan Type</label>
        <select name="loanType" required>
            <option value="">-- Select Loan Type --</option>
            <option>Home Loan</option>
            <option>Personal Loan</option>
            <option>Education Loan</option>
            <option>Vehicle Loan</option>
            <option>Business Loan</option>
        </select>

        <label>Duration (Months)</label>
        <input type="number" name="duration" required>

        <button class="btn">Submit Application</button>
    </form>

    <!-- FIX: Use JSP expression to display msg parameter, not EL ${msg} -->
    <% if (msg != null && !msg.isEmpty()) { %>
        <p class="<%= msg.contains("Successfully") ? "msg-success" : "msg-error" %>">
            <%= msg %>
        </p>
    <% } %>
</div>

</body>
</html>
