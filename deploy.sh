#!/bin/bash

echo "Starting deployment of Mattermost and Gitea..."

# Check if docker-compose is installed
if ! command -v docker-compose &> /dev/null; then
    echo "Error: docker-compose is not installed. Please install it first."
    exit 1
fi

# Create necessary directories if they don't exist
mkdir -p ./data/mattermost
mkdir -p ./data/gitea

# Pull the latest images
echo "Pulling latest Docker images..."
docker-compose pull

# Start the containers
echo "Starting containers..."
docker-compose up -d

# Check if containers are running
echo "Checking container status..."
sleep 5
if docker-compose ps | grep -q "Up"; then
    echo "Deployment successful!"
    echo "Mattermost is available at: http://localhost:8065"
    echo "Gitea is available at: http://localhost:3000"
else
    echo "Deployment may have issues. Please check with 'docker-compose ps' and 'docker-compose logs'"
fi 