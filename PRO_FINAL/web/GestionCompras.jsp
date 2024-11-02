<%-- 
    Document   : GestionCompras
    Created on : 1/11/2024, 4:43:25 p. m.
    Author     : jealv
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*" %>
<%@page import="modelo.Conexion" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Gestión de Compras</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
</head>
<body>
    <div class="container mt-5">
        <h2>Gestión de Compras</h2>
        <p>Aquí puedes ver, modificar o eliminar compras registradas.</p>

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
                        Compra eliminada exitosamente.
                    </div>
        <%
                } else if (status.equals("delete_not_found")) {
        %>
                    <div class="alert alert-warning" role="alert">
                        No se encontró la compra para eliminar.
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
                        Ocurrió un error al intentar eliminar la compra.
                    </div>
        <%
                } else if (status.equals("success")) {
        %>
                    <div class="alert alert-success" role="alert">
                        Compra actualizada exitosamente.
                    </div>
        <%
                } else if (status.equals("not_found")) {
        %>
                    <div class="alert alert-warning" role="alert">
                        No se encontró la compra para actualizar.
                    </div>
        <%
                } else if (status.equals("error")) {
        %>
                    <div class="alert alert-danger" role="alert">
                        Ocurrió un error al actualizar la compra.
                    </div>
        <%
                }
            }
        %>

        <!-- Tabla de Compras -->
        <table class="table table-striped">
            <thead>
                <tr>
                    <th>ID Compra</th>
                    <th>Número de Orden</th>
                    <th>Fecha Orden</th>
                    <th>Fecha Ingreso</th>
                    <th>ID Proveedor</th>
                    <th>Total</th>
                    <th>Acciones</th>
                </tr>
            </thead>
            <tbody>
                <%
                    Conexion conn = new Conexion();
                    Connection conexionBD = conn.getConnection();
                    if (conexionBD != null) {
                        String query = "SELECT * FROM compras";
                        Statement stmt = conexionBD.createStatement();
                        ResultSet rs = stmt.executeQuery(query);

                        while (rs.next()) {
                %>
                <tr>
                    <td><%= rs.getInt("id_compra") %></td>
                    <td><%= rs.getInt("no_orden_compra") %></td>
                    <td><%= rs.getDate("fecha_orden") %></td>
                    <td><%= rs.getTimestamp("fecha_ingreso") %></td>
                    <td><%= rs.getInt("id_proveedor") %></td>
                    <td>Q <%= rs.getDouble("precio_total") %></td>
                    <td>
                        <a href="EditarCompra.jsp?id=<%= rs.getInt("id_compra") %>" class="btn btn-warning btn-sm">Editar</a>
                        <a href="EliminarCompraServlet?id=<%= rs.getInt("id_compra") %>" class="btn btn-danger btn-sm" onclick="return confirm('¿Estás seguro de eliminar esta compra?')">Eliminar</a>
                    </td>
                </tr>
                <%
                        }
                        rs.close();
                        stmt.close();
                    } else {
                        out.println("<tr><td colspan='7'>No se pudo conectar a la base de datos.</td></tr>");
                    }
                %>
            </tbody>
        </table>
    </div>
</body>
</html>
