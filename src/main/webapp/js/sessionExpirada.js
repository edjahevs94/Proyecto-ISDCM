/* 
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Other/javascript.js to edit this template
 */


let segundos = 5;
const cuenta = document.getElementById("cuenta");
const intervalo = setInterval(() => {
    segundos--;
    cuenta.textContent = segundos;
    if (segundos <= 0) {
        clearInterval(intervalo);
        window.location.href = "login.jsp";
    }
}, 1000);