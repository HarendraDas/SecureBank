package Servlets;

import java.io.IOException;

import DAO.LoanDAO;
import Entity.Loan;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/ApplyLoanServlet")
public class ApplyLoanServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        int    customerId = Integer.parseInt(req.getParameter("customerId"));
        String loanType   = req.getParameter("loanType");
        double amount     = Double.parseDouble(req.getParameter("amount"));
        int    duration   = Integer.parseInt(req.getParameter("duration"));

        Loan loan = new Loan();
        loan.setCustomerId(customerId);
        loan.setLoanType(loanType);
        loan.setAmount(amount);
        loan.setDuration(duration);

        LoanDAO dao = new LoanDAO();
        boolean success = dao.applyLoan(loan);

        if (success) {
            resp.sendRedirect("ApplyLoan.jsp?msg=Loan+Applied+Successfully!");
        } else {
            resp.sendRedirect("ApplyLoan.jsp?msg=Something+went+wrong!");
        }
    }
}
