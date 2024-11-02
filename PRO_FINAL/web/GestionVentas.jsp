<%-- 
    Document   : GestionVentas
    Created on : 1/11/2024, 4:12:02 p. m.
    Author     : jealv
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*" %>
<%@page import="modelo.Conexion" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Gestión de Ventas</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <div class="container mt-5">
        <h2>Gestión de Ventas</h2>
        <p>Aquí puedes ver, modificar o eliminar ventas registradas.</p>

        <!-- Botón de retorno a OpcionesFormulario.jsp -->
        <div class="mb-3">
            <a href="OpcionesFormulario.jsp" class="btn btn-secondary">
                <i class="fas fa-arrow-left me-2"></i> Regresar a Opciones
            </a>
        </div>

        <!-- Mensaje de estado -->
        <%
            String status = request.getParameter("status");
            if (status != null) {
                if (status.equals("delete_success")) {
        %>
                    <div class="alert alert-success" role="alert">
                        Venta eliminada exitosamente.
                    </div>
        <%
                } else if (status.equals("not_found")) {
        %>
                    <div class="alert alert-warning" role="alert">
                        No se encontró la venta para eliminar.
                    </div>
        <%
                } else if (status.equals("db_error")) {
        %>
                    <div class="alert alert-danger" role="alert">
                        Error de conexión a la base de datos.
                    </div>
        <%
                } else if (status.equals("delete_error")) {
        %>
                    <div class="alert alert-danger" role="alert">
                        Ocurrió un error al intentar eliminar la venta. Es posible que existan registros asociados en el detalle de ventas.
                    </div>
        <%
                }
            }
        %>

        <!-- Tabla de Ventas -->
        <table class="table table-striped">
            <thead>
                <tr>
                    <th>ID Venta</th>
                    <th>Número de Factura</th>
                    <th>Serie</th>
                    <th>Fecha de Factura</th>
                    <th>ID Cliente</th>
                    <th>ID Empleado</th>
                    <th>Total</th>
                    <th>Acciones</th>
                </tr>
            </thead>
            <tbody>
                <%
                    Conexion conn = new Conexion();
                    Connection conexionBD = conn.getConnection();
                    if (conexionBD != null) {
                        String query = "SELECT * FROM ventas";
                        Statement stmt = conexionBD.createStatement();
                        ResultSet rs = stmt.executeQuery(query);

                        while (rs.next()) {
                %>
                <tr>
                    <td><%= rs.getInt("id_venta") %></td>
                    <td><%= rs.getInt("no_factura") %></td>
                    <td><%= rs.getString("serie") %></td>
                    <td><%= rs.getTimestamp("fecha_factura") %></td>
                    <td><%= rs.getInt("id_cliente") %></td>
                    <td><%= rs.getInt("id_empleado") %></td>
                    <td>Q <%= rs.getDouble("precio_total") %></td>
                    <td>
                        <a href="EditarVenta.jsp?id=<%= rs.getInt("id_venta") %>" class="btn btn-warning btn-sm">Editar</a>
                        <a href="EliminarVentaServlet?id=<%= rs.getInt("id_venta") %>" class="btn btn-danger btn-sm" onclick="return confirm('¿Estás seguro de eliminar esta venta?')">Eliminar</a>
                    </td>
                </tr>
                <%
                        }
                        rs.close();
                        stmt.close();
                    } else {
                        out.println("<tr><td colspan='8'>No se pudo conectar a la base de datos.</td></tr>");
                    }
                %>
            </tbody>
        </table>
    </div>
</body>
</html>

