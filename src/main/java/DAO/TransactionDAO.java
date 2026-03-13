package DAO;

import java.sql.*;
import DBConnection.DBConnection;

public class TransactionDAO {

    // Transfer Amount Method
    public boolean transferAmount(String senderAccount, String receiverAccount, double amount) {

        String getBalanceSQL = "SELECT BALANCE FROM USER_ACCOUNTS WHERE ACCOUNT_NUMBER = ?";
        String debitSQL      = "UPDATE USER_ACCOUNTS SET BALANCE = BALANCE - ? WHERE ACCOUNT_NUMBER = ?";
        String creditSQL     = "UPDATE USER_ACCOUNTS SET BALANCE = BALANCE + ? WHERE ACCOUNT_NUMBER = ?";

        String insertTxnSQL  = "INSERT INTO TXN_HISTORY "
                + "(SENDER_ACCOUNT, RECEIVER_ACCOUNT, AMOUNT, TXN_TYPE, DESCRIPTION, STATUS, TXN_DATE) "
                + "VALUES (?, ?, ?, ?, ?, ?, SYSDATE)";

        Connection conn = null;

        try {
            conn = DBConnection.getConnection();
            if (conn == null) {
                System.err.println("DB Connection is null!");
                return false;
            }
            conn.setAutoCommit(false);

            // 1. Check sender balance
            double senderBalance = 0;
            try (PreparedStatement balStmt = conn.prepareStatement(getBalanceSQL)) {
                balStmt.setString(1, senderAccount);
                ResultSet rs = balStmt.executeQuery();
                if (rs.next()) {
                    senderBalance = rs.getDouble("BALANCE");
                } else {
                    conn.rollback();
                    return false; // Sender not found
                }
            }

            // 2. Check for insufficient funds
            if (senderBalance < amount) {
                insertFailedTransaction(conn, senderAccount, receiverAccount, amount, "INSUFFICIENT BALANCE");
                conn.commit(); // commit the failed log
                return false;
            }

            // 3. Debit sender & Credit receiver
            try (
                PreparedStatement debitStmt  = conn.prepareStatement(debitSQL);
                PreparedStatement creditStmt = conn.prepareStatement(creditSQL);
                PreparedStatement debitTxn   = conn.prepareStatement(insertTxnSQL);
                PreparedStatement creditTxn  = conn.prepareStatement(insertTxnSQL)
            ) {
                debitStmt.setDouble(1, amount);
                debitStmt.setString(2, senderAccount);
                int debited = debitStmt.executeUpdate();

                creditStmt.setDouble(1, amount);
                creditStmt.setString(2, receiverAccount);
                int credited = creditStmt.executeUpdate();

                if (debited > 0 && credited > 0) {

                    // FIX: Debit record — from sender's perspective (money going OUT)
                    debitTxn.setString(1, senderAccount);
                    debitTxn.setString(2, receiverAccount);
                    debitTxn.setDouble(3, amount);
                    debitTxn.setString(4, "Debit");
                    debitTxn.setString(5, "Money sent to " + receiverAccount);
                    debitTxn.setString(6, "SUCCESS");
                    debitTxn.executeUpdate();

                    // FIX: Credit record — from receiver's perspective (money coming IN)
                    creditTxn.setString(1, senderAccount);
                    creditTxn.setString(2, receiverAccount);
                    creditTxn.setDouble(3, amount);
                    creditTxn.setString(4, "Credit");
                    creditTxn.setString(5, "Money received from " + senderAccount);
                    creditTxn.setString(6, "SUCCESS");
                    creditTxn.executeUpdate();

                    conn.commit();
                    return true;

                } else {
                    conn.rollback();
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
            try { if (conn != null) conn.rollback(); } catch (Exception ex) {}
        } finally {
            try { if (conn != null) conn.close(); } catch (Exception e) {}
        }

        return false;
    }

    // Failed Transaction Logger
    private void insertFailedTransaction(Connection conn, String sender, String receiver, double amount, String reason)
            throws SQLException {
        String sql = "INSERT INTO TXN_HISTORY "
                + "(SENDER_ACCOUNT, RECEIVER_ACCOUNT, AMOUNT, TXN_TYPE, DESCRIPTION, STATUS, TXN_DATE) "
                + "VALUES (?, ?, ?, 'TRANSFER', ?, 'FAILED', SYSDATE)";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, sender);
            ps.setString(2, receiver);
            ps.setDouble(3, amount);
            ps.setString(4, "Transaction Failed: " + reason);
            ps.executeUpdate();
        }
    }
}
