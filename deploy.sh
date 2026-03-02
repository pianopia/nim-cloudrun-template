#!/bin/sh
set -eu

ROOT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$ROOT_DIR"
. "${ROOT_DIR}/scripts/load_env.sh"

load_env_file ".env"

PROJECT_ID="${PROJECT_ID:-}"
SERVICE="${SERVICE:-basolato-app}"
REGION="${REGION:-asia-northeast1}"
IMAGE="${REGION}-docker.pkg.dev/${PROJECT_ID}/${SERVICE}/${SERVICE}:latest"
PORT="${PORT:-8080}"
SECRET_NAME="${SECRET_NAME:-${SERVICE}-secret-key}"
SERVICE_ACCOUNT="${SERVICE_ACCOUNT:-}"
TAILWIND_SHA256_LINUX_X64="${TAILWIND_SHA256_LINUX_X64:-}"
BASOLATO_REF="${BASOLATO_REF:-}"

: "${PROJECT_ID:?Set PROJECT_ID in .env or env vars}"
: "${TAILWIND_SHA256_LINUX_X64:?Set TAILWIND_SHA256_LINUX_X64 in .env or env vars}"

PROJECT_NUMBER="$(gcloud projects describe "$PROJECT_ID" --format='value(projectNumber)')"
if [ -z "$SERVICE_ACCOUNT" ]; then
  SERVICE_ACCOUNT="${PROJECT_NUMBER}-compute@developer.gserviceaccount.com"
fi

gcloud config set project "$PROJECT_ID"
gcloud artifacts repositories create "$SERVICE" --repository-format=docker --location="$REGION" >/dev/null 2>&1 || true
gcloud auth configure-docker "${REGION}-docker.pkg.dev" --quiet
if [ -n "$BASOLATO_REF" ]; then
  docker buildx build --platform linux/amd64 \
    --build-arg "TAILWIND_SHA256=${TAILWIND_SHA256_LINUX_X64}" \
    --build-arg "BASOLATO_REF=${BASOLATO_REF}" \
    -t "$IMAGE" --push .
else
  docker buildx build --platform linux/amd64 \
    --build-arg "TAILWIND_SHA256=${TAILWIND_SHA256_LINUX_X64}" \
    -t "$IMAGE" --push .
fi

if gcloud secrets describe "$SECRET_NAME" --project "$PROJECT_ID" >/dev/null 2>&1; then
  if [ -n "${SECRET_KEY:-}" ]; then
    printf '%s' "$SECRET_KEY" | gcloud secrets versions add "$SECRET_NAME" --project "$PROJECT_ID" --data-file=-
  fi
else
  : "${SECRET_KEY:?Set SECRET_KEY to create the initial secret value}"
  printf '%s' "$SECRET_KEY" | gcloud secrets create "$SECRET_NAME" \
    --project "$PROJECT_ID" \
    --replication-policy=automatic \
    --data-file=-
fi

gcloud secrets add-iam-policy-binding "$SECRET_NAME" \
  --project "$PROJECT_ID" \
  --member="serviceAccount:${SERVICE_ACCOUNT}" \
  --role="roles/secretmanager.secretAccessor" >/dev/null

ENV_VARS=""
[ -n "${SITE_NAME:-}" ] && ENV_VARS="SITE_NAME=${SITE_NAME}"
if [ -n "${SITE_URL:-}" ]; then
  if [ -n "$ENV_VARS" ]; then
    ENV_VARS="${ENV_VARS},SITE_URL=${SITE_URL}"
  else
    ENV_VARS="SITE_URL=${SITE_URL}"
  fi
fi

if [ -n "$ENV_VARS" ]; then
  gcloud run deploy "$SERVICE" \
    --image "$IMAGE" \
    --region "$REGION" \
    --platform managed \
    --allow-unauthenticated \
    --port "$PORT" \
    --service-account "$SERVICE_ACCOUNT" \
    --set-secrets "SECRET_KEY=${SECRET_NAME}:latest" \
    --set-env-vars "$ENV_VARS"
else
  gcloud run deploy "$SERVICE" \
    --image "$IMAGE" \
    --region "$REGION" \
    --platform managed \
    --allow-unauthenticated \
    --port "$PORT" \
    --service-account "$SERVICE_ACCOUNT" \
    --set-secrets "SECRET_KEY=${SECRET_NAME}:latest"
fi
