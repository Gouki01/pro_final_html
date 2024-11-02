package Controlador;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import modelo.Conexion;

@WebServlet(name = "EliminarVentaServlet", urlPatterns = {"/EliminarVentaServlet"})
public class EliminarVentaServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int idVenta = Integer.parseInt(request.getParameter("id"));
        Connection conexionBD = null;
        PreparedStatement deleteDetalleStmt = null;
        PreparedStatement deleteVentaStmt = null;

        try {
            Conexion conn = new Conexion();
            conexionBD = conn.getConnection();
            
            if (conexionBD != null) {
                // Primero, eliminar los registros de ventas_detalle asociados a la venta
                String deleteDetalleQuery = "DELETE FROM ventas_detalle WHERE id_venta = ?";
                deleteDetalleStmt = conexionBD.prepareStatement(deleteDetalleQuery);
                deleteDetalleStmt.setInt(1, idVenta);
                deleteDetalleStmt.executeUpdate();

                // Luego, eliminar la venta
                String deleteVentaQuery = "DELETE FROM ventas WHERE id_venta = ?";
                deleteVentaStmt = conexionBD.prepareStatement(deleteVentaQuery);
                deleteVentaStmt.setInt(1, idVenta);
                int filasEliminadas = deleteVentaStmt.executeUpdate();

                if (filasEliminadas > 0) {
                    // Redirigir con éxito
                    response.sendRedirect("GestionVentas.jsp?status=delete_success");
                } else {
                    // Redirigir si no se encontró la venta
                    response.sendRedirect("GestionVentas.jsp?status=not_found");
                }
            } else {
                response.sendRedirect("GestionVentas.jsp?status=db_error");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            // Redirigir a la página de gestión con un mensaje de error genérico
            response.sendRedirect("GestionVentas.jsp?status=delete_error");
        } finally {
            try {
                if (deleteDetalleStmt != null) deleteDetalleStmt.close();
                if (deleteVentaStmt != null) deleteVentaStmt.close();
                if (conexionBD != null) conexionBD.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}

