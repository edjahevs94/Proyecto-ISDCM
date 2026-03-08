/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controlador;

/**
 *
 * @author alumne
 */
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import modelo.Video;
import dao.VideoDAO;

@WebServlet(name = "servletRegistroVid", urlPatterns = {"/servletRegistroVid"})
public class Servletregistrovid extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Verificar sesión activa
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuario") == null) {
            response.sendRedirect("sessionExpirada.jsp");
            return;
        }

        // Mostrar formulario de registro
        request.getRequestDispatcher("registroVid.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Verificar sesión activa
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuario") == null) {
            response.sendRedirect("sessionExpirada.jsp");
            return;
        }

        request.setCharacterEncoding("UTF-8");

        // Recoger parámetros
        String titulo       = request.getParameter("titulo")       != null ? request.getParameter("titulo").trim()       : "";
        String autor        = request.getParameter("autor")        != null ? request.getParameter("autor").trim()        : "";
        String fecha        = request.getParameter("fechaCreacion")!= null ? request.getParameter("fechaCreacion").trim(): "";
        String duracion     = request.getParameter("duracion")     != null ? request.getParameter("duracion").trim()     : "";
        String reproStr     = request.getParameter("reproducciones")!= null? request.getParameter("reproducciones").trim(): "0";
        String descripcion  = request.getParameter("descripcion")  != null ? request.getParameter("descripcion").trim()  : "";
        String formato      = request.getParameter("formato")      != null ? request.getParameter("formato").trim()      : "";
        String rutaFichero   = request.getParameter("rutaFichero")     != null ? request.getParameter("rutaFichero").trim()     : "";

        // --- Validaciones ---

        // Campos obligatorios vacíos
        if (titulo.isEmpty() || autor.isEmpty() || fecha.isEmpty() ||
            duracion.isEmpty() || descripcion.isEmpty() || formato.isEmpty()) {
            request.setAttribute("error", "Todos los campos marcados con * son obligatorios.");
            request.getRequestDispatcher("registroVid.jsp").forward(request, response);
            return;
        }

        // Formato fecha yyyy-MM-dd
        if (!fecha.matches("\\d{4}-\\d{2}-\\d{2}")) {
            request.setAttribute("error", "Formato de fecha incorrecto. Usa yyyy-MM-dd.");
            request.getRequestDispatcher("registroVid.jsp").forward(request, response);
            return;
        }

        // Formato duración HH:mm:ss
        if (!duracion.matches("\\d{2}:\\d{2}:\\d{2}")) {
            request.setAttribute("error", "Formato de duración incorrecto. Usa HH:mm:ss (ej: 01:30:00).");
            request.getRequestDispatcher("registroVid.jsp").forward(request, response);
            return;
        }

        // Reproducciones debe ser número no negativo
        int reproducciones;
        try {
            reproducciones = Integer.parseInt(reproStr);
            if (reproducciones < 0) throw new NumberFormatException();
        } catch (NumberFormatException e) {
            request.setAttribute("error", "El número de reproducciones debe ser un número positivo.");
            request.getRequestDispatcher("registroVid.jsp").forward(request, response);
            return;
        }
        
        // Validar formato de URL si se ha introducido (no es obligatorio)
        if (!rutaFichero.isEmpty()) {
            boolean esUrlValida = rutaFichero.startsWith("http://") 
                               || rutaFichero.startsWith("https://")
                               || rutaFichero.startsWith("/");
            if (!esUrlValida) {
                request.setAttribute("error", "La ruta del fichero debe ser una URL (http/https) o una ruta local que empiece por /");
                request.getRequestDispatcher("registroVid.jsp").forward(request, response);
                return;
            }
        }

        // Crear objeto Video y guardar
        Video v = new Video(titulo, autor, fecha, duracion, reproducciones, descripcion, formato, rutaFichero);
        VideoDAO dao = new VideoDAO();
        String errorDB = dao.insertarVideo(v);

        if (errorDB != null) {
            request.setAttribute("error", errorDB);
            request.getRequestDispatcher("registroVid.jsp").forward(request, response);
        } else {
            request.setAttribute("exito", "Vídeo \"" + titulo + "\" registrado correctamente.");
            request.getRequestDispatcher("registroVid.jsp").forward(request, response);
        }
    }
}
