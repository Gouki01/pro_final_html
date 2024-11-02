<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="jakarta.servlet.http.HttpSession"%>
<%@page import="jakarta.servlet.http.HttpServletResponse"%>
<%@page import="jakarta.servlet.http.HttpServletRequest"%>

<%
    // Intentar obtener la sesión existente sin crear una nueva
    HttpSession userSession = request.getSession(false);
    String username = (userSession != null) ? (String) userSession.getAttribute("username") : null;

    if (username == null) {
        // Si el usuario no está autenticado, redirigir a la página principal
        response.sendRedirect("principal.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Opciones de Formulario</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <div class="container mt-5">
        <h2>Opciones de Formulario</h2>
        <p>Bienvenido, <%= username %>. Selecciona una opción:</p>
        <div class="d-flex flex-column">
            <a href="GestionVentas.jsp" class="btn btn-primary mb-2">Gestionar Ventas</a>
            <a href="GestionCompras.jsp" class="btn btn-primary mb-2">Gestionar Compras</a>
        </div>
        <div class="mt-4">
            <a href="LogoutServlet" class="btn btn-danger">Cerrar sesión</a>
        </div>
    </div>
</body>
</html>
