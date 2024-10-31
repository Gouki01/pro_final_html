<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*" %>
<%@page import="modelo.Conexion" %>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Compras</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
        <script>
            function updatePriceAndStock() {
                var select = document.getElementById("id_producto");
                var selectedOption = select.options[select.selectedIndex];
                var price = selectedOption.getAttribute("data-precio");
                var stock = selectedOption.getAttribute("data-stock");

                document.getElementById("precio_costo_unitario").value = price;
                document.getElementById("stock_disponible").value = stock;

                if (stock <= 0) {
                    select.classList.add("text-danger");
                    select.disabled = true;
                }
            }

            function validateStock() {
                var stock = parseInt(document.getElementById("stock_disponible").value) || 0;
                var cantidad = parseInt(document.getElementById("cantidad").value) || 0;

                if (cantidad > stock) {
                    alert("No hay suficiente stock para la cantidad solicitada.");
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
            .form-container {
                border: 3px solid #0d6efd; 
                padding: 20px;
                border-radius: 8px;
                margin: 20px 0;
            }
        </style>
    </head>
    <body>
        <div class="container my-5">
            <div class="form-container">
                <form action="${pageContext.request.contextPath}/ComprasServlet" method="post" onsubmit="return validateStock()">
                    <div class="row mb-3">
                        <div class="col">
                            <label>Número de Orden de Compra:</label>
                            <input type="number" name="no_orden_compra" class="form-control" required>
                        </div>
                        <div class="col">
                            <label>Fecha de Orden:</label>
                            <input type="date" name="fecha_orden" class="form-control" required>
                        </div>
                        <div class="col">
                            <label>Fecha de Ingreso:</label>
                            <input type="datetime-local" name="fecha_ingreso" class="form-control" required>
                        </div>
                    </div>
                    <div class="row mb-3">
                        <div class="col">
                            <label>Proveedor:</label>
                            <select name="id_proveedor" class="form-control" required>
                                <% 
                                    Conexion conn = new Conexion();
                                    Connection conexionBD = conn.getConnection();
                                    if (conexionBD != null) {
                                        String query = "SELECT id_proveedor, proveedor FROM proveedores";
                                        Statement stmt = conexionBD.createStatement();
                                        ResultSet rs = stmt.executeQuery(query);
                                        while (rs.next()) {
                                %>
                                <option value="<%= rs.getInt("id_proveedor") %>"><%= rs.getString("proveedor") %></option>
                                <% 
                                        }
                                        rs.close();
                                        stmt.close();
                                    } else {
                                        out.println("<option disabled>No se pudo cargar proveedores</option>"); 
                                    }
                                %>
                            </select>
                            <a href="proveedores.jsp" class="btn btn-link">Ir a Proveedores</a>
                        </div>
                        <div class="col">
                            <label>Producto:</label>
                            <select id="id_producto" name="id_producto" class="form-control" onchange="updatePriceAndStock()" required>
                                <% 
                                    if (conexionBD != null) {
                                        String productQuery = "SELECT id_producto, producto, precio_costo, existencia FROM productos";
                                        Statement productStmt = conexionBD.createStatement();
                                        ResultSet productRs = productStmt.executeQuery(productQuery);
                                        while (productRs.next()) {
                                %>
                                <option value="<%= productRs.getInt("id_producto") %>" 
                                        data-precio="<%= productRs.getDouble("precio_costo") %>"
                                        data-stock="<%= productRs.getInt("existencia") %>"
                                        <% if (productRs.getInt("existencia") <= 0) { %> style="color: red;" disabled <% } %> >
                                    <%= productRs.getString("producto") %> 
                                </option>
                                <% 
                                        }
                                        productRs.close();
                                        productStmt.close();
                                    }
                                %>
                            </select>
                        </div>
                    </div>
                    <div class="row mb-3">
                        <div class="col">
                            <label>Cantidad:</label>
                            <input type="number" id="cantidad" name="cantidad" class="form-control" required>
                        </div>
                        <div class="col">
                            <label>Precio Costo Unitario:</label>
                            <input type="number" id="precio_costo_unitario" name="precio_costo_unitario" class="form-control" readonly>
                        </div>
                        <div class="col">
                            <label>Stock Disponible:</label>
                            <input type="number" id="stock_disponible" class="form-control" readonly>
                        </div>
                    </div>
                    <button type="submit" class="btn btn-primary">
                        <i class="fas fa-floppy-disk me-2"></i> Guardar Compra
                    </button>
                </form>
            </div>
        </div>
    </body>
</html>
