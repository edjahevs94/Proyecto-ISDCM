<%--
    Document   : busqueda
    Created on : 29 mar 2026
    Author     : alumne
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="jakarta.servlet.http.HttpServletRequest" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Búsqueda de Vídeos</title>

    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"/>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet"/>

    <style>
        .search-card {
            max-width: 800px;
        }
        .result-item {
            transition: all 0.2s ease;
            background: #ffffff;
        }
        .result-item:hover {
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
        }
    </style>
</head>
<body class="bg-light py-4">

<div class="container">

    <!-- Header con usuario -->
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

    <div class="search-card mx-auto">

        <div class="d-flex justify-content-between align-items-center mb-4">
            <h3 class="fw-bold mb-0 text-primary">
                <i class="bi bi-search me-2"></i>Búsqueda de Vídeos
            </h3>
            <a href="servletListadoVid" class="btn btn-outline-primary">
                <i class="bi bi-list-ul me-1"></i>Listado completo
            </a>
        </div>

        <!-- Formulario de búsqueda -->
        <div class="card border-0 shadow-sm rounded-3 mb-4">
            <div class="card-header bg-primary text-white rounded-top-3 py-3">
                <div class="d-flex align-items-center gap-2">
                    <i class="bi bi-search fs-4"></i>
                    <div>
                        <h4 class="mb-0 fw-bold">Buscar Vídeos</h4>
                    </div>
                </div>
            </div>
            <div class="card-body p-4">
                <form action="ServletBusqueda" method="get">
                    


                    <div class="row g-3">

                        <div class="col-md-4">
                            <label class="form-label fw-semibold small text-secondary">
                                <i class="bi bi-text-fields me-1"></i>Buscar por Título
                            </label>
                            <input type="text" class="form-control" name="titulo"
                                   placeholder="Ej: tutorial"
                                   value="${param.titulo}"/>
                        </div>

                        <div class="col-md-4">
                            <label class="form-label fw-semibold small text-secondary">
                                <i class="bi bi-person-badge me-1"></i>Buscar por Autor
                            </label>
                            <input type="text" class="form-control" name="autor"
                                   placeholder="Ej: Juan Pérez"
                                   value="${param.autor}"/>
                        </div>

                        <div class="col-md-4">
                            <label class="form-label fw-semibold small text-secondary">
                                <i class="bi bi-calendar-event me-1"></i>Buscar por Fecha
                            </label>
                            <input type="date" class="form-control" name="fecha"
                                   placeholder="AAAA-MM-DD"
                                   value="${param.fecha}"/>
                            <div class="form-text small">Formato: AAAA-MM-DD</div>
                        </div>

                    </div>

                    <hr class="my-4"/>

                    <div class="d-flex justify-content-end">
                        <button type="submit" class="btn btn-primary px-4 fw-semibold">
                            <i class="bi bi-search me-1"></i>Buscar
                        </button>
                    </div>

                </form>
            </div>
        </div>

        <!-- Resultados -->
        <%
            String jsonResultados = (String) request.getAttribute("jsonResultados");
            String tituloParam = request.getParameter("titulo");
            String autorParam = request.getParameter("autor");
            String fechaParam = request.getParameter("fecha");
            boolean hayParametros = tituloParam != null || autorParam != null || fechaParam != null;
        %>

        <% if (!hayParametros) { %>
        <div class="text-center py-5 text-muted">
            <i class="bi bi-search fs-1 d-block mb-2"></i>
            <p class="mb-0">Introduce algún criterio de búsqueda para encontrar vídeos.</p>
        </div>
        <% } else { %>

        <!-- Contenedor de resultados (se llena con JavaScript) -->
        <div id="resultadosContainer">
            <div class="text-center py-4">
                <div class="spinner-border text-primary" role="status">
                    <span class="visually-hidden">Cargando...</span>
                </div>
            </div>
        </div>

        <% } %>

    </div>

</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<script>
var jsonResultadosStr = <%= jsonResultados != null ? "\"" + jsonResultados.replace("\"", "\\\"").replace("\n", "").replace("\r", "") + "\"" : "[]" %>;
var tituloParam = "<%= tituloParam != null ? tituloParam.replace("\"", "\\\"") : "" %>";
var autorParam = "<%= autorParam != null ? autorParam.replace("\"", "\\\"") : "" %>";
var fechaParam = "<%= fechaParam != null ? fechaParam.replace("\"", "\\\"") : "" %>";

document.addEventListener('DOMContentLoaded', function() {
    var container = document.getElementById('resultadosContainer');

    if (!jsonResultadosStr || jsonResultadosStr === '[]' || jsonResultadosStr.indexOf('"error"') !== -1) {
        container.innerHTML = '<div class="alert alert-warning d-flex align-items-center gap-2">' +
            '<i class="bi bi-exclamation-circle flex-shrink-0"></i>' +
            '<span>No se encontraron vídeos que coincidan con los criterios de búsqueda.</span></div>';
        return;
    }

    try {
        var videos = JSON.parse(jsonResultadosStr);

        if (videos.length === 0) {
            container.innerHTML = '<div class="alert alert-warning d-flex align-items-center gap-2">' +
                '<i class="bi bi-exclamation-circle flex-shrink-0"></i>' +
                '<span>No se encontraron vídeos que coincidan con los criterios de búsqueda.</span></div>';
            return;
        }

        var html = '<div class="mb-3"><span class="badge bg-primary fs-6">' + videos.length + ' resultado(s) encontrado(s)</span></div>' +
            '<div class="list-group">';

        for (var i = 0; i < videos.length; i++) {
            var video = videos[i];
            var descripcionCorta = '';
            if (video.descripcion && video.descripcion.length > 150) {
                descripcionCorta = video.descripcion.substring(0, 150) + "...";
            } else if (video.descripcion) {
                descripcionCorta = video.descripcion;
            }

            var botonReproducir = '';
            if (video.rutaFichero && video.rutaFichero !== '') {
                botonReproducir = '<a href="ServletReproducir?id=' + video.id + '" class="btn btn-outline-primary btn-sm">' +
                    '<i class="bi bi-play-circle me-1"></i>Reproducir</a>';
            }

            html += '<div class="list-group-item list-group-item-action result-item">' +
                '<div class="d-flex w-100 justify-content-between align-items-start">' +
                '<div class="flex-grow-1">' +
                '<h6 class="mb-2 fw-bold"><i class="bi bi-camera-video-fill text-primary me-2"></i>' + (video.titulo || 'Sin título') + '</h6>' +
                '<p class="mb-2 small text-muted">' +
                '<i class="bi bi-person-circle me-1"></i>' + (video.autor || 'Autor desconocido') + ' ';

            if (video.fechaCreacion) {
                html += '| <i class="bi bi-calendar3 me-1"></i>' + video.fechaCreacion;
            }

            html += '| <i class="bi bi-play-circle me-1"></i>' + (video.reproducciones || 0) + ' reproducciones</p>';

            if (descripcionCorta) {
                html += '<p class="mb-2 small">' + descripcionCorta + '</p>';
            }

            html += '<div class="mt-2">' +
                '<span class="badge bg-primary me-1">' + (video.formato || '-') + '</span> ' +
                botonReproducir +
                '</div></div></div></div>';
        }

        html += '</div>';
        container.innerHTML = html;

    } catch (e) {
        container.innerHTML = '<div class="alert alert-danger d-flex align-items-center gap-2">' +
            '<i class="bi bi-exclamation-triangle-fill flex-shrink-0"></i>' +
            '<span>Error al procesar los resultados de búsqueda.</span></div>';
        console.error('Error al parsear JSON:', e);
    }
});
</script>

</body>
</html>
