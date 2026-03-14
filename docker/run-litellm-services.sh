#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
COMPOSE_FILE="${SCRIPT_DIR}/compose.yaml"

# Set one of these before running if your LiteLLM endpoint requires auth.
# export MINERU_VL_API_KEY="your_api_key"
# export LITELLM_API_KEY="your_api_key"

export MINERU_DEFAULT_BACKEND="${MINERU_DEFAULT_BACKEND:-vlm-http-client}"
export MINERU_MODEL_SOURCE="${MINERU_MODEL_SOURCE:-huggingface}"
export MINERU_VL_SERVER="${MINERU_VL_SERVER:-${MINERU_OPENAI_SERVER_URL:-https://litellm.uaysk.com}}"
export MINERU_OPENAI_SERVER_URL="${MINERU_OPENAI_SERVER_URL:-${MINERU_VL_SERVER}}"
export MINERU_VL_MODEL_NAME="mineru2.5"
export MINERU_VL_API_KEY="${MINERU_VL_API_KEY:-${LITELLM_API_KEY:-sk-srGY0gEDL1A3KkOKiVkFqg}}"

echo "Compose file: ${COMPOSE_FILE}"
echo "Model source: ${MINERU_MODEL_SOURCE}"
echo "Server URL: ${MINERU_VL_SERVER}"
echo "Model name: ${MINERU_VL_MODEL_NAME}"
if [[ -n "${MINERU_VL_API_KEY}" ]]; then
  echo "API key: configured"
else
  echo "API key: not set"
fi

exec docker compose \
  -f "${COMPOSE_FILE}" \
  --profile api \
  --profile gradio \
  up -d --force-recreate
