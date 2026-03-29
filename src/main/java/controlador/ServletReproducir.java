/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 */
package controlador;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

/**
 * Servlet único para consumir el servicio REST y mostrar página de reproducción
 *
 * GET /ServletReproducir?id=ID_VIDEO
 * POST /ServletReproducir - Incrementa reproducciones
 *
 * @author alumne
 */
@WebServlet(name = "ServletReproducir", urlPatterns = {"/ServletReproducir"})
public class ServletReproducir extends HttpServlet {

    private static final String BACKEND_URL = "http://localhost:8080/Proyecto-ISDCM-Backend/api/videos";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuario") == null) {
            response.sendRedirect("sessionExpirada.jsp");
            return;
        }

        String idParam = request.getParameter("id");
        if (idParam == null || idParam.isEmpty()) {
            request.setAttribute("error", "ID de vídeo no válido");
            request.getRequestDispatcher("reproduccion.jsp").forward(request, response);
            return;
        }

        int videoId;
        try {
            videoId = Integer.parseInt(idParam);
        } catch (NumberFormatException e) {
            request.setAttribute("error", "ID de vídeo no válido");
            request.getRequestDispatcher("reproduccion.jsp").forward(request, response);
            return;
        }

        // Obtener información del vídeo desde el servicio REST
        String jsonVideo = ejecutarGet(BACKEND_URL + "/" + videoId);
        request.setAttribute("videoJson", jsonVideo);

        request.getRequestDispatcher("reproduccion.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuario") == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }

        String idParam = request.getParameter("id");
        if (idParam == null || idParam.isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        int videoId;
        try {
            videoId = Integer.parseInt(idParam);
        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        // Llamar al servicio REST para incrementar reproducciones
        String resultado = ejecutarPost(BACKEND_URL + "/" + videoId + "/reproduccion");

        response.setContentType("application/json");
        response.getWriter().write(resultado);
    }

    private String ejecutarGet(String url) {
        try {
            java.net.URI uri = new java.net.URI(url);
            java.net.http.HttpClient client = java.net.http.HttpClient.newHttpClient();
            java.net.http.HttpRequest request = java.net.http.HttpRequest.newBuilder()
                    .uri(uri)
                    .GET()
                    .build();

            java.net.http.HttpResponse<String> response = client.send(request,
                    java.net.http.HttpResponse.BodyHandlers.ofString());
            return response.body();
        } catch (Exception e) {
            e.printStackTrace();
            return "{\"error\":\"Error al conectar con el servicio\"}";
        }
    }

    private String ejecutarPost(String url) {
        try {
            java.net.URI uri = new java.net.URI(url);
            java.net.http.HttpClient client = java.net.http.HttpClient.newHttpClient();
            java.net.http.HttpRequest request = java.net.http.HttpRequest.newBuilder()
                    .uri(uri)
                    .POST(java.net.http.HttpRequest.BodyPublishers.noBody())
                    .header("Content-Type", "application/json")
                    .build();

            java.net.http.HttpResponse<String> response = client.send(request,
                    java.net.http.HttpResponse.BodyHandlers.ofString());
            return response.body();
        } catch (Exception e) {
            e.printStackTrace();
            return "{\"estado\":\"error\",\"mensaje\":\"Error en la petición\"}";
        }
    }
}
