package modelo;

import java.util.Date;

/**
 *
 * @author jealv
 */
public class Venta {
    private int id_venta; 
    private int no_factura; 
    private String serie; 
    private Date fecha_factura; 
    private int id_cliente; 
    private int id_empleado; 
    private Date fecha_ingreso; 

    
    public Venta() {}

    
    public Venta(int id_venta, int no_factura, String serie, Date fecha_factura, int id_cliente, int id_empleado, Date fecha_ingreso) {
        this.id_venta = id_venta;  
        this.no_factura = no_factura; 
        this.serie = serie;
        this.fecha_factura = fecha_factura; 
        this.id_cliente = id_cliente; 
        this.id_empleado = id_empleado; 
        this.fecha_ingreso = fecha_ingreso;
    }

    
    public int getId_venta() {
        return id_venta;
    }

    public void setId_venta(int id_venta) {
        this.id_venta = id_venta;
    }

    public int getNo_factura() {
        return no_factura;
    }

    public void setNo_factura(int no_factura) { 
        this.no_factura = no_factura;
    }

    public String getSerie() {
        return serie;
    }

    public void setSerie(String serie) {
        this.serie = serie;
    }

    public Date getFecha_factura() {
        return fecha_factura;
    }

    public void setFecha_factura(Date fecha_factura) {
        this.fecha_factura = fecha_factura;
    }

    public int getId_cliente() {
        return id_cliente;
    }

    public void setId_cliente(int id_cliente) {
        this.id_cliente = id_cliente;
    }

    public int getId_empleado() {
        return id_empleado;
    }

    public void setId_empleado(int id_empleado) {
        this.id_empleado = id_empleado;
    }

    public Date getFecha_ingreso() {
        return fecha_ingreso;
    }

    public void setFecha_ingreso(Date fecha_ingreso) {
        this.fecha_ingreso = fecha_ingreso;
    }
}
