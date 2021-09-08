FROM node:lts-buster-slim as builder
WORKDIR /app
COPY . /app
RUN yarn install && yarn run build

FROM nginx:latest
COPY --from=builder /app/build /usr/share/nginx/html