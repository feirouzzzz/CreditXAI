#!/bin/bash
echo "🧹 Cleaning Docker system..."
docker system prune -f
docker image prune -f
docker volume prune -f
echo "✅ Clean complete."
