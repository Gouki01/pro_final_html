<%-- 
    Document   : EditarCompra
    Created on : 1/11/2024, 4:43:47 p. m.
    Author     : jealv
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*" %>
<%@page import="modelo.Conexion" %>

<%
    int idCompra = Integer.parseInt(request.getParameter("id"));
    Conexion conn = new Conexion();
    Connection conexionBD = conn.getConnection();
    ResultSet rs = null;
    
    if (conexionBD != null) {
        String query = "SELECT * FROM compras WHERE id_compra = ?";
        PreparedStatement stmt = conexionBD.prepareStatement(query);
        stmt.setInt(1, idCompra);
        rs = stmt.executeQuery();
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Editar Compra</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <div class="container mt-5">
        <h2>Editar Compra</h2>
        <form action="ActualizarCompraServlet" method="post">
            <input type="hidden" name="id_compra" value="<%= idCompra %>">
            <%
                if (rs != null && rs.next()) {
            %>
            <div class="mb-3">
                <label>Número de Orden:</label>
                <input type="number" name="no_orden_compra" class="form-control" value="<%= rs.getInt("no_orden_compra") %>" required>
            </div>
            <div class="mb-3">
                <label>Fecha Orden:</label>
                <input type="date" name="fecha_orden" class="form-control" value="<%= rs.getDate("fecha_orden") %>" required>
            </div>
            <div class="mb-3">
                <label>Fecha Ingreso:</label>
                <input type="datetime-local" name="fecha_ingreso" class="form-control" value="<%= rs.getTimestamp("fecha_ingreso") %>" required>
            </div>
            <div class="mb-3">
                <label>ID Proveedor:</label>
                <input type="number" name="id_proveedor" class="form-control" value="<%= rs.getInt("id_proveedor") %>" required>
            </div>
            <div class="mb-3">
                <label>Total:</label>
                <input type="number" step="0.01" name="precio_total" class="form-control" value="<%= rs.getDouble("precio_total") %>" required>
            </div>
            <button type="submit" class="btn btn-primary">Guardar Cambios</button>
            <a href="GestionCompras.jsp" class="btn btn-secondary">Cancelar</a>
            <%
                }
                rs.close();
                conexionBD.close();
            %>
        </form>
    </div>
</body>
</html>
