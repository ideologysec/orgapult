# Orgapult

Orgapult is an open-source organization launcher designed to bootstrap the digital infrastructure of a growing company. This project provides an automated deployment of essential services—such as chat and code management—using open-source tools. The current implementation focuses on launching a Mattermost instance (for team communication) and a Gitea instance (for Git repository management) on an Ubuntu server using Docker Compose. Future iterations may integrate additional services like a static wiki, blog, jobs portal, and HR/payroll systems.

## Overview

**Orgapult** aims to:
- **Streamline Infrastructure Deployment:** Quickly set up essential organizational tools with a single script.
- **Leverage Lightweight, Open-Source Solutions:** Mattermost and Gitea are both built with Go, offering efficiency and performance.
- **Simplify Integrations:** Configure services to run on subdomains (e.g., \`chat.<domain>\` for Mattermost and \`code.<domain>\` for Gitea) and integrate with Google authentication.
- **Provide a Foundation for Future Growth:** While the initial focus is on chat and code, the project is designed to evolve by adding more integrated services over time.

## Features

- **Automated Deployment:**  
  A Python script generates a Docker Compose file and launches containers for Mattermost and Gitea.

- **Subdomain Configuration:**  
  The services are pre-configured to run on \`chat.<domain>\` and \`code.<domain>\`, easing the DNS setup process.

- **Google Authentication Integration:**  
  Mattermost is configured with a placeholder for Google auth using your provided API key.

- **Container Isolation:**  
  The services run in Docker containers, keeping them isolated from the host system.

- **Extensible Design:**  
  The setup provides a solid base that can be extended to include additional services like a static wiki, blog, and HR systems.

## Prerequisites

- **Operating System:** Ubuntu (or another Linux distribution)
- **Docker:** Installed and running ([Docker installation guide](https://docs.docker.com/engine/install/))
- **Docker Compose:** Installed ([Docker Compose installation guide](https://docs.docker.com/compose/install/))
- **Python 3:** For running the deployment script
- **Google API Key:** For Mattermost's Google authentication integration

## Installation & Deployment

1. **Clone the Orgapult Repository:**
   \`\`\`bash
   git clone https://github.com/yourusername/orgapult.git
   cd orgapult
   \`\`\`

2. **Prepare Your Environment:**
   - Install Docker and Docker Compose on your Ubuntu server.
   - Ensure Python 3 is installed:
     \`\`\`bash
     sudo apt update && sudo apt install python3 python3-pip
     \`\`\`

3. **Run the Deployment Script:**
   - The deployment script (\`deploy.py\`) accepts two arguments: your Google API key and your domain name.
   - Example usage:
     \`\`\`bash
     chmod +x deploy.py
     ./deploy.py YOUR_GOOGLE_API_KEY yourdomain.com
     \`\`\`
   - The script will generate a \`docker-compose.yml\` file configured to run:
     - **Mattermost:** Accessible at \`https://chat.yourdomain.com\` (port 8065)
     - **Gitea:** Accessible at \`https://code.yourdomain.com\` (HTTP on port 3000 and SSH on port 222)

4. **DNS Configuration:**
   - Update your DNS settings (or your local \`/etc/hosts\` file) so that \`chat.yourdomain.com\` and \`code.yourdomain.com\` point to your server's public IP address.

## Script Details

The deployment script (\`deploy.py\`) performs the following actions:
- **Docker Compose File Generation:**  
  It creates a \`docker-compose.yml\` file that defines two services:
  - **Mattermost:** Configured with environment variables for site URL and Google API key.
  - **Gitea:** Configured with basic settings for domain and root URL.
  
- **Container Launch:**  
  It launches both services using Docker Compose in detached mode.
  
- **Deployment Summary:**  
  After launching, it outputs the URLs where the services are accessible and reminds you to configure your DNS accordingly.

## Future Work

- **Enhanced Configuration:**  
  Integrate persistent storage, databases, SSL configuration, and advanced application settings.
- **Automated DNS Management:**  
  Develop modules to automatically update DNS records using Google Cloud DNS or Cloudflare APIs.
- **Additional Services:**  
  Expand Orgapult to include a static wiki, blog, jobs portal (with an open-source ATS), and HR/payroll systems.
- **Cloud Deployment:**  
  Adapt the deployment script for launching on Google Cloud Platform (GCP) or other cloud providers.
- **Improved Integration:**  
  Enhance interoperability between Mattermost, Gitea, and future services (e.g., single sign-on, CI/CD integration).

## Cleanup

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
