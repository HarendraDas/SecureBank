package Servlets;

import java.io.IOException;

import DAO.AdminDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/AdminLoanServlet")
public class AdminLoanServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Check admin session
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("admin") == null) {
            response.sendRedirect("adminLogin.jsp");
            return;
        }

        int    loanId = Integer.parseInt(request.getParameter("loanId"));
        String status = request.getParameter("status"); // "Approved" or "Rejected"

        AdminDAO dao = new AdminDAO();
        boolean success = dao.updateLoanStatus(loanId, status);

        if (success) {
            response.sendRedirect("adminLoans.jsp?msg=Loan+" + status + "+successfully!");
        } else {
            response.sendRedirect("adminLoans.jsp?msg=Update+failed!");
        }
    }
}
