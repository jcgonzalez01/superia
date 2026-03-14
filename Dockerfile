FROM nginx:alpine

# Coolify sirve desde /app, usamos eso como root
RUN mkdir -p /app/icons

COPY index.html manifest.json sw.js favicon.ico /app/
COPY icons/ /app/icons/
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
