FROM node:latest

RUN mkdir /app

COPY app.js package.json package-lock.json /app/

WORKDIR /app

RUN npm install .

CMD ["npm", "run", "app"]