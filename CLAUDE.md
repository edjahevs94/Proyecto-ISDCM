# Proyecto ISDCM — Guía de configuración (Entrega 3)

## Arquitectura actual

Hay **tres** aplicaciones Maven (WAR):

| Proyecto | Servidor | Rama | Repositorio |
|---|---|---|---|
| **Proyecto-ISDCM** | GlassFish 6 | `feature/entregable-03` | github.com/edjahevs94/Proyecto-ISDCM |
| **Proyecto-ISDCM-Backend** | GlassFish 6 | `feature/entregable-03` | github.com/edjahevs94/Proyecto-ISDCM-Backend |
| **Proyecto-ISDCM-HTTPS** | Tomcat 10 (HTTPS) | `master` | github.com/MarioJGC/Proyecto-ISDCM-HTTPS |

- **Proyecto-ISDCM** — Frontend (JSP + Servlets). Login, registro usuarios, listado/búsqueda/reproducción de vídeos, subida de vídeos, cifrado de contenidos multimedia (AES) y cifrado de XML (XMLCipher AES-128).
- **Proyecto-ISDCM-Backend** — API REST (JAX-RS). Endpoints para buscar, actualizar y registrar reproducciones. GlassFish provee JAX-RS nativamente.
- **Proyecto-ISDCM-HTTPS** — App mínima de registro de usuarios sobre HTTPS/TLS con certificado autofirmado. Solo corre en Tomcat 10.

## Stack
- Java 17 (Oracle JDK en `/usr/lib/jvm/java-17-oracle`)
- Jakarta EE 9.1 (namespace `jakarta.*`)
- Eclipse GlassFish 6.2.4 — para Proyecto-ISDCM y Proyecto-ISDCM-Backend
- Apache Tomcat 10.1.54 — solo para Proyecto-ISDCM-HTTPS
- Apache Derby 10.14.x como servidor de BD (puerto 1527)
- Apache XML Security (xmlsec 1.5.8) — para cifrado XML

## Rutas importantes
| Recurso | Ruta |
|---|---|
| Proyecto frontend | `/home/alumne/Documentos/proyecto/Proyecto-ISDCM` |
| Proyecto backend | `/home/alumne/Documentos/proyecto/Proyecto-ISDCM-Backend` |
| Proyecto HTTPS | `/home/alumne/Documentos/proyecto/Proyecto-ISDCM-HTTPS` |
| Tomcat 10 | `/home/alumne/Documentos/apache-tomcat-10.1.54` |
| GlassFish | `/home/alumne/GlassFish_Server` |
| Base de datos Derby | `/home/alumne/derbyDB/isdcm` |
| Derby (binarios) | `/opt/derby/lib/derbyrun.jar` |
| Directorio vídeos subidos | `/home/alumne/isdcm_videos/` |
| Keystore SSL | `/home/alumne/.keystore` (contraseña: `isdcm1`) |

---

## PASO 1 — Verificar que Derby está corriendo

Derby debe estar activo antes de arrancar cualquier servidor.

```bash
systemctl status derby
```

Si no está activo: `sudo systemctl start derby`

Verificar que responde:
```bash
java -jar /opt/derby/lib/derbyrun.jar server ping
```
Resultado esperado: `Conexión obtenida para el host: localhost, número de puerto 1527`

### Si el servicio Derby no existe, crearlo

Crear `/etc/systemd/system/derby.service`:

```ini
[Unit]
Description=Apache Derby Network Server
After=network.target

[Service]
Type=simple
User=alumne
WorkingDirectory=/home/alumne/derbyDB
Environment="JAVA_HOME=/usr"
ExecStart=/usr/bin/java -jar /opt/derby/lib/derbyrun.jar server start
ExecStop=/usr/bin/java -jar /opt/derby/lib/derbyrun.jar server shutdown
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
```

```bash
sudo systemctl daemon-reload && sudo systemctl enable derby && sudo systemctl start derby
```

---

## PASO 2 — Crear directorio de vídeos

El servlet de subida de vídeos guarda los ficheros en esta ruta fija (necesario porque GlassFish no garantiza `getRealPath()`):

```bash
mkdir -p /home/alumne/isdcm_videos
```

---

## PASO 3 — Clonar los repositorios

```bash
cd /home/alumne/Documentos/proyecto

# Frontend
git clone https://github.com/edjahevs94/Proyecto-ISDCM.git
git -C Proyecto-ISDCM checkout feature/entregable-03

# Backend
git clone https://github.com/edjahevs94/Proyecto-ISDCM-Backend.git
git -C Proyecto-ISDCM-Backend checkout feature/entregable-03

# HTTPS (Tomcat)
git clone https://github.com/MarioJGC/Proyecto-ISDCM-HTTPS.git
```

---

## PASO 4 — Configurar servidores en NetBeans

### 4.1 GlassFish (para Proyecto-ISDCM y Proyecto-ISDCM-Backend)
`Tools → Servers → Add Server → GlassFish Server`
- Asignar GlassFish como servidor en las propiedades de ambos proyectos:
  clic derecho → `Properties → Run → Server → GlassFish`

### 4.2 Tomcat 10 (para Proyecto-ISDCM-HTTPS)
El archivo `/home/alumne/Documentos/apache-tomcat-10.1.54/conf/tomcat-users.xml` debe contener:

```xml
<role rolename="manager-gui"/>
<role rolename="manager-script"/>
<user username="admin" password="admin" roles="manager-gui,manager-script"/>
```

`Tools → Servers → Add Server → Apache Tomcat or TomEE`
- Server Location: `/home/alumne/Documentos/apache-tomcat-10.1.54`
- Username: `admin` / Password: `admin`

Asignar Tomcat 10 solo a `Proyecto-ISDCM-HTTPS`:
clic derecho → `Properties → Run → Server → Apache Tomcat`

### 4.3 Conector HTTPS en server.xml de Tomcat

El archivo `/home/alumne/Documentos/apache-tomcat-10.1.54/conf/server.xml` debe tener:

```xml
<Connector port="8443" protocol="org.apache.coyote.http11.Http11NioProtocol"
           maxThreads="150" SSLEnabled="true" maxParameterCount="1000">
    <SSLHostConfig>
        <Certificate certificateKeystoreFile="${user.home}/.keystore"
                     certificateKeystorePassword="isdcm1"
                     type="RSA" />
    </SSLHostConfig>
</Connector>
```

---

## PASO 5 — Generar el keystore SSL (si no existe)

```bash
ls /home/alumne/.keystore
```

Si no existe, ejecutar en orden (contraseña: `isdcm1`):

```bash
/usr/lib/jvm/java-17-oracle/bin/keytool -genkeypair -keysize 2048 -keyalg RSA \
  -alias isdcm \
  -dname "CN=Mario_Grande, OU=FIB, O=UPC, L=Barcelona, S=Barcelona, C=ES" \
  -keystore /home/alumne/.keystore

/usr/lib/jvm/java-17-oracle/bin/keytool -certreq -alias isdcm \
  -keystore /home/alumne/.keystore > certreq-isdcm.csr

/usr/lib/jvm/java-17-oracle/bin/keytool -gencert -alias isdcm \
  -infile certreq-isdcm.csr -outfile cert-isdcm.pem -rfc \
  -keystore /home/alumne/.keystore

/usr/lib/jvm/java-17-oracle/bin/keytool -importcert -file cert-isdcm.pem \
  -alias isdcm -keystore /home/alumne/.keystore

/usr/lib/jvm/java-17-oracle/bin/keytool -v -list -keystore /home/alumne/.keystore
```

---

## PASO 6 — Desplegar y probar

### 6.1 Orden de arranque
1. Arrancar Derby (`systemctl start derby`)
2. Arrancar GlassFish desde NetBeans → desplegar Proyecto-ISDCM y Proyecto-ISDCM-Backend
3. Arrancar Tomcat desde NetBeans → desplegar Proyecto-ISDCM-HTTPS

### 6.2 URLs de prueba

| App | URL |
|---|---|
| Frontend (GlassFish) | `http://localhost:8080/Proyecto-ISDCM/` |
| Backend REST | `http://localhost:8080/Proyecto-ISDCM-Backend/api/videos/buscar?titulo=` |
| Registro HTTPS (Tomcat) | `https://localhost:8443/Proyecto-ISDCM-HTTPS/` |

### 6.3 Verificar BD
```bash
echo "CONNECT 'jdbc:derby://localhost:1527/isdcm;user=isdcm;password=isdcm'; SELECT COUNT(*) FROM Videos; EXIT;" | java -jar /opt/derby/lib/derbyrun.jar ij
```

---

## Funcionalidades implementadas (Entrega 3)

### Parte 1 — HTTPS (Proyecto-ISDCM-HTTPS)
- Registro de usuarios a través de conexión segura HTTPS/TLS
- Certificado autofirmado generado con `keytool`
- Redirección automática HTTP → HTTPS mediante `security-constraint` en `web.xml`
- Interfaz idéntica al formulario de registro del frontend principal

### Parte 2.1 — Cifrado de contenidos multimedia
- Servlet: `ServletCifradoContenido` → `/ServletCifradoContenido`
- Página: `cifradoContenido.jsp` (accesible desde el botón "Cifrado" en el listado)
- El usuario sube cualquier fichero (vídeo, imagen, audio, etc.)
- **Cifrado:** AES/CBC/PKCS5Padding, clave 128 bits, IV aleatorio de 16 bytes prepuesto al fichero
- **Descifrado:** extrae el IV de los primeros 16 bytes y recupera el fichero original
- Procesado en **streaming** (no carga todo en RAM) → soporta ficheros grandes
- Clase de utilidad: `util/CifradoUtil.java`
- Validar resultado: `diff fichero_original fichero_descifrado && echo OK`

### Parte 2.2 — Cifrado de Digital Items (XML Encryption)
- Servlet: `ServletCifradoXML` → `/ServletCifradoXML`
- Página: `cifradoXML.jsp` (accesible desde el botón "Cifrado XML" en el listado)
- Librería: Apache XML Security `org.apache.santuario:xmlsec:1.5.8`
- Algoritmo: `XMLCipher.AES_128` (estándar W3C XML Encryption)
- Fichero de ejemplo incluido: `webapp/xml/didlFilm1.xml` (Digital Item MPEG-21)
- Modos de cifrado:
  - Elemento completo (el tag queda sustituido por `<xenc:EncryptedData>`)
  - Solo el contenido del elemento
  - Se puede indicar cualquier tag por nombre (`metadata`, `Statement`, etc.) o dejar vacío para cifrar el elemento raíz
- Clase de utilidad: `util/CifradoXMLUtil.java`

### Subida de vídeos desde el ordenador
- Formulario de registro con dos pestañas: URL externa o subir fichero local
- El fichero se guarda en `/home/alumne/isdcm_videos/` (directorio fijo, compatible con GlassFish)
- Autodetección del formato a partir de la extensión del fichero o URL
- Servlet `ServletVideo` → `/video/*` sirve los vídeos con soporte Range (seeking)
- Formatos soportados: MP4, OGG, AVI, MKV, MOV, WebM

---

## Decisiones de arquitectura relevantes

### Por qué GlassFish para el frontend/backend
El enunciado de la Parte 2 especifica GlassFish. El backend usa JAX-RS que GlassFish provee nativamente, por lo que **no se incluyen dependencias Jersey en el WAR** (generarían conflictos). El `AppConfig.java` con `@ApplicationPath("/api")` es suficiente para el autodescubrimiento en GlassFish.

### Por qué Tomcat solo para HTTPS
La Parte 1 especifica Tomcat con certificados SSL. `Proyecto-ISDCM-HTTPS` es una app mínima independiente que demuestra HTTPS y que se mantiene separada del resto.

### Directorio de vídeos fuera del WAR
`getServletContext().getRealPath()` devuelve `null` en GlassFish cuando el WAR no está completamente desempaquetado. Por eso los vídeos se guardan en `/home/alumne/isdcm_videos/` y se sirven mediante `ServletVideo`.

### `@MultipartConfig` en GlassFish
Siempre especificar `location = "/tmp"` en la anotación, de lo contrario GlassFish lanza `RuntimeException: Error in multipart initialization`.

---

## Errores comunes y soluciones

| Error | Causa | Solución |
|---|---|---|
| `NullPointerException` en `new File(dirPath)` | `getRealPath()` devuelve null en GlassFish | Usar ruta fija `System.getProperty("user.home") + "/isdcm_videos/"` |
| `RuntimeException: Error in multipart initialization` | `@MultipartConfig` sin `location` en GlassFish | Añadir `location = "/tmp"` a la anotación |
| `OutOfMemoryError` al cifrar ficheros grandes | Carga todo el fichero en RAM con `readAllBytes()` | Usar `CipherOutputStream`/`CipherInputStream` en streaming |
| Backend devuelve 404 en `/api/...` | JAX-RS no detectado | Verificar que `AppConfig.java` tiene `@ApplicationPath("/api")` y que no hay dependencias Jersey en el WAR |
| `conn is null` en login | Derby no corre o driver incorrecto | `systemctl start derby` y verificar `ClientAutoloadedDriver` en `ConexionBD.java` |
| Error SSL al arrancar Tomcat | Keystore no existe o contraseña incorrecta | Verificar `/home/alumne/.keystore` y contraseña `isdcm1` en `server.xml` |
| Puertos ocupados al arrancar Tomcat | GlassFish usa el 8080 | Parar GlassFish antes de arrancar Tomcat o cambiar el puerto de Tomcat |
