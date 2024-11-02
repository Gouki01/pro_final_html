/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
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

@WebServlet(name = "ActualizarCompraServlet", urlPatterns = {"/ActualizarCompraServlet"})
public class ActualizarCompraServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        int idCompra = Integer.parseInt(request.getParameter("id_compra"));
        int noOrdenCompra = Integer.parseInt(request.getParameter("no_orden_compra"));
        String fechaOrden = request.getParameter("fecha_orden");
        String fechaIngreso = request.getParameter("fecha_ingreso");
        int idProveedor = Integer.parseInt(request.getParameter("id_proveedor"));
        double precioTotal = Double.parseDouble(request.getParameter("precio_total"));

        try (Connection conexionBD = new Conexion().getConnection()) {
            if (conexionBD != null) {
                String query = "UPDATE compras SET no_orden_compra = ?, fecha_orden = ?, fecha_ingreso = ?, id_proveedor = ?, precio_total = ? WHERE id_compra = ?";
                PreparedStatement stmt = conexionBD.prepareStatement(query);
                stmt.setInt(1, noOrdenCompra);
                stmt.setString(2, fechaOrden);
                stmt.setString(3, fechaIngreso);
                stmt.setInt(4, idProveedor);
                stmt.setDouble(5, precioTotal);
                stmt.setInt(6, idCompra);

                int filasActualizadas = stmt.executeUpdate();

                if (filasActualizadas > 0) {
                    response.sendRedirect("GestionCompras.jsp?status=success");
                } else {
                    response.sendRedirect("GestionCompras.jsp?status=not_found");
                }
            } else {
                response.sendRedirect("GestionCompras.jsp?status=db_error");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("GestionCompras.jsp?status=error");
        }
    }
}
