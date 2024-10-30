<%-- 
    Document   : Ventas
    Created on : 29/10/2024, 11:48:28 p. m.
    Author     : Soporte_IT
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*" %>
<%@page import="modelo.Conexion" %>

<%
    String id_venta_str = request.getParameter("id_venta");
    int id_venta = id_venta_str != null ? Integer.parseInt(id_venta_str) : 0; 
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Tabla de Ventas</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
        <script>
            function updatePrice() {
                var select = document.getElementById("id_producto");
                var selectedOption = select.options[select.selectedIndex];
                var price = selectedOption.getAttribute("data-precio");
                var stock = selectedOption.getAttribute("data-stock");
                document.getElementById("precio_unitario").value = price;
                document.getElementById("cantidad").max = stock; // Actualiza el stock máximo disponible
            }

            function validateStock() {
                var quantity = parseInt(document.getElementById("cantidad").value) || 0;
                var stock = parseInt(document.getElementById("id_producto").options[document.getElementById("id_producto").selectedIndex].getAttribute("data-stock")) || 0;

                if (quantity > stock) {
                    alert("Error: La cantidad solicitada supera el stock disponible.");
                    return false;
                }
                return true;
            }
        </script>
        <style>
            .custom-header th {
                background-color: #007bff; 
                color: #ffffff; 
            }
            .container {
                margin-left: 0.5cm;
                margin-right: 0.5cm;
            }
            .save-button-container {
                margin-bottom: 10px;
                display: flex;
                justify-content: flex-end;
            }
            .out-of-stock {
                color: red;
                font-weight: bold;
            }
        </style>
    </head>
    <body>
        <div class="container my-5">
            <div class="save-button-container">
                <button type="submit" form="ventasForm" class="btn btn-success">
                    <i class="fas fa-floppy-disk me-2"></i> Guardar
                </button>
            </div>
            <table class="table table-striped table-bordered table-hover text-center">
                <thead class="custom-header">
                    <tr>                    
                        <th scope="col">No.</th> 
                        <th scope="col">Número de Factura</th>
                        <th scope="col">Serie</th>
                        <th scope="col">Fecha de Factura</th>
                        <th scope="col">ID Cliente</th>
                        <th scope="col">ID Empleado</th>
                        <th scope="col">Fecha de Ingreso</th>
                        <th scope="col">Producto</th>
                        <th scope="col">Cantidad</th>
                        <th scope="col">Precio Unitario</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <form id="ventasForm" action="${pageContext.request.contextPath}/VentasServlet" method="post" onsubmit="return validateStock()">
                            <td></td> 
                            <td><input type="text" name="no_factura" class="form-control" placeholder="Número de Factura" required></td>
                            <td><input type="text" name="serie" class="form-control" placeholder="Serie" required></td>
                            <td><input type="datetime-local" name="fecha_factura" class="form-control" required></td>
                            <td>
                                <div class="form-group">
                                    <select name="id_cliente" class="form-control" required>
                                        <% 
                                            Conexion conn = new Conexion();
                                            Connection conexionBD = conn.getConnection();
                                            if (conexionBD != null) {
                                                String clientQuery = "SELECT id_cliente, CONCAT(nombres, ' ', apellidos, ' (', nit, ')') AS nombre_cliente FROM clientes"; 
                                                Statement clientStmt = conexionBD.createStatement();
                                                ResultSet clientRs = clientStmt.executeQuery(clientQuery);
                                                
                                                while (clientRs.next()) {
                                        %>
                                        <option value="<%= clientRs.getInt("id_cliente") %>"><%= clientRs.getString("nombre_cliente") %></option> 
                                        <% 
                                                }
                                                clientRs.close();
                                                clientStmt.close();
                                            } else {
                                                out.println("<option disabled>No se pudo cargar clientes</option>"); 
                                            }
                                        %>
                                    </select>
                                    <a href="clientes.jsp" class="btn btn-link">Clientes</a>
                                </div>
                            </td>
                            <td>
                                <div class="form-group">
                                    <select name="id_empleado" class="form-control" required>
                                        <% 
                                            if (conexionBD != null) {
                                                String employeeQuery = "SELECT id_empleado, CONCAT(nombres, ' ', apellidos) AS nombre_empleado FROM empleados"; 
                                                Statement employeeStmt = conexionBD.createStatement();
                                                ResultSet employeeRs = employeeStmt.executeQuery(employeeQuery);
                                                
                                                while (employeeRs.next()) {
                                        %>
                                        <option value="<%= employeeRs.getInt("id_empleado") %>"><%= employeeRs.getString("nombre_empleado") %></option> 
                                        <% 
                                                }
                                                employeeRs.close();
                                                employeeStmt.close();
                                            } else {
                                                out.println("<option disabled>No se pudo cargar empleados</option>"); 
                                            }
                                        %>
                                    </select>
                                    <a href="empleados.jsp" class="btn btn-link">Empleados</a>
                                </div>
                            </td>
                            <td><input type="datetime-local" name="fecha_ingreso" class="form-control" required></td>
                            <td>
                                <div class="form-group">
                                    <select id="id_producto" name="id_producto" class="form-control" required onchange="updatePrice()">
                                        <% 
                                            if (conexionBD != null) {
                                                String productQuery = "SELECT id_producto, producto, precio_venta, existencia FROM productos"; 
                                                Statement productStmt = conexionBD.createStatement();
                                                ResultSet productRs = productStmt.executeQuery(productQuery);
                                                
                                                while (productRs.next()) {
                                                    int existencia = productRs.getInt("existencia");
                                                    String styleClass = existencia == 0 ? "out-of-stock" : "";
                                                    String disabled = existencia == 0 ? "disabled" : "";
                                        %>
                                        <option value="<%= productRs.getInt("id_producto") %>" data-precio="<%= productRs.getDouble("precio_venta") %>" data-stock="<%= existencia %>" class="<%= styleClass %>" <%= disabled %>>
                                            <%= productRs.getString("producto") %>
                                        </option> 
                                        <% 
                                                }
                                                productRs.close();
                                                productStmt.close();
                                            } else {
                                                out.println("<option disabled>No se pudo cargar productos</option>"); 
                                            }
                                        %>
                                    </select>
                                </div>
                            </td>
                            <td><input type="number" id="cantidad" name="cantidad" class="form-control" placeholder="Cantidad" required oninput="updatePrice()"></td>
                            <td><input type="number" id="precio_unitario" name="precio_unitario" class="form-control" placeholder="Precio Unitario" required readonly></td>
                        </form>
                    </tr>
                    <% 
                        try {
                            if (conexionBD == null) {
                                throw new SQLException("No se pudo establecer la conexión a la base de datos."); 
                            }
                            String query = "SELECT v.*, vd.id_producto, vd.cantidad, vd.precio_unitario, p.producto AS nombre_producto "
                                         + "FROM ventas v "
                                         + "LEFT JOIN ventas_detalle vd ON v.id_venta = vd.id_venta "
                                         + "LEFT JOIN productos p ON vd.id_producto = p.id_producto"; 
                            Statement stmt = conexionBD.createStatement();
                            ResultSet rs = stmt.executeQuery(query);
                            while (rs.next()) {
                    %>
                    <tr>
                        <td><%= rs.getInt("id_venta") %></td>
                        <td><%= rs.getString("no_factura") %></td>
                        <td><%= rs.getString("serie") %></td>
                        <td><%= rs.getTimestamp("fecha_factura") != null ? rs.getTimestamp("fecha_factura").toString() : "N/A" %></td>
                        <td><%= rs.getInt("id_cliente") %></td>
                        <td><%= rs.getInt("id_empleado") %></td>
                        <td><%= rs.getTimestamp("fecha_ingreso") != null ? rs.getTimestamp("fecha_ingreso").toString() : "N/A" %></td>
                        <td><%= rs.getString("nombre_producto") != null ? rs.getString("nombre_producto") : "N/A" %></td> 
                        <td><%= rs.getInt("cantidad") > 0 ? rs.getInt("cantidad") : 0 %></td> 
                        <td><%= rs.getDouble("precio_unitario") > 0 ? rs.getDouble("precio_unitario") : 0 %></td> 
                    </tr>
                    <%
                            }
                            rs.close();
                            stmt.close();
                        } catch (SQLException e) {
                            e.printStackTrace();
                        } finally {
                            if (conexionBD != null) {
                                conn.cerrar_conexion();
                            }
                        }
                    %>
                </tbody>
            </table>
        </div>
    </body>
</html> 
