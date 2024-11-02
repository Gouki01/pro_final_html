package Controlador;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import modelo.DetalleCompraDAO;

@WebServlet(name = "DetalleComprasServlet", urlPatterns = {"/DetalleComprasServlet"})
public class DetalleComprasServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Aquí puedes colocar la lógica necesaria para el procesamiento de detalles de compras,
        // excluyendo el cálculo de total general en la solicitud.

        response.sendRedirect("Compras.jsp"); // Redireccionar después de procesar la solicitud
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
