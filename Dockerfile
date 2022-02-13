# First Stage : to install and build dependences
FROM node:14-alpine AS builder
ENV NODE_ENV build

WORKDIR /home/node

COPY . /home/node

RUN npm ci && npm run build && npm prune --production

# ---

# Second Stage : Setup command to run your app
FROM node:14-alpine

ENV NODE_ENV production
USER node
WORKDIR /home/node

COPY --from=builder /home/node/package*.json /home/node/
COPY --from=builder /home/node/node_modules/ /home/node/node_modules/
COPY --from=builder /home/node/dist/ /home/node/dist/

EXPOSE 5000

CMD ["node", "dist/main.js"]
