<%@page import="DAO.AdminDAO"%>
<%@page import="Entity.Admin"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    Admin admin = (Admin) session.getAttribute("admin");
    if (admin == null) {
        response.sendRedirect("adminLogin.jsp");
        return;
    }
    AdminDAO dao = new AdminDAO();
    int totalUsers        = dao.getTotalUsers();
    int totalTransactions = dao.getTotalTransactions();
    int pendingLoans      = dao.getPendingLoans();
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Admin Dashboard - SecureBank</title>
    <link rel="stylesheet" href="style.css" />
    <style>
        .admin-navbar { background:#1a1a2e; padding:15px 0; }
        .admin-navbar .logo { color:white; font-size:1.5em; font-weight:bold; }
        .admin-navbar nav ul li a { color:#ccc; }
        .admin-navbar nav ul li a:hover { color:white; background:rgba(255,255,255,0.1); }
        .admin-content { padding:40px 0; }
        .stats { display:flex; gap:20px; margin-bottom:30px; flex-wrap:wrap; }
        .stat-card { background:white; padding:25px 30px; border-radius:12px; box-shadow:0 4px 15px rgba(0,0,0,0.08); flex:1; min-width:180px; text-align:center; border-top:4px solid #0a3d62; }
        .stat-card h3 { color:#666; font-size:13px; text-transform:uppercase; letter-spacing:1px; margin-bottom:10px; }
        .stat-card p  { font-size:2.5em; font-weight:bold; color:#0a3d62; }
        .stat-card.green  { border-top-color:#27ae60; }
        .stat-card.green p { color:#27ae60; }
        .stat-card.orange { border-top-color:#f39c12; }
        .stat-card.orange p { color:#f39c12; }
        .quick-links { display:flex; gap:15px; flex-wrap:wrap; }
        .quick-link-card { background:white; padding:20px 25px; border-radius:12px; box-shadow:0 4px 15px rgba(0,0,0,0.08); flex:1; min-width:180px; text-align:center; transition:transform 0.2s; }
        .quick-link-card:hover { transform:translateY(-3px); }
        .quick-link-card a { color:#0a3d62; font-weight:bold; font-size:15px; text-decoration:none; }
        .quick-link-card p { color:#888; font-size:13px; margin-top:5px; }
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

<section class="admin-content">
    <div class="container">

        <div style="background:linear-gradient(135deg,#1a1a2e,#0a3d62);color:white;padding:25px 30px;border-radius:12px;margin-bottom:25px;">
            <h2>Welcome, <%= admin.getFullName() %> 👋</h2>
            <p style="color:#dce7f3;margin-top:5px;">Admin Control Panel</p>
        </div>

        <!-- Stats Cards -->
        <div class="stats">
            <div class="stat-card">
                <h3>Total Users</h3>
                <p><%= totalUsers %></p>
            </div>
            <div class="stat-card green">
                <h3>Total Transactions</h3>
                <p><%= totalTransactions %></p>
            </div>
            <div class="stat-card orange">
                <h3>Pending Loans</h3>
                <p><%= pendingLoans %></p>
            </div>
        </div>

        <!-- Quick Links -->
        <h3 style="margin-bottom:15px;color:#0a3d62;">Quick Actions</h3>
        <div class="quick-links">
            <div class="quick-link-card">
                <a href="adminUsers.jsp">👥 View All Users</a>
                <p>See all registered customers</p>
            </div>
            <div class="quick-link-card">
                <a href="adminTransactions.jsp">💸 View Transactions</a>
                <p>All money transfer records</p>
            </div>
            <div class="quick-link-card">
                <a href="adminLoans.jsp">📋 Manage Loans</a>
                <p>Approve or reject loan requests</p>
            </div>
        </div>

    </div>
</section>

</body>
</html>
