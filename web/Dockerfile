FROM node:22.13.0-alpine

WORKDIR /app

COPY package*.json ./

RUN npm install

COPY . /app

RUN npm run build

EXPOSE 5000

CMD npm run start
