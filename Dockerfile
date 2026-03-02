FROM debian:bookworm-slim AS css-builder
WORKDIR /app

ARG TAILWIND_VERSION=v3.4.17
ARG TAILWIND_SHA256
RUN apt-get update \
  && apt-get install -y --no-install-recommends curl ca-certificates \
  && rm -rf /var/lib/apt/lists/*

RUN test -n "${TAILWIND_SHA256}"
RUN curl -fsSL \
  "https://github.com/tailwindlabs/tailwindcss/releases/download/${TAILWIND_VERSION}/tailwindcss-linux-x64" \
  -o /usr/local/bin/tailwindcss \
  && echo "${TAILWIND_SHA256}  /usr/local/bin/tailwindcss" | sha256sum -c - \
  && chmod +x /usr/local/bin/tailwindcss

COPY tailwind.config.js ./
COPY src ./src
COPY app ./app
COPY main.nim ./main.nim
RUN mkdir -p public/css \
  && tailwindcss -c ./tailwind.config.js -i ./src/styles/tailwind.css -o ./public/css/tailwind.css --minify

FROM nimlang/nim:alpine AS nim-builder
WORKDIR /app

ARG BASOLATO_REPO=https://github.com/itsumura-h/nim-basolato
ARG BASOLATO_REF=6ef054fa959d4a10421723c5ccbd3ea9b751c240
RUN apk add --no-cache git build-base

RUN tmp_dir="$(mktemp -d)" \
  && git clone --filter=blob:none "${BASOLATO_REPO}" "${tmp_dir}/repo" \
  && cd "${tmp_dir}/repo" \
  && git checkout --detach "${BASOLATO_REF}" \
  && nimble install -y . \
  && cd / \
  && rm -rf "${tmp_dir}"

COPY app ./app
COPY main.nim ./
COPY config.nims ./
COPY public ./public
COPY --from=css-builder /app/public/css/tailwind.css ./public/css/tailwind.css

RUN nim c -d:release --opt:size --hints:off -o:server main.nim

FROM alpine:3.20
WORKDIR /app

RUN apk add --no-cache libstdc++ pcre
RUN addgroup -S app && adduser -S -G app app

ENV HOST=0.0.0.0
ENV PORT=8080

COPY --from=nim-builder --chown=app:app /app/server ./server
COPY --from=nim-builder --chown=app:app /app/public ./public

EXPOSE 8080
USER app:app
CMD ["./server"]
