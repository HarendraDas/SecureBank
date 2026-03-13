package HelperMethods;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import DBConnection.DBConnection;
import Entity.Transaction;

public class Helper {

    public double getBalance(String accountNumber) {
        double balance = 0;
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.getConnection();
            if (conn == null) return balance;

            ps = conn.prepareStatement("SELECT BALANCE FROM USER_ACCOUNTS WHERE ACCOUNT_NUMBER = ?");
            ps.setString(1, accountNumber);
            rs = ps.executeQuery();

            if (rs.next()) {
                balance = rs.getDouble("BALANCE");
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (rs   != null) rs.close();   } catch (Exception e) {}
            try { if (ps   != null) ps.close();   } catch (Exception e) {}
            try { if (conn != null) conn.close(); } catch (Exception e) {}
        }
        return balance;
    }

    public List<Transaction> getRecentTransactions(String accountNumber) {
        List<Transaction> list = new ArrayList<>();
        // FIX: Shows both sent AND received transactions
        String sql = "SELECT * FROM TXN_HISTORY "
                   + "WHERE SENDER_ACCOUNT = ? OR RECEIVER_ACCOUNT = ? "
                   + "ORDER BY TXN_DATE DESC FETCH FIRST 5 ROWS ONLY";

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.getConnection();
            if (conn == null) return list;

            ps = conn.prepareStatement(sql);
            ps.setString(1, accountNumber);
            ps.setString(2, accountNumber);
            rs = ps.executeQuery();

            while (rs.next()) {
                Transaction t = new Transaction();
                t.setTxnId(rs.getInt("TXN_ID"));
                t.setSenderAccount(rs.getString("SENDER_ACCOUNT"));
                t.setReceiverAccount(rs.getString("RECEIVER_ACCOUNT"));
                t.setAmount(rs.getDouble("AMOUNT"));
                t.setTxnType(rs.getString("TXN_TYPE"));
                t.setDescription(rs.getString("DESCRIPTION"));
                t.setStatus(rs.getString("STATUS"));
                t.setTxnDate(rs.getDate("TXN_DATE"));
                list.add(t);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (rs   != null) rs.close();   } catch (Exception e) {}
            try { if (ps   != null) ps.close();   } catch (Exception e) {}
            try { if (conn != null) conn.close(); } catch (Exception e) {}
        }
        return list;
    }
}
