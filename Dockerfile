FROM node:16.17.1-alpine

WORKDIR /app
ENV PATH /app/node_modules/.bin:$PATH

COPY cra-template-custom/ ./cra-template-custom/
RUN npm install -g create-react-app
RUN npx create-react-app cra --template file:./cra-template-custom

CMD ["watch", "ls", "-ahl"]
