<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Cifrado de XML</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"/>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet"/>
</head>
<body class="bg-light py-4">

<div class="container" style="max-width:700px;">

    <div class="text-end mb-3">
        <div class="dropdown d-inline-block">
            <button class="btn btn-secondary rounded-circle fw-bold"
                    data-bs-toggle="dropdown" style="width:50px;height:50px;">
                ${sessionScope.usuario}
            </button>
            <ul class="dropdown-menu dropdown-menu-end">
                <li><a class="dropdown-item text-danger" href="ServletLogout">
                    <i class="bi bi-box-arrow-right me-2"></i>Cerrar sesión
                </a></li>
            </ul>
        </div>
    </div>

    <div class="d-flex align-items-center gap-2 mb-4">
        <a href="servletListadoVid" class="btn btn-outline-secondary btn-sm">
            <i class="bi bi-arrow-left"></i>
        </a>
        <h3 class="fw-bold mb-0">
            <i class="bi bi-file-earmark-code text-primary me-2"></i>Cifrado de Digital Items (XML)
        </h3>
    </div>

    <% if (request.getAttribute("error") != null) { %>
    <div class="alert alert-danger d-flex align-items-center gap-2">
        <i class="bi bi-exclamation-triangle-fill"></i>
        <span>${error}</span>
    </div>
    <% } %>

    <div class="card border-0 shadow-sm rounded-3">
        <div class="card-body p-4">

            <div class="alert alert-info d-flex gap-2 mb-4">
                <i class="bi bi-info-circle-fill mt-1 flex-shrink-0"></i>
                <div>
                    Cifra o descifra documentos XML en formato DIDL usando
                    <strong>XML Encryption (AES-128)</strong>.
                </div>
            </div>

            <form method="post" action="ServletCifradoXML" enctype="multipart/form-data">

                <!-- Fichero XML -->
                <div class="mb-4">
                    <label class="form-label fw-semibold">Subir fichero XML</label>
                    <input type="file" class="form-control" name="ficheroXML" accept=".xml"/>
                </div>

                <!-- Ámbito del cifrado -->
                <div class="mb-4" id="opcionesCifrado">
                    <label class="form-label fw-semibold">Ámbito del cifrado</label>
                    <select class="form-select mb-2" name="modo" id="selectModo"
                            onchange="toggleTagElemento(this.value)">
                        <option value="elemento">Cifrar elemento completo</option>
                        <option value="contenido">Cifrar contenido del elemento</option>
                        <option value="documento">Cifrar todo el documento</option>
                    </select>
                    <div id="divTagElemento">
                        <input type="text" class="form-control" name="tagElemento"
                               id="inputTag" placeholder="Nombre del elemento"/>
                    </div>
                </div>

                <!-- Botones -->
                <div class="d-flex gap-3">
                    <button type="submit" name="accion" value="cifrar"
                            class="btn btn-primary flex-fill">
                        <i class="bi bi-lock-fill me-2"></i>Cifrar XML
                    </button>
                    <button type="submit" name="accion" value="descifrar"
                            class="btn btn-outline-primary flex-fill">
                        <i class="bi bi-unlock-fill me-2"></i>Descifrar XML
                    </button>
                </div>

            </form>
        </div>
    </div>


</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
    function toggleTagElemento(modo) {
        document.getElementById('divTagElemento').classList.toggle('d-none', modo === 'documento');
    }
</script>
</body>
</html>
