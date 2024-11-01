package modelo;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class Conexion {
    private Connection conexionBD;
    private final String puerto = "3306";
    private final String bd = "proyecto_pro2";
    private final String urlConexion = String.format("jdbc:mysql://localhost:%s/%s?serverTimezone=UTC", puerto, bd);
    private final String usuario = "root";
    private final String contra = "123456";
    private final String jdbc = "com.mysql.cj.jdbc.Driver";

    public void abrir_conexion() {
        try {
            Class.forName(jdbc);
            conexionBD = DriverManager.getConnection(urlConexion, usuario, contra);
            System.out.println("Conexion Exitosa...");
        } catch (ClassNotFoundException | SQLException ex) {
            System.out.println("Error: " + ex.getMessage());
        }
    }

    public void cerrar_conexion() {
        try {
            if (conexionBD != null && !conexionBD.isClosed()) {
                conexionBD.close();
                System.out.println("Conexion Cerrada...");
            }
        } catch (SQLException ex) {
            System.out.println("Error: " + ex.getMessage());
        }
    }

    public Connection getConnection() {
        if (conexionBD == null) {
            abrir_conexion();
        }
        return conexionBD;
    }
}
