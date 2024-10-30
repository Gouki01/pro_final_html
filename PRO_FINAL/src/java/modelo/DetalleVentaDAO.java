package modelo;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

public class DetalleVentaDAO {
    // Método para insertar un nuevo detalle de venta
    public boolean insertarDetalle(int idVenta, int idProducto, int cantidad, double precioUnitario) {
        String sql = "INSERT INTO ventas_detalle (id_venta, id_producto, cantidad, precio_unitario) VALUES (?, ?, ?, ?)";
        Connection conn = null;

        try {
            // Abrir conexión
            Conexion conexion = new Conexion();
            conn = conexion.abrir_conexion();
            PreparedStatement pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, idVenta);
            pstmt.setInt(2, idProducto);
            pstmt.setInt(3, cantidad);
            pstmt.setDouble(4, precioUnitario);
            int filasAfectadas = pstmt.executeUpdate();
            return filasAfectadas > 0; // Retorna true si se insertó al menos una fila
        } catch (SQLException e) {
            System.out.println("Error al insertar detalle de venta: " + e.getMessage());
            return false; // Retorna false si hubo un error
        } finally {
            if (conn != null) {
                new Conexion().cerrar_conexion(conn); // Cerrar la conexión
            }
        }
    }
}