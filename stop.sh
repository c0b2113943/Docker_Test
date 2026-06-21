#!/usr/bin/env bash
set -e

MODE="${1:-full}"

if [ "$MODE" = "full" ]; then
  COMPOSE_FILE="docker-compose.yml"
elif [ "$MODE" = "light" ]; then
  COMPOSE_FILE="docker-compose.light.yml"
else
  echo "Usage: ./stop.sh [full|light]"
  exit 1
fi

echo "Stopping ${MODE} environment..."
docker compose -f "$COMPOSE_FILE" down

echo "Stopped."
