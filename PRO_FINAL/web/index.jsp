<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <title>Login</title>
</head>
<body>
    <div class="container mt-4 col-lg-4">
        <div class="card col-sm-10">
            <div class="card-body">
                <form class="form-sign" action="validar" method="post">    
                    <div class="form-group text-center">
                        <h3>Login</h3>
                        <img src="imgs/login/logo.jpg" alt="Logo" width="170"/>
                        <label>Bienvenido al sistema</label>                            
                    </div>
                    <div class="form-group">
                        <label>Usuario</label>
                        <input type="text" name="txt_user" class="form-control" required>
                    </div>
                    <div class="form-group">
                        <label>Contraseña</label>
                        <input type="password" name="txt_pass" class="form-control" required>
                    </div>
                    <input type="submit" name="accion" value="Ingresar" class="btn btn-primary w-100">
                </form>

                <!-- Mostrar mensaje de error si existe -->
                <%
                    String error = (String) request.getAttribute("error");
                    if (error != null) {
                %>
                    <div class="alert alert-danger mt-3">
                        <%= error %>
                    </div>
                <%
                    }
                %>
            </div>
        </div>
    </div>
</body>
</html>
