<%@page import="modelo.PuestoDAO"%>
<%@page import="java.util.List"%>
<%@page import="modelo.Empleado"%>
<%@page import="modelo.EmpleadoDAO"%>
<%@page import="modelo.Puesto"%>

<%
    EmpleadoDAO empleadoDAO = new EmpleadoDAO();
    List<Empleado> empleados = empleadoDAO.listar();
    Empleado empleadoSeleccionado = (Empleado) request.getAttribute("empleadoSeleccionado");

    // Obtener la lista de puestos
    PuestoDAO puestoDAO = new PuestoDAO();
    List<Puesto> puestos = puestoDAO.listar();
%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
        <title>Gestión de Empleados</title>
    </head>
    <body>
        <div class="card">
            <div class="card-body">
               <form action="EmpleadoControlador" method="post">
                <!-- Campo oculto que contiene el ID del empleado si ha sido seleccionado -->
                <input type="hidden" name="id" value="<%= empleadoSeleccionado != null ? empleadoSeleccionado.getId() : "" %>">
                
                <div class="row">
                    <div class="col-md-6">
                        <div class="form-group">
                            <label>Nombres</label>
                            <input type="text" name="txtnombres" class="form-control" value="<%= empleadoSeleccionado != null ? empleadoSeleccionado.getNombres() : "" %>">
                        </div>
                        <div class="form-group">
                            <label>Apellidos</label>
                            <input type="text" name="txtapellidos" class="form-control" value="<%= empleadoSeleccionado != null ? empleadoSeleccionado.getApellidos() : "" %>">
                        </div>
                        <div class="form-group">
                            <label>Direccion</label>
                            <input type="text" name="txtdireccion" class="form-control" value="<%= empleadoSeleccionado != null ? empleadoSeleccionado.getDireccion() : "" %>">
                        </div>
                        <div class="form-group">
                            <label>Telefono</label>
                            <input type="text" name="txttelefono" class="form-control" value="<%= empleadoSeleccionado != null ? empleadoSeleccionado.getTelefono() : "" %>">
                        </div>
                        <div class="form-group">
                            <label>DPI</label>
                            <input type="text" name="txtdpi" class="form-control" value="<%= empleadoSeleccionado != null ? empleadoSeleccionado.getDpi() : "" %>">
                        </div>
                        <div class="form-group">
                            <label>Genero</label>
                            <div class="form-group">
                                <select name="txtgenero" class="form-control">
                                    <option value="1" <%= (empleadoSeleccionado != null && empleadoSeleccionado.getGenero() == 1) ? "selected" : "" %>>Masculino</option>
                                    <option value="0" <%= (empleadoSeleccionado != null && empleadoSeleccionado.getGenero() == 0) ? "selected" : "" %>>Femenino</option>
                                </select>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="form-group">
                            <label>Fecha de Nacimiento</label>
                            <input type="text" name="txtnacimiento" class="form-control" value="<%= empleadoSeleccionado != null ? empleadoSeleccionado.getFecha_nacimiento() : "" %>">
                        </div>
                        <div class="form-group">
                            <label>Puesto</label>
                            <select name="txtpuesto" class="form-control">
                                <option value="">Seleccione un puesto</option>
                                <% for (Puesto puesto : puestos) { %>
                                    <option value="<%= puesto.getId_puesto() %>"
                                        <%= (empleadoSeleccionado != null && empleadoSeleccionado.getIdpuesto() == puesto.getId_puesto()) ? "selected" : "" %>>
                                        <%= puesto.getPuesto() %>
                                    </option>
                                <% } %>
                            </select>
                        </div>
                        <div class="form-group">
                            <label>Fecha de inicio laboral</label>
                            <input type="text" name="txtinicio" class="form-control" value="<%= empleadoSeleccionado != null ? empleadoSeleccionado.getFecha_inicio_labores() : "" %>">
                        </div>
                        <div class="form-group">
                            <label>Fecha de ingreso</label>
                            <input type="text" name="txtingreso" class="form-control" value="<%= empleadoSeleccionado != null ? empleadoSeleccionado.getFecha_ingreso() : "" %>">
                        </div>
                        <div class="form-group">
                            <label>Usuario</label>
                            <input type="text" name="txtusuario" class="form-control" value="<%= empleadoSeleccionado != null ? empleadoSeleccionado.getUsuario() : "" %>">
                        </div>
                        <div class="d-flex gap-2 mt-4">
                            <!-- Botones de acción -->
                            <button type="submit" class="btn <%= empleadoSeleccionado != null ? "btn-primary" : "btn-success" %>" name="accion" value="<%= empleadoSeleccionado != null ? "Actualizar" : "Agregar" %>">
                                <%= empleadoSeleccionado != null ? "Actualizar" : "Agregar" %>
                            </button>
                            <button type="submit" class="btn btn-danger" name="accion" value="Eliminar">Eliminar</button>
                            <!-- Botón de cancelar selección -->
                            <a href="Empleados.jsp" class="btn btn-secondary">Cancelar</a>
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
                            <th scope="col">Nombres</th>
                            <th scope="col">Apellidos</th>
                            <th scope="col">Direccion</th>
                            <th scope="col">Telefono</th>
                            <th scope="col">DPI</th>
                            <th scope="col">Genero</th>
                            <th scope="col">Fecha Nacimiento</th>
                            <th scope="col">Puesto</th>
                            <th scope="col">Fecha Inicio</th>
                            <th scope="col">Fecha Ingreso</th>
                            <th scope="col">Usuario</th>
                            <th scope="col">Seleccion</th>
                        </tr>
                    </thead>
                    <tbody>
                    <%
                        for (Empleado empleado : empleados) {
                    %>
                    <tr class="table-primary">
                        <td><%= empleado.getId() %></td>
                        <td><%= empleado.getNombres() %></td>
                        <td><%= empleado.getApellidos() %></td>
                        <td><%= empleado.getDireccion() %></td>
                        <td><%= empleado.getTelefono() %></td>
                        <td><%= empleado.getDpi() %></td>
                        <td><%= empleado.getGenero() %></td>
                        <td><%= empleado.getFecha_nacimiento() %></td>
                        <td><%= empleado.getIdpuesto() %></td>
                        <td><%= empleado.getFecha_inicio_labores() %></td>
                        <td><%= empleado.getFecha_ingreso() %></td>
                        <td><%= empleado.getUsuario() %></td>
                        <td>
                            <a href="EmpleadoControlador?accion=Seleccionar&id=<%= empleado.getId() %>" class="btn btn-info">Seleccionar</a>
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
