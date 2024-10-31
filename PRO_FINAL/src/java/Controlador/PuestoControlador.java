package Controlador;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import modelo.Puesto;
import modelo.PuestoDAO;

@WebServlet(name = "PuestoControlador", urlPatterns = {"/PuestoControlador"})
public class PuestoControlador extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String accion = request.getParameter("accion");
        PuestoDAO dao = new PuestoDAO();

        if ("Agregar".equals(accion)) {
            Puesto p = new Puesto();
            p.setPuesto(request.getParameter("txtpuesto"));
            dao.agregar(p);
            response.sendRedirect("Puestos.jsp");
        } else if ("Seleccionar".equals(accion)) {
            int id = Integer.parseInt(request.getParameter("id"));
            Puesto p = dao.buscarPorId(id);
            request.setAttribute("puestoSeleccionado", p);
            request.getRequestDispatcher("Puestos.jsp").forward(request, response);
        } else if ("Actualizar".equals(accion)) {
            Puesto p = new Puesto();
            p.setId_puesto(Integer.parseInt(request.getParameter("id")));
            p.setPuesto(request.getParameter("txtpuesto"));
            dao.actualizar(p);
            response.sendRedirect("Puestos.jsp");
        } else if ("Eliminar".equals(accion)) {
            int id = Integer.parseInt(request.getParameter("id"));
            dao.eliminar(id);
            response.sendRedirect("Puestos.jsp");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doPost(request, response);
    }
}
