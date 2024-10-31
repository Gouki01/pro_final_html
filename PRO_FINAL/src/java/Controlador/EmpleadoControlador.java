package Controlador;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import modelo.Empleado;
import modelo.EmpleadoDAO;

@WebServlet(name = "EmpleadoControlador", urlPatterns = {"/EmpleadoControlador"})
public class EmpleadoControlador extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String accion = request.getParameter("accion");
        EmpleadoDAO dao = new EmpleadoDAO();

        if ("Agregar".equals(accion)) {
            Empleado em = new Empleado();
            em.setNombres(request.getParameter("txtnombres"));
            em.setApellidos(request.getParameter("txtapellidos"));
            em.setDireccion(request.getParameter("txtdireccion"));
            em.setTelefono(request.getParameter("txttelefono"));
            em.setDpi(request.getParameter("txtdpi"));
            em.setGenero(Integer.parseInt(request.getParameter("txtgenero")));
            em.setFecha_nacimiento(request.getParameter("txtnacimiento"));
            em.setIdpuesto(Integer.parseInt(request.getParameter("txtpuesto")));
            em.setFecha_inicio_labores(request.getParameter("txtinicio"));
            em.setFecha_ingreso(request.getParameter("txtingreso"));
            em.setUsuario(request.getParameter("txtusuario"));
            
            boolean success = dao.agregar(em); // Intenta agregar el empleado
            if (success) {
                response.sendRedirect("Empleados.jsp"); // Redirige si se inserta exitosamente
            } else {
                response.getWriter().write("Error al agregar el empleado.");
            }
        } 
        else if ("Seleccionar".equals(accion)) { // Nueva opción para seleccionar un empleado
            int id = Integer.parseInt(request.getParameter("id"));
            Empleado empleado = dao.buscarPorId(id); // Método buscarPorId en EmpleadoDAO
            request.setAttribute("empleadoSeleccionado", empleado);
            request.getRequestDispatcher("Empleados.jsp").forward(request, response); // Redirige a Empleados.jsp con los datos cargados
        } 
        else if ("Actualizar".equals(accion)) {
            int id = Integer.parseInt(request.getParameter("id"));
            System.out.println("ID recibido para actualizar: " + id); // Mensaje de depuración para verificar el ID

            Empleado em = new Empleado();
            em.setId(id);
            em.setNombres(request.getParameter("txtnombres"));
            em.setApellidos(request.getParameter("txtapellidos"));
            em.setDireccion(request.getParameter("txtdireccion"));
            em.setTelefono(request.getParameter("txttelefono"));
            em.setDpi(request.getParameter("txtdpi"));
            em.setGenero(Integer.parseInt(request.getParameter("txtgenero")));
            em.setFecha_nacimiento(request.getParameter("txtnacimiento"));
            em.setIdpuesto(Integer.parseInt(request.getParameter("txtpuesto")));
            em.setFecha_inicio_labores(request.getParameter("txtinicio"));
            em.setFecha_ingreso(request.getParameter("txtingreso"));
            em.setUsuario(request.getParameter("txtusuario"));

            boolean success = dao.actualizar(em); // Llama al método actualizar en EmpleadoDAO
            System.out.println("Resultado de la actualización: " + success); // Mensaje de depuración para verificar si la actualización fue exitosa
            if (success) {
                response.sendRedirect("Empleados.jsp"); // Redirige a Empleados.jsp si se actualiza exitosamente
            } else {
                response.getWriter().write("Error al actualizar el empleado.");
            }
        }

        else if ("Eliminar".equals(accion)) { // Nueva opción para eliminar un empleado
            int id = Integer.parseInt(request.getParameter("id"));
            boolean success = dao.eliminar(id); // Verifica si la eliminación fue exitosa
            if (success) {
                response.sendRedirect("Empleados.jsp"); // Redirige si se elimina exitosamente
            } else {
                response.getWriter().write("Error al eliminar el empleado.");
            }
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doPost(request, response); // Redirige todas las solicitudes GET a doPost para manejo de acciones
    }
}
