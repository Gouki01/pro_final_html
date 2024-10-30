package modelo;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

public class DetalleVentaDAO {
   
    public boolean insertarDetalle(int idVenta, int idProducto, int cantidad, double precioUnitario) {
        String sql = "INSERT INTO ventas_detalle (id_venta, id_producto, cantidad, precio_unitario) VALUES (?, ?, ?, ?)";
        Conexion conexion = new Conexion();
        Connection conn = null;

        try {
            conn = conexion.getConnection(); // Obtener la conexión de la clase Conexion
            PreparedStatement pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, idVenta);
            pstmt.setInt(2, idProducto);
            pstmt.setInt(3, cantidad);
            pstmt.setDouble(4, precioUnitario);
            int filasAfectadas = pstmt.executeUpdate();
            return filasAfectadas > 0; 
        } catch (SQLException e) {
            System.out.println("Error al insertar detalle de venta: " + e.getMessage());
            return false; 
        } finally {
            if (conn != null) {
                conexion.cerrar_conexion(); // Cerrar la conexión sin parámetros
            }
        }
    }
}
