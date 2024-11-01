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
        PrintWriter out = response.getWriter();

        try {
            // Recopilar datos generales de la venta
            String noFacturaStr = request.getParameter("no_factura");
            String serie = request.getParameter("serie");
            String fechaFacturaStr = request.getParameter("fecha_factura");
            String idClienteStr = request.getParameter("id_cliente");
            String idEmpleadoStr = request.getParameter("id_empleado");
            String fechaIngresoStr = request.getParameter("fecha_ingreso");

            // Verificar que los datos esenciales estén completos
            if (noFacturaStr == null || noFacturaStr.isEmpty() ||
                idClienteStr == null || idClienteStr.isEmpty() ||
                idEmpleadoStr == null || idEmpleadoStr.isEmpty() ||
                fechaFacturaStr == null || fechaIngresoStr == null) {
                out.println("<h1>Error: todos los campos son obligatorios, incluyendo las fechas.</h1>");
                out.println("<a href='Ventas.jsp'>Volver</a>");
                return;
            }

            // Parseo de datos generales
            int no_factura = Integer.parseInt(noFacturaStr);
            int id_cliente = Integer.parseInt(idClienteStr);
            int id_empleado = Integer.parseInt(idEmpleadoStr);


            // Parseo de fecha con datetime-local<<<<<<< HEAD=======>>>>>>> a6ed828 (ventas_ventas_detalle)
            SimpleDateFormat dateTimeFormat = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm");
            Date fecha_factura = dateTimeFormat.parse(fechaFacturaStr);
            Date fecha_ingreso = dateTimeFormat.parse(fechaIngresoStr);

            // Crear la instancia de Venta
            Venta nuevaVenta = new Venta();
            nuevaVenta.setNo_factura(no_factura);
            nuevaVenta.setSerie(serie);
            nuevaVenta.setFecha_factura(new Timestamp(fecha_factura.getTime()));
            nuevaVenta.setId_cliente(id_cliente);
            nuevaVenta.setId_empleado(id_empleado);
            nuevaVenta.setFecha_ingreso(new Timestamp(fecha_ingreso.getTime()));

            VentaDAO ventaDAO = new VentaDAO();
            boolean resultado = ventaDAO.insertar(nuevaVenta);

            double totalGeneral = 0.0;

            // Procesar los productos del carrito solo si la venta principal se ha insertado correctamente
            if (resultado) {
                Conexion conn = new Conexion();
                try (Connection conexionBD = conn.getConnection()) {
                    // Obtener listas de productos, cantidades y precios
                    String[] idProductos = request.getParameterValues("id_producto");
                    String[] cantidades = request.getParameterValues("cantidad");
                    String[] preciosUnitarios = request.getParameterValues("precio_unitario");

                    // Validar que los productos y cantidades no estén vacíos
                    if (idProductos == null || cantidades == null || preciosUnitarios == null) {
                        out.println("<h1>Error: El carrito está vacío o hay datos faltantes en productos.</h1>");
                        out.println("<a href='Ventas.jsp'>Volver</a>");
                        return;
                    }

                    // Iterar sobre los productos del carrito
                    for (int i = 0; i < idProductos.length; i++) {
                        int id_producto = Integer.parseInt(idProductos[i]);
                        int cantidad = Integer.parseInt(cantidades[i]);
                        double precio_unitario = Double.parseDouble(preciosUnitarios[i]);
                        double subtotal = cantidad * precio_unitario;
                        totalGeneral += subtotal;

                        // Insertar en ventas_detalle incluyendo el campo precio_total
                        String insertDetalleQuery = "INSERT INTO ventas_detalle (id_venta, id_producto, cantidad, precio_unitario, precio_total) VALUES (?, ?, ?, ?, ?)";
                        try (PreparedStatement pstmt = conexionBD.prepareStatement(insertDetalleQuery)) {
                            pstmt.setInt(1, nuevaVenta.getId_venta());
                            pstmt.setInt(2, id_producto);
                            pstmt.setInt(3, cantidad);
                            pstmt.setDouble(4, precio_unitario);
                            pstmt.setDouble(5, subtotal);
                            pstmt.executeUpdate();
                        }

                        // Actualizar el stock del producto
                        String updateProductQuery = "UPDATE productos SET existencia = existencia - ? WHERE id_producto = ?";
                        try (PreparedStatement pstmt = conexionBD.prepareStatement(updateProductQuery)) {
                            pstmt.setInt(1, cantidad);
                            pstmt.setInt(2, id_producto);
                            pstmt.executeUpdate();
                        }
                    }

                    // Actualizar el total general en la venta principal
                    nuevaVenta.setPrecio_total(totalGeneral);
                    ventaDAO.actualizarTotalVenta(nuevaVenta.getId_venta(), totalGeneral);

                } catch (SQLException e) {
                    e.printStackTrace();
                    out.println("<h1>Error al guardar el detalle de la venta: " + e.getMessage() + "</h1>");
                }

                // Redirigir después de guardar la venta completa
                response.sendRedirect("Ventas.jsp?id_venta=" + nuevaVenta.getId_venta());
            } else {
                out.println("<h1>Error al registrar la venta: Problema con la base de datos.</h1>");
                out.println("<a href='Ventas.jsp'>Volver</a>");
            }

        } catch (Exception e) {
            out.println("<h1>Error al procesar la solicitud: " + e.getMessage() + "</h1>");
        } finally {
            if (out != null) {
                out.close();
            }
        }
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
