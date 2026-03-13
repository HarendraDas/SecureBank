<%@page import="HelperMethods.Helper"%>
<%@page import="Entity.Transaction"%>
<%@page import="Entity.User"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, java.text.DecimalFormat" %>

<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("index.jsp"); // FIX: was index.html
        return;
    }

    Helper dao = new Helper();
    double balance = dao.getBalance(user.getAccountNumber());
    List<Transaction> txns = dao.getRecentTransactions(user.getAccountNumber());

    String msg = request.getParameter("msg");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>SecureBank | Dashboard</title>
    <link rel="stylesheet" href="style.css" />
</head>
<body>

<header class="navbar">
    <div class="container">
        <h1 class="logo">💳 SecureBank</h1>
        <nav>
            <ul>
                <li><a href="dashboard.jsp" class="active">Dashboard</a></li>
                <li><a href="Transaction.jsp">Transactions</a></li>
                <li><a href="profile.jsp">Profile</a></li>
                <li><a href="SendMoney.jsp">Send Money</a></li>
                <li><a href="ApplyLoan.jsp">Apply Loan</a></li>
                <li><a href="logout" class="logout-btn">Logout</a></li>
            </ul>
        </nav>
    </div>
</header>

<section class="dashboard">
    <div class="container">

        <% if (msg != null && !msg.isEmpty()) { %>
            <div style="background:#d4edda;color:#155724;padding:10px;border-radius:5px;margin-bottom:15px;text-align:center;">
                <%= msg %>
            </div>
        <% } %>

        <div class="welcome-box">
            <h2>Welcome back, <%= user.getFullName() %> 👋</h2>
            <p>Account Number: <b><%= user.getAccountNumber() %></b></p>
        </div>

        <div class="summary">
            <div class="card balance-card">
                <h3>Current Balance</h3>
                <p>₹ <%= new DecimalFormat("#,##0.00").format(balance) %></p>
            </div>
            <div class="card">
                <h3>Make a Transfer</h3>
                <a class="btn-transfer" href="SendMoney.jsp">Transfer Money</a>
            </div>
        </div>

        <div class="transactions">
            <h3>Recent Transactions</h3>
            <table>
                <thead>
                    <tr>
                        <th>Date</th>
                        <th>Description</th>
                        <th>Type</th>
                        <th>Amount</th>
                        <th>Status</th>
                    </tr>
                </thead>
                <tbody>
                <% if (txns != null && !txns.isEmpty()) {
                    for (Transaction t : txns) { %>
                        <tr>
                            <td><%= t.getTxnDate() %></td>
                            <td><%= t.getDescription() %></td>
                            <td><%= t.getTxnType() %></td>
                            <td>₹ <%= new DecimalFormat("#,##0.00").format(t.getAmount()) %></td>
                            <td>
                                <% if ("SUCCESS".equalsIgnoreCase(t.getStatus())) { %>
                                    <span class="status completed">Completed</span>
                                <% } else { %>
                                    <span class="status pending"><%= t.getStatus() %></span>
                                <% } %>
                            </td>
                        </tr>
                <%  }
                } else { %>
                    <tr><td colspan="5" style="text-align:center;">No recent transactions found.</td></tr>
                <% } %>
                </tbody>
            </table>
        </div>

    </div>
</section>

<footer>
    <p>© 2025 SecureBank. All rights reserved.</p>
</footer>

</body>
</html>
