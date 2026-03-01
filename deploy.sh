#!/bin/sh
set -eu

PROJECT_ID="${PROJECT_ID:-}"
SERVICE="${SERVICE:-basolato-app}"
REGION="${REGION:-asia-northeast1}"
IMAGE="${REGION}-docker.pkg.dev/${PROJECT_ID}/${SERVICE}/${SERVICE}:latest"
PORT="${PORT:-8080}"

[ -f .env ] && set -a && . ./.env && set +a
: "${PROJECT_ID:?Set PROJECT_ID in .env or env vars}"
: "${SECRET_KEY:?Set SECRET_KEY in .env or env vars}"

gcloud config set project "$PROJECT_ID"
gcloud artifacts repositories create "$SERVICE" --repository-format=docker --location="$REGION" >/dev/null 2>&1 || true
gcloud auth configure-docker "${REGION}-docker.pkg.dev" --quiet
docker buildx build --platform linux/amd64 -t "$IMAGE" --push .

ENV_VARS="SECRET_KEY=${SECRET_KEY}"
[ -n "${SITE_NAME:-}" ] && ENV_VARS="${ENV_VARS},SITE_NAME=${SITE_NAME}"
[ -n "${SITE_URL:-}" ] && ENV_VARS="${ENV_VARS},SITE_URL=${SITE_URL}"

gcloud run deploy "$SERVICE" \
  --image "$IMAGE" \
  --region "$REGION" \
  --platform managed \
  --allow-unauthenticated \
  --port "$PORT" \
  --set-env-vars "$ENV_VARS"
