/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

/**
 *
 * @author alumne
 */
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import modelo.Video;
import util.ConexionBD;
import static util.ConexionBD.getConnection;
/**
 *
 * @author alumne
 */




public class VideoDAO {


    /**
     * Inserta un vídeo en la BD.
     * @return null si fue correcto, o mensaje de error si falló.
     */
    public String insertarVideo(Video v) {
        // Comprobar si ya existe un vídeo con el mismo título y autor
        String sqlCheck = "SELECT ID FROM Videos WHERE Titulo = ? AND Autor = ?";
        String sqlInsert = "INSERT INTO Videos (Titulo, Autor, \"Fecha creacion\", " +
                           "Duracion, Reproducciones, Descripcion, Formato) " +
                           "VALUES (?, ?, ?, ?, ?, ?, ?)";

        try (Connection con = ConexionBD.getConnection();) {

            // 1. Comprobar duplicado
            PreparedStatement psCheck = con.prepareStatement(sqlCheck);
            psCheck.setString(1, v.getTitulo());
            psCheck.setString(2, v.getAutor());
            ResultSet rs = psCheck.executeQuery();
            if (rs.next()) {
                return "Ya existe un vídeo con ese título y autor.";
            }

            // 2. Insertar
            PreparedStatement psInsert = con.prepareStatement(sqlInsert);
            psInsert.setString(1, v.getTitulo());
            psInsert.setString(2, v.getAutor());
            psInsert.setDate(3, Date.valueOf(v.getFechaCreacion()));
            psInsert.setTime(4, Time.valueOf(v.getDuracion()));
            psInsert.setInt(5, v.getReproducciones());
            psInsert.setString(6, v.getDescripcion());
            psInsert.setString(7, v.getFormato());
            psInsert.executeUpdate();

            return null; // éxito

        } catch (SQLException e) {
            return "Error en la base de datos: " + e.getMessage();
        }
    }

    /**
     * Devuelve todos los vídeos de la BD.
     */
    public List<Video> listarVideos() {
        List<Video> lista = new ArrayList<>();
        String sql = "SELECT * FROM Videos";

        try (Connection con = getConnection();
             Statement st = con.createStatement();
             ResultSet rs = st.executeQuery(sql)) {

            while (rs.next()) {
                Video v = new Video();
                v.setId(rs.getInt("ID"));
                v.setTitulo(rs.getString("Titulo"));
                v.setAutor(rs.getString("Autor"));
                v.setFechaCreacion(rs.getDate("Fecha creacion").toString());
                v.setDuracion(rs.getTime("Duracion").toString());
                v.setReproducciones(rs.getInt("Reproducciones"));
                v.setDescripcion(rs.getString("Descripcion"));
                v.setFormato(rs.getString("Formato"));
                lista.add(v);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return lista;
    }
}
