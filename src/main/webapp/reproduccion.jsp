<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="modelo.Video" %>
<%
    // 1. Recuperar objetos de la solicitud de forma segura
    Video video = (Video) request.getAttribute("video");
    String usuario = (String) session.getAttribute("usuario");
    
    // 2. Definir variables para evitar NullPointerException en el HTML
    String titulo = (video != null) ? video.getTitulo() : "Video no encontrado";
    String autor = (video != null) ? video.getAutor() : "Desconocido";
    long reproducciones = (video != null) ? video.getReproducciones() : 0;
    long idVideo = (video != null) ? video.getId() : 0;
    
    // Ruta forzada para pruebas
    String rutaFichero = video.getRutaFichero() != null ? video.getRutaFichero() : "";
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
<body class="bg-light">

<nav class="navbar navbar-dark bg-dark px-4">
    <span class="navbar-brand fw-bold">ISDCM</span>
    <div class="d-flex align-items-center gap-3">
        <span class="text-white small">Usuario: <%= (usuario != null) ? usuario : "Invitado" %></span>
        <a href="servletListadoVid" class="btn btn-outline-light btn-sm">Volver</a>
    </div>
</nav>

<div class="container py-4" style="max-width: 900px;">

    <%-- Bloque de información del video --%>
    <h4 class="fw-bold mb-1"><%= titulo %></h4>
    <p class="text-muted small mb-3">
        Autor: <%= autor %> &nbsp;·&nbsp; 
        <span id="contadorReproducciones"><%= reproducciones %></span> reproducciones
    </p>

    <div class="card border-0 shadow-sm rounded-3 overflow-hidden mb-3">
        <video id="miVideo" class="video-js vjs-default-skin vjs-big-play-centered w-100" controls preload="auto">
            <source src="<%= rutaFichero %>" type="video/mp4"/>
        </video>
    </div>

    <%-- Alerta invisible para el contador --%>
    <div id="alertaReproduccion" class="alert alert-success mt-3 d-none" role="alert">
        Reproducción registrada correctamente.
    </div>

</div>

<script src="https://vjs.zencdn.net/8.10.0/video.min.js"></script>
<script>
    // Inicialización del player
    var player = videojs('miVideo', {
        fluid: true,
        playbackRates: [0.5, 1, 1.5, 2]
    });

    var reproduccionContada = false;
    var BACKEND_URL = 'http://localhost:8080/Proyecto-ISDCM-Backend/api/videos/<%= idVideo %>/reproduccion';

    player.on('play', function() {
        if (!reproduccionContada) {
            reproduccionContada = true;
            // Añade este console.log en tu script para ver qué URL se está generando
console.log("Intentando actualizar en: " + BACKEND_URL);
            fetch(BACKEND_URL, { method: 'POST' })
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
</body>
</html>