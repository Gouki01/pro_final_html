package Controlador;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import modelo.Venta;
import modelo.VentaDAO;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import modelo.Conexion;

@WebServlet(name = "VentasServlet", urlPatterns = {"/VentasServlet"})
public class VentasServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = null;

        try {
            out = response.getWriter();

            String noFacturaStr = request.getParameter("no_factura");
            String serie = request.getParameter("serie");
            String fechaFacturaStr = request.getParameter("fecha_factura");
            String idClienteStr = request.getParameter("id_cliente");
            String idEmpleadoStr = request.getParameter("id_empleado");
            String fechaIngresoStr = request.getParameter("fecha_ingreso");
            String idProductoStr = request.getParameter("id_producto"); 
            String cantidadStr = request.getParameter("cantidad"); 
            String precioUnitarioStr = request.getParameter("precio_unitario");

            if (noFacturaStr == null || noFacturaStr.isEmpty() ||
                idClienteStr == null || idClienteStr.isEmpty() ||
                idEmpleadoStr == null || idEmpleadoStr.isEmpty() ||
                idProductoStr == null || idProductoStr.isEmpty() ||
                cantidadStr == null || cantidadStr.isEmpty()) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Error: todos los campos son obligatorios.");
                return;
            }

            int no_factura = Integer.parseInt(noFacturaStr);
            int id_cliente = Integer.parseInt(idClienteStr);
            int id_empleado = Integer.parseInt(idEmpleadoStr);
            int id_producto = Integer.parseInt(idProductoStr);
            int cantidad = Integer.parseInt(cantidadStr);

           
            SimpleDateFormat dateTimeFormat = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm");
            Date fecha_factura;
            try {
                fecha_factura = dateTimeFormat.parse(fechaFacturaStr);
            } catch (ParseException e) {
                sendErrorResponse(out, "Error: El formato de la fecha de factura no es válido.");
                return;
            }

            Date fecha_ingreso;
            try {
                fecha_ingreso = dateTimeFormat.parse(fechaIngresoStr);
            } catch (ParseException e) {
                sendErrorResponse(out, "Error: El formato de la fecha de ingreso no es válido.");
                return;
            }

            Venta nuevaVenta = new Venta();
            nuevaVenta.setNo_factura(no_factura);
            nuevaVenta.setSerie(serie);
            nuevaVenta.setFecha_factura(new Timestamp(fecha_factura.getTime()));
            nuevaVenta.setId_cliente(id_cliente);
            nuevaVenta.setId_empleado(id_empleado);
            nuevaVenta.setFecha_ingreso(new Timestamp(fecha_ingreso.getTime()));

            VentaDAO ventaDAO = new VentaDAO();
            boolean resultado = ventaDAO.insertar(nuevaVenta);

            if (resultado) {
                Conexion conn = new Conexion();
                try (Connection conexionBD = conn.getConnection()) { 
                    String insertDetalleQuery = "INSERT INTO ventas_detalle (id_venta, id_producto, cantidad, precio_unitario) VALUES (?, ?, ?, ?)";
                    try (PreparedStatement pstmt = conexionBD.prepareStatement(insertDetalleQuery)) {
                        pstmt.setInt(1, nuevaVenta.getId_venta());
                        pstmt.setInt(2, id_producto);
                        pstmt.setInt(3, cantidad);
                        pstmt.setDouble(4, Double.parseDouble(precioUnitarioStr)); 
                        pstmt.executeUpdate();
                    }

                    String updateProductQuery = "UPDATE productos SET existencia = existencia - ? WHERE id_producto = ?";
                    try (PreparedStatement pstmt = conexionBD.prepareStatement(updateProductQuery)) {
                        pstmt.setInt(1, cantidad);
                        pstmt.setInt(2, id_producto);
                        pstmt.executeUpdate();
                    }

                } catch (SQLException e) {
                    e.printStackTrace();
                }

                response.sendRedirect("Ventas.jsp?id_venta=" + nuevaVenta.getId_venta());
            } else {
                out.println("<h1>Error al registrar la venta.</h1>");
            }
            out.println("<a href='Ventas.jsp'>Volver</a>");

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
        out.println("<a href='Ventas.jsp'>Volver</a>");
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
        return "Servlet para manejar la inserción de ventas";
    }
}
