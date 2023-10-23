# build stage
FROM node:lts-alpine
RUN mkdir /app
WORKDIR /app
# This copy command is being gotten from the root of the ui process
#build ontext in the docker compose file
#Read the docker compose file for more info

COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build
EXPOSE 8000
CMD ["npm", "run", "serve"]