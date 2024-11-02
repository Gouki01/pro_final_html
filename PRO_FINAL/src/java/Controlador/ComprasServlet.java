package Controlador;

import java.io.IOException;
import java.sql.Timestamp;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import modelo.Compra;
import modelo.CompraDAO;
import modelo.CompraDetalle;

@WebServlet(name = "ComprasServlet", urlPatterns = {"/ComprasServlet"})
public class ComprasServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int noOrdenCompra = Integer.parseInt(request.getParameter("no_orden_compra"));
        int idProveedor = Integer.parseInt(request.getParameter("id_proveedor"));
        
        String fechaOrdenStr = request.getParameter("fecha_orden");
        String fechaIngresoStr = request.getParameter("fecha_ingreso");

        Timestamp fechaOrden = parseTimestamp(fechaOrdenStr);
        Timestamp fechaIngreso = parseTimestamp(fechaIngresoStr);

        Compra compra = new Compra(0, noOrdenCompra, idProveedor, fechaOrden, fechaIngreso);
        List<CompraDetalle> detalles = new ArrayList<>();

        String[] productos = request.getParameterValues("id_producto");
        String[] cantidades = request.getParameterValues("cantidad");
        String[] precios = request.getParameterValues("precio_costo_unitario");

        for (int i = 0; i < productos.length; i++) {
            int idProducto = Integer.parseInt(productos[i]);
            int cantidad = Integer.parseInt(cantidades[i]);
            double precioCostoUnitario = Double.parseDouble(precios[i]);

            CompraDetalle compraDetalle = new CompraDetalle(0, 0, idProducto, cantidad, precioCostoUnitario);
            detalles.add(compraDetalle);
        }

        CompraDAO compraDAO = new CompraDAO();
        boolean resultado = compraDAO.insertarCompraYDetalles(compra, detalles);

        if (resultado) {
            response.sendRedirect("Compras.jsp?status=success");
        } else {
            response.sendRedirect("Compras.jsp?status=error");
        }
    }

    private Timestamp parseTimestamp(String dateTimeStr) {
        try {
            if (dateTimeStr.length() == 10) { 
                LocalDate date = LocalDate.parse(dateTimeStr, DateTimeFormatter.ofPattern("yyyy-MM-dd"));
                return Timestamp.valueOf(date.atStartOfDay());
            } else { 
                LocalDateTime dateTime = LocalDateTime.parse(dateTimeStr, DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm"));
                return Timestamp.valueOf(dateTime);
            }
        } catch (Exception e) {
            e.printStackTrace();
            throw new IllegalArgumentException("Formato de fecha/hora no válido. Se esperaba 'yyyy-MM-dd' o 'yyyy-MM-dd'T'HH:mm'");
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
        return "Servlet para gestionar las compras y sus detalles";
    }
}
