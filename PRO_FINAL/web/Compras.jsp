<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*" %>
<%@page import="modelo.Conexion" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Carrito de Compras</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <script>
        let cartItems = [];
        let totalGeneral = 0.0;

        function updatePriceAndStock() {
            var select = document.getElementById("id_producto");
            var selectedOption = select.options[select.selectedIndex];
            var price = selectedOption.getAttribute("data-precio");
            var stock = selectedOption.getAttribute("data-stock");

            document.getElementById("precio_costo_unitario").value = price;
            document.getElementById("stock_disponible").value = stock;
        }

        function addToCart() {
            var productoSelect = document.getElementById("id_producto");
            var producto = productoSelect.options[productoSelect.selectedIndex].text;
            var productoID = productoSelect.value;
            var cantidad = parseInt(document.getElementById("cantidad").value);
            var precio = parseFloat(document.getElementById("precio_costo_unitario").value);

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
            tableBody.innerHTML = ""; 

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

        function cancelarCompra() {
            cartItems = [];
            totalGeneral = 0.0;
            document.getElementById("totalGeneral").innerText = totalGeneral.toFixed(2);
            renderCartTable();
        }

        function addCartItemsToForm() {
            var form = document.getElementById("comprasForm");
            document.querySelectorAll(".productField").forEach(el => el.remove());

            cartItems.forEach((item, index) => {
                let idField = document.createElement("input");
                idField.type = "hidden";
                idField.name = `id_producto[${index}]`;
                idField.value = item.id;
                idField.classList.add("productField");
                form.appendChild(idField);

                let cantidadField = document.createElement("input");
                cantidadField.type = "hidden";
                cantidadField.name = `cantidad[${index}]`;
                cantidadField.value = item.cantidad;
                cantidadField.classList.add("productField");
                form.appendChild(cantidadField);

                let precioField = document.createElement("input");
                precioField.type = "hidden";
                precioField.name = `precio_costo_unitario[${index}]`;
                precioField.value = item.precio;
                precioField.classList.add("productField");
                form.appendChild(precioField);
            });

            let totalField = document.createElement("input");
            totalField.type = "hidden";
            totalField.name = "totalGeneral";
            totalField.value = totalGeneral.toFixed(2);
            totalField.classList.add("productField");
            form.appendChild(totalField);

            return true;
        }
    </script>
    <style>
        .custom-header th {
            background-color: #007bff; 
            color: #ffffff; 
        }
        .form-container, .product-container {
            border: 3px solid #0d6efd;
            padding: 20px;
            border-radius: 8px;
            margin-bottom: 20px;
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
    </style>
</head>
<body>
    <div class="container my-5">
        <div class="text-end mt-4">
            <a href="HistorialCompras.jsp" class="btn btn-secondary">
                <i class="fas fa-history me-2"></i> Ver Historial de Compras
            </a>
        </div>
        
        <h3>Formulario de Compra</h3>
        
        <!-- Contenedor 1 -->
        <div class="form-container">
            <form id="comprasForm" action="${pageContext.request.contextPath}/ComprasServlet" method="post" onsubmit="return addCartItemsToForm()">
                <div class="row mb-3">
                    <div class="col">
                        <label>Número de Orden de Compra:</label>
                        <input type="text" name="no_orden_compra" class="form-control" required>
                    </div>
                    <div class="col">
                        <label>Fecha Orden:</label>
                        <input type="datetime-local" name="fecha_orden" class="form-control" required>
                    </div>
                    <div class="col">
                        <label>Fecha Ingreso:</label>
                        <input type="datetime-local" name="fecha_ingreso" class="form-control" required>
                    </div>
                </div>
        </div>

        <!-- Contenedor 2 -->
        <div class="product-container">
            <div class="row mb-3">
                <div class="col">
                    <label>Proveedor:</label>
                    <select name="id_proveedor" class="form-control" required>
                        <% 
                            Conexion conn = new Conexion();
                            Connection conexionBD = conn.getConnection();
                            if (conexionBD != null) {
                                String providerQuery = "SELECT id_proveedor, proveedor FROM proveedores"; 
                                Statement providerStmt = conexionBD.createStatement();
                                ResultSet providerRs = providerStmt.executeQuery(providerQuery);

                                while (providerRs.next()) {
                        %>
                        <option value="<%= providerRs.getInt("id_proveedor") %>"><%= providerRs.getString("proveedor") %></option> 
                        <% 
                                }
                                providerRs.close();
                                providerStmt.close();
                            } else {
                                out.println("<option disabled>No se pudo cargar proveedores</option>"); 
                            }
                        %>
                    </select>
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
                        <option value="<%= productRs.getInt("id_producto") %>" data-precio="<%= productRs.getDouble("precio_costo") %>" data-stock="<%= productRs.getInt("existencia") %>">
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

            <div class="row">
                <div class="col">
                    <h5>Total General: <span id="totalGeneral">0.00</span></h5>
                </div>
                <div class="col d-flex justify-content-end">
                    <button type="button" class="btn btn-primary me-2" onclick="addToCart()">
                        <i class="fas fa-cart-plus me-2"></i> Agregar Producto
                    </button>
                    <button type="submit" class="btn btn-success me-2">
                        <i class="fas fa-floppy-disk me-2"></i> Guardar Compra
                    </button>
                    <button type="button" class="btn btn-danger" onclick="cancelarCompra()">
                        <i class="fas fa-times-circle me-2"></i> Cancelar Compra
                    </button>
                </div>
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
