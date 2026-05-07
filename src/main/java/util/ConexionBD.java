package util;

import java.sql.Connection;
import java.sql.DriverManager;

public class ConexionBD {
    private static final String URL = "jdbc:derby://localhost:1527/isdcm"; 
    private static final String USER = "isdcm";
    private static final String PASS = "isdcm";
    
    public static Connection getConnection(){
        Connection conn = null;
        
        try{
            Class.forName("org.apache.derby.client.ClientAutoloadedDriver");
            conn = DriverManager.getConnection(URL, USER, PASS);
        }
        catch(Exception e){
            e.printStackTrace();
        }
        
        return conn;
        
    }
    
}
