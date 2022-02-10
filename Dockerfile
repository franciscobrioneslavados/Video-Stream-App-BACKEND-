# First Stage : to install and build dependences
FROM node:14-alpine AS builder
ENV NODE_ENV build
WORKDIR /app
COPY . /app
RUN npm ci && npm run build && npm prune --production
COPY . .


# Second Stage : Setup command to run your app
FROM node:14-alpine

ENV NODE_ENV production
USER node
WORKDIR /app

COPY --from=builder /app/package*.json /app/
COPY --from=builder /app/node_modules /app/node_modules/
COPY --from=builder /app/dist/ /app/dist/

CMD ["node", "dist/main"]
