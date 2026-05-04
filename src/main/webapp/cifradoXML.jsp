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
        <a href="ServletListadoVid" class="btn btn-outline-secondary btn-sm">
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
                    <strong>XML Encryption (AES-128)</strong>.<br/>
                    Puedes usar el fichero <code>didlFilm1.xml</code> de ejemplo
                    o subir tu propio XML.
                </div>
            </div>

            <form method="post" action="ServletCifradoXML" enctype="multipart/form-data">

                <!-- Origen del XML -->
                <div class="mb-4">
                    <label class="form-label fw-semibold">Fichero XML</label>
                    <ul class="nav nav-tabs mb-3" id="tabOrigen">
                        <li class="nav-item">
                            <button type="button" class="nav-link active" id="tabBuiltin"
                                    onclick="mostrarTab('builtin')">
                                <i class="bi bi-file-earmark-code me-1"></i>Usar didlFilm1.xml
                            </button>
                        </li>
                        <li class="nav-item">
                            <button type="button" class="nav-link" id="tabUpload"
                                    onclick="mostrarTab('upload')">
                                <i class="bi bi-upload me-1"></i>Subir fichero XML
                            </button>
                        </li>
                    </ul>

                    <input type="hidden" name="origenXML" id="origenXML" value="builtin"/>

                    <div id="panelBuiltin" class="alert alert-secondary py-2">
                        <i class="bi bi-file-earmark-check me-2 text-success"></i>
                        Se usará <strong>didlFilm1.xml</strong> (Digital Item de ejemplo del Racó)
                    </div>

                    <div id="panelUpload" class="d-none">
                        <input type="file" class="form-control" name="ficheroXML" accept=".xml"/>
                        <div class="form-text">Selecciona un fichero XML (normal o previamente cifrado)</div>
                    </div>
                </div>

                <!-- Opciones de cifrado (solo para cifrar) -->
                <div class="mb-4" id="opcionesCifrado">
                    <label class="form-label fw-semibold">Ámbito del cifrado</label>
                    <div class="mb-2">
                        <select class="form-select" name="modo" id="selectModo"
                                onchange="toggleTagElemento(this.value)">
                            <option value="elemento">Cifrar elemento completo</option>
                            <option value="contenido">Cifrar solo el contenido del elemento</option>
                        </select>
                    </div>
                    <div>
                        <input type="text" class="form-control" name="tagElemento"
                               id="inputTag"
                               placeholder="Nombre del elemento (vacío = documento completo)"/>
                        <div class="form-text">
                            Ejemplos: <code>metadata</code>, <code>Statement</code>, <code>Item</code>.
                            Vacío cifra el elemento raíz (<code>DIDL</code>).
                        </div>
                    </div>
                </div>

                <!-- Botones -->
                <div class="d-flex gap-3">
                    <button type="submit" name="accion" value="cifrar"
                            class="btn btn-primary flex-fill">
                        <i class="bi bi-lock-fill me-2"></i>Cifrar XML
                    </button>
                    <button type="submit" name="accion" value="descifrar"
                            class="btn btn-outline-primary flex-fill"
                            onclick="document.getElementById('opcionesCifrado').style.opacity='0.4'">
                        <i class="bi bi-unlock-fill me-2"></i>Descifrar XML
                    </button>
                </div>

            </form>
        </div>
    </div>

    <!-- Detalles técnicos -->
    <div class="card border-0 shadow-sm rounded-3 mt-4">
        <div class="card-body p-4">
            <h6 class="fw-semibold mb-3">
                <i class="bi bi-cpu text-secondary me-2"></i>Detalles técnicos
            </h6>
            <ul class="mb-0 text-muted small">
                <li>Estándar: <strong>W3C XML Encryption Syntax and Processing</strong></li>
                <li>Algoritmo: <strong>AES-128 (XMLCipher.AES_128)</strong></li>
                <li>Librería: <strong>Apache XML Security (xmlsec 1.5.8)</strong></li>
                <li>El elemento cifrado queda sustituido por <code>&lt;xenc:EncryptedData&gt;</code></li>
            </ul>
        </div>
    </div>

</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
    function mostrarTab(tab) {
        const esBuiltin = tab === 'builtin';
        document.getElementById('origenXML').value = tab;
        document.getElementById('panelBuiltin').classList.toggle('d-none', !esBuiltin);
        document.getElementById('panelUpload').classList.toggle('d-none', esBuiltin);
        document.getElementById('tabBuiltin').classList.toggle('active', esBuiltin);
        document.getElementById('tabUpload').classList.toggle('active', !esBuiltin);
    }
</script>
</body>
</html>
