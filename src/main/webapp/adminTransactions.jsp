<%@page import="DAO.AdminDAO"%>
<%@page import="Entity.Transaction"%>
<%@page import="Entity.Admin"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    Admin admin = (Admin) session.getAttribute("admin");
    if (admin == null) {
        response.sendRedirect("adminLogin.jsp");
        return;
    }
    AdminDAO dao = new AdminDAO();
    List<Transaction> txns = dao.getAllTransactions();
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>All Transactions - Admin</title>
    <link rel="stylesheet" href="style.css" />
    <style>
        .admin-navbar { background:#1a1a2e; padding:15px 0; }
        .admin-navbar .logo { color:white; font-size:1.5em; font-weight:bold; }
        .admin-navbar nav ul li a { color:#ccc; }
        .content { padding:40px 0; }
        .page-title { color:#0a3d62; margin-bottom:20px; font-size:1.5em; }
        .table-box { background:white; border-radius:12px; padding:25px; box-shadow:0 4px 15px rgba(0,0,0,0.08); overflow-x:auto; }
        th { background:#0a3d62; color:white; }
        td, th { padding:12px 15px; font-size:14px; }
        tr:hover { background:#f8f9ff; }
        .success { color:green; font-weight:bold; }
        .failed  { color:red;   font-weight:bold; }
    </style>
</head>
<body style="background:#f5f6fa;">

<header class="admin-navbar">
    <div class="container">
        <h1 class="logo">🏦 SecureBank Admin</h1>
        <nav>
            <ul>
                <li><a href="adminDashboard.jsp">Dashboard</a></li>
                <li><a href="adminUsers.jsp">All Users</a></li>
                <li><a href="adminTransactions.jsp">Transactions</a></li>
                <li><a href="adminLoans.jsp">Loans</a></li>
                <li><a href="adminLogout.jsp" style="color:#e74c3c;">Logout</a></li>
            </ul>
        </nav>
    </div>
</header>

<section class="content">
    <div class="container">
        <h2 class="page-title">💸 All Transactions</h2>

        <div class="table-box">
            <table>
                <thead>
                    <tr>
                        <th>TXN ID</th>
                        <th>Date</th>
                        <th>Sender</th>
                        <th>Receiver</th>
                        <th>Amount (₹)</th>
                        <th>Type</th>
                        <th>Description</th>
                        <th>Status</th>
                    </tr>
                </thead>
                <tbody>
                <% if (txns != null && !txns.isEmpty()) {
                    for (Transaction t : txns) { %>
                    <tr>
                        <td><%= t.getTxnId() %></td>
                        <td><%= t.getTxnDate() %></td>
                        <td><%= t.getSenderAccount() %></td>
                        <td><%= t.getReceiverAccount() %></td>
                        <td>₹ <%= t.getAmount() %></td>
                        <td><%= t.getTxnType() %></td>
                        <td><%= t.getDescription() %></td>
                        <td class="<%= "SUCCESS".equalsIgnoreCase(t.getStatus()) ? "success" : "failed" %>">
                            <%= t.getStatus() %>
                        </td>
                    </tr>
                <% } } else { %>
                    <tr><td colspan="8" style="text-align:center;color:gray;">No transactions found</td></tr>
                <% } %>
                </tbody>
            </table>
        </div>
    </div>
</section>

</body>
</html>
