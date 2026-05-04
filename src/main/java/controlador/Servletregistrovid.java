package controlador;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import modelo.Video;
import dao.VideoDAO;

@WebServlet(name = "servletRegistroVid", urlPatterns = {"/servletRegistroVid"})
@MultipartConfig(maxFileSize = 524288000) // 500 MB
public class Servletregistrovid extends HttpServlet {

    private static final java.util.Set<String> FORMATOS_VALIDOS =
        new java.util.HashSet<>(java.util.Arrays.asList("mp4", "ogg", "avi", "mkv", "mov", "webm"));

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuario") == null) {
            response.sendRedirect("sessionExpirada.jsp");
            return;
        }
        request.getRequestDispatcher("registroVid.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuario") == null) {
            response.sendRedirect("sessionExpirada.jsp");
            return;
        }

        request.setCharacterEncoding("UTF-8");

        String titulo      = param(request, "titulo");
        String autor       = param(request, "autor");
        String fecha       = param(request, "fechaCreacion");
        String duracion    = param(request, "duracion");
        String descripcion = param(request, "descripcion");
        String formato     = param(request, "formato");
        String rutaFichero = param(request, "rutaFichero");

        // Intentar procesar fichero subido
        Part filePart = request.getPart("ficheroVideo");
        if (filePart != null && filePart.getSize() > 0) {
            String nombreOriginal = obtenerNombreFichero(filePart);
            String extension = extensionDe(nombreOriginal);

            if (!FORMATOS_VALIDOS.contains(extension)) {
                request.setAttribute("error", "Formato no soportado: " + extension +
                        ". Usa: " + String.join(", ", FORMATOS_VALIDOS));
                request.getRequestDispatcher("registroVid.jsp").forward(request, response);
                return;
            }

            // Directorio fijo en el sistema de ficheros (getRealPath es null en GlassFish)
            String dirPath = System.getProperty("user.home") + "/isdcm_videos/";
            File dir = new File(dirPath);
            if (!dir.exists()) dir.mkdirs();

            // Nombre único para evitar colisiones
            String nombreGuardado = System.currentTimeMillis() + "_" + nombreOriginal;
            try (InputStream is = filePart.getInputStream()) {
                Files.copy(is, Paths.get(dirPath, nombreGuardado), StandardCopyOption.REPLACE_EXISTING);
            }

            // URL servida por ServletVideo
            rutaFichero = request.getContextPath() + "/video/" + nombreGuardado;
            // El formato se autodetecta de la extensión del fichero subido
            formato = extension;
        }

        // Validaciones campos obligatorios
        if (titulo.isEmpty() || autor.isEmpty() || fecha.isEmpty() ||
                duracion.isEmpty() || descripcion.isEmpty() || formato.isEmpty()) {
            request.setAttribute("error", "Todos los campos marcados con * son obligatorios.");
            request.getRequestDispatcher("registroVid.jsp").forward(request, response);
            return;
        }

        if (!fecha.matches("\\d{4}-\\d{2}-\\d{2}")) {
            request.setAttribute("error", "Formato de fecha incorrecto. Usa yyyy-MM-dd.");
            request.getRequestDispatcher("registroVid.jsp").forward(request, response);
            return;
        }

        if (!duracion.matches("\\d{2}:\\d{2}:\\d{2}")) {
            request.setAttribute("error", "Formato de duración incorrecto. Usa HH:mm:ss (ej: 01:30:00).");
            request.getRequestDispatcher("registroVid.jsp").forward(request, response);
            return;
        }

        // Validar ruta externa si se introdujo manualmente (no vino de subida)
        if (filePart == null || filePart.getSize() == 0) {
            if (!rutaFichero.isEmpty()) {
                boolean valida = rutaFichero.startsWith("http://")
                        || rutaFichero.startsWith("https://")
                        || rutaFichero.startsWith("/");
                if (!valida) {
                    request.setAttribute("error", "La ruta debe ser una URL (http/https) o empezar por /");
                    request.getRequestDispatcher("registroVid.jsp").forward(request, response);
                    return;
                }
            }
        }

        int usuarioId = (int) session.getAttribute("usuarioId");
        Video v = new Video(titulo, autor, fecha, duracion, 0, descripcion, formato, rutaFichero);
        v.setUsuarioId(usuarioId);

        String resultado = new VideoDAO().insertarVideo(v);
        if (!resultado.equalsIgnoreCase("creado_exitosamente")) {
            request.setAttribute("error", resultado);
            request.getRequestDispatcher("registroVid.jsp").forward(request, response);
        } else {
            request.setAttribute("exito", "Vídeo \"" + titulo + "\" registrado correctamente.");
            request.getRequestDispatcher("registroVid.jsp").forward(request, response);
        }
    }

    private String param(HttpServletRequest req, String name) {
        String v = req.getParameter(name);
        return v != null ? v.trim() : "";
    }

    private String extensionDe(String nombre) {
        int dot = nombre.lastIndexOf('.');
        return (dot >= 0) ? nombre.substring(dot + 1).toLowerCase() : "";
    }

    private String obtenerNombreFichero(Part part) {
        String cd = part.getHeader("content-disposition");
        for (String token : cd.split(";")) {
            if (token.trim().startsWith("filename")) {
                String nombre = token.substring(token.indexOf('=') + 1).trim().replace("\"", "");
                if (nombre.contains("/"))  return nombre.substring(nombre.lastIndexOf('/') + 1);
                if (nombre.contains("\\")) return nombre.substring(nombre.lastIndexOf('\\') + 1);
                return nombre;
            }
        }
        return "video";
    }
}
