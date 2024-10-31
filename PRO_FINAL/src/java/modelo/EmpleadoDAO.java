package modelo;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class EmpleadoDAO {

    Conexion cn = new Conexion();
    Connection con;
    PreparedStatement ps;
    ResultSet rs;
    
    public Empleado validar(String usuario, String dpi) {
        Empleado em = new Empleado();
        String sql = "SELECT * FROM empleados WHERE usuario = ? AND dpi = ?";
        try {
            con = cn.getConnection();
            ps = con.prepareStatement(sql);
            ps.setString(1, usuario);
            ps.setString(2, dpi); 
            rs = ps.executeQuery();
            
            if (rs.next()) {
                em.setUsuario(rs.getString("usuario"));
                em.setDpi(rs.getString("dpi"));
                em.setNombres(rs.getString("nombres"));
                em.setApellidos(rs.getString("apellidos"));
            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (con != null) cn.cerrar_conexion();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        return em;
    }

    public List<Empleado> listar() {
    List<Empleado> lista = new ArrayList<>();
    String sql = "SELECT * FROM empleados";
    try {
        con = cn.getConnection();
        ps = con.prepareStatement(sql);
        rs = ps.executeQuery();
        while (rs.next()) {
            Empleado em = new Empleado();
            em.setId(rs.getInt("id_empleado"));  // Usa el nombre correcto de la columna
            em.setNombres(rs.getString("nombres"));
            em.setApellidos(rs.getString("apellidos"));
            em.setDireccion(rs.getString("direccion"));
            em.setTelefono(rs.getString("telefono"));
            em.setDpi(rs.getString("dpi"));
            em.setGenero(rs.getInt("genero"));
            em.setFecha_nacimiento(rs.getString("fecha_nacimiento"));
            em.setIdpuesto(rs.getInt("id_puesto"));  // Asegúrate de usar el nombre correcto
            em.setFecha_inicio_labores(rs.getString("fecha_inicio_labores"));
            em.setFecha_ingreso(rs.getString("fecha_ingreso"));
            em.setUsuario(rs.getString("usuario"));
            lista.add(em);
        }
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        try {
            if (rs != null) rs.close();
            if (ps != null) ps.close();
            if (con != null) cn.cerrar_conexion();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    return lista;
}

        public boolean agregar(Empleado em) {
            String sql = "INSERT INTO empleados (nombres, apellidos, direccion, telefono, dpi, genero, fecha_nacimiento, id_puesto, fecha_inicio_labores, fecha_ingreso, usuario) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
            try {
                con = cn.getConnection();
                ps = con.prepareStatement(sql);
                ps.setString(1, em.getNombres());
                ps.setString(2, em.getApellidos());
                ps.setString(3, em.getDireccion());
                ps.setString(4, em.getTelefono());
                ps.setString(5, em.getDpi());
                ps.setInt(6, em.getGenero()); // Asegúrate de enviar 0 o 1
                ps.setString(7, em.getFecha_nacimiento()); // Formato 'YYYY-MM-DD'
                ps.setInt(8, em.getIdpuesto());
                ps.setString(9, em.getFecha_inicio_labores()); // Formato 'YYYY-MM-DD'
                ps.setString(10, em.getFecha_ingreso()); // Formato 'YYYY-MM-DD HH:MM:SS'
                ps.setString(11, em.getUsuario());

                System.out.println("Ejecutando SQL: " + ps);
                ps.executeUpdate();
                return true;
            } catch (Exception e) {
                System.out.println("Error al agregar empleado: " + e.getMessage());
                e.printStackTrace();
            } finally {
                try {
                    if (ps != null) ps.close();
                    if (con != null) cn.cerrar_conexion();
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
            return false;
        }
    
            public boolean actualizar(Empleado em) {
                String sql = "UPDATE empleados SET nombres=?, apellidos=?, direccion=?, telefono=?, dpi=?, genero=?, fecha_nacimiento=?, id_puesto=?, fecha_inicio_labores=?, fecha_ingreso=?, usuario=? WHERE id_empleado=?";
                try {
                    con = cn.getConnection();
                    ps = con.prepareStatement(sql);
                    ps.setString(1, em.getNombres());
                    ps.setString(2, em.getApellidos());
                    ps.setString(3, em.getDireccion());
                    ps.setString(4, em.getTelefono());
                    ps.setString(5, em.getDpi());
                    ps.setInt(6, em.getGenero()); // Verifica que el valor sea 0 o 1
                    ps.setString(7, em.getFecha_nacimiento());
                    ps.setInt(8, em.getIdpuesto());
                    ps.setString(9, em.getFecha_inicio_labores());
                    ps.setString(10, em.getFecha_ingreso());
                    ps.setString(11, em.getUsuario());
                    ps.setInt(12, em.getId()); // Asegúrate de que el ID está correcto

                    System.out.println("Ejecutando actualización: " + ps); // Muestra la consulta completa
                    int rowsUpdated = ps.executeUpdate();
                    System.out.println("Filas actualizadas: " + rowsUpdated); // Debe mostrar 1 si se actualizó correctamente

                    return rowsUpdated > 0;
                } catch (Exception e) {
                    System.out.println("Error al actualizar empleado: " + e.getMessage());
                    e.printStackTrace();
                } finally {
                    try {
                        if (ps != null) ps.close();
                        if (con != null) cn.cerrar_conexion();
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                }
                return false;
            }

                public boolean eliminar(int id) {
                    String sql = "DELETE FROM empleados WHERE id_empleado=?";
                    try {
                        con = cn.getConnection();
                        ps = con.prepareStatement(sql);
                        ps.setInt(1, id);
                        int rowsDeleted = ps.executeUpdate();
                        return rowsDeleted > 0; // Retorna true si al menos una fila fue afectada
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                    return false;
                }
                
                public Empleado buscarPorId(int id) {
                    Empleado empleado = null;
                    String sql = "SELECT * FROM empleados WHERE id_empleado = ?";
                    try {
                        con = cn.getConnection();
                        ps = con.prepareStatement(sql);
                        ps.setInt(1, id);
                        rs = ps.executeQuery();
                        if (rs.next()) {
                            empleado = new Empleado();
                            empleado.setId(rs.getInt("id_empleado"));
                            empleado.setNombres(rs.getString("nombres"));
                            empleado.setApellidos(rs.getString("apellidos"));
                            empleado.setDireccion(rs.getString("direccion"));
                            empleado.setTelefono(rs.getString("telefono"));
                            empleado.setDpi(rs.getString("dpi"));
                            empleado.setGenero(rs.getInt("genero"));
                            empleado.setFecha_nacimiento(rs.getString("fecha_nacimiento"));
                            empleado.setIdpuesto(rs.getInt("id_puesto"));
                            empleado.setFecha_inicio_labores(rs.getString("fecha_inicio_labores"));
                            empleado.setFecha_ingreso(rs.getString("fecha_ingreso"));
                            empleado.setUsuario(rs.getString("usuario"));
                        }
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                    return empleado;
                }
}
