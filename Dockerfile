FROM arm64v8/node:18.17 AS build

WORKDIR /opt/node_app

COPY package.json yarn.lock ./
RUN yarn --ignore-optional --network-timeout 600000

ARG NODE_ENV=production

COPY . .
RUN yarn build:app:docker

FROM arm64v8/nginx:1.21.3-alpine

COPY --from=build /opt/node_app/build /usr/share/nginx/html

HEALTHCHECK CMD wget -q -O /dev/null http://localhost || exit 1
