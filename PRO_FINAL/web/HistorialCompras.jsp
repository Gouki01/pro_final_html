<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*" %>
<%@page import="modelo.Conexion" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Historial de Compras</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
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
        <h3>Historial de Compras</h3>

        <!-- Formulario de búsqueda por rango de fechas -->
        <form method="get" action="HistorialCompras.jsp" class="mb-4">
            <div class="row">
                <div class="col-md-4">
                    <label>Fecha de inicio:</label>
                    <input type="date" name="fecha_inicio" class="form-control">
                </div>
                <div class="col-md-4">
                    <label>Fecha de fin:</label>
                    <input type="date" name="fecha_fin" class="form-control">
                </div>
                <div class="col-md-4 d-flex align-items-end">
                    <button type="submit" class="btn btn-primary">Buscar</button>
                </div>
            </div>
        </form>

        <table class="table table-striped table-bordered text-center">
            <thead class="custom-header">
                <tr>
                    <th>ID Compra</th>
                    <th>Número de Orden</th>
                    <th>ID Proveedor</th>
                    <th>Fecha de Orden</th>
                    <th>Fecha de Ingreso</th>
                    <th>Precio Total</th>
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
                    StringBuilder sql = new StringBuilder("SELECT * FROM compras");
                    if (fechaInicio != null && fechaFin != null && !fechaInicio.isEmpty() && !fechaFin.isEmpty()) {
                        sql.append(" WHERE fecha_orden BETWEEN '").append(fechaInicio).append("' AND '").append(fechaFin).append("'");
                    }
                    sql.append(" LIMIT ").append(start).append(", ").append(recordsPerPage);

                    // Obtener el total de registros para la paginación
                    int totalRecords = 0;
                    try (Statement countStmt = conexionBD.createStatement()) {
                        String countQuery = "SELECT COUNT(*) FROM compras";
                        if (fechaInicio != null && fechaFin != null && !fechaInicio.isEmpty() && !fechaFin.isEmpty()) {
                            countQuery += " WHERE fecha_orden BETWEEN '" + fechaInicio + "' AND '" + fechaFin + "'";
                        }
                        ResultSet countRs = countStmt.executeQuery(countQuery);
                        if (countRs.next()) {
                            totalRecords = countRs.getInt(1);
                        }
                    }

                    // Ejecutar la consulta principal
                    try (Statement stmt = conexionBD.createStatement(); ResultSet rs = stmt.executeQuery(sql.toString())) {
                        while (rs.next()) {
                %>
                <tr>
                    <td><%= rs.getInt("id_compra") %></td>
                    <td><%= rs.getInt("no_orden_compra") %></td>
                    <td><%= rs.getInt("id_proveedor") %></td>
                    <td><%= rs.getDate("fecha_orden") %></td>
                    <td><%= rs.getTimestamp("fecha_ingreso") %></td>
                    <td>Q <%= rs.getDouble("precio_total") %></td>
                </tr>
                <% 
                        }
                    } catch (SQLException e) {
                        out.println("<tr><td colspan='6'>Error al cargar el historial de compras.</td></tr>");
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
                    <a class="page-link" href="HistorialCompras.jsp?page=<%= i %>&fecha_inicio=<%= fechaInicio %>&fecha_fin=<%= fechaFin %>"><%= i %></a>
                </li>
            <% } %>
        </ul>

        <div class="text-end mt-3">
            <a href="Compras.jsp" class="btn btn-primary">
                <i class="fas fa-arrow-left me-2"></i> Regresar a Compras
            </a>
        </div>
    </div>
</body>
</html>
