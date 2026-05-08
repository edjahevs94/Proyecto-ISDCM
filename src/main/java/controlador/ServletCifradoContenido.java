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
            error(request, response, "No se ha seleccionado ningún fichero.");
            return;
        }

        String nombreOriginal = obtenerNombreFichero(filePart);
        boolean yaEstaEncriptado = nombreOriginal.endsWith(".cifrado");

        if ("cifrar".equals(accion) && yaEstaEncriptado) {
            error(request, response, "El fichero ya está cifrado. No se puede cifrar de nuevo.");
            return;
        }
        if ("descifrar".equals(accion) && !yaEstaEncriptado) {
            error(request, response, "El fichero no está cifrado. Solo se pueden descifrar ficheros con extensión .cifrado.");
            return;
        }

        String nombreSalida = "cifrar".equals(accion)
                ? nombreOriginal + ".cifrado"
                : nombreOriginal.substring(0, nombreOriginal.length() - 8);

        response.setContentType("application/octet-stream");
        response.setHeader("Content-Disposition", "attachment; filename=\"" + nombreSalida + "\"");

        try (InputStream entrada = filePart.getInputStream()) {
            if ("cifrar".equals(accion)) {
                CifradoUtil.cifrarStream(entrada, response.getOutputStream());
            } else {
                CifradoUtil.descifrarStream(entrada, response.getOutputStream());
            }
        } catch (Exception e) {
            log("Error al procesar fichero: " + e.getMessage(), e);
            if (!response.isCommitted()) {
                response.reset();
                error(request, response, "Error al procesar el fichero. Asegúrate de que el fichero es válido y no está corrupto.");
            }
        }
    }

    private void error(HttpServletRequest req, HttpServletResponse res, String msg)
            throws ServletException, IOException {
        req.setAttribute("error", msg);
        req.getRequestDispatcher("cifradoContenido.jsp").forward(req, res);
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
