package Servlets;

import java.io.IOException;

import DAO.TransactionDAO;
import Entity.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

// FIX: Added missing @WebServlet annotation — without this the servlet was never registered
@WebServlet("/TransferServlet")
public class TransferServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. Get session and sender user
        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect("index.jsp");
            return;
        }

        User sender = (User) session.getAttribute("user");
        if (sender == null) {
            response.sendRedirect("index.jsp");
            return;
        }

        // 2. Get receiver account and amount
        String receiverAccount = request.getParameter("receiverAccount");
        String amountStr       = request.getParameter("amount");

        if (receiverAccount == null || receiverAccount.trim().isEmpty()
                || amountStr == null || amountStr.trim().isEmpty()) {
            response.sendRedirect("MakePayment.jsp?error=Missing+fields");
            return;
        }

        double amount;
        try {
            amount = Double.parseDouble(amountStr);
        } catch (NumberFormatException e) {
            response.sendRedirect("MakePayment.jsp?error=Invalid+amount");
            return;
        }

        // 3. Perform transaction via DAO
        TransactionDAO dao = new TransactionDAO();
        boolean success = dao.transferAmount(sender.getAccountNumber(), receiverAccount, amount);

        // 4. Redirect based on result
        if (success) {
            response.sendRedirect("dashboard.jsp?msg=Transfer+Successful");
        } else {
            response.sendRedirect("MakePayment.jsp?error=Transfer+Failed");
        }
    }
}
