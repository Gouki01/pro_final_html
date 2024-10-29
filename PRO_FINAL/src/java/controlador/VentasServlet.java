/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controlador;

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
import java.util.Date;
import modelo.Conexion;


/**
 *
 * @author jealv
 */
@WebServlet(name = "VentasServlet", urlPatterns = {"/VentasServlet"})
public class VentasServlet extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
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
            String idProductoStr = request.getParameter("id_producto"); // Obtener el ID del producto
            String cantidadStr = request.getParameter("cantidad"); // Obtener la cantidad
            String precioUnitarioStr = request.getParameter("precio_unitario"); // Obtener el precio unitario

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
            int cantidad = Integer.parseInt(cantidadStr); // Convertir cantidad a entero

              Date fecha_factura;
            try {
                fecha_factura = java.sql.Date.valueOf(fechaFacturaStr);
            } catch (IllegalArgumentException e) {
                sendErrorResponse(out, "Error: El formato de la fecha de factura no es válido.");
                return;
            }

            
             java.sql.Date fechaIngreso = null; 
            if (fechaIngresoStr != null && !fechaIngresoStr.isEmpty()) {
                try {
                    fechaIngreso = java.sql.Date.valueOf(fechaIngresoStr);
                } catch (IllegalArgumentException e) {
                    sendErrorResponse(out, "Error: El formato de la fecha de ingreso no es válido.");
                    return; 
                }
            } else {
                sendErrorResponse(out, "Error: El campo de fecha de ingreso no puede estar vacío.");
                return; 
            }

       // Crear la venta
             Venta nuevaVenta = new Venta();
            nuevaVenta.setNo_factura(no_factura);
            nuevaVenta.setSerie(serie);
            nuevaVenta.setFecha_factura(fecha_factura);
            nuevaVenta.setId_cliente(id_cliente);
            nuevaVenta.setId_empleado(id_empleado);
            nuevaVenta.setFecha_ingreso(fechaIngreso); 

            
            VentaDAO ventaDAO = new VentaDAO();
            boolean resultado = ventaDAO.insertar(nuevaVenta);

            
              if (resultado) {
                // Iniciar conexión para insertar en ventas_detalle
                Conexion conn = new Conexion();
                try (Connection conexionBD = conn.abrir_conexion()) { // Usa try-with-resources para la conexión
                    String insertDetalleQuery = "INSERT INTO ventas_detalle (id_venta, id_producto, cantidad, precio_unitario) VALUES (?, ?, ?, ?)";
                    try (PreparedStatement pstmt = conexionBD.prepareStatement(insertDetalleQuery)) {
                        pstmt.setInt(1, nuevaVenta.getId_venta());
                        pstmt.setInt(2, id_producto);
                        pstmt.setInt(3, cantidad);
                        pstmt.setDouble(4, Double.parseDouble(precioUnitarioStr)); // Convertir a double
                        pstmt.executeUpdate();
                    }

                    // Actualizar saldo del producto
                    String updateProductQuery = "UPDATE productos SET existencia = existencia - ? WHERE id_producto = ?";
                    try (PreparedStatement pstmt = conexionBD.prepareStatement(updateProductQuery)) {
                        pstmt.setInt(1, cantidad);
                        pstmt.setInt(2, id_producto);
                        pstmt.executeUpdate();
                    }

                } catch (SQLException e) {
                    e.printStackTrace();
                }

                response.sendRedirect("ventas.jsp?id_venta=" + nuevaVenta.getId_venta()); 
            } else {
                out.println("<h1>Error al registrar la venta.</h1>");
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

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
     @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }
    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
     @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
     @Override
    public String getServletInfo() {
        return "Servlet para manejar la inserción de ventas";
    }
}