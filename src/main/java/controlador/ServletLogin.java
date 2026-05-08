package controlador;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet(name = "ServletLogin", urlPatterns = {"/servletLogin"})
public class ServletLogin extends HttpServlet {

    private static final String BACKEND_LOGIN_URL =
            "http://localhost:8080/Proyecto-ISDCM-Backend/api/usuarios/login";

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        if (username == null || username.isEmpty() || password == null || password.isEmpty()) {
            request.setAttribute("error", "Usuario y contraseña son obligatorios.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }

        String json = "{\"username\":\"" + escapar(username) + "\""
                + ",\"password\":\"" + escapar(password) + "\"}";

        try {
            HttpURLConnection conn = (HttpURLConnection) new URL(BACKEND_LOGIN_URL).openConnection();
            conn.setRequestMethod("POST");
            conn.setRequestProperty("Content-Type", "application/json; charset=UTF-8");
            conn.setDoOutput(true);

            try (OutputStream os = conn.getOutputStream()) {
                os.write(json.getBytes(StandardCharsets.UTF_8));
            }

            int status = conn.getResponseCode();

            if (status == HttpURLConnection.HTTP_OK) {
                InputStream is = conn.getInputStream();
                String respuesta = new String(is.readAllBytes(), StandardCharsets.UTF_8);

                int id = extraerInt(respuesta, "id");
                String usernameRespuesta = extraerString(respuesta, "username");

                HttpSession session = request.getSession();
                session.setAttribute("usuario", usernameRespuesta);
                session.setAttribute("usuarioId", id);
                session.setMaxInactiveInterval(120);

                response.sendRedirect("servletRegistroVid");
                return;
            }

            if (status == HttpURLConnection.HTTP_UNAUTHORIZED) {
                request.setAttribute("error", "Usuario o contraseña incorrecto.");
            } else {
                request.setAttribute("error", "Error al conectar con el servidor. Inténtalo más tarde.");
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "No se pudo conectar con el servidor. Inténtalo más tarde.");
        }

        request.getRequestDispatcher("login.jsp").forward(request, response);
    }

    private int extraerInt(String json, String clave) {
        String patron = "\"" + clave + "\":";
        int idx = json.indexOf(patron);
        if (idx == -1) return -1;
        int start = idx + patron.length();
        int end = start;
        while (end < json.length() && (Character.isDigit(json.charAt(end)) || json.charAt(end) == '-')) {
            end++;
        }
        try { return Integer.parseInt(json.substring(start, end)); } catch (NumberFormatException e) { return -1; }
    }

    private String extraerString(String json, String clave) {
        String patron = "\"" + clave + "\":\"";
        int idx = json.indexOf(patron);
        if (idx == -1) return "";
        int start = idx + patron.length();
        int end = json.indexOf("\"", start);
        return end == -1 ? "" : json.substring(start, end);
    }

    private String escapar(String s) {
        return s.replace("\\", "\\\\").replace("\"", "\\\"");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }
}