package modelo;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.List;
import java.util.ArrayList;

public class PuestoDAO {
    Conexion cn = new Conexion();
    Connection con;
    PreparedStatement ps;
    ResultSet rs;

    // Método para listar todos los puestos
    public List<Puesto> listar() {
        List<Puesto> lista = new ArrayList<>();
        String sql = "SELECT * FROM puestos";
        try {
            con = cn.getConnection();
            ps = con.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                Puesto puesto = new Puesto();
                puesto.setId_puesto(rs.getInt("id_puesto"));
                puesto.setPuesto(rs.getString("puesto"));
                lista.add(puesto);
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

    // Método para agregar un nuevo puesto
    public boolean agregar(Puesto p) {
        String sql = "INSERT INTO puestos (puesto) VALUES (?)";
        try {
            con = cn.getConnection();
            ps = con.prepareStatement(sql);
            ps.setString(1, p.getPuesto());
            ps.executeUpdate();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // Método para actualizar un puesto
    public boolean actualizar(Puesto p) {
        String sql = "UPDATE puestos SET puesto = ? WHERE id_puesto = ?";
        try {
            con = cn.getConnection();
            ps = con.prepareStatement(sql);
            ps.setString(1, p.getPuesto());
            ps.setInt(2, p.getId_puesto());
            ps.executeUpdate();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // Método para eliminar un puesto
    public boolean eliminar(int id) {
        String sql = "DELETE FROM puestos WHERE id_puesto = ?";
        try {
            con = cn.getConnection();
            ps = con.prepareStatement(sql);
            ps.setInt(1, id);
            ps.executeUpdate();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // Método para buscar un puesto por ID
    public Puesto buscarPorId(int id) {
        Puesto p = null;
        String sql = "SELECT * FROM puestos WHERE id_puesto = ?";
        try {
            con = cn.getConnection();
            ps = con.prepareStatement(sql);
            ps.setInt(1, id);
            rs = ps.executeQuery();
            if (rs.next()) {
                p = new Puesto();
                p.setId_puesto(rs.getInt("id_puesto"));
                p.setPuesto(rs.getString("puesto"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return p;
    }
}
