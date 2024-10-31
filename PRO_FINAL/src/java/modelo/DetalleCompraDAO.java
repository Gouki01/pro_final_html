package modelo;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

public class DetalleCompraDAO {
    
    public boolean insertarDetalleCompra(CompraDetalle compraDetalle) throws SQLException {
        String sqlInsertDetalle = "INSERT INTO compras_detalle (id_compra, id_producto, cantidad, precio_costo_unitario) VALUES (?, ?, ?, ?)";
        String sqlUpdateStock = "UPDATE productos SET existencia = existencia + ?, precio_costo = ?, precio_venta = ? WHERE id_producto = ?";
        
        Connection conexionBD = null;
        PreparedStatement pstmtInsert = null;
        PreparedStatement pstmtUpdate = null;
        
        try {
            Conexion conexion = new Conexion();
            conexionBD = conexion.getConnection();
            conexionBD.setAutoCommit(false); 

            
            pstmtInsert = conexionBD.prepareStatement(sqlInsertDetalle);
            pstmtInsert.setInt(1, compraDetalle.getIdCompra());
            pstmtInsert.setInt(2, compraDetalle.getIdProducto());
            pstmtInsert.setInt(3, compraDetalle.getCantidad());
            pstmtInsert.setDouble(4, compraDetalle.getPrecioCostoUnitario());
            int rowsInserted = pstmtInsert.executeUpdate();
            
            
            double nuevoPrecioVenta = compraDetalle.getPrecioCostoUnitario() * 1.25;

            
            pstmtUpdate = conexionBD.prepareStatement(sqlUpdateStock);
            pstmtUpdate.setInt(1, compraDetalle.getCantidad());
            pstmtUpdate.setDouble(2, compraDetalle.getPrecioCostoUnitario());
            pstmtUpdate.setDouble(3, nuevoPrecioVenta);
            pstmtUpdate.setInt(4, compraDetalle.getIdProducto());
            int rowsUpdated = pstmtUpdate.executeUpdate();

           
            conexionBD.commit();
            
            return rowsInserted > 0 && rowsUpdated > 0;
            
        } catch (SQLException e) {
            if (conexionBD != null) {
                conexionBD.rollback(); 
            }
            e.printStackTrace();
            throw e;
        } finally {
            if (pstmtInsert != null) pstmtInsert.close();
            if (pstmtUpdate != null) pstmtUpdate.close();
            if (conexionBD != null) {
                conexionBD.setAutoCommit(true);
                conexionBD.close();
            }
        }
    }
}
