# Orgapult

Orgapult is an open-source organization launcher designed to bootstrap the digital infrastructure of a growing company. This project provides an automated deployment of essential services—such as chat and code management—using open-source tools. The current implementation focuses on launching a Mattermost instance (for team communication) and a Gitea instance (for Git repository management) using Docker Compose.

## Tech Stack

The deployment consists of the following components:

1. **Mattermost** - An open-source, self-hostable messaging platform designed as an alternative to Slack and Microsoft Teams
   - Uses the official `mattermost/mattermost-prod-app:latest` image
   - Runs on port 8065
   - Configured with email notifications disabled

2. **Gitea** - A lightweight, self-hosted Git service similar to GitHub or GitLab
   - Uses the official `gitea/gitea:latest` image
   - Web interface runs on port 3000
   - SSH service runs on port 222

3. **PostgreSQL** - A powerful, open-source relational database
   - Uses `postgres:13` image
   - Serves as the database backend for Mattermost
   - Data persisted in a Docker volume

## Overview

**Orgapult** aims to:
- **Streamline Infrastructure Deployment:** Quickly set up essential organizational tools with a single script.
- **Leverage Lightweight, Open-Source Solutions:** Mattermost and Gitea are both built with Go, offering efficiency and performance.
- **Simplify Integrations:** Configure services to run on localhost ports for easy access.
- **Provide a Foundation for Future Growth:** While the initial focus is on chat and code, the project is designed to evolve by adding more integrated services over time.

## Features

- **Automated Deployment:**  
  Shell scripts handle the deployment and cleanup of Docker containers for Mattermost and Gitea.

- **Container Isolation:**  
  The services run in Docker containers, keeping them isolated from the host system.

- **Persistent Storage:**  
  Docker volumes ensure that your data persists between container restarts.

- **Extensible Design:**  
  The setup provides a solid base that can be extended to include additional services.

## Prerequisites

- **Operating System:** Ubuntu, macOS, or another system with Docker support
- **Docker:** Installed and running ([Docker installation guide](https://docs.docker.com/engine/install/))
- **Docker Compose:** Installed ([Docker Compose installation guide](https://docs.docker.com/compose/install/))
- **User permissions:** Your user should be in the docker group to run containers without sudo

## Usage Instructions

### Deployment

To deploy the services:

```bash
chmod +x deploy.sh
./deploy.sh
```

The deployment script:
1. Checks for Docker and Docker Compose installation
2. Creates necessary directories for data persistence
3. Sets up Mattermost configuration with email notifications disabled
4. Pulls the latest Docker images
5. Starts the containers
6. Verifies the deployment status

### Cleanup

To stop and remove all containers and data:

```bash
chmod +x cleanup.sh
./cleanup.sh
```

The cleanup script:
1. Lists current containers and volumes
2. Asks for confirmation before proceeding
3. Stops and removes all containers
4. Removes all associated volumes
5. Verifies that everything has been cleaned up

**Warning**: The cleanup script will permanently delete all data stored in the Docker volumes.

## Accessing the Services

After successful deployment:
- Mattermost will be available at: http://localhost:8065
- Gitea will be available at: http://localhost:3000

You'll need to complete the initial setup for both services when accessing them for the first time.

## Docker Configuration

The deployment uses Docker Compose with the following configuration:

- **Volumes**: Three Docker volumes are created to persist data:
  - `mattermost_data`: Stores Mattermost application data
  - `gitea_data`: Stores Gitea repositories and application data
  - `postgres_data`: Stores PostgreSQL database files

- **Networking**: All services run on the same Docker network
  - Mattermost is accessible at http://localhost:8065
  - Gitea is accessible at http://localhost:3000

## Troubleshooting

### Docker Permission Issues
If you encounter permission errors when running the scripts, ensure your user is in the docker group:
```bash
sudo usermod -aG docker $USER
```
Then log out and log back in, or restart your system.

### Mattermost Configuration
The deployment script creates a custom configuration for Mattermost with email notifications disabled to prevent common startup errors.

## Future Work

- **Enhanced Configuration:**  
  Add support for SSL configuration and advanced application settings.
- **Automated DNS Management:**  
  Develop modules to automatically update DNS records for public deployments.
- **Additional Services:**  
  Expand Orgapult to include a static wiki, blog, jobs portal, and HR/payroll systems.
- **Cloud Deployment:**  
  Adapt the deployment script for launching on cloud providers like AWS, GCP, or Azure.
- **Improved Integration:**  
  Enhance interoperability between Mattermost, Gitea, and future services (e.g., single sign-on, CI/CD integration).

## Contributing

Contributions are welcome! Please fork the repository, submit issues, or create pull requests to help improve Orgapult.
