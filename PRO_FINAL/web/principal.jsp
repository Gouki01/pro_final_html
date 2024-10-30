<%-- 
    Document   : principal
    Created on : 25/10/2024, 10:41:50 p. m.
    Author     : Soporte_IT
--%>

<%@page import="modelo.Empleado"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
        <title>JSP Page</title>
    </head>
    <body>
        <nav class="navbar navbar-expand-lg bg-info">
            <div class="container-fluid">
              <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav">
                  <li class="nav-item">
                    <a style="margin-left: 10px; border: none" class="btn btn-outline-light"href="#">Proveedores</a>
                  </li>
                  <li class="nav-item">
                    <a style="margin-left: 10px; border: none" class="btn btn-outline-light" href="#">Clientes</a>
                  </li>
                  <div class="dropdown">
                    <button style="border: none" class="btn btn-outline-light dropdown-toggle" data-bs-toggle="dropdown" aria-expanded="false">
                      Ventas
                    </button>
                    <ul class="dropdown-menu">
                      <li><a class="dropdown-item" href="controlador?accion=Ventas" target="myFrame">Ventas</a></li>
                      <li><a class="dropdown-item" href="controlador?accion=Compras" target="myFrame">Compras</a></li>
                      <li><a class="dropdown-item" href="controlador?accion=Ventas_detalles" target="myFrame">Ventas Detalle</a></li>
                      <li><a class="dropdown-item" href="controlador?accion=Compra_detalle" target="myFrame">Compras Detalle</a></li>
                    </ul>
                  </div>
                  <div class="dropdown">
                    <button style="border: none" class="btn btn-outline-light dropdown-toggle" data-bs-toggle="dropdown" aria-expanded="false">
                      Empleados
                    </button>
                    <ul class="dropdown-menu">
                        <li><a class="dropdown-item" href="controlador?accion=Empleados" target="myFrame">Registo/modificaion</a></li>
                      <li><a class="dropdown-item" href="controlador?accion=Puestos" target="myFrame">Puestos</a></li>
                    </ul>
                  </div>
                </ul>
              </div>
                <div class="dropdown">
                        <button style="border: none" class="btn btn-outline-light dropdown-toggle" type="button" data-bs-toggle="dropdown" aria-expanded="false">
                                <% 
                                    Empleado usuario = (Empleado) session.getAttribute("usuario");
                                    if (usuario != null) {
                                        out.print(usuario.getNombreCompleto());
                                    } else {
                                        out.print("USUARIO INGRESADO");
                                    }
                                %>
                            </button>
                        <ul class="dropdown-menu text-center" >
                            <li><a class="dropdown-item" href="#">
                             <img src="imgs/login/usuario.jpg" alt="50" width="60"/>
                                </a></li>
                          <li><a class="dropdown-item">BIENVENIDO</a></li>
                          <li><a class="dropdown-item">${usuario.getUsuario()}</a></li>
                          <div class="dropdown-divider"></div>
                          <form action="validar" method="post">
                             <button name="accion" value="Salir" class="dropdown-item">SALIR</button>
                           </form>                         
                        </ul>
                    </div>
            </div>
          </nav>
                          <div class="m-4" style="height: 550px;">
                    <iframe name="myFrame" style="height: 100%; width: 100%"></iframe>          
                </div>
    </body>
</html>
