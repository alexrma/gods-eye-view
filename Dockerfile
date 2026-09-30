# syntax=docker/dockerfile:1

# Stage 1: Build the application
FROM node:24-bookworm-slim AS builder

WORKDIR /app

# Optional build-time arguments for pre-baking client keys into bundle
ARG GOOGLE_MAPS_API_KEY
ARG CESIUM_ION_TOKEN
ENV GOOGLE_MAPS_API_KEY=$GOOGLE_MAPS_API_KEY
ENV CESIUM_ION_TOKEN=$CESIUM_ION_TOKEN

# Install dependencies
COPY package.json package-lock.json ./
RUN npm ci

# Copy all source files
COPY . .

# Build production assets into /app/dist
RUN npm run build

# Stage 2: Production runtime runner
FROM node:24-bookworm-slim AS runner

WORKDIR /app

# Install curl for container healthcheck
RUN apt-get update && apt-get install -y --no-install-recommends curl ca-certificates \
    && rm -rf /var/lib/apt/lists/*

ENV NODE_ENV=production
ENV HOST=0.0.0.0
ENV PORT=4173

# Create cache directory and configure ownership for node user
RUN mkdir -p /app/.gev-cache /app/dist && chown -R node:node /app

# Copy dependencies, built assets, server proxies, and configurations
COPY --from=builder --chown=node:node /app/node_modules ./node_modules
COPY --from=builder --chown=node:node /app/dist ./dist
COPY --from=builder --chown=node:node /app/server ./server
COPY --from=builder --chown=node:node /app/src ./src
COPY --from=builder --chown=node:node /app/build ./build
COPY --from=builder --chown=node:node /app/public ./public
COPY --from=builder --chown=node:node /app/package.json ./package.json
COPY --from=builder --chown=node:node /app/vite.config.js ./vite.config.js
COPY --from=builder --chown=node:node /app/index.html ./index.html
COPY --chown=node:node docker-entrypoint.sh /app/docker-entrypoint.sh

RUN chmod +x /app/docker-entrypoint.sh

USER node

EXPOSE 4173

HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
  CMD curl -fsS "http://localhost:${PORT:-4173}/" || exit 1

ENTRYPOINT ["/app/docker-entrypoint.sh"]
