FROM node:20-alpine

WORKDIR /app

# Install nginx
RUN apk add --no-cache nginx

# Copy proxy
COPY proxy.js .

# Copy static files to nginx root
RUN mkdir -p /usr/share/nginx/html/icons
COPY index.html manifest.json sw.js favicon.ico /usr/share/nginx/html/
COPY icons/ /usr/share/nginx/html/icons/

# Nginx config
COPY nginx.conf /etc/nginx/http.d/default.conf

# Startup script
COPY start.sh /start.sh
RUN chmod +x /start.sh

EXPOSE 80

CMD ["/bin/sh", "/start.sh"]
