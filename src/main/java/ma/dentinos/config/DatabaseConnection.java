package ma.dentinos.config;

import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Properties;

public class DatabaseConnection {

    private static DatabaseConnection instance;
    private String baseUrl;
    private String dbName;
    private String user;
    private String password;

    private DatabaseConnection() {
        loadProperties();
        initializeDatabase();
    }

    public static DatabaseConnection getInstance() {
        if (instance == null) {
            instance = new DatabaseConnection();
        }
        return instance;
    }

    private void loadProperties() {
        try (InputStream input = getClass().getClassLoader().getResourceAsStream("application.properties")) {
            Properties prop = new Properties();
            if (input == null) {
                System.err.println("Erreur: application.properties introuvable.");
                return;
            }
            prop.load(input);
            baseUrl = prop.getProperty("db.url");
            dbName = prop.getProperty("db.dbname", "dentinos_db");
            user = prop.getProperty("db.user");
            password = prop.getProperty("db.password");

            Class.forName(prop.getProperty("db.driver"));
        } catch (Exception ex) {
            ex.printStackTrace();
        }
    }

    private void initializeDatabase() {
        System.out.println("--- Initialisation de la base de donnees ---");

        // 1. Créer la base si elle n'existe pas
        try (Connection conn = DriverManager.getConnection(baseUrl, user, password);
             Statement stmt = conn.createStatement()) {
            stmt.executeUpdate("CREATE DATABASE IF NOT EXISTS " + dbName);
            System.out.println("✔ Base de donnees '" + dbName + "' prete.");
        } catch (SQLException e) {
            System.err.println("❌ Erreur de creation de la base : " + e.getMessage());
            return;
        }

        // 2. Exécuter le schema.sql
        String fullUrl = baseUrl + dbName + "?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true";
        try (Connection conn = DriverManager.getConnection(fullUrl, user, password);
             Statement stmt = conn.createStatement();
             InputStream is = getClass().getClassLoader().getResourceAsStream("db/schema.sql")) {

            if (is == null) {
                System.err.println("❌ schema.sql introuvable.");
                return;
            }

            BufferedReader reader = new BufferedReader(new InputStreamReader(is));
            StringBuilder sb = new StringBuilder();
            String line;
            while ((line = reader.readLine()) != null) {
                if (!line.trim().startsWith("--") && !line.trim().isEmpty()) {
                    sb.append(line).append("\n");
                }
            }

            String[] queries = sb.toString().split(";");
            for (String query : queries) {
                if (!query.trim().isEmpty()) {
                    stmt.execute(query);
                }
            }
            System.out.println("✔ Tables creees et verifiees avec succes.");
        } catch (Exception e) {
            System.err.println("❌ Erreur schema.sql : " + e.getMessage());
        }
    }

    public Connection getConnection() throws SQLException {
        String fullUrl = baseUrl + dbName + "?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true";
        return DriverManager.getConnection(fullUrl, user, password);
    }
}