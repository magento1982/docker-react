FROM node:lts-buster-slim
WORKDIR /app
COPY . /app
RUN yarn install && yarn run build

FROM nginx:latest
COPY --from=build /app/build /usr/share/nginx/html