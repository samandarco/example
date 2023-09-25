# syntax=docker/dockerfile:1.4

####################################################################################################
## Build Packages

FROM node:18-alpine AS builder
WORKDIR /directus

ARG TARGETPLATFORM
ARG PORT
ARG RAILWAY_ENVIRONMENT
ARG DB_CLIENT
ARG DB_HOST
ARG DB_PORT
ARG DB_DATABASE
ARG DB_USER
ARG DB_PASSWORD
ARG MESSENGER_STORE
ARG SYNCHRONIZATION_STORE
ARG REDIS_HOST
ARG REDIS_PORT
ARG CACHE_ENABLED
ARG CACHE_STORE
ARG REDIS_USERNAME
ARG REDIS_PASSWORD
ARG STORAGE_LOCATIONS
ARG STORAGE_SUPABASE_DRIVER
ARG STORAGE_SUPABASE_SERVICE_ROLE
ARG STORAGE_SUPABASE_BUCKET
ARG STORAGE_SUPABASE_PROJECT_ID
ARG STORAGE_SUPABASE_ENDPOINT

ENV NODE_OPTIONS=--max-old-space-size=8192

RUN \
  if [ "$TARGETPLATFORM" = 'linux/arm64' ]; then \
  apk --no-cache add \
  python3 \
  build-base \
  && ln -sf /usr/bin/python3 /usr/bin/python \
  ; fi

COPY package.json .
RUN corepack enable && corepack prepare

COPY pnpm-lock.yaml .
RUN pnpm fetch
COPY . .
RUN pnpm install --recursive --offline --frozen-lockfile

RUN : \
	&& npm_config_workspace_concurrency=1 pnpm run build \
	&& pnpm --filter directus deploy --prod dist \
	&& cd dist \
	&& pnpm pack \
	&& tar -zxvf *.tgz package/package.json \
	&& mv package/package.json package.json \
	&& rm -r *.tgz package \
	&& mkdir -p database extensions uploads \
	;

####################################################################################################
## Create Production Image

FROM node:18-alpine AS runtime

USER node

WORKDIR /directus

EXPOSE $PORT

ENV \
	EXTENSIONS_PATH="/directus/extensions" \
	NODE_ENV="production" \
	NPM_CONFIG_UPDATE_NOTIFIER="false"


COPY --from=builder --chown=node:node /directus/dist .

CMD : \
	&& node /directus/cli.js start \
	;
