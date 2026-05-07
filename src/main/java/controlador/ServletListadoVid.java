package controlador;

import dao.VideoDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import modelo.Video;


@WebServlet(name = "servletListadoVid", urlPatterns = {"/servletListadoVid"})
public class ServletListadoVid extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuario") == null) {
            response.sendRedirect("sessionExpirada.jsp");
            return;
        }
        int usuarioId = (int) session.getAttribute("usuarioId");
        VideoDAO dao = new VideoDAO();
        List<Video> lista = dao.listarVideos(usuarioId);
        request.setAttribute("videos", lista);
        request.getRequestDispatcher("listadoVid.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
