package DAO;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

import DBConnection.DBConnection;
import Entity.Loan;

public class LoanDAO {

    // Insert Loan
    public boolean applyLoan(Loan loan) {
        boolean success = false;
        Connection con = null;
        PreparedStatement ps = null;

        try {
            con = DBConnection.getConnection();
            if (con == null) {
                System.err.println("DB Connection is null!");
                return false;
            }

            System.out.println("customerId  = " + loan.getCustomerId());
            System.out.println("loanType    = " + loan.getLoanType());
            System.out.println("amount      = " + loan.getAmount());
            System.out.println("duration    = " + loan.getDuration());

            String sql = "INSERT INTO LOAN_DETAILS (CUSTOMER_ID, LOAN_TYPE, AMOUNT, DURATION, STATUS, APPLY_DATE) "
                       + "VALUES (?, ?, ?, ?, 'Pending', SYSDATE)";
            ps = con.prepareStatement(sql);
            ps.setInt(1, loan.getCustomerId());
            ps.setString(2, loan.getLoanType());
            ps.setDouble(3, loan.getAmount());
            ps.setInt(4, loan.getDuration());

            int rows = ps.executeUpdate();
            success = rows > 0;

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            // FIX: Always close resources to prevent connection leaks
            try { if (ps  != null) ps.close();  } catch (Exception e) {}
            try { if (con != null) con.close(); } catch (Exception e) {}
        }

        return success;
    }

    // Get all loans (for admin view)
    public List<Loan> getAllLoans() {
        List<Loan> list = new ArrayList<>();
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = DBConnection.getConnection();
            if (con == null) return list;

            String sql = "SELECT * FROM LOAN_DETAILS ORDER BY loan_id DESC";
            ps = con.prepareStatement(sql);
            rs = ps.executeQuery();

            while (rs.next()) {
                Loan l = new Loan();
                l.setLoanId(rs.getInt("loan_id"));
                l.setCustomerId(rs.getInt("customer_id"));
                l.setLoanType(rs.getString("loan_type"));
                l.setAmount(rs.getDouble("amount"));
                l.setDuration(rs.getInt("duration"));
                l.setStatus(rs.getString("status"));
                l.setApplyDate(rs.getString("apply_date"));
                list.add(l);
            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            // FIX: Close all resources
            try { if (rs  != null) rs.close();  } catch (Exception e) {}
            try { if (ps  != null) ps.close();  } catch (Exception e) {}
            try { if (con != null) con.close(); } catch (Exception e) {}
        }

        return list;
    }
}
