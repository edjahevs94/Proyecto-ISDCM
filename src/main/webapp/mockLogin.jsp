<%-- 
    Document   : mockLogin
    Created on : 7 mar 2026, 17:19:22
    Author     : alumne
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%
    session.setAttribute("usuario", "usuarioPrueba");
    response.sendRedirect("servletRegistroVid");
%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <h1>Hello World!</h1>
    </body>
</html>
