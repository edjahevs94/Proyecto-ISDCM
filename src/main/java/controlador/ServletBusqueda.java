package controlador;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.net.URLEncoder;
import java.net.HttpURLConnection;

@WebServlet(name = "ServletBusqueda", urlPatterns = {"/ServletBusqueda"})
public class ServletBusqueda extends HttpServlet {

    private static final String BACKEND_URL = "http://localhost:8080/Proyecto-ISDCM-Backend/api/videos/buscar";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        System.out.println("Ingreso al servlet.........");

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuario") == null) {
            response.sendRedirect("sessionExpirada.jsp");
            return;
        }

        String titulo = request.getParameter("titulo");
        String autor = request.getParameter("autor");
        String fecha = request.getParameter("fecha");

        StringBuilder url = new StringBuilder(BACKEND_URL);
        url.append("?");

        if (titulo != null && !titulo.isEmpty()) {
            url.append("titulo=").append(URLEncoder.encode(titulo, "UTF-8")).append("&");
        }
        if (autor != null && !autor.isEmpty()) {
            url.append("autor=").append(URLEncoder.encode(autor, "UTF-8")).append("&");
        }
        if (fecha != null && !fecha.isEmpty()) {
            url.append("fecha=").append(URLEncoder.encode(fecha, "UTF-8")).append("&");
        }

        if (url.charAt(url.length() - 1) == '&') {
            url.deleteCharAt(url.length() - 1);
        }

        String jsonResultados = ejecutarGet(url.toString());

        request.setAttribute("titulo", titulo != null ? titulo : "");
        request.setAttribute("autor", autor != null ? autor : "");
        request.setAttribute("fecha", fecha != null ? fecha : "");
        request.setAttribute("jsonResultados", jsonResultados);

        request.getRequestDispatcher("busqueda.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

    private String ejecutarGet(String url) {
        try {
            java.net.URI uri = new java.net.URI(url);
            java.net.http.HttpClient client = java.net.http.HttpClient.newHttpClient();
            java.net.http.HttpRequest request = java.net.http.HttpRequest.newBuilder()
                    .uri(uri)
                    .GET()
                    .build();

            java.net.http.HttpResponse<String> respuesta = client.send(request,
                    java.net.http.HttpResponse.BodyHandlers.ofString());
            return respuesta.body();
        } catch (Exception e) {
            e.printStackTrace();
            return "[]";
        }
    }
}
