package modelo;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class Conexion {
    private final String puerto = "3306";
    private final String bd = "proyecto_pro2"; 
    private final String urlConexion = String.format("jdbc:mysql://localhost:%s/%s?serverTimezone=UTC", puerto, bd);
    private final String usuario = "root"; 
    private final String contra = "Gouki1556"; 
    private final String jdbc = "com.mysql.cj.jdbc.Driver";

    public Connection abrir_conexion() {
        Connection conexionBD = null;
        try {
            Class.forName(jdbc);
            conexionBD = DriverManager.getConnection(urlConexion, usuario, contra);
            System.out.println("Conexión Exitosa...");
        } catch (ClassNotFoundException | SQLException ex) {
            System.out.println("Error al abrir la conexión: " + ex.getMessage());
        }
        return conexionBD; 
    }

    public void cerrar_conexion(Connection conexion) {
        try {
            if (conexion != null && !conexion.isClosed()) {
                conexion.close();
                System.out.println("Conexión cerrada.");
            }
        } catch (SQLException ex) {
            System.out.println("Error al cerrar conexión: " + ex.getMessage());
        }
    }
}