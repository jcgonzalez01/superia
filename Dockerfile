FROM nginx:alpine

RUN mkdir -p /usr/share/nginx/html/icons

COPY index.html manifest.json sw.js favicon.ico /usr/share/nginx/html/
COPY icons/ /usr/share/nginx/html/icons/
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
