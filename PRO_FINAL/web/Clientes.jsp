<%@ page import="java.sql.*" %>
<%@ page import="modelo.Conexion" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Gestión de Clientes</title>
    <!-- Enlace a Bootstrap 5 -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <div class="container my-4">
        <h1 class="text-center">Gestión de Clientes</h1>

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

        <!-- Formulario para agregar o actualizar cliente -->
        <h2 class="mt-4">Agregar o Actualizar Cliente</h2>
        <form action="Clientes.jsp" method="post" class="row g-3">
            <input type="hidden" name="action" value="<%= request.getParameter("action") != null && request.getParameter("action").equals("edit") ? "update" : "create" %>">
            <input type="hidden" name="id_cliente" value="<%= request.getParameter("id_cliente") != null ? request.getParameter("id_cliente") : "" %>">

            <div class="col-md-6">
                <label class="form-label">Nombres:</label>
                <input type="text" name="nombres" class="form-control" value="<%= request.getParameter("nombres") != null ? request.getParameter("nombres") : "" %>" required>
            </div>
            <div class="col-md-6">
                <label class="form-label">Apellidos:</label>
                <input type="text" name="apellidos" class="form-control" value="<%= request.getParameter("apellidos") != null ? request.getParameter("apellidos") : "" %>" required>
            </div>
            <div class="col-md-4">
                <label class="form-label">NIT:</label>
                <input type="text" name="nit" class="form-control" value="<%= request.getParameter("nit") != null ? request.getParameter("nit") : "" %>" required>
            </div>
            <div class="col-md-4">
                <label class="form-label">Género:</label>
                <select name="genero" class="form-control" required>
                    <option value="1" <%= "1".equals(request.getParameter("genero")) ? "selected" : "" %>>Masculino</option>
                    <option value="0" <%= "0".equals(request.getParameter("genero")) ? "selected" : "" %>>Femenino</option>
                </select>
            </div>
            <div class="col-md-4">
                <label class="form-label">Teléfono:</label>
                <input type="text" name="telefono" class="form-control" value="<%= request.getParameter("telefono") != null ? request.getParameter("telefono") : "" %>" required>
            </div>
            <div class="col-md-6">
                <label class="form-label">Correo Electrónico:</label>
                <input type="email" name="correo" class="form-control" value="<%= request.getParameter("correo") != null ? request.getParameter("correo") : "" %>" required>
            </div>
            <div class="col-12">
                <button type="submit" class="btn btn-primary">
                    <%= request.getParameter("action") != null && request.getParameter("action").equals("edit") ? "Actualizar" : "Agregar" %> Cliente
                </button>
                <% if (request.getParameter("action") != null && request.getParameter("action").equals("edit")) { %>
                    <a href="Clientes.jsp" class="btn btn-secondary">Cancelar</a>
                <% } %>
            </div>
        </form>

        <!-- Listado de clientes -->
        <h2 class="mt-5">Listado de Clientes</h2>
        <div class="table-responsive">
            <table class="table table-striped table-bordered">
                <thead class="table-dark">
                    <tr>
                        <th>ID</th>
                        <th>Nombres</th>
                        <th>Apellidos</th>
                        <th>NIT</th>
                        <th>Género</th>
                        <th>Teléfono</th>
                        <th>Correo Electrónico</th>
                        <th>Fecha de Ingreso</th>
                        <th>Acciones</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        Conexion conexion = new Conexion();
                        Connection conn = conexion.getConnection();

                        try {
                            String action = request.getParameter("action");

                            if ("create".equals(action)) {
                                // Código para crear cliente
                                String nombres = request.getParameter("nombres");
                                String apellidos = request.getParameter("apellidos");
                                String nit = request.getParameter("nit");
                                String genero = request.getParameter("genero");
                                String telefono = request.getParameter("telefono");
                                String correo = request.getParameter("correo");

                                if (nombres != null && apellidos != null && nit != null && genero != null && telefono != null && correo != null) {
                                    String query = "INSERT INTO clientes (nombres, apellidos, nit, genero, telefono, correo_electronico, fecha_ingreso) VALUES (?, ?, ?, ?, ?, ?, NOW())";
                                    PreparedStatement stmt = conn.prepareStatement(query);
                                    stmt.setString(1, nombres);
                                    stmt.setString(2, apellidos);
                                    stmt.setString(3, nit);
                                    stmt.setBoolean(4, "1".equals(genero));
                                    stmt.setString(5, telefono);
                                    stmt.setString(6, correo);
                                    stmt.executeUpdate();
                                    stmt.close();

                                    // Redirigir con mensaje de éxito
                                    response.sendRedirect("Clientes.jsp?mensaje=Cliente agregado exitosamente");
                                    return;
                                }
                            } else if ("update".equals(action)) {
                                // Código para actualizar cliente
                                int idCliente = Integer.parseInt(request.getParameter("id_cliente"));
                                String nombres = request.getParameter("nombres");
                                String apellidos = request.getParameter("apellidos");
                                String nit = request.getParameter("nit");
                                String genero = request.getParameter("genero");
                                String telefono = request.getParameter("telefono");
                                String correo = request.getParameter("correo");

                                if (idCliente > 0 && nombres != null && apellidos != null && nit != null && genero != null && telefono != null && correo != null) {
                                    String query = "UPDATE clientes SET nombres=?, apellidos=?, nit=?, genero=?, telefono=?, correo_electronico=? WHERE id_cliente=?";
                                    PreparedStatement stmt = conn.prepareStatement(query);
                                    stmt.setString(1, nombres);
                                    stmt.setString(2, apellidos);
                                    stmt.setString(3, nit);
                                    stmt.setBoolean(4, "1".equals(genero));
                                    stmt.setString(5, telefono);
                                    stmt.setString(6, correo);
                                    stmt.setInt(7, idCliente);
                                    stmt.executeUpdate();
                                    stmt.close();

                                    // Redirigir con mensaje de éxito
                                    response.sendRedirect("Clientes.jsp?mensaje=Cliente actualizado exitosamente");
                                    return;
                                }
                            } else if ("delete".equals(action)) {
                                // Código para eliminar cliente
                                int idCliente = Integer.parseInt(request.getParameter("id_cliente"));
                                String query = "DELETE FROM clientes WHERE id_cliente = ?";
                                PreparedStatement stmt = conn.prepareStatement(query);
                                stmt.setInt(1, idCliente);
                                stmt.executeUpdate();
                                stmt.close();

                                // Redirigir con mensaje de éxito
                                response.sendRedirect("Clientes.jsp?mensaje=Cliente eliminado exitosamente");
                                return;
                            }

                            // Código para listar clientes
                            String query = "SELECT * FROM clientes";
                            PreparedStatement stmt = conn.prepareStatement(query);
                            ResultSet rs = stmt.executeQuery();
                            while (rs.next()) {
                    %>
                                <tr>
                                    <td><%= rs.getInt("id_cliente") %></td>
                                    <td><%= rs.getString("nombres") %></td>
                                    <td><%= rs.getString("apellidos") %></td>
                                    <td><%= rs.getString("nit") %></td>
                                    <td><%= rs.getBoolean("genero") ? "Masculino" : "Femenino" %></td>
                                    <td><%= rs.getString("telefono") %></td>
                                    <td><%= rs.getString("correo_electronico") %></td>
                                    <td><%= rs.getTimestamp("fecha_ingreso") %></td>
                                    <td>
                                        <a href="Clientes.jsp?action=edit&id_cliente=<%= rs.getInt("id_cliente") %>&nombres=<%= rs.getString("nombres") %>&apellidos=<%= rs.getString("apellidos") %>&nit=<%= rs.getString("nit") %>&genero=<%= rs.getBoolean("genero") %>&telefono=<%= rs.getString("telefono") %>&correo=<%= rs.getString("correo_electronico") %>" class="btn btn-warning btn-sm">Editar</a>
                                        <a href="Clientes.jsp?action=delete&id_cliente=<%= rs.getInt("id_cliente") %>" class="btn btn-danger btn-sm" onclick="return confirm('¿Estás seguro de que deseas eliminar este cliente?');">Eliminar</a>
                                    </td>
                                </tr>
                    <%
                            }
                            rs.close();
                            stmt.close();
                        } catch (Exception e) {
                            e.printStackTrace();
                            out.println("<tr><td colspan='9' class='text-center text-danger'>Error al conectar con la base de datos.</td></tr>");
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
