<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="es">
<head>
<meta charset="UTF-8"/>
<meta name="viewport" content="width=device-width, initial-scale=1.0"/>
<title>Iniciar Sesión</title>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"/>
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet"/>

<script>
    const params = new URLSearchParams(window.location.search);
    var res = params.get("message");
    
    if(res){
        alert(res);
    }
</script>

</head>

    <body class="bg-light min-vh-100 d-flex align-items-center justify-content-center py-4">

    <div class="container" style="max-width: 600px;">

    <div class="card border-0 shadow-sm rounded-3">

    <!-- Header -->
    <div class="card-header bg-primary text-white rounded-top-3 py-3">
    <div class="d-flex align-items-center gap-2">
    <i class="bi bi-box-arrow-in-right fs-4"></i>
    <div>
    <h4 class="mb-0 fw-bold">Iniciar Sesión</h4>
    <small class="opacity-75">Accede con tu usuario y contraseña</small>
    </div>
    </div>
    </div>

    <div class="card-body p-4">

    <% if (request.getAttribute("error") != null) { %>
    <div class="alert alert-danger d-flex align-items-center gap-2" role="alert">
    <i class="bi bi-exclamation-triangle-fill"></i>
    <span>${error}</span>
    </div>
    <% } %>

    <% if (request.getAttribute("exito") != null) { %>
    <div class="alert alert-success d-flex align-items-center gap-2" role="alert">
    <i class="bi bi-check-circle-fill"></i>
    <span>${exito}</span>
    </div>
    <% } %>

    <form action="LoginServlet" method="post">

        <div class="mb-3">
                <label class="form-label fw-medium text-secondary small">
                Usuario <span class="text-danger">*</span>
            </label>

            <div class="input-group">
                <span class="input-group-text bg-light text-secondary">
                <i class="bi bi-person"></i>
                </span>

                <input type="text" class="form-control"
                name="username"
                placeholder="Introduce tu nombre de usuario"
                required/>
                </div>
            </div>

            <div class="mb-4">
            <label class="form-label fw-medium text-secondary small">
            Contraseña <span class="text-danger">*</span>
            </label>

            <div class="input-group">
                <span class="input-group-text bg-light text-secondary">
                <i class="bi bi-lock"></i>
                </span>

                <input type="password" class="form-control"
                name="password"
                placeholder="Introduce tu contraseña"
                required/>
                </div>
            </div>

            <hr class="mb-4"/>

            <div class="d-flex justify-content-between align-items-center">

            <a href="registroUsu.jsp" class="btn btn-outline-secondary">
                <i class="bi bi-person-plus me-1"></i> Crear cuenta
            </a>

            <button type="submit" class="btn btn-primary px-4 fw-semibold">
                <i class="bi bi-box-arrow-in-right me-1"></i> Iniciar sesión
            </button>

        </div>

    </form>

    </div>
    </div>

    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

    </body>
</html>
