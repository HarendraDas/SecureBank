package Servlets;

import java.io.IOException;

import DAO.AdminDAO;
import Entity.Admin;
import Utils.PasswordUtil;
import Utils.ValidationUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/adminLogin")
public class AdminLoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        // Validation
        if (ValidationUtil.isEmpty(username) || ValidationUtil.isEmpty(password)) {
            request.setAttribute("error", "Username and Password are required!");
            request.getRequestDispatcher("adminLogin.jsp").forward(request, response);
            return;
        }

        // Hash password before checking
        String hashedPassword = PasswordUtil.hashPassword(password);

        AdminDAO dao = new AdminDAO();
        Admin admin = dao.validateAdmin(username, hashedPassword);

        if (admin != null) {
            HttpSession session = request.getSession();
            session.setAttribute("admin", admin);
            response.sendRedirect("adminDashboard.jsp");
        } else {
            request.setAttribute("error", "Invalid Admin Credentials!");
            request.getRequestDispatcher("adminLogin.jsp").forward(request, response);
        }
    }
}
