#!/bin/bash

echo "==============================================================="
echo "🧹 STARTING CLEANUP OF DOCKER CONTAINERS AND VOLUMES 🧹"
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

# Check if docker is installed
echo
echo "📋 Checking if Docker is installed..."
if ! command -v docker &> /dev/null; then
    echo "❌ ERROR: Docker is not installed. Please install Docker first."
    echo "   For Ubuntu: sudo apt install docker.io"
    echo "   For macOS: Install Docker Desktop from https://www.docker.com/products/docker-desktop"
    exit 1
else
    echo "✅ Docker is installed. Version: $(docker --version)"
fi

# Check Docker access
echo
echo "📋 Checking Docker access..."
if ! docker info &> /dev/null; then
    # Check if Docker daemon is running
    if systemctl is-active --quiet docker 2>/dev/null || pgrep -f docker &>/dev/null; then
        echo "❌ ERROR: Docker daemon is running but you don't have permission to access it."
        echo "   This is likely because your user is not in the 'docker' group."
        echo "   To fix this, run: sudo usermod -aG docker $USER"
        echo "   Then log out and log back in, or restart your system."
        echo
        echo "   Alternatively, you can run this script with sudo:"
        echo "   sudo $0"
    else
        echo "❌ ERROR: Docker daemon is not running. Please start Docker service."
        echo "   For Ubuntu: sudo systemctl start docker"
        echo "   For macOS: Start Docker Desktop application"
    fi
    exit 1
else
    echo "✅ Docker is running and accessible."
fi

# List current containers and volumes
echo
echo "📊 Current containers:"
docker-compose ps
echo
echo "📊 Current volumes:"
docker volume ls | grep -E "mattermost_data|gitea_data" || echo "   No relevant volumes found."

# Ask for confirmation
echo
echo "⚠️ WARNING: This will stop and remove all containers and volumes defined in docker-compose.yml."
echo "   All data in these volumes will be permanently deleted."
read -p "   Do you want to continue? (y/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "❌ Operation cancelled by user."
    exit 0
fi

# Stop and remove containers
echo
echo "🛑 Stopping containers..."
docker-compose down
echo "✅ Containers stopped successfully."

# Show status after stopping containers
echo
echo "📊 Container status after stopping:"
docker-compose ps

# Remove volumes
echo
echo "🗑️ Removing volumes..."
echo "   This will permanently delete all data in the volumes."
docker-compose down -v
echo "✅ Volumes removed successfully."

# Verify volumes are gone
echo
echo "📊 Verifying volumes have been removed:"
if docker volume ls | grep -q -E "mattermost_data|gitea_data"; then
    echo "⚠️ Some volumes may still exist:"
    docker volume ls | grep -E "mattermost_data|gitea_data"
else
    echo "✅ All volumes have been successfully removed."
fi

# Check for any leftover containers
echo
echo "📊 Checking for any leftover containers:"
if docker ps -a | grep -q -E "mattermost|gitea"; then
    echo "⚠️ Some containers may still exist:"
    docker ps -a | grep -E "mattermost|gitea"
    echo
    echo "   To remove these containers manually, run:"
    echo "   docker rm -f \$(docker ps -a | grep -E 'mattermost|gitea' | awk '{print \$1}')"
else
    echo "✅ No leftover containers found."
fi

# Check for any leftover images
echo
echo "📊 Docker images that can be removed if needed:"
docker images | grep -E "mattermost|gitea" || echo "   No relevant images found."
echo
echo "   To remove these images manually, run:"
echo "   docker rmi \$(docker images | grep -E 'mattermost|gitea' | awk '{print \$3}')"

echo
echo "==============================================================="
echo "🏁 CLEANUP PROCESS COMPLETED 🏁"
echo "===============================================================" 