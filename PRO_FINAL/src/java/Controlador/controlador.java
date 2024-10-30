package Controlador;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class controlador extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String accion = request.getParameter("accion");
        
        if (accion == null) {
            accion = "default"; // Establecemos un valor por defecto si no hay "accion"
        }
        
        switch (accion) {
            
        case "principal":
        request.getRequestDispatcher("principal.jsp").forward(request, response);
        break;
        
        case "Empleados":
        request.getRequestDispatcher("Empleados.jsp").forward(request, response);
        break;
        
        case "Puestos":
        request.getRequestDispatcher("Puestos.jsp").forward(request, response);
        break;
        
        case "Ventas":
        request.getRequestDispatcher("Ventas.jsp").forward(request, response);
        break;
        
        case "Compras":
        request.getRequestDispatcher("Compras.jsp").forward(request, response);
        break;
              
        
        
    default:
        // Si no hay una acción válida, se redirige a una página de error o de inicio
        request.setAttribute("error", "Acción no válida.");
        request.getRequestDispatcher("index.jsp").forward(request, response);
        break;
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
        return "Short description";
    }
}
