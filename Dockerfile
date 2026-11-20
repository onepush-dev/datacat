# DataCat on Railway: upstream replit/datacat (Apache-2.0) built from source at a pinned commit, code unmodified.
# Same build steps as the upstream Dockerfile; Railway layer bakes the listener port (8080) and safe defaults
# (proxy trust for Railway's edge, 15-day retention) so the template needs no plain variables.
ARG DATACAT_COMMIT=f08fb635fd7f28f6ed725209382af3e2c2673676

FROM node:22-bookworm-slim AS build
ARG DATACAT_COMMIT
RUN apt-get update && apt-get install -y --no-install-recommends git ca-certificates && rm -rf /var/lib/apt/lists/*
WORKDIR /app
RUN corepack enable && corepack prepare pnpm@10.11.0 --activate
RUN git clone https://github.com/replit/datacat /app && git checkout ${DATACAT_COMMIT}
RUN pnpm install --frozen-lockfile --filter @workspace/api-server... --filter @workspace/web...
RUN BASE_PATH=/ pnpm run build:selfhost

FROM node:22-bookworm-slim AS runtime
LABEL org.opencontainers.image.source="https://github.com/onepush-dev/datacat"
ENV NODE_ENV=production \
    PORT=8080 \
    DATACAT_DOWNLOADS_DIR=/app/downloads \
    DATACAT_TRUST_PROXY=1 \
    DATACAT_RETENTION_DAYS=15
WORKDIR /app
RUN mkdir -p /app/downloads && chown node:node /app/downloads
COPY --from=build --chown=node:node /app/artifacts/api-server/dist ./artifacts/api-server/dist
COPY --from=build --chown=node:node /app/artifacts/web/dist ./artifacts/web/dist
COPY --from=build --chown=node:node /app/LICENSE /app/NOTICE /app/THIRD_PARTY_LICENSES.md ./
USER node
EXPOSE 8080
CMD ["node", "--enable-source-maps", "artifacts/api-server/dist/index.mjs"]
