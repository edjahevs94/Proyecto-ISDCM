package controlador;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import util.CifradoXMLUtil;

import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Paths;

@WebServlet(name = "ServletCifradoXML", urlPatterns = {"/ServletCifradoXML"})
@MultipartConfig(location = "/tmp", maxFileSize = -1, maxRequestSize = -1)
public class ServletCifradoXML extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuario") == null) {
            response.sendRedirect("sessionExpirada.jsp");
            return;
        }
        request.getRequestDispatcher("cifradoXML.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuario") == null) {
            response.sendRedirect("sessionExpirada.jsp");
            return;
        }

        String accion       = request.getParameter("accion");
        String origenXML    = request.getParameter("origenXML");   // "builtin" o "upload"
        String tagElemento  = request.getParameter("tagElemento"); // puede estar vacío
        String modoStr      = request.getParameter("modo");        // "elemento" o "contenido"
        boolean soloContenido = "contenido".equals(modoStr);

        String nombreSalida;
        InputStream xmlInput = null;

        try {
            // Obtener el XML de entrada
            if ("builtin".equals(origenXML)) {
                String rutaFichero = getServletContext().getRealPath("/xml/didlFilm1.xml");
                if (rutaFichero != null) {
                    xmlInput = Files.newInputStream(Paths.get(rutaFichero));
                } else {
                    xmlInput = getServletContext().getResourceAsStream("/xml/didlFilm1.xml");
                }
                nombreSalida = "cifrar".equals(accion) ? "didlFilm1.cifrado.xml" : "didlFilm1.descifrado.xml";
            } else {
                Part filePart = request.getPart("ficheroXML");
                if (filePart == null || filePart.getSize() == 0) {
                    request.setAttribute("error", "No se ha seleccionado ningún fichero XML.");
                    request.getRequestDispatcher("cifradoXML.jsp").forward(request, response);
                    return;
                }
                xmlInput = filePart.getInputStream();
                String nombreOriginal = obtenerNombre(filePart);
                nombreSalida = "cifrar".equals(accion)
                        ? nombreOriginal + ".cifrado.xml"
                        : nombreOriginal.replace(".cifrado.xml", "") + ".descifrado.xml";
            }

            response.setContentType("application/xml");
            response.setHeader("Content-Disposition", "attachment; filename=\"" + nombreSalida + "\"");

            if ("cifrar".equals(accion)) {
                CifradoXMLUtil.cifrar(xmlInput, response.getOutputStream(), tagElemento, soloContenido);
            } else {
                CifradoXMLUtil.descifrar(xmlInput, response.getOutputStream());
            }

        } catch (Exception e) {
            log("Error en cifrado XML: " + e.getMessage(), e);
            if (!response.isCommitted()) {
                request.setAttribute("error", "Error al procesar el XML: " + e.getMessage());
                request.getRequestDispatcher("cifradoXML.jsp").forward(request, response);
            }
        } finally {
            if (xmlInput != null) try { xmlInput.close(); } catch (IOException ignored) {}
        }
    }

    private String obtenerNombre(Part part) {
        String cd = part.getHeader("content-disposition");
        for (String token : cd.split(";")) {
            if (token.trim().startsWith("filename")) {
                String nombre = token.substring(token.indexOf('=') + 1).trim().replace("\"", "");
                if (nombre.contains("/"))  return nombre.substring(nombre.lastIndexOf('/') + 1);
                if (nombre.contains("\\")) return nombre.substring(nombre.lastIndexOf('\\') + 1);
                return nombre;
            }
        }
        return "fichero.xml";
    }
}
