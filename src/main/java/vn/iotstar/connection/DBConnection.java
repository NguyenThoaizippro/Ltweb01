package vn.iotstar.connection;

import java.sql.Connection;
import java.sql.DriverManager;

public class DBConnection {

    private final String url = "jdbc:sqlserver://localhost\\SQLEXPRESS;databaseName=bt01;trustServerCertificate=true";
    private final String userID = "sa";
    private final String password = "1234";

    public Connection getConnection() throws Exception {
        Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
        return DriverManager.getConnection(url, userID, password);
    }
}
