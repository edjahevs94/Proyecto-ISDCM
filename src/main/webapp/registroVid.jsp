<%-- 
    Document   : registroVid
    Created on : 6 mar 2026, 16:02:27
    Author     : alumne
--%>

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

    <div class="card border-0 shadow-sm rounded-3">

        <!-- Header -->
        <div class="card-header bg-primary text-white rounded-top-3 py-3">
            <div class="d-flex align-items-center gap-2">
                <i class="bi bi-camera-video-fill fs-4"></i>
                <div>
                    <h4 class="mb-0 fw-bold">Registrar Vídeo</h4>
                    <small class="opacity-75">
                        Usuario: <strong>${sessionScope.usuario}</strong>
                    </small>
                </div>
                <a href="servletListadoVid" class="btn btn-outline-light btn-sm ms-auto">
                    <i class="bi bi-list-ul me-1"></i>Ver listado
                </a>
            </div>
        </div>

        <div class="card-body p-4">

            <!-- Alerta error -->
            <% if (request.getAttribute("error") != null) { %>
            <div class="alert alert-danger d-flex align-items-center gap-2" role="alert">
                <i class="bi bi-exclamation-triangle-fill flex-shrink-0"></i>
                <span>${error}</span>
            </div>
            <% } %>

            <!-- Alerta éxito -->
            <% if (request.getAttribute("exito") != null) { %>
            <div class="alert alert-success d-flex align-items-center gap-2" role="alert">
                <i class="bi bi-check-circle-fill flex-shrink-0"></i>
                <span>${exito}</span>
            </div>
            <% } %>

            <form action="servletRegistroVid" method="post" novalidate>

                <!-- Título -->
                <div class="mb-3">
                    <label class="form-label fw-semibold small text-secondary">
                        Título <span class="text-danger">*</span>
                    </label>
                    <input type="text" class="form-control" name="titulo"
                           placeholder="Ej: Big Bunny"
                           value="${param.titulo}"/>
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
                                   placeholder="Nombre del autor"
                                   value="${param.autor}"/>
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

                <!-- Duración + Reproducciones -->
                <div class="row g-3 mb-3">
                    <div class="col-md-6">
                        <label class="form-label fw-semibold small text-secondary">
                            Duración (HH:mm:ss) <span class="text-danger">*</span>
                        </label>
                        <div class="input-group">
                            <span class="input-group-text bg-light">
                                <i class="bi bi-stopwatch text-secondary"></i>
                            </span>
                            <input type="text" class="form-control" name="duracion"
                                   placeholder="00:32:00"
                                   pattern="\d{2}:\d{2}:\d{2}"
                                   value="${param.duracion}"/>
                        </div>
                        <div class="form-text">Formato: horas:minutos:segundos</div>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label fw-semibold small text-secondary">
                            Nº Reproducciones
                        </label>
                        <div class="input-group">
                            <span class="input-group-text bg-light">
                                <i class="bi bi-play-circle text-secondary"></i>
                            </span>
                            <input type="number" class="form-control" name="reproducciones"
                                   placeholder="0" min="0"
                                   value="${param.reproducciones}"/>
                        </div>
                    </div>
                </div>

                <!-- Formato -->
                <div class="mb-3">
                    <label class="form-label fw-semibold small text-secondary">
                        Formato <span class="text-danger">*</span>
                    </label>
                    <div class="input-group">
                        <span class="input-group-text bg-light">
                            <i class="bi bi-file-earmark-play text-secondary"></i>
                        </span>
                        <select class="form-select" name="formato">
                            <option value="" disabled selected>Selecciona un formato</option>
                            <option value="mp4"  ${param.formato == 'mp4'  ? 'selected' : ''}>MP4</option>
                            <option value="ogg"  ${param.formato == 'ogg'  ? 'selected' : ''}>OGG</option>
                            <option value="avi"  ${param.formato == 'avi'  ? 'selected' : ''}>AVI</option>
                            <option value="mkv"  ${param.formato == 'mkv'  ? 'selected' : ''}>MKV</option>
                            <option value="mov"  ${param.formato == 'mov'  ? 'selected' : ''}>MOV</option>
                            <option value="webm" ${param.formato == 'webm' ? 'selected' : ''}>WebM</option>
                        </select>
                    </div>
                </div>

                <!-- Descripción -->
                <div class="mb-4">
                    <label class="form-label fw-semibold small text-secondary">
                        Descripción <span class="text-danger">*</span>
                    </label>
                    <textarea class="form-control" name="descripcion" rows="3"
                              placeholder="Describe brevemente el contenido del vídeo...">${param.descripcion}</textarea>
                </div>

                <hr class="mb-4"/>

                <div class="d-flex justify-content-between align-items-center">
                    <small class="text-muted"><span class="text-danger">*</span> Campos obligatorios</small>
                    <button type="submit" class="btn btn-primary px-4 fw-semibold">
                        <i class="bi bi-cloud-upload me-1"></i> Registrar vídeo
                    </button>
                </div>

            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

