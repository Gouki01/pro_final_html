package controlador;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import modelo.DetalleVentaDAO;
import modelo.Conexion;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

@WebServlet(name = "DetalleVentasServlet", urlPatterns = {"/DetalleVentasServlet"})
public class DetalleVentasServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = null;

        try {
            out = response.getWriter();

            // Obtener parámetros del formulario
            String idVentaStr = request.getParameter("id_venta");
            String idProductoStr = request.getParameter("id_producto");
            String cantidadStr = request.getParameter("cantidad");
            String precioUnitarioStr = request.getParameter("precio_unitario");

            if (idVentaStr == null || idProductoStr == null || cantidadStr == null || precioUnitarioStr == null) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Error: todos los campos son obligatorios.");
                return;
            }

            int id_venta = Integer.parseInt(idVentaStr);
            int id_producto = Integer.parseInt(idProductoStr);
            int cantidad = Integer.parseInt(cantidadStr);
            double precio_unitario = Double.parseDouble(precioUnitarioStr);

            // Lógica para insertar el detalle de la venta
            DetalleVentaDAO detalleVentaDAO = new DetalleVentaDAO();
            boolean resultado = detalleVentaDAO.insertarDetalle(id_venta, id_producto, cantidad, precio_unitario);

            if (resultado) {
                // Actualizar saldo del producto
                Connection conexionBD = null;
                try {
                    Conexion conn = new Conexion();
                    conexionBD = conn.abrir_conexion();
                    String updateProductQuery = "UPDATE productos SET existencia = existencia - ? WHERE id_producto = ?";
                    try (PreparedStatement pstmt = conexionBD.prepareStatement(updateProductQuery)) {
                        pstmt.setInt(1, cantidad);
                        pstmt.setInt(2, id_producto);
                        pstmt.executeUpdate();
                    }
                } catch (SQLException e) {
                    e.printStackTrace();
                } finally {
                    if (conexionBD != null) {
                        new Conexion().cerrar_conexion(conexionBD);
                    }
                }

                response.sendRedirect("ventas.jsp?id_venta=" + id_venta);
            } else {
                out.println("<h1>Error al registrar el detalle de la venta.</h1>");
            }
            out.println("<a href='ventas.jsp'>Volver</a>");

        } catch (NumberFormatException e) {
            sendErrorResponse(out, "Error: uno de los campos numéricos no es válido.");
        } catch (IOException e) {
            sendErrorResponse(out, "Error al procesar la solicitud: " + e.getMessage());
        } finally {
            if (out != null) {
                out.close();
            }
        }
    }

    private void sendErrorResponse(PrintWriter out, String message) {
        out.println("<h1>" + message + "</h1>");
        out.println("<a href='ventas.jsp'>Volver</a>");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Servlet para manejar la inserción de detalles de venta";
    }
}

