package Servlets;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import DBConnection.DBConnection;
import Entity.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/UpdateProfileServlet")
public class UpdateProfileServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect("index.jsp"); // FIX: index.jsp not index.html
            return;
        }

        User user = (User) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect("index.jsp"); // FIX: index.jsp not index.html
            return;
        }

        String fullName    = request.getParameter("fullName");
        String email       = request.getParameter("email");
        String username    = request.getParameter("username");
        String password    = request.getParameter("password");
        String phoneNumber = request.getParameter("phoneNumber");

        Connection conn = null;
        PreparedStatement ps = null;

        try {
            conn = DBConnection.getConnection();
            if (conn == null) {
                response.sendRedirect("edit.jsp?error=2"); // FIX: edit.jsp not editProfile.jsp
                return;
            }

            String sql;
            if (password != null && !password.trim().isEmpty()) {
                sql = "UPDATE USER_ACCOUNTS SET FULL_NAME=?, EMAIL=?, USERNAME=?, PASSWORD=?, PHONE_NUMBER=? WHERE USER_ID=?";
            } else {
                sql = "UPDATE USER_ACCOUNTS SET FULL_NAME=?, EMAIL=?, USERNAME=?, PHONE_NUMBER=? WHERE USER_ID=?";
            }

            ps = conn.prepareStatement(sql);
            ps.setString(1, fullName);
            ps.setString(2, email);
            ps.setString(3, username);

            if (password != null && !password.trim().isEmpty()) {
                ps.setString(4, password);
                ps.setString(5, phoneNumber);
                ps.setInt(6, user.getUserId());
            } else {
                ps.setString(4, phoneNumber);
                ps.setInt(5, user.getUserId());
            }

            int updated = ps.executeUpdate();
            if (updated > 0) {
                // Update the session object with new values
                user.setFullName(fullName);
                user.setEmail(email);
                user.setUsername(username);
                user.setPhoneNo(phoneNumber);
                session.setAttribute("user", user);
                response.sendRedirect("profile.jsp?success=1");
            } else {
                response.sendRedirect("edit.jsp?error=1"); // FIX: edit.jsp not editProfile.jsp
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("edit.jsp?error=2"); // FIX: edit.jsp not editProfile.jsp
        } finally {
            try { if (ps   != null) ps.close();   } catch (Exception ex) {}
            try { if (conn != null) conn.close(); } catch (Exception ex) {}
        }
    }
}
