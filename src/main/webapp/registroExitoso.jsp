<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8"/>
    <title>Usuario Registrado</title>
    <script src="js/registroExitoso.js" defer></script>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"/>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet"/>
    <link rel="stylesheet" href="css/registroExitoso.css"/>
    
</head>

<body class="bg-light min-vh-100 d-flex align-items-center justify-content-center">

<div class="modal d-block" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content border-0 shadow">

            <div class="modal-header bg-primary text-white">
                <h5 class="modal-title fw-bold">
                    <i class="bi bi-check-circle-fill me-2"></i>Registro completado
                </h5>
            </div>

            <div class="modal-body text-center py-4">
                <i class="bi bi-check-circle-fill text-primary fs-1 mb-3 d-block"></i>
                <p class="fs-5 fw-semibold mb-1">Usuario registrado correctamente</p>
            </div>

        </div>
    </div>
</div>

<div class="modal-backdrop fade show"></div>


</body>
</html>