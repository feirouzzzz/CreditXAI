#!/bin/bash

if [ "$#" -ne 2 ]; then
  echo "Usage: ./tag_push.sh <image_name> <tag>"
  exit 1
fi

IMAGE=$1
TAG=$2

echo "🔖 Building Docker image $IMAGE:$TAG..."
docker build -t $IMAGE:$TAG ./services/$IMAGE

echo "🔖 Tagging image for GitHub Container Registry..."
docker tag $IMAGE:$TAG ghcr.io/<feirouzzzz>/$IMAGE:$TAG

echo "🚀 Pushing image to registry..."
docker push ghcr.io/<feirouzzzz>/$IMAGE:$TAG

echo "✅ Done."
