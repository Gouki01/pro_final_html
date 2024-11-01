package Controlador;

import java.io.IOException;
import java.sql.SQLException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import modelo.CompraDetalle;
import modelo.DetalleCompraDAO;

@WebServlet(name = "DetalleComprasServlet", urlPatterns = {"/DetalleComprasServlet"})
public class DetalleComprasServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        
        String idCompraStr = request.getParameter("id_compra");
        String idProductoStr = request.getParameter("id_producto");
        String cantidadStr = request.getParameter("cantidad");
        String precioCostoUnitarioStr = request.getParameter("precio_costo_unitario");

        if (idCompraStr == null || idProductoStr == null || cantidadStr == null || precioCostoUnitarioStr == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Error: Todos los campos son obligatorios.");
            return;
        }

        int idCompra = Integer.parseInt(idCompraStr);
        int idProducto = Integer.parseInt(idProductoStr);
        int cantidad = Integer.parseInt(cantidadStr);
        double precioCostoUnitario = Double.parseDouble(precioCostoUnitarioStr);

        
        CompraDetalle compraDetalle = new CompraDetalle();
        compraDetalle.setIdCompra(idCompra);
        compraDetalle.setIdProducto(idProducto);
        compraDetalle.setCantidad(cantidad);
        compraDetalle.setPrecioCostoUnitario(precioCostoUnitario);

        
        DetalleCompraDAO detalleCompraDAO = new DetalleCompraDAO();
        try {
            boolean resultado = detalleCompraDAO.insertarDetalleCompra(compraDetalle);
            if (resultado) {
                response.getWriter().println("<h1>Detalle de compra registrado exitosamente.</h1>");
            } else {
                response.getWriter().println("<h1>Error al registrar el detalle de compra.</h1>");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.getWriter().println("<h1>Error al registrar el detalle de compra: " + e.getMessage() + "</h1>");
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
        return "Servlet para manejar la inserción de detalles de compra";
    }
}
