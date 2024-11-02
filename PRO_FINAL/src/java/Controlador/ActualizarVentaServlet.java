package Controlador;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.Timestamp;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import modelo.Conexion;

@WebServlet(name = "ActualizarVentaServlet", urlPatterns = {"/ActualizarVentaServlet"})
public class ActualizarVentaServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Obtener los parámetros del formulario
        int idVenta = Integer.parseInt(request.getParameter("id_venta"));
        int noFactura = Integer.parseInt(request.getParameter("no_factura"));
        String serie = request.getParameter("serie");
        String fechaFactura = request.getParameter("fecha_factura");  // Fecha en formato 'yyyy-MM-ddTHH:mm'
        int idCliente = Integer.parseInt(request.getParameter("id_cliente"));
        int idEmpleado = Integer.parseInt(request.getParameter("id_empleado"));
        double precioTotal = Double.parseDouble(request.getParameter("precio_total"));

        Connection conexionBD = null;
        PreparedStatement stmt = null;

        try {
            // Establecer conexión con la base de datos
            Conexion conn = new Conexion();
            conexionBD = conn.getConnection();
            
            if (conexionBD != null) {
                // Convertir fechaFactura a Timestamp
                Timestamp fechaFacturaTimestamp = Timestamp.valueOf(fechaFactura.replace("T", " ") + ":00");

                // Actualizar la venta en la base de datos
                String query = "UPDATE ventas SET no_factura = ?, serie = ?, fecha_factura = ?, id_cliente = ?, id_empleado = ?, precio_total = ? WHERE id_venta = ?";
                stmt = conexionBD.prepareStatement(query);
                stmt.setInt(1, noFactura);
                stmt.setString(2, serie);
                stmt.setTimestamp(3, fechaFacturaTimestamp);
                stmt.setInt(4, idCliente);
                stmt.setInt(5, idEmpleado);
                stmt.setDouble(6, precioTotal);
                stmt.setInt(7, idVenta);

                int filasActualizadas = stmt.executeUpdate();

                if (filasActualizadas > 0) {
                    // Redirigir a la página de gestión de ventas si la actualización fue exitosa
                    response.sendRedirect("GestionVentas.jsp?status=success");
                } else {
                    // Redirigir a la página de gestión de ventas con error si no se encontró la venta
                    response.sendRedirect("GestionVentas.jsp?status=not_found");
                }
            } else {
                response.sendRedirect("GestionVentas.jsp?status=db_error");
            }
        } catch (SQLException e) {
            System.err.println("Error al actualizar la venta: " + e.getMessage());
            response.sendRedirect("GestionVentas.jsp?status=error");
        } finally {
            // Cerrar la conexión y el statement
            try {
                if (stmt != null) stmt.close();
                if (conexionBD != null) conexionBD.close();
            } catch (SQLException e) {
                System.err.println("Error al cerrar los recursos: " + e.getMessage());
            }
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doPost(request, response);
    }
}
