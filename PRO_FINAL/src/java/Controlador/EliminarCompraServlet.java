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

@WebServlet(name = "EliminarCompraServlet", urlPatterns = {"/EliminarCompraServlet"})
public class EliminarCompraServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        int idCompra = Integer.parseInt(request.getParameter("id"));
        
        try (Connection conexionBD = new Conexion().getConnection()) {
            if (conexionBD != null) {
                // Primero eliminar los detalles de la compra en compras_detalle
                String deleteDetalleQuery = "DELETE FROM compras_detalle WHERE id_compra = ?";
                try (PreparedStatement detalleStmt = conexionBD.prepareStatement(deleteDetalleQuery)) {
                    detalleStmt.setInt(1, idCompra);
                    detalleStmt.executeUpdate();
                }

                // Ahora eliminar la compra principal en compras
                String deleteCompraQuery = "DELETE FROM compras WHERE id_compra = ?";
                try (PreparedStatement compraStmt = conexionBD.prepareStatement(deleteCompraQuery)) {
                    compraStmt.setInt(1, idCompra);
                    int filasEliminadas = compraStmt.executeUpdate();

                    if (filasEliminadas > 0) {
                        response.sendRedirect("GestionCompras.jsp?status=delete_success");
                    } else {
                        response.sendRedirect("GestionCompras.jsp?status=delete_not_found");
                    }
                }
            } else {
                response.sendRedirect("GestionCompras.jsp?status=db_error");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("GestionCompras.jsp?status=delete_error");
        }
    }
}
