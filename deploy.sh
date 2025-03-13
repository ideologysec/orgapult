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

# Create Mattermost config directory and config file
echo
echo "📁 Creating Mattermost configuration..."
mkdir -p ./data/mattermost/config
echo "   ✅ ./data/mattermost/config directory created."

# Set proper permissions for Mattermost config directory
echo "   Setting permissions for Mattermost config directory..."
chmod -R 777 ./data/mattermost/config
echo "   ✅ Permissions set to allow Mattermost to write to config directory."

# Create config.json file with email notifications disabled
echo "   Creating Mattermost config.json file..."
cat > ./data/mattermost/config/config.json << 'EOF'
{
    "ServiceSettings": {
        "SiteURL": "http://localhost:8065"
    },
    "SqlSettings": {
        "DriverName": "postgres",
        "DataSource": "postgres://mmuser:mmpassword@postgres:5432/mattermost?sslmode=disable&connect_timeout=10"
    },
    "EmailSettings": {
        "SendEmailNotifications": false,
        "FeedbackName": "No-Reply",
        "FeedbackEmail": "no-reply@example.com",
        "EnableSMTPAuth": false,
        "SMTPUsername": "",
        "SMTPPassword": "",
        "SMTPServer": "",
        "SMTPPort": "",
        "ConnectionSecurity": "",
        "SkipServerCertificateVerification": true,
        "EnableEmailBatching": false,
        "EnablePreviewModeBanner": false
    },
    "AnnouncementSettings": {
        "AdminNoticesEnabled": false,
        "UserNoticesEnabled": false
    },
    "LogSettings": {
        "EnableConsole": true,
        "ConsoleLevel": "INFO"
    }
}
EOF
echo "   ✅ Mattermost config.json created successfully."

# Ensure config file has proper permissions
echo "   Setting permissions for config.json..."
chmod 666 ./data/mattermost/config/config.json
echo "   ✅ Permissions set for config.json."

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