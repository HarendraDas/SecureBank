<%@page import="Entity.User"%>
<%@page import="DBConnection.DBConnection"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Send Money</title>
    <link rel="stylesheet" href="style.css" />
    <style>
        .Moneycontainer { width:400px; margin:50px auto; background:white; padding:25px; border-radius:10px; box-shadow:0 0 10px #ccc; }
        h2 { color:#0078d7; text-align:center; }
        input[type=text], input[type=number] { width:100%; padding:10px; margin:8px 0; border:1px solid #ccc; border-radius:6px; box-sizing:border-box; }
        input[type=submit] { background-color:#0078d7; color:white; border:none; padding:10px; width:100%; border-radius:6px; cursor:pointer; font-size:16px; }
        input[type=submit]:hover { background-color:#005fa3; }
        .message { text-align:center; font-weight:bold; margin-top:15px; }
        .success { color:green; }
        .error   { color:red;   }
        a.back   { display:block; margin-top:15px; text-align:center; text-decoration:none; color:#0078d7; }
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
                <li><a href="SendMoney.jsp" class="active">Send Money</a></li>
                <li><a href="ApplyLoan.jsp">Apply Loan</a></li>
                <li><a href="logout" class="logout-btn">Logout</a></li>
            </ul>
        </nav>
    </div>
</header>

<%
    // FIX: Session check at TOP of page, before any output — was previously inside the form processing block
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("index.jsp"); // FIX: was index.html
        return;
    }
%>

<div class="Moneycontainer">
    <h2>Send Money</h2>

    <form method="post" action="SendMoney.jsp">
        <label>Recipient Account Number or Mobile:</label>
        <input type="text" name="receiver" required placeholder="Enter account or mobile number">

        <label>Amount (₹):</label>
        <input type="number" name="amount" required min="1" step="0.01">

        <label>Description:</label>
        <input type="text" name="description" placeholder="Purpose (optional)">

        <input type="submit" value="Send Money">
    </form>

    <div class="message">
        <%
            if ("POST".equalsIgnoreCase(request.getMethod())) {
                String receiver    = request.getParameter("receiver");
                String description = request.getParameter("description");
                double amount      = Double.parseDouble(request.getParameter("amount"));

                Connection conn      = null;
                PreparedStatement ps = null;
                ResultSet rs         = null;

                try {
                    conn = DBConnection.getConnection();
                    conn.setAutoCommit(false);

                    String senderAccount = user.getAccountNumber();

                    // Get sender balance
                    ps = conn.prepareStatement("SELECT BALANCE FROM USER_ACCOUNTS WHERE ACCOUNT_NUMBER=?");
                    ps.setString(1, senderAccount);
                    rs = ps.executeQuery();

                    if (!rs.next()) {
                        out.println("<p class='error'>Sender not found!</p>");
                    } else {
                        double senderBalance = rs.getDouble("BALANCE");

                        if (senderBalance < amount) {
                            out.println("<p class='error'>Insufficient balance!</p>");
                        } else {
                            // Find receiver by account number OR phone
                            ps = conn.prepareStatement(
                                "SELECT ACCOUNT_NUMBER, FULL_NAME, BALANCE FROM USER_ACCOUNTS WHERE ACCOUNT_NUMBER=? OR PHONE_NUMBER=?"
                            );
                            ps.setString(1, receiver);
                            ps.setString(2, receiver);
                            rs = ps.executeQuery();

                            if (!rs.next()) {
                                out.println("<p class='error'>Receiver not found!</p>");
                            } else {
                                String receiverAccount = rs.getString("ACCOUNT_NUMBER");
                                String receiverName    = rs.getString("FULL_NAME");
                                double receiverBalance = rs.getDouble("BALANCE");

                                // Debit sender
                                ps = conn.prepareStatement("UPDATE USER_ACCOUNTS SET BALANCE=? WHERE ACCOUNT_NUMBER=?");
                                ps.setDouble(1, senderBalance - amount);
                                ps.setString(2, senderAccount);
                                ps.executeUpdate();

                                // Credit receiver
                                ps.setDouble(1, receiverBalance + amount);
                                ps.setString(2, receiverAccount);
                                ps.executeUpdate();

                                // Record transaction
                                ps = conn.prepareStatement(
                                    "INSERT INTO TXN_HISTORY (SENDER_ACCOUNT, RECEIVER_ACCOUNT, AMOUNT, TXN_TYPE, DESCRIPTION, STATUS, TXN_DATE) VALUES (?, ?, ?, ?, ?, ?, SYSDATE)"
                                );
                                ps.setString(1, senderAccount);
                                ps.setString(2, receiverAccount);
                                ps.setDouble(3, amount);
                                ps.setString(4, "TRANSFER");
                                ps.setString(5, (description != null && !description.isEmpty()) ? description : "Money transfer");
                                ps.setString(6, "SUCCESS");
                                ps.executeUpdate();

                                conn.commit();

                                // FIX: Update session balance so dashboard shows correct value
                                user.setBalance(senderBalance - amount);
                                session.setAttribute("user", user);

                                out.println("<p class='success'>₹" + amount + " sent successfully to " + receiverName + "!</p>");
                            }
                        }
                    }

                } catch (Exception e) {
                    try { if (conn != null) conn.rollback(); } catch (Exception ex) {}
                    out.println("<p class='error'>Transaction failed: " + e.getMessage() + "</p>");
                } finally {
                    try { if (rs   != null) rs.close();   } catch (Exception e) {}
                    try { if (ps   != null) ps.close();   } catch (Exception e) {}
                    try { if (conn != null) conn.close(); } catch (Exception e) {}
                }
            }
        %>
    </div>

    <a href="dashboard.jsp" class="back">⬅ Back to Dashboard</a>
</div>

</body>
</html>
