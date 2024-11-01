package modelo;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.List;

public class CompraDAO {
    Conexion conexion = new Conexion();

    public boolean insertarCompraYDetalle(int noOrdenCompra, int idProveedor, String fechaOrden, String fechaIngreso,
                                          int idProducto, int cantidad, double precioCostoUnitario) {
        Connection conn = null;
        PreparedStatement pstmtCompra = null;
        PreparedStatement pstmtDetalle = null;
        PreparedStatement pstmtUpdateProducto = null;

        try {
            conn = conexion.getConnection();
            conn.setAutoCommit(false); 

            // Insertamos en la tabla compras
            String sqlCompra = "INSERT INTO compras (no_orden_compra, id_proveedor, fecha_orden, fecha_ingreso) VALUES (?, ?, ?, ?)";
            pstmtCompra = conn.prepareStatement(sqlCompra, PreparedStatement.RETURN_GENERATED_KEYS);
            pstmtCompra.setInt(1, noOrdenCompra);
            pstmtCompra.setInt(2, idProveedor);
            pstmtCompra.setTimestamp(3, Timestamp.valueOf(fechaOrden + " 00:00:00"));
            pstmtCompra.setTimestamp(4, Timestamp.valueOf(fechaIngreso));

            int filasAfectadas = pstmtCompra.executeUpdate();
            if (filasAfectadas == 0) {
                conn.rollback();
                return false;
            }

            ResultSet generatedKeys = pstmtCompra.getGeneratedKeys();
            int idCompra = 0;
            if (generatedKeys.next()) {
                idCompra = generatedKeys.getInt(1);
            } else {
                conn.rollback();
                return false;
            }

           
            String sqlDetalle = "INSERT INTO compras_detalle (id_compra, id_producto, cantidad, precio_costo_unitario) VALUES (?, ?, ?, ?)";
            pstmtDetalle = conn.prepareStatement(sqlDetalle);
            pstmtDetalle.setInt(1, idCompra);
            pstmtDetalle.setInt(2, idProducto);
            pstmtDetalle.setInt(3, cantidad);
            pstmtDetalle.setDouble(4, precioCostoUnitario);

            filasAfectadas = pstmtDetalle.executeUpdate();
            if (filasAfectadas == 0) {
                conn.rollback();
                return false;
            }

            
            String sqlUpdateProducto = "UPDATE productos SET existencia = existencia + ?, precio_costo = ?, precio_venta = ? WHERE id_producto = ?";
            pstmtUpdateProducto = conn.prepareStatement(sqlUpdateProducto);
            double nuevoPrecioVenta = precioCostoUnitario * 1.25;
            pstmtUpdateProducto.setInt(1, cantidad);
            pstmtUpdateProducto.setDouble(2, precioCostoUnitario);
            pstmtUpdateProducto.setDouble(3, nuevoPrecioVenta);
            pstmtUpdateProducto.setInt(4, idProducto);

            filasAfectadas = pstmtUpdateProducto.executeUpdate();
            if (filasAfectadas == 0) {
                conn.rollback();
                return false;
            }

            conn.commit();
            return true;

        } catch (SQLException e) {
            e.printStackTrace();
            try {
                if (conn != null) conn.rollback();
            } catch (SQLException rollbackEx) {
                rollbackEx.printStackTrace();
            }
            return false;
        } finally {
            try {
                if (pstmtCompra != null) pstmtCompra.close();
                if (pstmtDetalle != null) pstmtDetalle.close();
                if (pstmtUpdateProducto != null) pstmtUpdateProducto.close();
                if (conn != null) conn.setAutoCommit(true);
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    public boolean insertarCompra(Compra compra) {
        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            conn = conexion.getConnection();
            String sql = "INSERT INTO compras (no_orden_compra, id_proveedor, fecha_orden, fecha_ingreso) VALUES (?, ?, ?, ?)";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, compra.getNoOrdenCompra());
            pstmt.setInt(2, compra.getIdProveedor());
            pstmt.setTimestamp(3, compra.getFechaOrden());
            pstmt.setTimestamp(4, compra.getFechaIngreso());

            int filasAfectadas = pstmt.executeUpdate();
            return filasAfectadas > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;

        } finally {
            try {
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    public boolean insertarCompraYDetalles(Compra compra, List<CompraDetalle> detalles) {
        Connection conn = null;
        PreparedStatement pstmtCompra = null;
        PreparedStatement pstmtDetalle = null;
        PreparedStatement pstmtUpdateProducto = null;

        try {
            conn = conexion.getConnection();
            conn.setAutoCommit(false); 

            String sqlCompra = "INSERT INTO compras (no_orden_compra, id_proveedor, fecha_orden, fecha_ingreso) VALUES (?, ?, ?, ?)";
            pstmtCompra = conn.prepareStatement(sqlCompra, PreparedStatement.RETURN_GENERATED_KEYS);
            pstmtCompra.setInt(1, compra.getNoOrdenCompra());
            pstmtCompra.setInt(2, compra.getIdProveedor());
            pstmtCompra.setTimestamp(3, compra.getFechaOrden());
            pstmtCompra.setTimestamp(4, compra.getFechaIngreso());

            int filasAfectadas = pstmtCompra.executeUpdate();
            if (filasAfectadas == 0) {
                conn.rollback();
                return false;
            }

            ResultSet generatedKeys = pstmtCompra.getGeneratedKeys();
            int idCompra = 0;
            if (generatedKeys.next()) {
                idCompra = generatedKeys.getInt(1);
            } else {
                conn.rollback();
                return false;
            }

            String sqlDetalle = "INSERT INTO compras_detalle (id_compra, id_producto, cantidad, precio_costo_unitario) VALUES (?, ?, ?, ?)";
            pstmtDetalle = conn.prepareStatement(sqlDetalle);

            for (CompraDetalle detalle : detalles) {
                pstmtDetalle.setInt(1, idCompra);
                pstmtDetalle.setInt(2, detalle.getIdProducto());
                pstmtDetalle.setInt(3, detalle.getCantidad());
                pstmtDetalle.setDouble(4, detalle.getPrecioCostoUnitario());
                pstmtDetalle.executeUpdate();

                // Actualizar producto en cada iteración
                String sqlUpdateProducto = "UPDATE productos SET existencia = existencia + ?, precio_costo = ?, precio_venta = ? WHERE id_producto = ?";
                pstmtUpdateProducto = conn.prepareStatement(sqlUpdateProducto);
                double nuevoPrecioVenta = detalle.getPrecioCostoUnitario() * 1.25;
                pstmtUpdateProducto.setInt(1, detalle.getCantidad());
                pstmtUpdateProducto.setDouble(2, detalle.getPrecioCostoUnitario());
                pstmtUpdateProducto.setDouble(3, nuevoPrecioVenta);
                pstmtUpdateProducto.setInt(4, detalle.getIdProducto());
                pstmtUpdateProducto.executeUpdate();
            }

            conn.commit();
            return true;

        } catch (SQLException e) {
            e.printStackTrace();
            try {
                if (conn != null) conn.rollback();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
            return false;

        } finally {
            try {
                if (pstmtCompra != null) pstmtCompra.close();
                if (pstmtDetalle != null) pstmtDetalle.close();
                if (pstmtUpdateProducto != null) pstmtUpdateProducto.close();
                if (conn != null) conn.setAutoCommit(true);
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}
