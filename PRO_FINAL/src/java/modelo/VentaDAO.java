/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package modelo;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class VentaDAO {
    Conexion conexion = new Conexion();

    
public boolean insertar(Venta venta) {
    String sql = "INSERT INTO ventas (no_factura, serie, fecha_factura, id_cliente, id_empleado, fecha_ingreso) VALUES (?, ?, ?, ?, ?, ?)";
    try (Connection conn = conexion.abrir_conexion();
         PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) { 

        pstmt.setInt(1, venta.getNo_factura());
        pstmt.setString(2, venta.getSerie());
        pstmt.setDate(3, new java.sql.Date(venta.getFecha_factura().getTime()));
        pstmt.setInt(4, venta.getId_cliente());
        pstmt.setInt(5, venta.getId_empleado());
        pstmt.setDate(6, new java.sql.Date(venta.getFecha_ingreso().getTime()));
        
        int affectedRows = pstmt.executeUpdate();
        if (affectedRows > 0) {
            try (ResultSet rs = pstmt.getGeneratedKeys()) {
                if (rs.next()) {
                    venta.setId_venta(rs.getInt(1)); 
                }
            }
            return true; 
        }
    } catch (SQLException e) {
        System.out.println("Error al insertar venta: " + e.getMessage());
        return false; 
    }
    return false; 
}


   
    public List<Venta> listar() {
        List<Venta> lista = new ArrayList<>();
        String sql = "SELECT * FROM ventas";
        try (Connection conn = conexion.abrir_conexion();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                
                Venta venta = new Venta(
                    rs.getInt("id_venta"), 
                    rs.getInt("no_factura"), 
                    rs.getString("serie"), 
                    rs.getDate("fecha_factura"), 
                    rs.getInt("id_cliente"), 
                    rs.getInt("id_empleado"), 
                    rs.getDate("fecha_ingreso") 
                );
                lista.add(venta);
            }
        } catch (SQLException e) {
            System.out.println("Error al listar ventas: " + e.getMessage());
        }
        return lista; 
    }
}
