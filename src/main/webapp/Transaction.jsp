<%@page import="DBConnection.DBConnection"%>
<%@page import="Entity.User"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Transaction History</title>
    <link rel="stylesheet" href="style.css" />
    <style>
        body { font-family: Arial, sans-serif; background-color: #f5f6fa; margin: 0; padding: 0; }
        h2 { color: #0078d7; }
        table { width: 100%; border-collapse: collapse; margin-top: 15px; }
        th, td { padding: 12px; text-align: center; border-bottom: 1px solid #ddd; }
        th { background-color: #0078d7; color: white; }
        tr:hover { background-color: #f1f1f1; }
        .status-success { color: green; font-weight: bold; }
        .status-failed  { color: red;   font-weight: bold; }
        a.back {
            display: inline-block; margin-top: 20px; text-decoration: none;
            background: #0078d7; color: white; padding: 10px 15px; border-radius: 6px;
        }
        a.back:hover { background: #005fa3; }
    </style>
</head>
<body>

<header class="navbar">
    <div class="container">
        <h1 class="logo">💳 SecureBank</h1>
        <nav>
            <ul>
                <li><a href="dashboard.jsp">Dashboard</a></li>
                <li><a href="Transaction.jsp" class="active">Transactions</a></li>
                <li><a href="profile.jsp">Profile</a></li>
                <li><a href="SendMoney.jsp">Send Money</a></li>
                <li><a href="ApplyLoan.jsp">Apply Loan</a></li>
                <li><a href="logout" class="logout-btn">Logout</a></li>
            </ul>
        </nav>
    </div>
</header>

<div class="container">
    <h2>Your Transactions</h2>

    <table>
        <tr>
            <th>Transaction ID</th>
            <th>Date</th>
            <th>Description</th>
            <th>Type</th>
            <th>Amount (₹)</th>
            <th>Status</th>
        </tr>

        <%
            User user = (User) session.getAttribute("user");
            if (user == null) {
                response.sendRedirect("index.jsp"); // FIX: was index.html
                return;
            }

            Connection conn = null;
            PreparedStatement ps = null;
            ResultSet rs = null;

            try {
                conn = DBConnection.getConnection();

                // FIX: Shows BOTH sent and received transactions
                String sql = "SELECT TXN_ID, TXN_DATE, DESCRIPTION, TXN_TYPE, AMOUNT, STATUS "
                           + "FROM TXN_HISTORY "
                           + "WHERE SENDER_ACCOUNT = ? OR RECEIVER_ACCOUNT = ? "
                           + "ORDER BY TXN_DATE DESC";
                ps = conn.prepareStatement(sql);
                ps.setString(1, user.getAccountNumber());
                ps.setString(2, user.getAccountNumber()); // FIX: was missing receiver filter
                rs = ps.executeQuery();

                boolean hasData = false;
                while (rs.next()) {
                    hasData = true;
        %>
                    <tr>
                        <td><%= rs.getInt("TXN_ID") %></td>
                        <td><%= rs.getDate("TXN_DATE") %></td>
                        <td><%= rs.getString("DESCRIPTION") %></td>
                        <td><%= rs.getString("TXN_TYPE") %></td>
                        <td><%= rs.getDouble("AMOUNT") %></td>
                        <td class="<%= "SUCCESS".equalsIgnoreCase(rs.getString("STATUS")) ? "status-success" : "status-failed" %>">
                            <%= rs.getString("STATUS") %>
                        </td>
                    </tr>
        <%
                }
                if (!hasData) {
        %>
                    <tr><td colspan="6" style="color:gray;">No transactions found</td></tr>
        <%
                }
            } catch (Exception e) {
                e.printStackTrace();
        %>
                <tr><td colspan="6" style="color:red;">Error: <%= e.getMessage() %></td></tr>
        <%
            } finally {
                try { if (rs   != null) rs.close();   } catch (Exception e) {}
                try { if (ps   != null) ps.close();   } catch (Exception e) {}
                try { if (conn != null) conn.close(); } catch (Exception e) {}
            }
        %>
    </table>

    <a href="dashboard.jsp" class="back">⬅ Back to Dashboard</a>
</div>

</body>
</html>
