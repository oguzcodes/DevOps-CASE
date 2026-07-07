# 1. Aşama: Builder
FROM node:18-bullseye-slim AS builder
WORKDIR /app
COPY package*.json ./
RUN npm install --production

# 2. Aşama: Runner
FROM node:18-bullseye-slim AS runner
WORKDIR /app
ENV NODE_ENV=production
COPY --from=builder /app/node_modules ./node_modules
COPY . .

USER node
EXPOSE 5050
CMD ["node", "server.mjs"]