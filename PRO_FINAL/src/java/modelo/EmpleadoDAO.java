package modelo;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

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
}
