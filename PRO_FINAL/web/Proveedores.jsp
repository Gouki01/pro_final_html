<%@ page import="java.sql.*" %>
<%@ page import="modelo.Conexion" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Gestión de Proveedores</title>
    <!-- Enlace a Bootstrap 5 -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <div class="container my-4">
        <h1 class="text-center">Gestión de Proveedores</h1>

        <!-- Mensaje de confirmación -->
        <% 
            String mensaje = request.getParameter("mensaje");
            if (mensaje != null) { 
        %>
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <%= mensaje %>
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        <% } %>

        <!-- Instancia de la clase Conexion para obtener la conexión a la base de datos -->
        <%
            Conexion conexion = new Conexion();
            conexion.abrir_conexion();
            Connection conn = conexion.getConnection();
        %>

        <!-- Formulario para agregar o actualizar proveedor -->
        <h2 class="mt-4">Agregar o Actualizar Proveedor</h2>
        <form action="Proveedores.jsp" method="post" class="row g-3">
            <input type="hidden" name="action" value="<%= request.getParameter("action") != null && request.getParameter("action").equals("edit") ? "update" : "create" %>">
            <input type="hidden" name="id_proveedor" value="<%= request.getParameter("id_proveedor") != null ? request.getParameter("id_proveedor") : "" %>">

            <div class="col-md-6">
                <label class="form-label">Nombre del Proveedor:</label>
                <input type="text" name="proveedor" class="form-control" value="<%= request.getParameter("proveedor") != null ? request.getParameter("proveedor") : "" %>" required>
            </div>
            <div class="col-md-6">
                <label class="form-label">NIT:</label>
                <input type="text" name="nit" class="form-control" value="<%= request.getParameter("nit") != null ? request.getParameter("nit") : "" %>" required>
            </div>
            <div class="col-md-6">
                <label class="form-label">Teléfono:</label>
                <input type="text" name="telefono" class="form-control" value="<%= request.getParameter("telefono") != null ? request.getParameter("telefono") : "" %>" required>
            </div>
            <div class="col-md-6">
                <label class="form-label">Dirección:</label>
                <input type="text" name="direccion" class="form-control" value="<%= request.getParameter("direccion") != null ? request.getParameter("direccion") : "" %>" required>
            </div>
            <div class="col-12">
                <button type="submit" class="btn btn-primary">
                    <%= request.getParameter("action") != null && request.getParameter("action").equals("edit") ? "Actualizar" : "Agregar" %> Proveedor
                </button>
                <% if (request.getParameter("action") != null && request.getParameter("action").equals("edit")) { %>
                    <a href="Proveedores.jsp" class="btn btn-secondary">Cancelar</a>
                <% } %>
            </div>
        </form>

        <!-- Listado de proveedores -->
        <h2 class="mt-5">Listado de Proveedores</h2>
        <div class="table-responsive">
            <table class="table table-striped table-bordered">
                <thead class="table-dark">
                    <tr>
                        <th>ID</th>
                        <th>Proveedor</th>
                        <th>NIT</th>
                        <th>Teléfono</th>
                        <th>Dirección</th>
                        <th>Acciones</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        try {
                            String action = request.getParameter("action");

                            if ("create".equals(action)) {
                                // Código para crear proveedor
                                String proveedor = request.getParameter("proveedor");
                                String nit = request.getParameter("nit");
                                String telefono = request.getParameter("telefono");
                                String direccion = request.getParameter("direccion");

                                if (proveedor != null && nit != null && telefono != null && direccion != null) {
                                    String query = "INSERT INTO proveedores (proveedor, nit, telefono, direccion) VALUES (?, ?, ?, ?)";
                                    PreparedStatement stmt = conn.prepareStatement(query);
                                    stmt.setString(1, proveedor);
                                    stmt.setString(2, nit);
                                    stmt.setString(3, telefono);
                                    stmt.setString(4, direccion);
                                    stmt.executeUpdate();
                                    stmt.close();

                                    // Redirigir con mensaje de éxito
                                    response.sendRedirect("Proveedores.jsp?mensaje=Proveedor agregado exitosamente");
                                    return;
                                }
                            } else if ("update".equals(action)) {
                                // Código para actualizar proveedor
                                int idProveedor = Integer.parseInt(request.getParameter("id_proveedor"));
                                String proveedor = request.getParameter("proveedor");
                                String nit = request.getParameter("nit");
                                String telefono = request.getParameter("telefono");
                                String direccion = request.getParameter("direccion");

                                if (idProveedor > 0 && proveedor != null && nit != null && telefono != null && direccion != null) {
                                    String query = "UPDATE proveedores SET proveedor=?, nit=?, telefono=?, direccion=? WHERE id_proveedor=?";
                                    PreparedStatement stmt = conn.prepareStatement(query);
                                    stmt.setString(1, proveedor);
                                    stmt.setString(2, nit);
                                    stmt.setString(3, telefono);
                                    stmt.setString(4, direccion);
                                    stmt.setInt(5, idProveedor);
                                    stmt.executeUpdate();
                                    stmt.close();

                                    // Redirigir con mensaje de éxito
                                    response.sendRedirect("Proveedores.jsp?mensaje=Proveedor actualizado exitosamente");
                                    return;
                                }
                            } else if ("delete".equals(action)) {
                                // Código para eliminar proveedor
                                int idProveedor = Integer.parseInt(request.getParameter("id_proveedor"));
                                String query = "DELETE FROM proveedores WHERE id_proveedor = ?";
                                PreparedStatement stmt = conn.prepareStatement(query);
                                stmt.setInt(1, idProveedor);
                                stmt.executeUpdate();
                                stmt.close();

                                // Redirigir con mensaje de éxito (si se desea implementar)
                                response.sendRedirect("Proveedores.jsp?mensaje=Proveedor eliminado exitosamente");
                                return;
                            }

                            // Código para listar proveedores
                            String query = "SELECT * FROM proveedores";
                            PreparedStatement stmt = conn.prepareStatement(query);
                            ResultSet rs = stmt.executeQuery();
                            while (rs.next()) {
                    %>
                                <tr>
                                    <td><%= rs.getInt("id_proveedor") %></td>
                                    <td><%= rs.getString("proveedor") %></td>
                                    <td><%= rs.getString("nit") %></td>
                                    <td><%= rs.getString("telefono") %></td>
                                    <td><%= rs.getString("direccion") %></td>
                                    <td>
                                        <a href="Proveedores.jsp?action=edit&id_proveedor=<%= rs.getInt("id_proveedor") %>&proveedor=<%= rs.getString("proveedor") %>&nit=<%= rs.getString("nit") %>&telefono=<%= rs.getString("telefono") %>&direccion=<%= rs.getString("direccion") %>" class="btn btn-warning btn-sm">Editar</a>
                                        <a href="Proveedores.jsp?action=delete&id_proveedor=<%= rs.getInt("id_proveedor") %>" class="btn btn-danger btn-sm" onclick="return confirm('¿Estás seguro de que deseas eliminar este proveedor?');">Eliminar</a>
                                    </td>
                                </tr>
                    <%
                            }
                            rs.close();
                            stmt.close();
                        } catch (Exception e) {
                            e.printStackTrace();
                            out.println("<tr><td colspan='6' class='text-center text-danger'>Error al procesar la solicitud: " + e.getMessage() + "</td></tr>");
                        } finally {
                            conexion.cerrar_conexion();
                        }
                    %>
                </tbody>
            </table>
        </div>
    </div>

    <!-- Enlace al JavaScript de Bootstrap -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
