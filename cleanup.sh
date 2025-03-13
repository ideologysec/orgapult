#!/bin/bash

echo "Starting cleanup of Docker containers and volumes..."

# Check if docker-compose is installed
if ! command -v docker-compose &> /dev/null; then
    echo "Error: docker-compose is not installed. Please install it first."
    exit 1
fi

# Ask for confirmation
read -p "This will stop and remove all containers and volumes defined in docker-compose.yml. Continue? (y/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Operation cancelled."
    exit 0
fi

# Stop and remove containers
echo "Stopping containers..."
docker-compose down

# Remove volumes
echo "Removing volumes..."
docker-compose down -v

echo "Cleanup complete! All containers and volumes have been removed." 