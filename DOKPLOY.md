# Guía de Despliegue en Dokploy (VPS) — God's Eye View

Esta guía explica paso a paso cómo desplegar **God's Eye View** en tu servidor VPS utilizando [Dokploy](https://dokploy.com).

---

## 📌 Requisitos Previos

- Un VPS con **Dokploy** instalado y en funcionamiento.
- El repositorio forkeado en tu cuenta personal: [`alexrma/gods-eye-view`](https://github.com/alexrma/gods-eye-view).
- Acceso al panel web de tu Dokploy.

---

## 🚀 Método Recomendado: Despliegue como "Application" (Dockerfile)

Dokploy automatiza el build de la imagen Docker multi-stage y configura el proxy inverso (Traefik) con certificados SSL gratuitos de Let's Encrypt.

### Paso 1: Crear la Aplicación en Dokploy

1. Accede a tu panel de Dokploy.
2. Selecciona o crea un **Project** (por ejemplo, `Proyectos Personales` o `GodsEye`).
3. Haz clic en **Create Service** y elige **Application**.
4. Asígnale un nombre (ej. `gods-eye-view`).

---

### Paso 2: Conectar el Repositorio de GitHub

1. En la pestaña **Source / Provider**:
   - Si tienes GitHub conectado en Dokploy: selecciona tu cuenta `alexrma` y el repositorio `alexrma/gods-eye-view`.
   - Si usas Git público o URL directa: pega `https://github.com/alexrma/gods-eye-view.git`.
2. **Branch**: `main`.
3. **Build Type**: Selecciona **Dockerfile**.
4. **Dockerfile Path**: `/Dockerfile` (por defecto).
5. **Context Path**: `/` (por defecto).

---

### Paso 3: Configurar el Puerto de la Aplicación

1. En la pestaña **General** / **Network** de tu aplicación en Dokploy:
   - **Port**: `4173` *(puerto interno del contenedor donde corre Vite preview)*.

---

### Paso 4: Configurar Dominio y SSL

1. Ve a la pestaña **Domains** en la aplicación.
2. Haz clic en **Add Domain**.
3. Introduce el subdominio o dominio que apunta a tu VPS (ej. `godeye.tudominio.com`).
4. Configura el **Container Port** a `4173`.
5. Activa la opción **HTTPS / SSL (Let's Encrypt)**.
6. Guarda los cambios.

---

### Paso 5: Variables de Entorno (Opcional / Recomendado)

En la pestaña **Environment** de tu aplicación en Dokploy, puedes configurar las credenciales que desees utilizar. 

> 💡 **Nota:** La aplicación funciona inmediatamente sin ninguna clave (usando mapas satelitales públicos de Esri y OpenStreetMap). Si dispones de claves para datos 3D fotorrealistas, voz o telemetría, agrégalas aquí:

```env
# Puerto y Host (necesarios para el contenedor)
PORT=4173
HOST=0.0.0.0

# Terreno 3D Fotorrealista de Google Maps / Búsqueda
GOOGLE_MAPS_API_KEY=
GOOGLE_MAPS_SERVER_API_KEY=

# Cesium Ion Token (para 3D tiles alternativos)
CESIUM_ION_TOKEN=

# Control por Voz con IA (OpenAI Realtime)
OPENAI_API_KEY=

# Barcos en tiempo real (AISStream)
AISSTREAM_API_KEY=

# Incendios satelitales NASA (FIRMS)
FIRMS_MAP_KEY=

# Tráfico en tiempo real (TomTom)
TOMTOM_API_KEY=

# Modo de telemetría de aviones OpenSky (anon o oauth)
OPENSKY_AUTH_MODE=anon
```

---

### Paso 6: Desplegar

1. Haz clic en el botón **Deploy** en la esquina superior derecha.
2. Dokploy clonará el repositorio, ejecutará el build multi-stage y arrancará el contenedor.
3. Puedes supervisar los logs en tiempo real desde la pestaña **Deployments** o **Logs**.
4. Una vez completado, visita tu dominio `https://godeye.tudominio.com`.

---

## 🔄 Despliegues Automáticos (Auto-Deploy)

Para que cada `git push` a tu rama `main` en GitHub despliegue automáticamente en Dokploy:
1. En Dokploy, entra en la pestaña **Deployments** de la aplicación.
2. Copia la **Webhook URL**.
3. En GitHub, ve a tu repositorio `alexrma/gods-eye-view` -> **Settings** -> **Webhooks** -> **Add webhook**.
4. Pega la URL, selecciona `application/json` y el evento `push`.

---

## 🛠️ Método Alternativo: Despliegue con Docker Compose

Si prefieres gestionar la aplicación como un stack de Compose:
1. En Dokploy, crea un servicio de tipo **Compose**.
2. Selecciona tu repositorio GitHub `alexrma/gods-eye-view`.
3. Dokploy detectará automáticamente el archivo `docker-compose.yml`.
4. Define las variables de entorno en la pestaña **Environment** y haz clic en **Deploy**.
