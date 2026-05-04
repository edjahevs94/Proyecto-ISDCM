<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8"/>
        <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
        <title>Cifrado de Contenidos</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"/>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet"/>
    </head>
    <body class="bg-light py-4">

        <div class="container" style="max-width:680px;">

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

            <div class="d-flex align-items-center gap-2 mb-4">
                <a href="ServletListadoVid" class="btn btn-outline-secondary btn-sm">
                    <i class="bi bi-arrow-left"></i>
                </a>
                <h3 class="fw-bold mb-0">
                    <i class="bi bi-shield-lock text-primary me-2"></i>Cifrado de Contenidos
                </h3>
            </div>

            <% if (request.getAttribute("error") != null) { %>
            <div class="alert alert-danger d-flex align-items-center gap-2">
                <i class="bi bi-exclamation-triangle-fill"></i>
                <%= request.getAttribute("error") %>
            </div>
            <% } %>

            <div class="card border-0 shadow-sm rounded-3">
                <div class="card-body p-4">

                    <div class="alert alert-info d-flex gap-2 mb-4">
                        <i class="bi bi-info-circle-fill mt-1 flex-shrink-0"></i>
                        <div>
                            Selecciona un fichero (vídeo, imagen, audio, etc.) y elige la operación.
                            El resultado se descargará automáticamente.<br/>
                            <strong>Cifrado:</strong> genera un fichero <code>.cifrado</code>.<br/>
                            <strong>Descifrado:</strong> recupera el fichero original a partir de un <code>.cifrado</code>.
                        </div>
                    </div>

                    <form method="post" action="ServletCifradoContenido" enctype="multipart/form-data">

                        <div class="mb-4">
                            <label class="form-label fw-semibold">Fichero</label>
                            <input type="file" name="fichero" class="form-control" required/>
                        </div>

                        <div class="d-flex gap-3">
                            <button type="submit" name="accion" value="cifrar"
                                    class="btn btn-primary flex-fill">
                                <i class="bi bi-lock-fill me-2"></i>Cifrar
                            </button>
                            <button type="submit" name="accion" value="descifrar"
                                    class="btn btn-outline-primary flex-fill">
                                <i class="bi bi-unlock-fill me-2"></i>Descifrar
                            </button>
                        </div>

                    </form>

                </div>
            </div>

            <div class="card border-0 shadow-sm rounded-3 mt-4">
                <div class="card-body p-4">
                    <h6 class="fw-semibold mb-3">
                        <i class="bi bi-cpu text-secondary me-2"></i>Detalles técnicos
                    </h6>
                    <ul class="mb-0 text-muted small">
                        <li>Algoritmo: <strong>AES/CBC/PKCS5Padding</strong></li>
                        <li>Longitud de clave: <strong>128 bits</strong></li>
                        <li>IV aleatorio de 16 bytes incluido en el fichero cifrado</li>
                        <li>Librería: <strong>javax.crypto</strong> (JDK estándar)</li>
                    </ul>
                </div>
            </div>

        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
