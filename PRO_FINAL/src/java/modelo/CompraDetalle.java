package modelo;

public class CompraDetalle {
    private int id_compra_detalle;
    private int id_compra;
    private int id_producto;
    private int cantidad;
    private double precio_costo_unitario;

    
    public CompraDetalle(int idCompraDetalle, int idCompra, int idProducto, int cantidad, double precioCostoUnitario) {
        this.id_compra_detalle = idCompraDetalle;
        this.id_compra = idCompra;
        this.id_producto = idProducto;
        this.cantidad = cantidad;
        this.precio_costo_unitario = precioCostoUnitario;
    }

    public CompraDetalle() {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    public CompraDetalle(int i, int i0, int idProducto, int cantidad, double precioCostoUnitario, double subtotal) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    
    public int getIdCompraDetalle() {
        return id_compra_detalle;
    }

    public void setIdCompraDetalle(int idCompraDetalle) {
        this.id_compra_detalle = idCompraDetalle;
    }

    public int getIdCompra() {
        return id_compra;
    }

    public void setIdCompra(int idCompra) {
        this.id_compra = idCompra;
    }

    public int getIdProducto() {
        return id_producto;
    }

    public void setIdProducto(int idProducto) {
        this.id_producto = idProducto;
    }

    public int getCantidad() {
        return cantidad;
    }

    public void setCantidad(int cantidad) {
        this.cantidad = cantidad;
    }

    public double getPrecioCostoUnitario() {
        return precio_costo_unitario;
    }

    public void setPrecioCostoUnitario(double precioCostoUnitario) {
        this.precio_costo_unitario = precioCostoUnitario;
    }
}
