<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="es">
<head>
<meta charset="UTF-8"/>
<meta name="viewport" content="width=device-width, initial-scale=1.0"/>
<title>Registro de Usuario</title>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"/>
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet"/>

</head>

    <body class="bg-light min-vh-100 d-flex align-items-center justify-content-center py-4">

    <div class="container" style="max-width: 650px;">

    <div class="card border-0 shadow-sm rounded-3">

    <div class="card-header bg-primary text-white rounded-top-3 py-3">
        <div class="d-flex align-items-center gap-2">
            <i class="bi bi-person-plus-fill fs-4"></i>
            <div>
                <h4 class="mb-0 fw-bold">Registro de Usuario</h4>
                <small class="opacity-75">Completa los datos para crear una cuenta</small>
            </div>
        </div>
    </div>

    <div class="card-body p-4">

    <% if (request.getAttribute("error") != null) { %>
    <div class="alert alert-danger d-flex align-items-center gap-2">
        <i class="bi bi-exclamation-triangle-fill"></i>
        <span>${error}</span>
    </div>
    <% } %>

    <form action="servletUsuarios" method="post" onsubmit="return validarPassword()">

        <div class="mb-3">
            <label class="form-label fw-medium text-secondary small">
            Nombre <span class="text-danger">*</span>
            </label>
            <input type="text" class="form-control" name="name"
            placeholder="Ingrese su nombre" required>
        </div>
        
        <div class="mb-3">
            <label class="form-label fw-medium text-secondary small">
            Apellidos <span class="text-danger">*</span>
            </label>
            <input type="text" class="form-control" name="lastname"
            placeholder="Ingrese sus apellidos" required>
        </div>

        <div class="mb-3">
            <label class="form-label fw-medium text-secondary small">
            Email <span class="text-danger">*</span>
            </label>
            <div class="input-group">
            <span class="input-group-text bg-light text-secondary">
            <i class="bi bi-envelope"></i>
            </span>
            <input type="email" class="form-control" name="email"
            placeholder="correo@email.com" required>
            </div>
        </div>

        <div class="mb-3">
            <label class="form-label fw-medium text-secondary small">
            Nombre de usuario <span class="text-danger">*</span>
            </label>
            <div class="input-group">
                <span class="input-group-text bg-light text-secondary">
                <i class="bi bi-person"></i>
                </span>
                <input type="text" class="form-control" name="username"
                placeholder="Usuario" required>
            </div>
        </div>

        <div class="mb-3">
            <label class="form-label fw-medium text-secondary small">
            Contraseña <span class="text-danger">*</span>
            </label>
            <div class="input-group">
            <span class="input-group-text bg-light text-secondary">
            <i class="bi bi-lock"></i>
            </span>
            <input type="password" class="form-control"
            id="password" name="password" required>
            </div>
        </div>

        <div class="mb-4">
            <label class="form-label fw-medium text-secondary small">
            Repetir contraseña <span class="text-danger">*</span>
            </label>
            <div class="input-group">
            <span class="input-group-text bg-light text-secondary">
            <i class="bi bi-lock-fill"></i>
            </span>
            <input type="password" class="form-control"
            id="repeatPassword" name="repeatPassword" required>
            </div>
        </div>

        <hr class="mb-4"/>

        <div class="d-flex justify-content-between align-items-center">

        <a href="login.jsp" class="btn btn-outline-secondary">
        <i class="bi bi-box-arrow-in-right me-1"></i> Ir al login
        </a>

        <button type="submit" class="btn btn-primary px-4 fw-semibold">
        <i class="bi bi-person-plus me-1"></i> Registrar
        </button>

        </div>

    </form>

    </div>
    </div>

    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

    </body>
</html>
