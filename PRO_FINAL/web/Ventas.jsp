<%-- 
    Document   : Ventas
    Created on : 29/10/2024, 11:48:28 p. m.
    Author     : Soporte_IT
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*" %>
<%@page import="modelo.Conexion" %>

<%
    String id_venta_str = request.getParameter("id");
    int id_venta = id_venta_str != null ? Integer.parseInt(id_venta_str) : 0; 
%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Carrito de Ventas</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <script>
        let cartItems = [];
        let totalGeneral = 0.0;

        function updatePrice() {
            var select = document.getElementById("id_producto");
            var selectedOption = select.options[select.selectedIndex];
            var price = selectedOption.getAttribute("data-precio");
            var stock = selectedOption.getAttribute("data-stock");
            document.getElementById("precio_unitario").value = price;
            document.getElementById("cantidad").max = stock; 
        }

        function addToCart() {
            var productoSelect = document.getElementById("id_producto");
            var producto = productoSelect.options[productoSelect.selectedIndex].text;
            var productoID = productoSelect.value;
            var cantidad = parseInt(document.getElementById("cantidad").value);
            var precio = parseFloat(document.getElementById("precio_unitario").value);

            if (cantidad <= 0 || isNaN(precio) || precio <= 0) {
                alert("Ingrese una cantidad válida y seleccione un producto con precio.");
                return;
            }

            let subtotal = cantidad * precio;
            totalGeneral += subtotal;
            document.getElementById("totalGeneral").innerText = totalGeneral.toFixed(2);

            cartItems.push({ id: productoID, nombre: producto, cantidad, precio, subtotal });
            renderCartTable();
        }

        function renderCartTable() {
            var tableBody = document.getElementById("cartTable");
            tableBody.innerHTML = ""; // Limpiar tabla antes de renderizar

            cartItems.forEach(item => {
                let row = document.createElement("tr");

                let idCell = document.createElement("td");
                idCell.innerText = item.id;
                row.appendChild(idCell);

                let nameCell = document.createElement("td");
                nameCell.innerText = item.nombre;
                row.appendChild(nameCell);

                let quantityCell = document.createElement("td");
                quantityCell.innerText = item.cantidad;
                row.appendChild(quantityCell);

                let priceCell = document.createElement("td");
                priceCell.innerText = "Q " + item.precio.toFixed(2);
                row.appendChild(priceCell);

                let subtotalCell = document.createElement("td");
                subtotalCell.innerText = "Q " + item.subtotal.toFixed(2);
                row.appendChild(subtotalCell);

                tableBody.appendChild(row);
            });
        }

        function cancelarVenta() {
            cartItems = [];
            totalGeneral = 0.0;
            document.getElementById("totalGeneral").innerText = totalGeneral.toFixed(2);
            renderCartTable();
        }

        function addCartItemsToForm() {
            // Asignar el valor del total general al campo oculto antes de enviar el formulario
            document.getElementById("precio_total").value = totalGeneral.toFixed(2);
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
        .form-container, .product-container {
            border: 3px solid #0d6efd;
            padding: 20px;
            border-radius: 8px;
            margin-bottom: 20px;
        }
        .out-of-stock {
            color: red;
            font-weight: bold;
        }
        .cart-table {
            max-height: 300px;
            overflow-y: auto;
            border: 1px solid #ddd;
            padding: 5px;
            margin-bottom: 20px;
        }
        .table-container {
            margin-top: 20px;
        }
        .gear-icon {
            position: fixed;
            top: 20px;
            right: 20px;
            background-color: #6c757d;
            color: white;
            border-radius: 50%;
            width: 50px;
            height: 50px;
            display: flex;
            align-items: center;
            justify-content: center;
        }
    </style>
</head>
<body>
    <div class="container my-5">
        <div class="text-end mt-4">
            <a href="HistorialVentas.jsp" class="btn btn-secondary">
                <i class="fas fa-history me-2"></i> Ver Historial de Ventas
            </a>
        </div>
        
        <!-- Botón de Opciones con Icono de Engranaje -->
        <a href="login.jsp" class="gear-icon">
            <i class="fas fa-cog"></i>
        </a>

        <h3>Formulario de Venta</h3>

        <!-- Contenedor de Información General -->
        <div class="form-container">
            <form id="ventasForm" action="${pageContext.request.contextPath}/VentasServlet" method="post" onsubmit="return addCartItemsToForm()">
                <input type="hidden" id="precio_total" name="precio_total" value="0.00"> <!-- Campo oculto para el total general -->
                <div class="row mb-3">
                    <div class="col">
                        <label>Número de Factura:</label>
                        <input type="text" name="no_factura" class="form-control" placeholder="Número de Factura" required>
                    </div>
                    <div class="col">
                        <label>Serie:</label>
                        <input type="text" name="serie" class="form-control" placeholder="Serie" required>
                    </div>
                    <div class="col">
                        <label>Fecha de Factura:</label>
                        <input type="datetime-local" name="fecha_factura" class="form-control" required>
                    </div>
                </div>
                <div class="row mb-3">
                    <div class="col">
                        <label>Cliente:</label>
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
                    </div>
                    <div class="col">
                        <label>Empleado:</label>
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
                    </div>
                    <div class="col">
                        <label>Fecha de Ingreso:</label>
                        <input type="datetime-local" name="fecha_ingreso" class="form-control" required>
                    </div>
                </div>
        </div>

        <!-- Contenedor de Productos y Botones -->
        <div class="product-container">
            <div class="row mb-3">
                <div class="col">
                    <label>Producto:</label>
                    <select id="id_producto" name="id_producto" class="form-control" onchange="updatePrice()" required>
                        <% 
                            if (conexionBD != null) {
                                String productQuery = "SELECT id_producto, producto, precio_venta, existencia FROM productos"; 
                                Statement productStmt = conexionBD.createStatement();
                                ResultSet productRs = productStmt.executeQuery(productQuery);

                                while (productRs.next()) {
                                    int existencia = productRs.getInt("existencia");
                                    String styleClass = existencia == 0 ? "out-of-stock" : "";
                        %>
                        <option value="<%= productRs.getInt("id_producto") %>" data-precio="<%= productRs.getDouble("precio_venta") %>" data-stock="<%= existencia %>" class="<%= styleClass %>">
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
                <div class="col">
                    <label>Cantidad:</label>
                    <input type="number" id="cantidad" name="cantidad" class="form-control" placeholder="Cantidad" required>
                </div>
                <div class="col">
                    <label>Precio Unitario:</label>
                    <input type="number" id="precio_unitario" name="precio_unitario" class="form-control" placeholder="Precio Unitario" readonly>
                </div>
            </div>
            <div class="d-flex justify-content-end">
                <button type="button" class="btn btn-primary me-2" onclick="addToCart()">
                    <i class="fas fa-cart-plus me-2"></i> Agregar Producto
                </button>
                <button type="submit" class="btn btn-success me-2">
                    <i class="fas fa-floppy-disk me-2"></i> Guardar Venta
                </button>
                <button type="button" class="btn btn-danger" onclick="cancelarVenta()">
                    <i class="fas fa-times-circle me-2"></i> Cancelar Venta
                </button>
            </div>
            <div class="text-end mt-3">
                <h5>Total General: <span id="totalGeneral">0.00</span></h5>
            </div>
        </div>
    </form>

    <!-- Tabla del carrito -->
    <h4>Carrito de Productos</h4>
    <div class="cart-table">
        <table class="table table-striped table-bordered text-center">
            <thead class="custom-header">
                <tr>
                    <th>ID</th>
                    <th>Producto</th>
                    <th>Cantidad</th>
                    <th>Precio</th>
                    <th>Subtotal</th>
                </tr>
            </thead>
            <tbody id="cartTable"></tbody>
        </table>
    </div>
</div>
</body>
</html>
