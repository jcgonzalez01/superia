FROM nginx:alpine

# Eliminar configs por defecto que Coolify podría sobrescribir
RUN rm -f /etc/nginx/conf.d/default.conf \
          /etc/nginx/conf.d/*.conf \
          /etc/nginx/sites-enabled/* 2>/dev/null || true

# Archivos estáticos en /app (donde Coolify los espera)
RUN mkdir -p /app/icons
COPY index.html manifest.json sw.js favicon.ico /app/
COPY icons/ /app/icons/

# Escribir nginx.conf directamente en el main config (no en conf.d)
RUN echo 'events { worker_processes auto; }' > /etc/nginx/nginx.conf && \
    echo 'http {' >> /etc/nginx/nginx.conf && \
    echo '  include /etc/nginx/mime.types;' >> /etc/nginx/nginx.conf && \
    echo '  default_type application/octet-stream;' >> /etc/nginx/nginx.conf && \
    echo '  server {' >> /etc/nginx/nginx.conf && \
    echo '    listen 80;' >> /etc/nginx/nginx.conf && \
    echo '    root /app;' >> /etc/nginx/nginx.conf && \
    echo '    index index.html;' >> /etc/nginx/nginx.conf && \
    echo '    location = /proxy/v1/messages {' >> /etc/nginx/nginx.conf && \
    echo '      proxy_pass https://api.anthropic.com/v1/messages;' >> /etc/nginx/nginx.conf && \
    echo '      proxy_ssl_server_name on;' >> /etc/nginx/nginx.conf && \
    echo '      proxy_set_header Host api.anthropic.com;' >> /etc/nginx/nginx.conf && \
    echo '      proxy_pass_request_headers on;' >> /etc/nginx/nginx.conf && \
    echo '      proxy_read_timeout 30s;' >> /etc/nginx/nginx.conf && \
    echo '      add_header Access-Control-Allow-Origin * always;' >> /etc/nginx/nginx.conf && \
    echo '      add_header Access-Control-Allow-Methods "POST, OPTIONS" always;' >> /etc/nginx/nginx.conf && \
    echo '      add_header Access-Control-Allow-Headers "Content-Type, x-api-key, anthropic-version" always;' >> /etc/nginx/nginx.conf && \
    echo '      if ($request_method = OPTIONS) { return 204; }' >> /etc/nginx/nginx.conf && \
    echo '    }' >> /etc/nginx/nginx.conf && \
    echo '    location / { try_files $uri $uri/ /index.html; }' >> /etc/nginx/nginx.conf && \
    echo '  }' >> /etc/nginx/nginx.conf && \
    echo '}' >> /etc/nginx/nginx.conf

# Verificar que el config es válido en build time
RUN nginx -t

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
