<%--
    Document   : reproduccion
    Created on : 29 mar 2026
    Author     : alumne
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Reproducir Vídeo</title>

    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"/>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet"/>

    <!-- Video.js CSS -->
    <link href="https://vjs.zencdn.net/8.6.1/video-js.css" rel="stylesheet"/>

    <style>
        .video-container {
            max-width: 900px;
        }
        .video-info {
            background: #ffffff;
            border-radius: 8px;
            padding: 1.5rem;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }
    </style>
</head>
<body class="bg-light py-4">

<div class="container py-4">

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

    <div class="video-container mx-auto">

        <%
            String videoJson = (String) request.getAttribute("videoJson");
            String error = (String) request.getAttribute("error");
            int videoId = Integer.parseInt(request.getParameter("id") != null ? request.getParameter("id") : "0");
        %>

        <% if (error != null) { %>
        <div class="alert alert-danger d-flex align-items-center gap-2">
            <i class="bi bi-exclamation-triangle-fill"></i>
            <span><%= error %></span>
        </div>
        <a href="servletListadoVid" class="btn btn-outline-primary">
            <i class="bi bi-arrow-left me-1"></i>Volver al listado
        </a>
        <% } else if (videoJson != null && videoJson.indexOf("\"error\"") == -1) { %>

        <div class="d-flex justify-content-between align-items-center mb-4">
            <h3 class="fw-bold mb-0 text-primary">
                <i class="bi bi-play-circle-fill me-2"></i>Reproduciendo
            </h3>
            <a href="servletListadoVid" class="btn btn-outline-primary">
                <i class="bi bi-arrow-left me-1"></i>Volver
            </a>
        </div>

        <!-- Reproductor Video.js -->
        <video
            id="my-video"
            class="video-js vjs-big-play-centered vjs-theme-city"
            controls
            preload="auto"
            width="900"
            height="506"
            poster=""
            data-setup='{"fluid": true, "techOrder": ["youtube"]}'
            data-video-id="<%= videoId %>">
            <p class="vjs-no-js">
                Para ver este vídeo, por favor activa JavaScript y considera actualizar a un navegador que soporte HTML5 vídeo.
            </p>
        </video>

        <!-- Información del vídeo (se llenará con JavaScript) -->
        <div class="video-info mt-4" id="videoInfo">
            <h4 class="fw-bold mb-3 text-primary"><i class="bi bi-info-circle me-2"></i>Información del Vídeo</h4>
            <div class="row g-3">
                <div class="col-md-8">
                    <h5 class="fw-semibold mb-2"><i class="bi bi-camera-video me-2"></i><span id="infoTitulo">Cargando...</span></h5>
                    <p class="text-muted mb-1">
                        <i class="bi bi-person-circle me-1"></i>Autor: <strong id="infoAutor">-</strong>
                    </p>
                    <p class="text-secondary" id="infoDescripcion"></p>
                </div>
                <div class="col-md-4">
                    <div class="small">
                        <p class="mb-2"><i class="bi bi-file-earmark-play me-1"></i>Formato: <code id="infoFormato">-</code></p>
                        <p class="mb-0"><i class="bi bi-play-circle me-1"></i>Reproducciones:
                            <span id="contadorReproducciones" class="badge bg-primary">0</span>
                        </p>
                    </div>
                </div>
            </div>
        </div>

        <% } else { %>
        <div class="alert alert-warning">
            <i class="bi bi-exclamation-circle me-2"></i>No se pudo cargar la información del vídeo.
        </div>
        <a href="servletListadoVid" class="btn btn-outline-primary">
            <i class="bi bi-arrow-left me-1"></i>Volver al listado
        </a>
        <% } %>

    </div>

</div>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<!-- Video.js + Youtube Plugin -->
<script src="https://vjs.zencdn.net/8.6.1/video.min.js"></script>
<script src="https://unpkg.com/videojs-youtube@3.0.1/dist/videojs-youtube.min.js"></script>

<script>
var videoJsonStr = <%= videoJson != null ? "\"" + videoJson.replace("\"", "\\\"").replace("\n", "").replace("\r", "") + "\"" : "null" %>;
var videoIdActual = <%= videoId %>;
var reproduccionRegistrada = false;

if (videoJsonStr && videoJsonStr.indexOf("\"error\"") === -1) {
    try {
        var videos = JSON.parse(videoJsonStr);
        if (videos && videos.length > 0) {
            var video = videos[0];
            document.getElementById('infoTitulo').textContent = video.titulo || 'Sin título';
            document.getElementById('infoAutor').textContent = video.autor || 'Autor desconocido';
            document.getElementById('infoFormato').textContent = video.formato || '-';
            document.getElementById('contadorReproducciones').textContent = video.reproducciones || 0;

            var descElement = document.getElementById('infoDescripcion');
            if (video.descripcion && video.descripcion !== '') {
                descElement.textContent = video.descripcion;
            } else {
                descElement.style.display = 'none';
            }

            // Configurar reproductor Video.js con YouTube
            var player = videojs('my-video', {
                techOrder: ['youtube'],
                sources: [{
                    type: 'video/youtube',
                    src: getYoutubeId(video.rutaFichero)
                }]
            });

            // Registrar reproducción al dar play
            player.on('play', function() {
                if (!reproduccionRegistrada) {
                    incrementarReproduccion(videoIdActual);
                    reproduccionRegistrada = true;
                }
            });
        }
    } catch (e) {
        console.error('Error al parsear JSON:', e);
    }
}

// Extraer ID de YouTube de URLs como https://www.youtube.com/watch?v=ID_O o youtube.com/embed/ID
function getYoutubeId(url) {
    if (!url) return '';

    // Si ya es un ID corto (11 caracteres)
    if (url.length === 11 && url.indexOf('http') === -1) {
        return 'youtube://' + url;
    }

    // Extraer ID de URL de YouTube
    var match = url.match(/(?:youtube\.com\/watch\?v=|youtu\.be\/|youtube\.com\/embed\/)([a-zA-Z0-9_-]{11})/);
    if (match) {
        return 'youtube://' + match[1];
    }

    return 'youtube://' + url;
}

function incrementarReproduccion(videoId) {
    fetch('ServletReproducir', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: 'id=' + videoId
    })
    .then(function(response) {
        return response.json();
    })
    .then(function(data) {
        if (data.estado === 'exito') {
            var contador = document.getElementById('contadorReproducciones');
            if (contador) {
                contador.textContent = data.nuevo_contador;
            }
        }
    })
    .catch(function(error) {
        console.error('Error:', error);
    });
}
</script>

</body>
</html>
