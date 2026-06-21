#!/usr/bin/env bash
set -e

MODE="${1:-full}"

if [ "$MODE" = "full" ]; then
  CONTAINER_NAME="colab-full"
elif [ "$MODE" = "light" ]; then
  CONTAINER_NAME="colab-light"
else
  echo "Usage: ./attach.sh [full|light]"
  exit 1
fi

echo "Attaching to ${CONTAINER_NAME}..."
docker exec -it "$CONTAINER_NAME" bash
