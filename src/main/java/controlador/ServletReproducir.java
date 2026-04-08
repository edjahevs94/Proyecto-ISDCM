package controlador;

import dao.VideoDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import modelo.Video;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/ServletReproducir")
public class ServletReproducir extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Verificar sesión
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuario") == null) {
            response.sendRedirect("sesionExpirada");
            return;
        }

        String idParam = request.getParameter("id");
        if (idParam == null || idParam.isEmpty()) {
            response.sendRedirect("servletListadoVid");
            return;
        }

        try {
            int id = Integer.parseInt(idParam);
            VideoDAO videoDAO = new VideoDAO();
            Video video = videoDAO.obtenerVideoPorId(id);

            if (video == null) {
                response.sendRedirect("servletListadoVid");
                return;
            }

            request.setAttribute("video", video);
            request.getRequestDispatcher("/reproduccion.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect("servletListadoVid");
        } catch (SQLException e) {
            throw new ServletException("Error al obtener el vídeo", e);
        }
    }
}