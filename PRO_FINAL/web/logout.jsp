<%-- 
    Document   : logout.jsp
    Created on : 1/11/2024, 4:56:36 p. m.
    Author     : jealv
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="jakarta.servlet.http.HttpSession"%>

<%
    // Invalida la sesión actual
    HttpSession userSession = request.getSession(false);
    if (userSession != null) {
        userSession.invalidate();
    }
    // Redirige al formulario de inicio de sesión o página principal
    response.sendRedirect("login.jsp");
%>
