<%@page import="java.util.List"%>
<%@page import="modelo.Puesto"%>
<%@page import="modelo.PuestoDAO"%>
<%
    PuestoDAO puestoDAO = new PuestoDAO();
    List<Puesto> puestos = puestoDAO.listar();
    Puesto puestoSeleccionado = (Puesto) request.getAttribute("puestoSeleccionado");
%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
        <title>Gestión de Puestos</title>
    </head>
    <body>
        <div class="card">
            <div class="card-body">
               <form action="PuestoControlador" method="post">
                <!-- Campo oculto para el ID del puesto si ha sido seleccionado -->
                <input type="hidden" name="id" value="<%= puestoSeleccionado != null ? puestoSeleccionado.getId_puesto(): "" %>">
                
                <div class="row">
                    <div class="col-md-6">
                        <div class="form-group">
                            <label>Puesto</label>
                            <input type="text" name="txtpuesto" class="form-control" value="<%= puestoSeleccionado != null ? puestoSeleccionado.getPuesto(): "" %>">
                        </div>
                        <div class="d-flex gap-2 mt-4">
                            <!-- Botones de acción -->
                            <button type="submit" class="btn <%= puestoSeleccionado != null ? "btn-primary" : "btn-success" %>" name="accion" value="<%= puestoSeleccionado != null ? "Actualizar" : "Agregar" %>">
                                <%= puestoSeleccionado != null ? "Actualizar" : "Agregar" %>
                            </button>
                            <button type="submit" class="btn btn-danger" name="accion" value="Eliminar">Eliminar</button>
                            <!-- Botón de cancelar selección -->
                            <a href="Puestos.jsp" class="btn btn-secondary">Cancelar</a>
                        </div>
                    </div>
                </div>
            </form>
            </div>
            <div>
                <table class="table table-secondary">
                    <thead>
                        <tr>
                            <th scope="col">ID</th>
                            <th scope="col">Puesto</th>
                            <th scope="col">Seleccionar</th>
                        </tr>
                    </thead>
                    <tbody>
                    <%
                        for (Puesto puesto : puestos) {
                    %>
                    <tr class="table-primary">
                        <td><%= puesto.getId_puesto() %></td>
                        <td><%= puesto.getPuesto() %></td>
                        <td>
                            <a href="PuestoControlador?accion=Seleccionar&id=<%= puesto.getId_puesto() %>" class="btn btn-info">Seleccionar</a>
                        </td>
                    </tr>
                        <%
                            }
                        %>
                    </tbody>
                </table>
            </div>
        </div>
    </body>
</html>
