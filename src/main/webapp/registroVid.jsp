<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Registrar Vídeo</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"/>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet"/>
</head>
<body class="bg-light min-vh-100 d-flex align-items-center justify-content-center py-4">

<div class="container" style="max-width:700px;">

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

    <div class="card border-0 shadow-sm rounded-3">

        <div class="card-header bg-primary text-white rounded-top-3 py-3">
            <div class="d-flex align-items-center gap-2">
                <i class="bi bi-camera-video-fill fs-4"></i>
                <h4 class="mb-0 fw-bold">Registrar Vídeo</h4>
                <a href="servletListadoVid" class="btn btn-outline-light btn-sm ms-auto">
                    <i class="bi bi-list-ul me-1"></i>Ver listado
                </a>
            </div>
        </div>

        <div class="card-body p-4">

            <% if (request.getAttribute("error") != null) { %>
            <div class="alert alert-danger d-flex align-items-center gap-2">
                <i class="bi bi-exclamation-triangle-fill flex-shrink-0"></i>
                <span>${error}</span>
            </div>
            <% } %>

            <% if (request.getAttribute("exito") != null) { %>
            <div class="alert alert-success d-flex align-items-center gap-2">
                <i class="bi bi-check-circle-fill flex-shrink-0"></i>
                <span>${exito}</span>
            </div>
            <% } %>

            <%-- enctype siempre multipart para soportar subida de fichero --%>
            <form action="servletRegistroVid" method="post" enctype="multipart/form-data" novalidate>

                <!-- Título -->
                <div class="mb-3">
                    <label class="form-label fw-semibold small text-secondary">
                        Título <span class="text-danger">*</span>
                    </label>
                    <input type="text" class="form-control" name="titulo"
                           placeholder="Título del vídeo" value="${param.titulo}"/>
                </div>

                <!-- Autor + Fecha -->
                <div class="row g-3 mb-3">
                    <div class="col-md-6">
                        <label class="form-label fw-semibold small text-secondary">
                            Autor <span class="text-danger">*</span>
                        </label>
                        <div class="input-group">
                            <span class="input-group-text bg-light">
                                <i class="bi bi-person text-secondary"></i>
                            </span>
                            <input type="text" class="form-control" name="autor"
                                   placeholder="Nombre del autor" value="${param.autor}"/>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label fw-semibold small text-secondary">
                            Fecha de creación <span class="text-danger">*</span>
                        </label>
                        <div class="input-group">
                            <span class="input-group-text bg-light">
                                <i class="bi bi-calendar3 text-secondary"></i>
                            </span>
                            <input type="date" class="form-control" name="fechaCreacion"
                                   value="${param.fechaCreacion}"/>
                        </div>
                    </div>
                </div>

                <!-- Duración -->
                <div class="mb-3">
                    <label class="form-label fw-semibold small text-secondary">
                        Duración (HH:mm:ss) <span class="text-danger">*</span>
                    </label>
                    <div class="input-group">
                        <span class="input-group-text bg-light">
                            <i class="bi bi-stopwatch text-secondary"></i>
                        </span>
                        <input type="text" class="form-control" name="duracion"
                               placeholder="00:32:00" pattern="\d{2}:\d{2}:\d{2}"
                               value="${param.duracion}"/>
                    </div>
                    <div class="form-text">Formato: horas:minutos:segundos</div>
                </div>

                <!-- Formato (autodetectado) -->
                <div class="mb-3">
                    <label class="form-label fw-semibold small text-secondary">
                        Formato <span class="text-danger">*</span>
                    </label>
                    <div class="input-group">
                        <span class="input-group-text bg-light">
                            <i class="bi bi-file-earmark-play text-secondary"></i>
                        </span>
                        <select class="form-select" name="formato" id="selectFormato">
                            <option value="" disabled selected>Selecciona un formato</option>
                            <option value="mp4"  ${param.formato == 'mp4'  ? 'selected' : ''}>MP4</option>
                            <option value="ogg"  ${param.formato == 'ogg'  ? 'selected' : ''}>OGG</option>
                            <option value="avi"  ${param.formato == 'avi'  ? 'selected' : ''}>AVI</option>
                            <option value="mkv"  ${param.formato == 'mkv'  ? 'selected' : ''}>MKV</option>
                            <option value="mov"  ${param.formato == 'mov'  ? 'selected' : ''}>MOV</option>
                            <option value="webm" ${param.formato == 'webm' ? 'selected' : ''}>WebM</option>
                        </select>
                    </div>
                    <div class="form-text" id="textoFormato"></div>
                </div>

                <!-- Descripción -->
                <div class="mb-4">
                    <label class="form-label fw-semibold small text-secondary">
                        Descripción <span class="text-danger">*</span>
                    </label>
                    <textarea class="form-control" name="descripcion" rows="3"
                              placeholder="Describe brevemente el contenido del vídeo...">${param.descripcion}</textarea>
                </div>

                <!-- Origen del fichero: pestañas -->
                <div class="mb-4">
                    <label class="form-label fw-semibold small text-secondary">Fichero de vídeo</label>

                    <ul class="nav nav-tabs mb-3" id="tabOrigen">
                        <li class="nav-item">
                            <button type="button" class="nav-link active" id="tabUrl"
                                    onclick="mostrarTab('url')">
                                <i class="bi bi-link-45deg me-1"></i>URL / Ruta externa
                            </button>
                        </li>
                        <li class="nav-item">
                            <button type="button" class="nav-link" id="tabSubir"
                                    onclick="mostrarTab('subir')">
                                <i class="bi bi-upload me-1"></i>Subir desde mi ordenador
                            </button>
                        </li>
                    </ul>

                    <!-- Panel URL -->
                    <div id="panelUrl">
                        <div class="input-group">
                            <span class="input-group-text bg-light">
                                <i class="bi bi-link-45deg text-secondary"></i>
                            </span>
                            <input type="text" class="form-control" name="rutaFichero"
                                   id="inputUrl"
                                   placeholder="https://ejemplo.com/video.mp4 o /ruta/local"
                                   value="${param.rutaFichero}"
                                   oninput="detectarFormatoDeTexto(this.value)"/>
                        </div>
                        <div class="form-text">Puede ser una URL pública o una ruta que empiece por /</div>
                    </div>

                    <!-- Panel subida -->
                    <div id="panelSubir" class="d-none">
                        <input type="file" class="form-control" name="ficheroVideo"
                               id="inputFichero"
                               accept=".mp4,.ogg,.avi,.mkv,.mov,.webm"
                               onchange="detectarFormatoDeArchivo(this)"/>
                        <div class="form-text">Formatos aceptados: MP4, OGG, AVI, MKV, MOV, WebM (máx. 500 MB)</div>
                    </div>
                </div>

                <hr class="mb-4"/>

                <div class="d-flex justify-content-between align-items-center">
                    <small class="text-muted"><span class="text-danger">*</span> Campos obligatorios</small>
                    <button type="submit" class="btn btn-primary px-4 fw-semibold">
                        <i class="bi bi-cloud-upload me-1"></i>Registrar vídeo
                    </button>
                </div>

            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
    const FORMATOS = ["mp4", "ogg", "avi", "mkv", "mov", "webm"];

    function mostrarTab(tab) {
        const esUrl = tab === 'url';
        document.getElementById('panelUrl').classList.toggle('d-none', !esUrl);
        document.getElementById('panelSubir').classList.toggle('d-none', esUrl);
        document.getElementById('tabUrl').classList.toggle('active', esUrl);
        document.getElementById('tabSubir').classList.toggle('active', !esUrl);

        // Limpiar el campo que queda oculto
        if (esUrl) {
            document.getElementById('inputFichero').value = '';
        } else {
            document.getElementById('inputUrl').value = '';
            limpiarFormato();
        }
    }

    function detectarFormatoDeTexto(valor) {
        const partes = valor.split('.');
        const ext = partes[partes.length - 1].toLowerCase().split('?')[0]; // quita query string
        aplicarFormato(ext);
    }

    function detectarFormatoDeArchivo(input) {
        if (!input.files || input.files.length === 0) { limpiarFormato(); return; }
        const nombre = input.files[0].name;
        const ext = nombre.split('.').pop().toLowerCase();
        aplicarFormato(ext);
    }

    function aplicarFormato(ext) {
        const select = document.getElementById('selectFormato');
        const info   = document.getElementById('textoFormato');
        if (FORMATOS.includes(ext)) {
            select.value = ext;
            info.textContent = 'Formato detectado automáticamente: ' + ext.toUpperCase();
            info.className = 'form-text text-success';
        } else {
            limpiarFormato();
        }
    }

    function limpiarFormato() {
        document.getElementById('textoFormato').textContent = '';
    }
</script>
</body>
</html>
