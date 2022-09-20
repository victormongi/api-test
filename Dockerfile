FROM node:lts-bullseye
WORKDIR /apps
COPY . .
RUN npm install
EXPOSE 5050
CMD [ "npm", "start" ]