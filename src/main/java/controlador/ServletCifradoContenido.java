package controlador;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import util.CifradoUtil;

import java.io.IOException;
import java.io.InputStream;

@WebServlet(name = "ServletCifradoContenido", urlPatterns = {"/ServletCifradoContenido"})
@MultipartConfig(location = "/tmp", maxFileSize = 104857600)
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
        byte[] datos;
        try (InputStream is = filePart.getInputStream()) {
            datos = is.readAllBytes();
        }

        byte[] resultado;
        String nombreSalida;

        try {
            if ("cifrar".equals(accion)) {
                resultado = CifradoUtil.cifrar(datos);
                nombreSalida = nombreOriginal + ".cifrado";
            } else {
                resultado = CifradoUtil.descifrar(datos);
                if (nombreOriginal.endsWith(".cifrado")) {
                    nombreSalida = nombreOriginal.substring(0, nombreOriginal.length() - 8);
                } else {
                    nombreSalida = nombreOriginal + ".descifrado";
                }
            }
        } catch (Exception e) {
            request.setAttribute("error", "Error al procesar el fichero: " + e.getMessage());
            request.getRequestDispatcher("cifradoContenido.jsp").forward(request, response);
            return;
        }

        response.setContentType("application/octet-stream");
        response.setHeader("Content-Disposition", "attachment; filename=\"" + nombreSalida + "\"");
        response.setContentLength(resultado.length);
        response.getOutputStream().write(resultado);
    }

    private String obtenerNombreFichero(Part part) {
        String cd = part.getHeader("content-disposition");
        for (String token : cd.split(";")) {
            if (token.trim().startsWith("filename")) {
                String nombre = token.substring(token.indexOf('=') + 1).trim().replace("\"", "");
                return nombre.contains("/") ? nombre.substring(nombre.lastIndexOf('/') + 1)
                                           : nombre.contains("\\") ? nombre.substring(nombre.lastIndexOf('\\') + 1)
                                                                    : nombre;
            }
        }
        return "fichero";
    }
}
