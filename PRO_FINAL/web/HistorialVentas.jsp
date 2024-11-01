<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*" %>
<%@page import="modelo.Conexion" %>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Historial de Ventas</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
        <style>
            .custom-header th {
                background-color: #007bff; 
                color: #ffffff; 
            }
            .container {
                margin: 20px auto;
                max-width: 90%;
            }
            .pagination {
                display: flex;
                justify-content: center;
                list-style: none;
                padding: 0;
            }
            .pagination li {
                margin: 0 5px;
            }
        </style>
    </head>
    <body>
        <div class="container">
            <h3>Historial de Ventas</h3>

            <!-- Formulario de búsqueda por rango de fechas -->
            <form method="get" action="HistorialVentas.jsp" class="mb-4">
                <div class="row">
                    <div class="col-md-4">
                        <label>Fecha de inicio:</label>
                        <input type="date" name="fecha_inicio" class="form-control" value="<%= request.getParameter("fecha_inicio") != null ? request.getParameter("fecha_inicio") : "" %>">
                    </div>
                    <div class="col-md-4">
                        <label>Fecha de fin:</label>
                        <input type="date" name="fecha_fin" class="form-control" value="<%= request.getParameter("fecha_fin") != null ? request.getParameter("fecha_fin") : "" %>">
                    </div>
                    <div class="col-md-4 d-flex align-items-end">
                        <button type="submit" class="btn btn-primary">Buscar</button>
                    </div>
                </div>
            </form>

            <table class="table table-striped table-bordered text-center">
                <thead class="custom-header">
                    <tr>
                        <th>ID Venta</th>
                        <th>Número de Factura</th>
                        <th>Serie</th>
                        <th>Fecha de Factura</th>
                        <th>ID Cliente</th>
                        <th>ID Empleado</th>
                        <th>Total</th>
                    </tr>
                </thead>
                <tbody>
                    <% 
                        Conexion conn = new Conexion();
                        Connection conexionBD = conn.getConnection();

                        // Parámetros de paginación
                        int currentPage = 1;
                        int recordsPerPage = 10;
                        if (request.getParameter("page") != null) {
                            currentPage = Integer.parseInt(request.getParameter("page"));
                        }
                        int start = (currentPage - 1) * recordsPerPage;

                        // Parámetros de búsqueda por fecha
                        String fechaInicio = request.getParameter("fecha_inicio");
                        String fechaFin = request.getParameter("fecha_fin");

                        // Construir la consulta SQL
                        StringBuilder sql = new StringBuilder("SELECT * FROM ventas");
                        StringBuilder countSql = new StringBuilder("SELECT COUNT(*) FROM ventas");
                        boolean hasDateFilter = (fechaInicio != null && !fechaInicio.isEmpty()) && (fechaFin != null && !fechaFin.isEmpty());

                        if (hasDateFilter) {
                            sql.append(" WHERE fecha_factura BETWEEN '").append(fechaInicio).append("' AND '").append(fechaFin).append("'");
                            countSql.append(" WHERE fecha_factura BETWEEN '").append(fechaInicio).append("' AND '").append(fechaFin).append("'");
                        }

                        sql.append(" LIMIT ").append(start).append(", ").append(recordsPerPage);

                        // Obtener el total de registros considerando el filtro de fechas
                        int totalRecords = 0;
                        try (Statement countStmt = conexionBD.createStatement()) {
                            ResultSet countRs = countStmt.executeQuery(countSql.toString());
                            if (countRs.next()) {
                                totalRecords = countRs.getInt(1);
                            }
                        }

                        // Ejecutar la consulta principal
                        try (Statement salesStmt = conexionBD.createStatement(); ResultSet salesRs = salesStmt.executeQuery(sql.toString())) {
                            while (salesRs.next()) {
                    %>
                    <tr>
                        <td><%= salesRs.getInt("id_venta") %></td>
                        <td><%= salesRs.getInt("no_factura") %></td>
                        <td><%= salesRs.getString("serie") %></td>
                        <td><%= salesRs.getTimestamp("fecha_factura") %></td>
                        <td><%= salesRs.getInt("id_cliente") %></td>
                        <td><%= salesRs.getInt("id_empleado") %></td>
                        <td><%= salesRs.getDouble("precio_total") %></td>
                    </tr>
                    <% 
                            }
                        } catch (SQLException e) {
                            out.println("<tr><td colspan='7'>Error al cargar el historial de ventas.</td></tr>");
                            e.printStackTrace();
                        }
                    %>
                </tbody>
            </table>

            <!-- Paginación -->
            <ul class="pagination">
                <% 
                    int totalPages = (int) Math.ceil(totalRecords * 1.0 / recordsPerPage);
                    for (int i = 1; i <= totalPages; i++) { 
                %>
                    <li class="page-item <%= (i == currentPage) ? "active" : "" %>">
                        <a class="page-link" href="HistorialVentas.jsp?page=<%= i %><%= (hasDateFilter ? "&fecha_inicio=" + fechaInicio + "&fecha_fin=" + fechaFin : "") %>"><%= i %></a>
                    </li>
                <% } %>
            </ul>

            <div class="text-end mt-3">
                <a href="Ventas.jsp" class="btn btn-primary">
                    <i class="fas fa-arrow-left me-2"></i> Regresar a Ventas
                </a>
            </div>
        </div>
    </body>
</html>
