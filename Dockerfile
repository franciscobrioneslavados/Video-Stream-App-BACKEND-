# First Stage : to install and build dependences
FROM node:12-alpine AS builder
ENV NODE_ENV build

WORKDIR /app

COPY . /app

RUN yarn install && npm run build && npm prune --production

# ---

# Second Stage : Setup command to run your app
FROM node:12-alpine

ENV NODE_ENV production
USER node
WORKDIR /app

COPY --from=builder /app/package*.json /app/
COPY --from=builder /app/node_modules/ /app/node_modules/
COPY --from=builder /app/dist/ /app/dist/

EXPOSE 5000

CMD ["node", "dist/main.js"]
