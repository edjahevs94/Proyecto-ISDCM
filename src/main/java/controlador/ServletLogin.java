package controlador;

import dao.UsuarioDAO;
import modelo.Usuario;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet(name = "ServletLogin", urlPatterns = {"/servletLogin"})
public class ServletLogin extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        
        UsuarioDAO dao = new UsuarioDAO();
        Usuario usuario = new Usuario();
        usuario.setUserName(username);
        usuario.setPassword(password);

        try {
            if (dao.loginUsuario(usuario)) {
                
                HttpSession session = request.getSession();
                
                // Guardar usuario en sesión (CLAVE para el filtro)
                session.setAttribute("usuario", username);

                UsuarioDAO usuarioDAO = new UsuarioDAO();
                int usuarioId = usuarioDAO.getIdByUsername(username);
                session.setAttribute("usuarioId", usuarioId);

                // ⏱️ 2 minutos (NO 1200)
                session.setMaxInactiveInterval(120);

                response.sendRedirect("servletRegistroVid");
                
            } else {
                request.setAttribute("error", "Usuario o contraseña incorrecto.");
                request.getRequestDispatcher("login.jsp").forward(request, response);
            }
        } catch (SQLException ex) {
            Logger.getLogger(ServletLogin.class.getName()).log(Level.SEVERE, null, ex);
        }
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

    @Override
    public String getServletInfo() {
        return "Short description";
    }
}