package controlador;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebFilter("/*")
public class AuthFilter implements Filter {

    @Override
    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
        throws IOException, ServletException {

        HttpServletRequest request = (HttpServletRequest) req;
        HttpServletResponse response = (HttpServletResponse) res;

        HttpSession session = request.getSession(false);

        boolean loggedIn = (session != null && session.getAttribute("usuario") != null);
        String uri = request.getRequestURI();

        boolean loginRequest = uri.contains("login.jsp")
                            || uri.contains("servletLogin")
                            || uri.contains("registroUsu.jsp")
                            || uri.contains("servletUsuarios")
                            || uri.contains("registroExitoso.jsp")
                            || uri.contains("css")
                            || uri.contains("js")
                            || uri.contains("images");

        if (loggedIn || loginRequest) {

            response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
            response.setHeader("Pragma", "no-cache");
            response.setDateHeader("Expires", 0);

            chain.doFilter(req, res);

        } else {
            response.sendRedirect("login.jsp");
        }
    }
}