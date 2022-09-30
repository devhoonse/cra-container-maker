FROM node:16.17.1-alpine

WORKDIR /app
ENV PATH /app/node_modules/.bin:$PATH

RUN npm install -g create-react-app
RUN npx create-react-app .
RUN npm install react-scripts

CMD ["ls", "-ahl"]