/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controlador;

import dao.UsuarioDAO;
import modelo.Usuario;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet(name = "servletUsuarios", urlPatterns = {"/servletUsuarios"})
public class ServletUsuarios extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String name = request.getParameter("name");
        String lastname = request.getParameter("lastname");
        String email = request.getParameter("email");
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String repeat_password = request.getParameter("repeatPassword");
        
        if (name == null || name.isEmpty() ||
            email == null || email.isEmpty() ||
            username == null || username.isEmpty() ||
            password == null || password.isEmpty() ||
            lastname == null || lastname.isEmpty())
            {
            
            request.setAttribute("error", "Todos los campos marcados con * son obligatorios.");
            request.getRequestDispatcher("registroUsu.jsp").forward(request, response);
            return;
        }
        
        UsuarioDAO dao = new UsuarioDAO();
        String res = dao.validateFields(email,username);
        
        if(!(repeat_password.equals(password))) {
            request.setAttribute("error", "La contraseñas son diferentes.");
            request.getRequestDispatcher("registroUsu.jsp").forward(request, response);
            return;
        }
        
        if ("email".equals(res)){
            request.setAttribute("error", "El email ya esta en uso.");
            request.getRequestDispatcher("registroUsu.jsp").forward(request, response);
            return;
        }
        
        if("username".equals(res)){
            request.setAttribute("error", "El username ya esta en uso.");
            request.getRequestDispatcher("registroUsu.jsp").forward(request, response);
            return;
        }

        Usuario usuario = new Usuario();
        usuario.setName(name);
        usuario.setLastName(lastname);
        usuario.setEmail(email);
        usuario.setUserName(username);
        usuario.setPassword(password);
        
        /*
        String hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());
        usuario.setPassword(hashedPassword);
        */

        try {
            dao.insertarUsuario(usuario);
            response.sendRedirect("registroExitoso.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("registroUsu.jsp");
        }
    }
}