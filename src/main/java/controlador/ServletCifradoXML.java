package controlador;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import util.CifradoXMLUtil;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.nio.charset.StandardCharsets;

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

        String accion      = request.getParameter("accion");
        String tagElemento = request.getParameter("tagElemento");
        String modoStr     = request.getParameter("modo");

        Part filePart = request.getPart("ficheroXML");
        if (filePart == null || filePart.getSize() == 0) {
            error(request, response, "Debes seleccionar un fichero XML para " +
                    ("cifrar".equals(accion) ? "cifrar." : "descifrar."));
            return;
        }

        byte[] xmlBytes = filePart.getInputStream().readAllBytes();
        boolean yaEncriptado = contieneEncryptedData(xmlBytes);

        if ("cifrar".equals(accion) && yaEncriptado) {
            error(request, response, "El documento ya está cifrado. Descífralo antes de volver a cifrarlo.");
            return;
        }
        if ("descifrar".equals(accion) && !yaEncriptado) {
            error(request, response, "El documento no está cifrado. No es posible descifrarlo.");
            return;
        }

        String nombreOriginal = obtenerNombre(filePart);
        String nombreSalida = "cifrar".equals(accion)
                ? nombreOriginal + ".cifrado.xml"
                : nombreOriginal.replace(".cifrado.xml", "") + ".descifrado.xml";

        boolean soloContenido = "contenido".equals(modoStr);
        String tag = "documento".equals(modoStr) ? null : tagElemento;

        ByteArrayOutputStream buffer = new ByteArrayOutputStream();
        try {
            if ("cifrar".equals(accion)) {
                CifradoXMLUtil.cifrar(new ByteArrayInputStream(xmlBytes), buffer, tag, soloContenido);
            } else {
                CifradoXMLUtil.descifrar(new ByteArrayInputStream(xmlBytes), buffer);
            }
        } catch (Exception e) {
            log("Error en cifrado XML: " + e.getMessage(), e);
            error(request, response, "Error al procesar el XML: " + e.getMessage());
            return;
        }

        response.setContentType("application/xml");
        response.setHeader("Content-Disposition", "attachment; filename=\"" + nombreSalida + "\"");
        response.setContentLength(buffer.size());
        buffer.writeTo(response.getOutputStream());
    }

    private void error(HttpServletRequest req, HttpServletResponse res, String msg)
            throws ServletException, IOException {
        req.setAttribute("error", msg);
        req.getRequestDispatcher("cifradoXML.jsp").forward(req, res);
    }

    private boolean contieneEncryptedData(byte[] xmlBytes) {
        return new String(xmlBytes, StandardCharsets.UTF_8).contains("EncryptedData");
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
