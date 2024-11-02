package modelo;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

public class DetalleVentaDAO {
   
    public boolean insertarDetalle(int idVenta, int idProducto, int cantidad, double precioUnitario) {
        String sql = "INSERT INTO ventas_detalle (id_venta, id_producto, cantidad, precio_unitario, precio_total) VALUES (?, ?, ?, ?, ?)";
        Conexion conexion = new Conexion();
        Connection conn = null;

        try {
            conn = conexion.getConnection(); // Obtener la conexión de la clase Conexion
            PreparedStatement pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, idVenta);
            pstmt.setInt(2, idProducto);
            pstmt.setInt(3, cantidad);
            pstmt.setDouble(4, precioUnitario);

            // Calcular el precio total y asignarlo al campo correspondiente
            double precioTotal = cantidad * precioUnitario;
            pstmt.setDouble(5, precioTotal);

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

    public boolean insertarDetalle(int id_venta, int id_producto, int cantidad, double precio_unitario, double subtotal) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }
}
