package DAO;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

import DBConnection.DBConnection;
import Entity.Admin;
import Entity.Loan;
import Entity.Transaction;
import Entity.User;

public class AdminDAO {

    // ===== ADMIN LOGIN =====
    public Admin validateAdmin(String username, String password) {
        Admin admin = null;
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = DBConnection.getConnection();
            if (con == null) return null;

            String sql = "SELECT * FROM ADMIN_ACCOUNTS WHERE USERNAME=? AND PASSWORD=?";
            ps = con.prepareStatement(sql);
            ps.setString(1, username);
            ps.setString(2, password);
            rs = ps.executeQuery();

            if (rs.next()) {
                admin = new Admin();
                admin.setAdminId(rs.getInt("ADMIN_ID"));
                admin.setUsername(rs.getString("USERNAME"));
                admin.setFullName(rs.getString("FULL_NAME"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (rs  != null) rs.close();  } catch (Exception e) {}
            try { if (ps  != null) ps.close();  } catch (Exception e) {}
            try { if (con != null) con.close(); } catch (Exception e) {}
        }
        return admin;
    }

    // ===== GET ALL USERS =====
    public List<User> getAllUsers() {
        List<User> list = new ArrayList<>();
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = DBConnection.getConnection();
            if (con == null) return list;

            String sql = "SELECT * FROM USER_ACCOUNTS ORDER BY USER_ID DESC";
            ps = con.prepareStatement(sql);
            rs = ps.executeQuery();

            while (rs.next()) {
                User u = new User();
                u.setUserId(rs.getInt("USER_ID"));
                u.setFullName(rs.getString("FULL_NAME"));
                u.setEmail(rs.getString("EMAIL"));
                u.setUsername(rs.getString("USERNAME"));
                u.setAccountNumber(rs.getString("ACCOUNT_NUMBER"));
                u.setBalance(rs.getDouble("BALANCE"));
                u.setPhoneNo(rs.getString("PHONE_NUMBER"));
                list.add(u);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (rs  != null) rs.close();  } catch (Exception e) {}
            try { if (ps  != null) ps.close();  } catch (Exception e) {}
            try { if (con != null) con.close(); } catch (Exception e) {}
        }
        return list;
    }

    // ===== GET ALL TRANSACTIONS =====
    public List<Transaction> getAllTransactions() {
        List<Transaction> list = new ArrayList<>();
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = DBConnection.getConnection();
            if (con == null) return list;

            String sql = "SELECT * FROM TXN_HISTORY ORDER BY TXN_DATE DESC";
            ps = con.prepareStatement(sql);
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
            try { if (rs  != null) rs.close();  } catch (Exception e) {}
            try { if (ps  != null) ps.close();  } catch (Exception e) {}
            try { if (con != null) con.close(); } catch (Exception e) {}
        }
        return list;
    }

    // ===== GET ALL LOANS =====
    public List<Loan> getAllLoans() {
        List<Loan> list = new ArrayList<>();
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = DBConnection.getConnection();
            if (con == null) return list;

            String sql = "SELECT * FROM LOAN_DETAILS ORDER BY LOAN_ID DESC";
            ps = con.prepareStatement(sql);
            rs = ps.executeQuery();

            while (rs.next()) {
                Loan l = new Loan();
                l.setLoanId(rs.getInt("LOAN_ID"));
                l.setCustomerId(rs.getInt("CUSTOMER_ID"));
                l.setLoanType(rs.getString("LOAN_TYPE"));
                l.setAmount(rs.getDouble("AMOUNT"));
                l.setDuration(rs.getInt("DURATION"));
                l.setStatus(rs.getString("STATUS"));
                l.setApplyDate(rs.getString("APPLY_DATE"));
                list.add(l);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (rs  != null) rs.close();  } catch (Exception e) {}
            try { if (ps  != null) ps.close();  } catch (Exception e) {}
            try { if (con != null) con.close(); } catch (Exception e) {}
        }
        return list;
    }

    // ===== APPROVE OR REJECT LOAN =====
    // FIX: When approved → loan amount is added to user balance automatically
    public boolean updateLoanStatus(int loanId, String status) {
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = DBConnection.getConnection();
            if (con == null) return false;
            con.setAutoCommit(false);

            // Step 1 — Get loan details (amount + customer_id)
            String getLoanSQL = "SELECT AMOUNT, CUSTOMER_ID FROM LOAN_DETAILS WHERE LOAN_ID = ?";
            ps = con.prepareStatement(getLoanSQL);
            ps.setInt(1, loanId);
            rs = ps.executeQuery();

            if (!rs.next()) {
                con.rollback();
                return false;
            }

            double loanAmount = rs.getDouble("AMOUNT");
            int customerId   = rs.getInt("CUSTOMER_ID");
            rs.close();
            ps.close();

            // Step 2 — Update loan status
            String updateLoanSQL = "UPDATE LOAN_DETAILS SET STATUS=? WHERE LOAN_ID=?";
            ps = con.prepareStatement(updateLoanSQL);
            ps.setString(1, status);
            ps.setInt(2, loanId);
            ps.executeUpdate();
            ps.close();

            // Step 3 — If APPROVED → add loan amount to user balance
            if ("Approved".equalsIgnoreCase(status)) {

                // Get user account number from USER_ACCOUNTS using USER_ID
                String getAccountSQL = "SELECT ACCOUNT_NUMBER FROM USER_ACCOUNTS WHERE USER_ID = ?";
                ps = con.prepareStatement(getAccountSQL);
                ps.setInt(1, customerId);
                rs = ps.executeQuery();

                if (rs.next()) {
                    String accountNumber = rs.getString("ACCOUNT_NUMBER");
                    rs.close();
                    ps.close();

                    // Add loan amount to balance
                    String updateBalanceSQL = "UPDATE USER_ACCOUNTS SET BALANCE = BALANCE + ? WHERE ACCOUNT_NUMBER = ?";
                    ps = con.prepareStatement(updateBalanceSQL);
                    ps.setDouble(1, loanAmount);
                    ps.setString(2, accountNumber);
                    ps.executeUpdate();
                    ps.close();

                    // Record in TXN_HISTORY as a credit transaction
                    String insertTxnSQL = "INSERT INTO TXN_HISTORY "
                            + "(SENDER_ACCOUNT, RECEIVER_ACCOUNT, AMOUNT, TXN_TYPE, DESCRIPTION, STATUS, TXN_DATE) "
                            + "VALUES (?, ?, ?, ?, ?, ?, SYSDATE)";
                    ps = con.prepareStatement(insertTxnSQL);
                    ps.setString(1, "SECUREBANK");       // Bank is the sender
                    ps.setString(2, accountNumber);       // User receives it
                    ps.setDouble(3, loanAmount);
                    ps.setString(4, "Credit");
                    ps.setString(5, "Loan Approved - Amount Credited");
                    ps.setString(6, "SUCCESS");
                    ps.executeUpdate();
                }
            }

            con.commit();
            return true;

        } catch (Exception e) {
            e.printStackTrace();
            try { if (con != null) con.rollback(); } catch (Exception ex) {}
        } finally {
            try { if (rs  != null) rs.close();  } catch (Exception e) {}
            try { if (ps  != null) ps.close();  } catch (Exception e) {}
            try { if (con != null) con.close(); } catch (Exception e) {}
        }
        return false;
    }

    // ===== DASHBOARD COUNTS =====
    public int getTotalUsers() {
        return getCount("SELECT COUNT(*) FROM USER_ACCOUNTS");
    }

    public int getTotalTransactions() {
        return getCount("SELECT COUNT(*) FROM TXN_HISTORY");
    }

    public int getPendingLoans() {
        return getCount("SELECT COUNT(*) FROM LOAN_DETAILS WHERE STATUS='Pending'");
    }

    private int getCount(String sql) {
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        int count = 0;
        try {
            con = DBConnection.getConnection();
            if (con == null) return 0;
            ps = con.prepareStatement(sql);
            rs = ps.executeQuery();
            if (rs.next()) count = rs.getInt(1);
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (rs  != null) rs.close();  } catch (Exception e) {}
            try { if (ps  != null) ps.close();  } catch (Exception e) {}
            try { if (con != null) con.close(); } catch (Exception e) {}
        }
        return count;
    }
}
