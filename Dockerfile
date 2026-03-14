FROM node:20-alpine

WORKDIR /app

COPY server.js .

RUN mkdir -p public/icons
COPY index.html manifest.json sw.js favicon.ico public/
COPY icons/ public/icons/

EXPOSE 3000

CMD ["node", "server.js"]
