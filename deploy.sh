#!/bin/bash

echo "==============================================================="
echo "🚀 STARTING DEPLOYMENT OF MATTERMOST AND GITEA CONTAINERS 🚀"
echo "==============================================================="
echo "$(date)"
echo

# Check if docker-compose is installed
echo "📋 Checking if docker-compose is installed..."
if ! command -v docker-compose &> /dev/null; then
    echo "❌ ERROR: docker-compose is not installed. Please install it first."
    echo "   For Ubuntu: sudo apt install docker-compose"
    echo "   For macOS: brew install docker-compose"
    exit 1
else
    echo "✅ docker-compose is installed. Version: $(docker-compose --version)"
fi

echo
echo "📋 Checking if Docker is running..."
if ! docker info &> /dev/null; then
    echo "❌ ERROR: Docker is not running. Please start Docker first."
    exit 1
else
    echo "✅ Docker is running."
fi

# Create necessary directories if they don't exist
echo
echo "📁 Creating necessary directories..."
if [ ! -d "./data/mattermost" ]; then
    echo "   Creating ./data/mattermost directory..."
    mkdir -p ./data/mattermost
    echo "   ✅ ./data/mattermost created successfully."
else
    echo "   ✅ ./data/mattermost already exists."
fi

if [ ! -d "./data/gitea" ]; then
    echo "   Creating ./data/gitea directory..."
    mkdir -p ./data/gitea
    echo "   ✅ ./data/gitea created successfully."
else
    echo "   ✅ ./data/gitea already exists."
fi

# Pull the latest images
echo
echo "🔄 Pulling latest Docker images..."
echo "   This may take a few minutes depending on your internet connection."
docker-compose pull
echo "✅ Docker images pulled successfully."

# Start the containers
echo
echo "🚀 Starting containers..."
docker-compose up -d
echo "✅ Container startup initiated."

# Check if containers are running
echo
echo "🔍 Checking container status..."
echo "   Waiting 10 seconds for containers to initialize..."
for i in {10..1}; do
    echo -ne "   $i seconds remaining...\r"
    sleep 1
done
echo -ne "                           \r"

echo
echo "📊 Container Status:"
docker-compose ps

if docker-compose ps | grep -q "Up"; then
    echo
    echo "✅ DEPLOYMENT SUCCESSFUL! ✅"
    echo
    echo "🌐 Service URLs:"
    echo "   Mattermost is available at: http://localhost:8065"
    echo "   Gitea is available at: http://localhost:3000"
    echo
    echo "📊 Resource Usage:"
    docker stats --no-stream $(docker-compose ps -q)
else
    echo
    echo "⚠️ Deployment may have issues. Please check the logs below:"
    echo
    docker-compose logs --tail=50
    echo
    echo "For more detailed logs, run: docker-compose logs"
fi

echo
echo "==============================================================="
echo "🏁 DEPLOYMENT PROCESS COMPLETED 🏁"
echo "===============================================================" 