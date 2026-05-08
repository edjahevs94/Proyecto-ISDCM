<%-- 
    Document   : listadoVid
    Created on : 7 mar 2026, 20:46:51
    Author     : alumne
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List, modelo.Video" %>
<% String jwtToken = (String) session.getAttribute("jwtToken"); %>
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
                    <a href="ServletCifradoContenido" class="btn btn-outline-secondary">
                        <i class="bi bi-shield-lock me-1"></i>Cifrado
                    </a>
                    <a href="ServletCifradoXML" class="btn btn-outline-secondary">
                        <i class="bi bi-file-earmark-code me-1"></i>Cifrado XML
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
                                    <th>Acciones</th>
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
    
                                    <td>
                                        <button class="btn btn-warning btn-sm"
                                            data-bs-toggle="modal"
                                            data-bs-target="#modalEditar"
                                            onclick="cargarDatosEditar(
                                                '<%= v.getId() %>',
                                                '<%= v.getTitulo() %>',
                                                '<%= v.getAutor() %>',
                                                '<%= v.getFechaCreacion() %>',
                                                '<%= v.getDuracion() %>',
                                                '<%= v.getDescripcion() %>',
                                                '<%= v.getFormato() %>',
                                                '<%= v.getRutaFichero() %>'
                                            )">
                                            <i class="bi bi-pencil"></i>
                                        </button>
                         
                                        
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

        <div class="modal fade" id="modalEditar">
            <div class="modal-dialog">
                <div class="modal-content">

                    <input type="hidden" id="editId"/>

                    <div class="modal-header">
                        <h5 class="modal-title">
                            <i class="bi bi-pencil-square me-2 text-warning"></i>
                            Editar Video
                        </h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>

                    <div class="modal-body">

                        <div class="alert alert-info d-flex align-items-center gap-2 mb-3">
                            <i class="bi bi-info-circle"></i>
                            Modifica los campos del vídeo y guarda los cambios.
                        </div>

                        <div class="row g-3">

                            <div class="col-md-6">
                                <label class="form-label">Título</label>
                                <input type="text" id="editTitulo" class="form-control"/>
                            </div>

                            <div class="col-md-6">
                                <label class="form-label">Autor</label>
                                <input type="text" id="editAutor" class="form-control"/>
                            </div>

                            <div class="col-md-6">
                                <label class="form-label">Fecha</label>
                                <input type="date" id="editFecha" class="form-control"/>
                            </div>

                            <div class="col-md-6">
                                <label class="form-label">Duración</label>
                                <input type="text" id="editDuracion" class="form-control"/>
                            </div>

                            <div class="col-md-6">
                                <label class="form-label">Formato</label>
                                <input type="text" id="editFormato" class="form-control"/>
                            </div>

                            <div class="col-md-6">
                                <label class="form-label">Ruta</label>
                                <input type="text" id="editRuta" class="form-control"/>
                            </div>

                            <div class="col-12">
                                <label class="form-label">Descripción</label>
                                <textarea id="editDescripcion" class="form-control" rows="3"></textarea>
                            </div>

                        </div>

                    </div>

                    <div class="modal-footer">
                        <button class="btn btn-secondary" data-bs-dismiss="modal">
                            Cancelar
                        </button>

                        <button class="btn btn-primary" onclick="actualizarVideo()">
                            Guardar cambios
                        </button>
                    </div>

                </div>
            </div>
        </div>
      
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
        
        <script>
            function cargarDatosEditar(id, titulo, autor, fecha, duracion, descripcion, formato, ruta) {
                document.getElementById("editId").value = id;
                document.getElementById("editTitulo").value = titulo;
                document.getElementById("editAutor").value = autor;
                document.getElementById("editFecha").value = fecha;
                document.getElementById("editDuracion").value = duracion;

                document.getElementById("editDescripcion").value = descripcion;
                document.getElementById("editFormato").value = formato;
                document.getElementById("editRuta").value = ruta;
            }
            
           function actualizarVideo() {
    const id = document.getElementById("editId").value;

    const video = {
        titulo: document.getElementById("editTitulo").value,
        autor: document.getElementById("editAutor").value,
        fechaCreacion: document.getElementById("editFecha").value,
        duracion: document.getElementById("editDuracion").value,
        reproducciones: 0,
        descripcion: document.getElementById("editDescripcion").value,
        formato: document.getElementById("editFormato").value,
        rutaFichero: document.getElementById("editRuta").value
    };

    var JWT_TOKEN = '<%= jwtToken != null ? jwtToken : "" %>';
    fetch("http://localhost:8080/Proyecto-ISDCM-Backend/api/videos/" + id, {
        method: "PUT",
        headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer " + JWT_TOKEN
        },
        body: JSON.stringify(video)
    })
    .then(res => {
        if (!res.ok) throw new Error("Error " + res.status);
        return res.json();
    })
    .then(data => {
        alert("Vídeo actualizado correctamente");
        location.reload();
    })
    .catch(err => alert("Error: " + err.message));
}
            
        </script>

    </body>
</html>
