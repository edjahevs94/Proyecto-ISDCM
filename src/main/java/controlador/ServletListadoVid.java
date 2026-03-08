/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controlador;

/**
 *
 * @author alumne
 */


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

        // Verificar sesión activa
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuario") == null) {
            response.sendRedirect("sessionExpirada.jsp");
            return;
        }

        // Obtener lista de vídeos y pasar a la vista
        VideoDAO dao = new VideoDAO();
        List<Video> lista = dao.listarVideos();
        request.setAttribute("videos", lista);
        request.getRequestDispatcher("listadoVid.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
