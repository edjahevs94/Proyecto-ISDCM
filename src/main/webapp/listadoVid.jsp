<%-- 
    Document   : listadoVid
    Created on : 7 mar 2026, 20:46:51
    Author     : alumne
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List, modelo.Video" %>
<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8"/>
        <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
        <title>Listado de Vídeos</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"/>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet"/>
    </head>
    <body class="bg-light py-4">

        <div class="container">

                               
            <div class="text-end mb-3">

                <div class="dropdown d-inline-block">
                    <button class="btn btn-secondary rounded-circle fw-bold"
                            data-bs-toggle="dropdown"
                            style="width:50px;height:50px;">
                        ${sessionScope.usuario}
                    </button>

                    <ul class="dropdown-menu dropdown-menu-end">
                        <li>
                            <a class="dropdown-item text-danger" href="ServletLogout">
                                <i class="bi bi-box-arrow-right me-2"></i>Cerrar sesión
                            </a>
                        </li>
                    </ul>
                </div>

            </div>
            
         
            <div class="d-flex justify-content-between align-items-center mb-4">

                <div>
                    <h3 class="fw-bold mb-0">
                        <i class="bi bi-collection-play text-primary me-2"></i>Listado de Vídeos
                    </h3>
                </div>

                <div class="d-flex gap-2">
                    <a href="ServletBusqueda" class="btn btn-outline-primary">
                        <i class="bi bi-search me-1"></i>Buscar
                    </a>
                    <a href="servletRegistroVid" class="btn btn-primary">
                        <i class="bi bi-plus-circle me-1"></i> Registrar vídeo
                    </a>
                </div>

            </div>

          
            <div class="card border-0 shadow-sm rounded-3">
                <div class="card-body p-0">
                    <%
                        List<Video> videos = (List<Video>) request.getAttribute("videos");
                        if (videos == null || videos.isEmpty()) {
                    %>
                    <div class="text-center py-5 text-muted">
                        <i class="bi bi-camera-video-off fs-1 d-block mb-2"></i>
                        <p class="mb-0">No hay vídeos registrados aún.</p>
                        <a href="servletRegistroVid" class="btn btn-outline-primary btn-sm mt-3">
                            Registrar el primero
                        </a>
                    </div>
                    <%
                        } else {
                    %>
                    <div class="table-responsive">
                        <table class="table table-hover align-middle mb-0">
                            <thead class="table-primary">
                                <tr>
                                    <th class="ps-3">#</th>
                                    <th>Título</th>
                                    <th>Autor</th>
                                    <th>Fecha</th>
                                    <th>Duración</th>
                                    <th>Reproducciones</th>
                                    <th>Formato</th>
                                    <th>Descripción</th>
                                    <th>Ruta/URL</th>
                                </tr>
                            </thead>
                            <tbody>
                                <%
                                    for (Video v : videos) {
                                %>
                                <tr>
                                    <td class="ps-3 text-muted small"><%= v.getId() %></td>
                                    <td class="fw-semibold"><%= v.getTitulo() %></td>
                                    <td>
                                        <i class="bi bi-person-circle text-secondary me-1"></i>
                                        <%= v.getAutor() %>
                                    </td>
                                    <td class="text-muted small">
                                        <i class="bi bi-calendar3 me-1"></i><%= v.getFechaCreacion() %>
                                    </td>
                                    <td class="text-muted small">
                                        <i class="bi bi-stopwatch me-1"></i><%= v.getDuracion() %>
                                    </td>
                                    <td>
                                        <span class="badge bg-primary rounded-pill">
                                            <i class="bi bi-play-fill me-1"></i><%= v.getReproducciones() %>
                                        </span>
                                    </td>
                                    <td>
                                        <span class="badge bg-primary text-uppercase">
                                            <%= v.getFormato() %>
                                        </span>
                                    </td>
                                    <td class="text-muted small"><%= v.getDescripcion() %></td>
    
                                    <td class="text-muted small">
                                        <% if (v.getRutaFichero() != null && !v.getRutaFichero().isEmpty()) { %>
                                        <a href="ServletReproducir?id=<%= v.getId() %>" class="btn btn-outline-primary btn-sm">
                                            <i class="bi bi-play-circle me-1"></i>Reproducir
                                        </a>
                                        <% } else { %>
                                        <span class="text-muted fst-italic">Sin ruta</span>
                                        <% } %>
                                    </td>  
                                </tr>
                                <%
                                    }
                                %>
                            </tbody>
                        </table>
                    </div>
                    <div class="px-3 py-2 text-muted small border-top">
                        Total: <strong><%= videos.size() %></strong> vídeo(s)
                    </div>
                    <%
                        }
                    %>
                </div>
            </div>

        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
