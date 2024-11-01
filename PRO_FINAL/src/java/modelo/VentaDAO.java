package modelo;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class VentaDAO {
    Conexion conexion = new Conexion();

    public boolean insertar(Venta venta) {
        String sql = "INSERT INTO ventas (no_factura, serie, fecha_factura, id_cliente, id_empleado, fecha_ingreso, precio_total) VALUES (?, ?, ?, ?, ?, ?, ?)";
        Connection conn = null;

        try {
            conn = conexion.getConnection();
            PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);

            pstmt.setInt(1, venta.getNo_factura());
            pstmt.setString(2, venta.getSerie());
            pstmt.setTimestamp(3, new Timestamp(venta.getFecha_factura().getTime()));
            pstmt.setInt(4, venta.getId_cliente());
            pstmt.setInt(5, venta.getId_empleado());
            pstmt.setTimestamp(6, new Timestamp(venta.getFecha_ingreso().getTime()));
            pstmt.setDouble(7, venta.getPrecio_total());

            int affectedRows = pstmt.executeUpdate();
            if (affectedRows > 0) {
                try (ResultSet rs = pstmt.getGeneratedKeys()) {
                    if (rs.next()) {
                        venta.setId_venta(rs.getInt(1));
                    }
                }
                return true;
            } else {
                System.out.println("No rows affected. Check if the table or fields are correct.");
            }
        } catch (SQLException e) {
            System.out.println("SQL Error during `insertar` in `VentaDAO`: " + e.getMessage());
            e.printStackTrace();
            return false;
        } finally {
            if (conn != null) {
                conexion.cerrar_conexion();
            }
        }
        return false;
    }

    public boolean actualizarTotalVenta(int idVenta, double total) {
        String sql = "UPDATE ventas SET precio_total = ? WHERE id_venta = ?";
        Connection conn = null;

        try {
            conn = conexion.getConnection();
            PreparedStatement pstmt = conn.prepareStatement(sql);

            pstmt.setDouble(1, total);
            pstmt.setInt(2, idVenta);

            int affectedRows = pstmt.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException e) {
            System.out.println("Error al actualizar el total de la venta: " + e.getMessage());
            e.printStackTrace();
            return false;
        } finally {
            if (conn != null) {
                conexion.cerrar_conexion();
            }
        }
    }

    // Método opcional para listar todas las ventas, útil para depuración o reportes
    public List<Venta> listarVentas() {
        List<Venta> listaVentas = new ArrayList<>();
        String sql = "SELECT * FROM ventas";
        Connection conn = null;

        try {
            conn = conexion.getConnection();
            Statement stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery(sql);

            while (rs.next()) {
                Venta venta = new Venta();
                venta.setId_venta(rs.getInt("id_venta"));
                venta.setNo_factura(rs.getInt("no_factura"));
                venta.setSerie(rs.getString("serie"));
                venta.setFecha_factura(rs.getTimestamp("fecha_factura"));
                venta.setId_cliente(rs.getInt("id_cliente"));
                venta.setId_empleado(rs.getInt("id_empleado"));
                venta.setFecha_ingreso(rs.getTimestamp("fecha_ingreso"));
                venta.setPrecio_total(rs.getDouble("precio_total"));
                listaVentas.add(venta);
            }
            rs.close();
            stmt.close();
        } catch (SQLException e) {
            System.out.println("Error al listar ventas: " + e.getMessage());
            e.printStackTrace();
        } finally {
            if (conn != null) {
                conexion.cerrar_conexion();
            }
        }
        return listaVentas;
    }
}
