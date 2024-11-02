<%-- 
    Document   : EditarVenta
    Created on : 1/11/2024, 4:16:40 p. m.
    Author     : jealv
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*" %>
<%@page import="modelo.Conexion" %>

<%
    // Obtener el ID de la venta desde la URL
    String idVentaStr = request.getParameter("id");
    int idVenta = (idVentaStr != null) ? Integer.parseInt(idVentaStr) : 0;

    // Variables para almacenar los datos de la venta
    int noFactura = 0;
    String serie = "";
    Timestamp fechaFactura = null;
    int idCliente = 0;
    int idEmpleado = 0;
    double precioTotal = 0.0;

    // Conectar a la base de datos y obtener los datos de la venta
    Conexion conn = new Conexion();
    Connection conexionBD = conn.getConnection();
    if (conexionBD != null && idVenta != 0) {
        String query = "SELECT * FROM ventas WHERE id_venta = ?";
        PreparedStatement stmt = conexionBD.prepareStatement(query);
        stmt.setInt(1, idVenta);
        ResultSet rs = stmt.executeQuery();

        if (rs.next()) {
            noFactura = rs.getInt("no_factura");
            serie = rs.getString("serie");
            fechaFactura = rs.getTimestamp("fecha_factura");
            idCliente = rs.getInt("id_cliente");
            idEmpleado = rs.getInt("id_empleado");
            precioTotal = rs.getDouble("precio_total");
        }
        rs.close();
        stmt.close();
    } else {
        out.println("<h3>Error: Venta no encontrada o conexión fallida.</h3>");
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Editar Venta</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <div class="container my-5">
        <h3>Editar Venta</h3>
        <form action="ActualizarVentaServlet" method="post">
            <!-- Campo oculto para el ID de la venta -->
            <input type="hidden" name="id_venta" value="<%= idVenta %>">

            <div class="mb-3">
                <label for="no_factura" class="form-label">Número de Factura:</label>
                <input type="number" id="no_factura" name="no_factura" class="form-control" value="<%= noFactura %>" required>
            </div>

            <div class="mb-3">
                <label for="serie" class="form-label">Serie:</label>
                <input type="text" id="serie" name="serie" class="form-control" value="<%= serie %>" required>
            </div>

            <div class="mb-3">
                <label for="fecha_factura" class="form-label">Fecha de Factura:</label>
                <input type="datetime-local" id="fecha_factura" name="fecha_factura" class="form-control" value="<%= fechaFactura.toString().replace(" ", "T") %>" required>
            </div>

            <div class="mb-3">
                <label for="id_cliente" class="form-label">Cliente:</label>
                <select id="id_cliente" name="id_cliente" class="form-control" required>
                    <% 
                        if (conexionBD != null) {
                            String clientQuery = "SELECT id_cliente, CONCAT(nombres, ' ', apellidos) AS nombre_cliente FROM clientes";
                            Statement clientStmt = conexionBD.createStatement();
                            ResultSet clientRs = clientStmt.executeQuery(clientQuery);

                            while (clientRs.next()) {
                    %>
                    <option value="<%= clientRs.getInt("id_cliente") %>" <%= (clientRs.getInt("id_cliente") == idCliente) ? "selected" : "" %>>
                        <%= clientRs.getString("nombre_cliente") %>
                    </option>
                    <% 
                            }
                            clientRs.close();
                            clientStmt.close();
                        }
                    %>
                </select>
            </div>

            <div class="mb-3">
                <label for="id_empleado" class="form-label">Empleado:</label>
                <select id="id_empleado" name="id_empleado" class="form-control" required>
                    <% 
                        if (conexionBD != null) {
                            String employeeQuery = "SELECT id_empleado, CONCAT(nombres, ' ', apellidos) AS nombre_empleado FROM empleados";
                            Statement employeeStmt = conexionBD.createStatement();
                            ResultSet employeeRs = employeeStmt.executeQuery(employeeQuery);

                            while (employeeRs.next()) {
                    %>
                    <option value="<%= employeeRs.getInt("id_empleado") %>" <%= (employeeRs.getInt("id_empleado") == idEmpleado) ? "selected" : "" %>>
                        <%= employeeRs.getString("nombre_empleado") %>
                    </option>
                    <% 
                            }
                            employeeRs.close();
                            employeeStmt.close();
                        }
                    %>
                </select>
            </div>

            <div class="mb-3">
                <label for="precio_total" class="form-label">Total de la Venta:</label>
                <input type="number" step="0.01" id="precio_total" name="precio_total" class="form-control" value="<%= precioTotal %>" required>
            </div>

            <button type="submit" class="btn btn-primary">Guardar Cambios</button>
            <a href="GestionVentas.jsp" class="btn btn-secondary">Cancelar</a>
        </form>
    </div>
</body>
</html>

<%
    // Cerrar la conexión a la base de datos
    if (conexionBD != null) {
        conexionBD.close();
    }
%>
