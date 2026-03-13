package DAO;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import DBConnection.DBConnection;
import Entity.User;

public class RegisterDAO {

    public boolean registerUser(User user) {
        String sql = "INSERT INTO USER_ACCOUNTS "
                   + "(FULL_NAME, EMAIL, USERNAME, PASSWORD, PHONE_NUMBER, ACCOUNT_NUMBER, BALANCE) "
                   + "VALUES (?, ?, ?, ?, ?, ?, ?)";

        Connection con = DBConnection.getConnection();

        // FIX: Check for null BEFORE using the connection
        if (con == null) {
            System.out.println("DB Connection is null! Cannot register user.");
            return false;
        }

        try (PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, user.getFullName());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getUsername());
            ps.setString(4, user.getPassword());
            ps.setString(5, user.getPhoneNo());
            ps.setString(6, user.getAccountNumber());
            ps.setDouble(7, user.getBalance());

            int rows = ps.executeUpdate();
            System.out.println("Rows inserted: " + rows);
            return rows > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try { con.close(); } catch (Exception e) {}
        }
        return false;
    }
}
