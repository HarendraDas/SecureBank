package Servlets;

import java.io.IOException;

import DAO.RegisterDAO;
import Entity.User;
import Utils.AccountNumberGenerator;
import Utils.PasswordUtil;
import Utils.ValidationUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/RegisterServlet")
public class RegisterServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String fullName        = request.getParameter("fullName");
        String email           = request.getParameter("email");
        String phone           = request.getParameter("phone");
        String username        = request.getParameter("username");
        String password        = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        // ===== INPUT VALIDATION =====
        if (ValidationUtil.isEmpty(fullName)) {
            request.setAttribute("error", "Full name is required!");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }
        if (!ValidationUtil.isValidEmail(email)) {
            request.setAttribute("error", "Please enter a valid email address!");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }
        if (!ValidationUtil.isValidPhone(phone)) {
            request.setAttribute("error", "Phone number must be exactly 10 digits!");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }
        if (!ValidationUtil.isValidUsername(username)) {
            request.setAttribute("error", "Username must be 4-20 characters, letters and numbers only!");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }
        if (!ValidationUtil.isValidPassword(password)) {
            request.setAttribute("error", "Password must be at least 6 characters!");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }
        if (!password.equals(confirmPassword)) {
            request.setAttribute("error", "Passwords do not match!");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        // ===== HASH PASSWORD =====
        String hashedPassword = PasswordUtil.hashPassword(password);

        // ===== CREATE USER =====
        String accountNumber = AccountNumberGenerator.generateAccountNo();
        User user = new User();
        user.setFullName(fullName);
        user.setEmail(email);
        user.setPhoneNo(phone);
        user.setUsername(username);
        user.setPassword(hashedPassword);
        user.setAccountNumber(accountNumber);
        user.setBalance(15000.0);

        RegisterDAO dao = new RegisterDAO();
        boolean success = dao.registerUser(user);

        if (success) {
            response.sendRedirect("index.jsp?msg=Registration+successful!+Please+login.");
        } else {
            request.setAttribute("error", "Registration failed. Username or Email may already exist!");
            request.getRequestDispatcher("register.jsp").forward(request, response);
        }
    }
}
