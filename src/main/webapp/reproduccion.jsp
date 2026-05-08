<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="modelo.Video" %>
<%
    Video video = (Video) request.getAttribute("video");
    String usuario = (String) session.getAttribute("usuario");
    String jwtToken = (String) session.getAttribute("jwtToken");

    String titulo       = (video != null) ? video.getTitulo()      : "Vídeo no encontrado";
    String autor        = (video != null) ? video.getAutor()       : "Desconocido";
    long reproducciones = (video != null) ? video.getReproducciones() : 0;
    long idVideo        = (video != null) ? video.getId()          : 0;
    String rutaFichero  = (video != null && video.getRutaFichero() != null) ? video.getRutaFichero() : "";
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title><%= titulo %> — ISDCM</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"/>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet"/>
    <link href="https://vjs.zencdn.net/8.10.0/video-js.css" rel="stylesheet"/>
</head>
<body class="bg-light py-4">

<div class="container" style="max-width: 900px;">

    <div class="card border-0 shadow-sm rounded-3">

        <!-- Header -->
        <div class="card-header bg-primary text-white rounded-top-3 py-3">
            <div class="d-flex align-items-center gap-2">
                <i class="bi bi-play-circle-fill fs-4"></i>
                <div class="flex-grow-1">
                    <h4 class="mb-0 fw-bold"><%= titulo %></h4>
                    <small class="opacity-75">
                        Usuario: <strong><%= (usuario != null) ? usuario : "Invitado" %></strong>
                    </small>
                </div>
                <a href="servletListadoVid" class="btn btn-outline-light btn-sm">
                    <i class="bi bi-arrow-left me-1"></i>Volver
                </a>
            </div>
        </div>

        <div class="card-body p-4">

            <!-- Info del vídeo -->
            <div class="d-flex align-items-center gap-3 mb-3">
                <span class="text-muted small">
                    <i class="bi bi-person-circle me-1"></i><%= autor %>
                </span>
                <span class="text-muted small">
                    <i class="bi bi-play-fill me-1"></i>
                    <span id="contadorReproducciones"><%= reproducciones %></span> reproducciones
                </span>
            </div>

            <!-- Reproductor -->
            <div class="rounded-3 overflow-hidden mb-3">
                <video
                    id="miVideo"
                    class="video-js vjs-default-skin vjs-big-play-centered w-100"
                    controls
                    preload="auto"
                    data-id-video="<%= idVideo %>">
                    <source src="<%= rutaFichero %>"/>
                    <p class="text-muted small">Tu navegador no soporta la reproducción de vídeo.</p>
                </video>
            </div>

            <!-- Alerta reproducción registrada -->
            <div id="alertaReproduccion" class="alert alert-success d-flex align-items-center gap-2 d-none" role="alert">
                <i class="bi bi-check-circle-fill flex-shrink-0"></i>
                <span>Reproducción registrada correctamente.</span>
            </div>

            <!-- Alerta error reproducción -->
            <div id="alertaError" class="alert alert-danger d-flex align-items-center gap-2 d-none" role="alert">
                <i class="bi bi-exclamation-triangle-fill flex-shrink-0"></i>
                <span>No se pudo registrar la reproducción.</span>
            </div>

            <hr class="mb-3"/>

            <!-- Botón volver -->
            <div class="d-flex justify-content-end">
                <a href="servletListadoVid" class="btn btn-outline-secondary">
                    <i class="bi bi-collection-play me-1"></i>Ver todos los vídeos
                </a>
            </div>

        </div>
    </div>
</div>

<script src="https://vjs.zencdn.net/8.10.0/video.min.js"></script>
<script src="js/reproducirVideo.js" defer></script>
<script>
    var player = videojs('miVideo', {
        fluid: true,
        playbackRates: [0.5, 1, 1.5, 2]
    });

    var reproduccionContada = false;
    var BACKEND_URL = 'http://localhost:8080/Proyecto-ISDCM-Backend/api/videos/<%= idVideo %>/reproduccion';
    var JWT_TOKEN = '<%= jwtToken != null ? jwtToken : "" %>';

    player.on('play', function() {
        if (!reproduccionContada) {
            reproduccionContada = true;

            console.log("Intentando actualizar en: " + BACKEND_URL);
            fetch(BACKEND_URL, {
                method: 'POST',
                headers: { 'Authorization': 'Bearer ' + JWT_TOKEN }
            })
                .then(function(res) { return res.json(); })
                .then(function(data) {
                    if (data.estado === 'exito') {
                        document.getElementById('contadorReproducciones').innerText = data.nuevo_contador;
                        var alerta = document.getElementById('alertaReproduccion');
                        alerta.classList.remove('d-none');
                        setTimeout(function() { alerta.classList.add('d-none'); }, 3000);
                    }
                })
                .catch(function(err) { console.log('Error registro:', err); });
        }
    });
</script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
