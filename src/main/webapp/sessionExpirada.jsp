<%-- 
    Document   : sessionExpirada
    Created on : 8 mar 2026, 18:00:43
    Author     : alumne
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8"/>
    <title>Sesión expirada</title>
    <script src="js/sessionExpirada.js" defer></script>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"/>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet"/>
</head>
<body class="bg-light min-vh-100 d-flex align-items-center justify-content-center">

<div class="modal d-block" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content border-0 shadow">
            <div class="modal-header bg-primary text-white">
                <h5 class="modal-title fw-bold">
                    <i class="bi bi-clock-history me-2"></i>Sesión expirada
                </h5>
            </div>
            <div class="modal-body text-center py-4">
                <i class="bi bi-shield-lock text-primary fs-1 mb-3 d-block"></i>
                <p class="fs-5 fw-semibold mb-1">Tu sesión ha expirado</p>
                <p class="text-muted">Por seguridad, tu sesión ha finalizado por inactividad.</p>
                <p class="text-muted small">Serás redirigido al login en <span id="cuenta" class="fw-bold text-danger">5</span> segundos...</p>
            </div>
            <div class="modal-footer justify-content-center">
                <a href="login.jsp" class="btn btn-primary">
                    <i class="bi bi-box-arrow-in-right me-1"></i>Ir al login ahora
                </a>
            </div>
        </div>
    </div>
</div>
<div class="modal-backdrop fade show"></div>

</body>
</html>
