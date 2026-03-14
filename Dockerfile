FROM node:20-alpine

WORKDIR /app

# Copy proxy + static files
COPY proxy.js .
COPY index.html manifest.json sw.js ./
COPY icons ./icons/

# Install nginx
RUN apk add --no-cache nginx

# Nginx config
COPY nginx.conf /etc/nginx/http.d/default.conf

# Static files for nginx
RUN mkdir -p /usr/share/nginx/html/icons && \
    cp index.html manifest.json sw.js /usr/share/nginx/html/ && \
    cp icons/* /usr/share/nginx/html/icons/

# Startup script: run proxy + nginx together
RUN printf '#!/bin/sh\nnode /app/proxy.js &\nnginx -g "daemon off;"\n' > /start.sh && \
    chmod +x /start.sh

EXPOSE 80

CMD ["/start.sh"]
