package modelo;

import java.sql.Timestamp;

public class Compra {
    private int id_compra;
    private int no_orden_compra;
    private int id_proveedor;
    private Timestamp fecha_orden;
    private Timestamp fecha_ingreso;

    
    public Compra(int id_compra, int no_orden_compra, int id_proveedor, Timestamp fecha_orden, Timestamp fecha_ingreso) {
        this.id_compra = id_compra;
        this.no_orden_compra = no_orden_compra;
        this.id_proveedor = id_proveedor;
        this.fecha_orden = fecha_orden;
        this.fecha_ingreso = fecha_ingreso;
    }

    
    public int getId_compra() {
        return id_compra;
    }

    public void setId_compra(int id_compra) {
        this.id_compra = id_compra;
    }

    public int getNoOrdenCompra() {
        return no_orden_compra;
    }

    public void setNoOrdenCompra(int no_orden_compra) {
        this.no_orden_compra = no_orden_compra;
    }

    public int getIdProveedor() {
        return id_proveedor;
    }

    public void setIdProveedor(int id_proveedor) {
        this.id_proveedor = id_proveedor;
    }

    public Timestamp getFechaOrden() {
        return fecha_orden;
    }

    public void setFechaOrden(Timestamp fecha_orden) {
        this.fecha_orden = fecha_orden;
    }

    public Timestamp getFechaIngreso() {
        return fecha_ingreso;
    }

    public void setFechaIngreso(Timestamp fecha_ingreso) {
        this.fecha_ingreso = fecha_ingreso;
    }

    public void setPrecio_total(double totalGeneral) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }
}