<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // Invalidate admin session and redirect to admin login
    HttpSession adminSession = request.getSession(false);
    if (adminSession != null) {
        adminSession.invalidate();
    }
    response.sendRedirect("adminLogin.jsp");
%>
