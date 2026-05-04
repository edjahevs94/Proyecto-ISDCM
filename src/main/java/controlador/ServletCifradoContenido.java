package controlador;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import util.CifradoUtil;

import java.io.IOException;
import java.io.InputStream;

@WebServlet(name = "ServletCifradoContenido", urlPatterns = {"/ServletCifradoContenido"})
@MultipartConfig(location = "/tmp", maxFileSize = -1, maxRequestSize = -1)
public class ServletCifradoContenido extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuario") == null) {
            response.sendRedirect("sessionExpirada.jsp");
            return;
        }
        request.getRequestDispatcher("cifradoContenido.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuario") == null) {
            response.sendRedirect("sessionExpirada.jsp");
            return;
        }

        String accion = request.getParameter("accion");
        Part filePart = request.getPart("fichero");

        if (filePart == null || filePart.getSize() == 0) {
            request.setAttribute("error", "No se ha seleccionado ningún fichero.");
            request.getRequestDispatcher("cifradoContenido.jsp").forward(request, response);
            return;
        }

        String nombreOriginal = obtenerNombreFichero(filePart);
        String nombreSalida;

        if ("cifrar".equals(accion)) {
            nombreSalida = nombreOriginal + ".cifrado";
        } else {
            nombreSalida = nombreOriginal.endsWith(".cifrado")
                    ? nombreOriginal.substring(0, nombreOriginal.length() - 8)
                    : nombreOriginal + ".descifrado";
        }

        response.setContentType("application/octet-stream");
        response.setHeader("Content-Disposition", "attachment; filename=\"" + nombreSalida + "\"");

        try (InputStream is = filePart.getInputStream()) {
            if ("cifrar".equals(accion)) {
                CifradoUtil.cifrarStream(is, response.getOutputStream());
            } else {
                CifradoUtil.descifrarStream(is, response.getOutputStream());
            }
        } catch (Exception e) {
            // Si ya empezamos a escribir la respuesta no podemos redirigir,
            // solo registramos el error en el log del servidor
            log("Error al procesar fichero: " + e.getMessage(), e);
        }
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
        return "fichero";
    }
}
