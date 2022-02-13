# First Stage : to install and build dependences
FROM node:14-alpine AS builder
ENV NODE_ENV build
WORKDIR /app
COPY . /app
RUN npm install
RUN  npm run build
COPY . .


# Second Stage : Setup command to run your app
FROM node:14-alpine

ENV NODE_ENV production
USER node
WORKDIR /app

COPY --from=builder /app/package*.json /app/
COPY --from=builder /app/node_modules /app/node_modules/
COPY --from=builder /app/dist/ /app/dist/

EXPOSE 5000

CMD ["node", "dist/main"]
