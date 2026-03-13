<%@page import="DAO.AdminDAO"%>
<%@page import="Entity.Loan"%>
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
    List<Loan> loans = dao.getAllLoans();
    String msg = request.getParameter("msg");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Manage Loans - Admin</title>
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
        .btn-approve { background:#27ae60; color:white; border:none; padding:6px 14px; border-radius:5px; cursor:pointer; font-size:13px; }
        .btn-reject  { background:#e74c3c; color:white; border:none; padding:6px 14px; border-radius:5px; cursor:pointer; font-size:13px; margin-left:5px; }
        .btn-approve:hover { background:#219a52; }
        .btn-reject:hover  { background:#c0392b; }
        .pending  { color:#f39c12; font-weight:bold; }
        .approved { color:#27ae60; font-weight:bold; }
        .rejected { color:#e74c3c; font-weight:bold; }
        .msg-box { background:#d4edda; color:#155724; padding:10px; border-radius:5px; margin-bottom:15px; text-align:center; }
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
        <h2 class="page-title">📋 Manage Loan Applications</h2>

        <% if (msg != null && !msg.isEmpty()) { %>
            <div class="msg-box"><%= msg %></div>
        <% } %>

        <div class="table-box">
            <table>
                <thead>
                    <tr>
                        <th>Loan ID</th>
                        <th>Customer ID</th>
                        <th>Loan Type</th>
                        <th>Amount (₹)</th>
                        <th>Duration</th>
                        <th>Apply Date</th>
                        <th>Status</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                <% if (loans != null && !loans.isEmpty()) {
                    for (Loan l : loans) { %>
                    <tr>
                        <td><%= l.getLoanId() %></td>
                        <td><%= l.getCustomerId() %></td>
                        <td><%= l.getLoanType() %></td>
                        <td>₹ <%= l.getAmount() %></td>
                        <td><%= l.getDuration() %> months</td>
                        <td><%= l.getApplyDate() %></td>
                        <td class="<%= l.getStatus().equalsIgnoreCase("Pending") ? "pending" : l.getStatus().equalsIgnoreCase("Approved") ? "approved" : "rejected" %>">
                            <%= l.getStatus() %>
                        </td>
                        <td>
                            <% if ("Pending".equalsIgnoreCase(l.getStatus())) { %>
                                <form action="AdminLoanServlet" method="post" style="display:inline;">
                                    <input type="hidden" name="loanId" value="<%= l.getLoanId() %>">
                                    <input type="hidden" name="status" value="Approved">
                                    <button type="submit" class="btn-approve">✅ Approve</button>
                                </form>
                                <form action="AdminLoanServlet" method="post" style="display:inline;">
                                    <input type="hidden" name="loanId" value="<%= l.getLoanId() %>">
                                    <input type="hidden" name="status" value="Rejected">
                                    <button type="submit" class="btn-reject">❌ Reject</button>
                                </form>
                            <% } else { %>
                                <span style="color:#888;font-size:13px;">Already <%= l.getStatus() %></span>
                            <% } %>
                        </td>
                    </tr>
                <% } } else { %>
                    <tr><td colspan="8" style="text-align:center;color:gray;">No loan applications found</td></tr>
                <% } %>
                </tbody>
            </table>
        </div>
    </div>
</section>

</body>
</html>
