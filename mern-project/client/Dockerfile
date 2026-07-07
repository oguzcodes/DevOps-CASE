# 1. Aşama: Builder
FROM node:18-bullseye-slim AS builder
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build

# 2. Aşama: Runner
FROM nginx:stable
RUN rm /etc/nginx/conf.d/default.conf
# SPA routing için temel nginx ayarını kopyalıyoruz
COPY nginx.conf /etc/nginx/conf.d/
COPY --from=builder /app/build /usr/share/nginx/html

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]