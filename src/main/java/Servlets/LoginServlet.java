package Servlets;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

import DAO.UserDAO;
import Entity.User;
import Utils.PasswordUtil;
import Utils.ValidationUtil;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        // ===== INPUT VALIDATION =====
        if (ValidationUtil.isEmpty(username) || ValidationUtil.isEmpty(password)) {
            request.setAttribute("error", "Username and Password are required!");
            request.getRequestDispatcher("index.jsp").forward(request, response);
            return;
        }

        // ===== HASH PASSWORD BEFORE CHECKING =====
        String hashedPassword = PasswordUtil.hashPassword(password);

        // ===== VALIDATE USER =====
        UserDAO dao = new UserDAO();
        User user = dao.validateUser(username, hashedPassword);

        if (user != null) {
            HttpSession session = request.getSession();
            session.setAttribute("user", user);
            response.sendRedirect("dashboard.jsp");
        } else {
            request.setAttribute("error", "Invalid Username or Password!");
            request.getRequestDispatcher("index.jsp").forward(request, response);
        }
    }
}
