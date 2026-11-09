package ma.dentinos;

import ma.dentinos.config.DatabaseConnection;
import java.sql.Connection;

public class DentinosApp {
    public static void main(String[] args) {
        System.out.println("Demarrage de Dentinos...");

        try (Connection conn = DatabaseConnection.getInstance().getConnection()) {
            if (conn != null) {
                System.out.println("✔ Connexion a MySQL reussie !");
                System.out.println("✔ Base de donnees : " + conn.getCatalog());
            }
        } catch (Exception e) {
            System.err.println("❌ Erreur de connexion : " + e.getMessage());
        }
    }
}