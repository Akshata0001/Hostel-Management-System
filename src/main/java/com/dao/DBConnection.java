package com.dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * Utility class for obtaining a JDBC connection to MySQL.
 * Change the constants below to match your local environment.
 */
public class DBConnection {

    private static final String DRIVER   = "com.mysql.cj.jdbc.Driver";
    private static final String DB_URL   = "jdbc:mysql://localhost:3306/hostel_db"
                                         + "?useSSL=false&serverTimezone=UTC"
                                         + "&allowPublicKeyRetrieval=true";
    private static final String DB_USER  = "root";
    private static final String DB_PASS  = "root";   // <-- change as needed

    static {
        try {
            Class.forName(DRIVER);
        } catch (ClassNotFoundException e) {
            throw new RuntimeException("MySQL JDBC Driver not found. "
                + "Ensure mysql-connector-j-*.jar is on the classpath.", e);
        }
    }

    /**
     * Returns a new Connection.  Caller is responsible for closing it.
     */
    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);
    }

    private DBConnection() { /* utility class */ }
}
