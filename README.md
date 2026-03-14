# PreciosRD PWA

Comparador de precios para supermercados de República Dominicana.
Supermercados: La Sirena, Nacional, Jumbo, Bravo.

## Archivos
```
precios-rd-pwa/
├── index.html       ← App completa
├── manifest.json    ← Config PWA
├── sw.js            ← Service worker (offline)
├── nginx.conf       ← Config Nginx
├── Dockerfile       ← Para Coolify
└── icons/
    ├── icon-192.png
    └── icon-512.png
```

## Despliegue en Coolify

1. Sube esta carpeta a un repo Git (GitHub, GitLab, etc.)
2. En Coolify → New Resource → Static Site o Docker
3. Apunta al repo, rama main
4. Coolify detecta el Dockerfile automáticamente
5. Deploy → obtén la URL HTTPS

## Instalar en Android

1. Abre la URL en Chrome
2. Menú (⋮) → "Agregar a pantalla de inicio"
3. O espera el banner automático que aparece en la app
4. Confirma → queda como app nativa

## Configurar API Key

- Al abrir la app, toca "API Key" arriba a la derecha
- Ingresa tu key de console.anthropic.com → API Keys
- Se guarda localmente en el dispositivo (nunca sale de tu teléfono)
- Sin API key puedes usar la entrada manual sin problema

## Funciones
- Buscar precios con IA (requiere API key)
- Entrada manual de precios
- Historial con detección de cambios de precio (↑ ↓)
- Lista optimizada: cuánto comprar en cada super y ahorro total
- Funciona offline (datos guardados localmente)
