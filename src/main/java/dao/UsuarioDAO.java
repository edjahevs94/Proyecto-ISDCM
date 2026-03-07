/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import modelo.Usuario;
import util.ConexionBD;

public class UsuarioDAO {
    
    public boolean loginUsuario(Usuario usuario) throws SQLException{
        
        boolean res = false;
           
        try{
            Connection conn = ConexionBD.getConnection();
            String sql = "SELECT 1 WHERE username = ? AND password = ?";

            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, usuario.getUserName());
            ps.setString(2, usuario.getPassword());
            
            ResultSet rs = ps.executeQuery();
            
            while(rs.next()){
                res = true;
            }
        
        
        } catch(SQLException e){
            e.printStackTrace();
        }
        
        return res;
        
    }
    
    public boolean insertarUsuario(Usuario usuario){

        boolean registrado = false;

        try{

            Connection conn = ConexionBD.getConnection();

            String sql = "INSERT INTO usuarios (name,lastname,email,username,password) VALUES (?,?,?,?,?)";

            PreparedStatement ps = conn.prepareStatement(sql);

            ps.setString(1, usuario.getName());
            ps.setString(2, usuario.getLastName());
            ps.setString(3, usuario.getEmail());
            ps.setString(4, usuario.getUserName());
            ps.setString(5, usuario.getPassword());

            int filas = ps.executeUpdate();

            if(filas > 0){
                registrado = true;
            }

            conn.close();

        }catch(Exception e){
            e.printStackTrace();
        }

        return registrado;
    }
    
    public String validateFields(String email, String username) {
        String resultado = "Usuario Registrado Correctamente";
        String sql = "SELECT email, username FROM usuarios WHERE email = ? OR username = ?";

        try (Connection con = ConexionBD.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, email);
            ps.setString(2, username);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                if (email.equals(rs.getString("email"))) {
                    resultado = "El Email ya esta en uso";
                }
                if (username.equals(rs.getString("username"))) {
                    resultado = "El Username ya esta en uso";
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
            resultado = "error_db";
        }

        return resultado;
    }
    
    
}
