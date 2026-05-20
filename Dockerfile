FROM node:22 AS builder
WORKDIR /app
COPY ./repo/public ./public
COPY ./repo/src ./src
COPY ./repo/index.html ./
COPY ./repo/package*.json ./
COPY ./repo/tsconfig.json ./
COPY ./repo/vite.config.ts ./
ARG VITE_ANALOG_API_GET_REQUEST_QUEUE
ARG VITE_ANALOG_API_GET_REQUEST_CLEAN_UP
ARG VITE_ANALOG_TIME_RANGE
ARG VITE_ANALOG_PAGE_TITLE
ENV VITE_ANALOG_API_GET_REQUEST_QUEUE=$VITE_ANALOG_API_GET_REQUEST_QUEUE
ENV VITE_ANALOG_API_GET_REQUEST_CLEAN_UP=$VITE_ANALOG_API_GET_REQUEST_CLEAN_UP
ENV VITE_ANALOG_TIME_RANGE=$VITE_ANALOG_TIME_RANGE
ENV VITE_ANALOG_PAGE_TITLE=$VITE_ANALOG_PAGE_TITLE
RUN npm install && npm run build

FROM node:22
WORKDIR /app
COPY ./repo/src ./src
COPY ./repo/package*.json ./
COPY ./repo/tsconfig.json ./
COPY --from=builder /app/dist ./repo/./src/services/server/dist
RUN npm install
CMD ["npx", "tsx", "src/services/server/index.ts"]
