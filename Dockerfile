FROM node:20-alpine as builder

COPY . /app

WORKDIR /app

RUN npm install --legacy-peer-deps
ENV NODE_OPTIONS=--openssl-legacy-provider
# workaround hack: force old lz-string
RUN npm install lz-string@1.4.4 --legacy-peer-deps
RUN rm -rf node_modules/secure-ls/node_modules
RUN npm run build

FROM caddy:2.4.5-alpine as server

COPY Caddyfile /etc/caddy/Caddyfile

COPY --from=builder /app/dist /app

WORKDIR /app

EXPOSE 8080

ENTRYPOINT [ "caddy", "run", "--config", "/etc/caddy/Caddyfile"]
