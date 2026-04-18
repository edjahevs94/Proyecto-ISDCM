/* 
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Other/javascript.js to edit this template
 */

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
