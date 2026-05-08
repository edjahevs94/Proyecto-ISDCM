package controlador;

import java.io.IOException;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "servletUsuarios", urlPatterns = {"/servletUsuarios"})
public class ServletUsuarios extends HttpServlet {

    private static final String BACKEND_REGISTRO_URL =
            "http://localhost:8080/Proyecto-ISDCM-Backend/api/usuarios/registro";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String name         = request.getParameter("name");
        String lastname     = request.getParameter("lastname");
        String email        = request.getParameter("email");
        String username     = request.getParameter("username");
        String password     = request.getParameter("password");
        String repeatPassword = request.getParameter("repeatPassword");

        if (name == null || name.isEmpty() ||
            lastname == null || lastname.isEmpty() ||
            email == null || email.isEmpty() ||
            username == null || username.isEmpty() ||
            password == null || password.isEmpty()) {
            request.setAttribute("error", "Todos los campos marcados con * son obligatorios.");
            request.getRequestDispatcher("registroUsu.jsp").forward(request, response);
            return;
        }

        if (!password.equals(repeatPassword)) {
            request.setAttribute("error", "Las contraseñas son diferentes.");
            request.getRequestDispatcher("registroUsu.jsp").forward(request, response);
            return;
        }

        String json = "{\"name\":\"" + escapar(name) + "\""
                + ",\"lastname\":\"" + escapar(lastname) + "\""
                + ",\"email\":\"" + escapar(email) + "\""
                + ",\"username\":\"" + escapar(username) + "\""
                + ",\"password\":\"" + escapar(password) + "\"}";

        try {
            HttpURLConnection conn = (HttpURLConnection) new URL(BACKEND_REGISTRO_URL).openConnection();
            conn.setRequestMethod("POST");
            conn.setRequestProperty("Content-Type", "application/json; charset=UTF-8");
            conn.setDoOutput(true);

            try (OutputStream os = conn.getOutputStream()) {
                os.write(json.getBytes(StandardCharsets.UTF_8));
            }

            int status = conn.getResponseCode();
            System.out.println("=================================="+status);
            if (status == HttpURLConnection.HTTP_CREATED) {
                response.sendRedirect("registroExitoso.jsp");
                return;
            }

            // Leer el mensaje de error del backend
            String respuesta = new String(conn.getErrorStream().readAllBytes(), StandardCharsets.UTF_8);

            if (status == HttpURLConnection.HTTP_CONFLICT) {
                if (respuesta.contains("email")) {
                    request.setAttribute("error", "El email ya está en uso.");
                } else {
                    request.setAttribute("error", "El nombre de usuario ya está en uso.");
                }
            } else {
                request.setAttribute("error", "Error al registrar el usuario. Inténtalo de nuevo.");
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "No se pudo conectar con el servidor. Inténtalo más tarde.");
        }

        request.getRequestDispatcher("registroUsu.jsp").forward(request, response);
    }

    private String escapar(String s) {
        return s.replace("\\", "\\\\").replace("\"", "\\\"");
    }
}