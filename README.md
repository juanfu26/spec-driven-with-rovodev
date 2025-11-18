# 🚀 RovoDev Docker Container

This repository contains everything needed to create a portable AI-powered development environment using Docker and RovoDev.

## 🎯 Objective

Enable users to download a single script (`run-rovodev.sh`) and execute it on any code repository to automatically:

1. **Pull the RovoDev Docker image** from DockerHub
2. **Create `.env` configuration file** from template with your credentials
3. **Create `.rovodev/` directory** (if it doesn't exist) with AI configuration
4. **Create `openspec/` directory** (if it doesn't exist) with pre-built development standards
5. **Enable RovoDev CLI** for AI-assisted development

## 🚀 Quick Start

### For End Users

1. **Navigate to your project directory:**
   ```bash
   cd /path/to/your/project
   ```

2. **Download the script:**
   ```bash
   curl -O https://raw.githubusercontent.com/juanfu26/spec-driven-with-rovodev/refs/heads/main/run-rovodev.sh
   chmod +x run-rovodev.sh
   ```

3. **Run RovoDev (first time):**
   ```bash
   ./run-rovodev.sh
   ```
   This will create `.env.template` with configuration instructions.

4. **Configure your credentials:**
   ```bash
   cp .env.template .env
   nano .env  # Edit with your Atlassian credentials
   ```

5. **Run RovoDev again:**
   ```bash
   ./run-rovodev.sh
   ```

The script will automatically:
- Create `.rovodev/` with MCP configuration and AI prompts
- Create `openspec/` with development standards
- Start the RovoDev AI assistant

## 📁 Project Structure Created

When running on a new project, the following structure is automatically created:

```
your-project/
├── .env.template          # Configuration template (safe for git)
├── .env                   # Your credentials (add to .gitignore)
├── .rovodev/              # RovoDev AI configuration
│   ├── mcp.json          # MCP server configuration
│   ├── prompts.yml       # Available AI prompts
│   └── commands/         # Command templates
│       ├── complete-jira-ticket.md
│       ├── meta-prompt.md
│       └── openspec/     # OpenSpec-specific commands
└── openspec/             # Development standards
    └── specs/
        └── standards/
            ├── base.mdc           # Core development standards
            └── documentation.mdc  # Documentation guidelines
```

## 🤖 Available RovoDev Commands

After successful execution of `run-rovodev.sh`, you can use these commands inside the RovoDev environment:

### 📋 1. Generate OpenSpec Standards

Generate development standards in OpenSpec format for your project:

```bash
# Generate comprehensive project standards
rovodev run openspec/analyze-and-create-standards

# Create backend-specific standards
rovodev run openspec/create-backend-standards

# Create frontend-specific standards  
rovodev run openspec/create-frontend-standards

# Create development guide
rovodev run openspec/create-development-guide

# Update existing documentation
rovodev run openspec/update-docs
```

### 🎫 2. Complete Jira Ticket

Complete development work for a Jira ticket:

```bash
# Complete a specific Jira ticket with AI assistance
rovodev run complete-jira-ticket

# This will:
# - Analyze the ticket requirements
# - Generate implementation plan
# - Write code changes
# - Create tests
# - Update documentation
# - Mark ticket as complete
```

### 🔧 3. Execute Jira Task Development

Execute development tasks directly from Jira:

```bash
# Execute development for a Jira task
rovodev run jira-task-development

# This will:
# - Fetch task details from Jira
# - Break down requirements
# - Implement the solution
# - Run tests and validation
# - Update task status
# - Create pull request (if configured)
```

### 🧠 4. Meta-Prompt for Custom Tasks

Use the meta-prompt for custom development tasks:

```bash
# Use meta-prompt for custom development
rovodev run meta-prompt

# This provides:
# - Intelligent code analysis
# - Custom implementation suggestions
# - Best practices recommendations
# - Architecture guidance
```

## ⚙️ Configuration

The `.env` file contains essential configuration:

```bash
# Atlassian CLI Authentication (Required)
ATLASSIAN_USERNAME=your.email@company.com
ATLASSIAN_API_TOKEN=your_api_token_here

# Container Settings
CONTAINER_NAME=rovodev-workspace

# Git credentials (Optional)
GIT_USERNAME=your_git_username
GIT_PASSWORD=your_personal_access_token
GIT_USER_NAME=Your Full Name
GIT_USER_EMAIL=your.email@company.com

# Persistence settings (Optional)
PERSISTENCE_MODE=shared     # Options: shared, instance
INSTANCE_ID=my-instance-1   # Only used with instance mode
```

Get your Atlassian API token from: https://id.atlassian.com/manage-profile/security/api-tokens

## 🏗️ For Repository Maintainers

### Prerequisites

To build and deploy the Docker image, you need:

1. **DockerHub Account** with username and access token
2. **GitHub Repository Secrets**:
   - `DOCKERHUB_USERNAME`: Your DockerHub username
   - `DOCKERHUB_TOKEN`: Your DockerHub access token

### Automatic Build & Deploy

The repository includes a GitHub Actions workflow (`.github/workflows/docker-build.yml`) that automatically:

- Builds multi-platform Docker images (AMD64 + ARM64)
- Pushes to DockerHub when changes are made to `Dockerfile` or `entrypoint.sh`
- Creates tagged versions for different architectures

### Manual Build

To build locally:

```bash
# Build for current platform
docker build -t juanfu26/rovodev:latest .

# Build for multiple platforms
docker buildx build --platform linux/amd64,linux/arm64 -t juanfu26/rovodev:latest --push .
```

## 🔧 Features

### Multi-Platform Support
- **AMD64** (Intel/AMD processors)
- **ARM64** (Apple Silicon, ARM processors)

### Development Tools Included
- **acli** (Atlassian CLI) for RovoDev integration
- **Node.js 20.19+** with npm
- **OpenSpec** for API documentation
- **Playwright** for browser automation
- **Docker-in-Docker** support
- **Git** with credential management

### Persistence Options
- **Shared**: Data persists across all container instances
- **Instance**: Data persists per specific instance ID

## 📋 Usage Examples

### Basic Usage
```bash
./run-rovodev.sh
```

### With Persistence
```bash
./run-rovodev.sh --persistence=shared
./run-rovodev.sh --persistence=instance --instance-id=my-project
```

### Help
```bash
./run-rovodev.sh --help
```

## 🛠️ Architecture

### Docker Image Structure
```
/opt/rovodev-template/     # Template content copied to new projects
├── .rovodev/              # Default RovoDev configuration
└── openspec/              # Default OpenSpec standards

/workspace/                # Mounted project directory
/persistence/              # Optional persistence volume
/home/rovodev/             # User home directory
```

### Initialization Flow
1. **Environment Setup**: Create `.env.template` if `.env` doesn't exist
2. **Template Copy**: Copy `.rovodev/` and `openspec/` if they don't exist
3. **Authentication**: Setup Atlassian and Jira authentication
4. **Docker**: Configure Docker-in-Docker access
5. **Persistence**: Setup data persistence if enabled
6. **Git**: Configure Git credentials and user info
7. **Launch**: Start RovoDev AI assistant

## 🔍 Troubleshooting

### Common Issues

**Authentication Failed**
- Verify `ATLASSIAN_API_TOKEN` and `ATLASSIAN_USERNAME` in `.env`
- Generate new API token at: https://id.atlassian.com/manage-profile/security/api-tokens

**Docker Access Issues**
- On macOS: Ensure Docker Desktop is running
- On Linux: Check Docker socket permissions
- Try running with `--privileged` flag

**Permission Issues**
- Ensure the script has execute permissions: `chmod +x run-rovodev.sh`
- Check that current user can write to the project directory

### Debug Mode

For detailed logging, examine container output:
```bash
./run-rovodev.sh
# Container will show detailed setup information
```

## 📈 Development

### Project Structure
```
.
├── Dockerfile              # Multi-stage Docker build
├── entrypoint.sh           # Container initialization script
├── run-rovodev.sh          # User-facing launcher script
├── .github/workflows/      # CI/CD automation
├── .rovodev/              # Template configuration
└── openspec/              # Template standards
```

### Contributing

1. Fork the repository
2. Make your changes
3. Test locally with `docker build`
4. Submit a pull request

Changes to `Dockerfile` or `entrypoint.sh` will trigger automatic builds and deployments.

## 🙏 Thanks

Special thanks to these amazing projects that inspired and contributed to this work:

- **[AI Specs by LIDR Academy](https://github.com/LIDR-academy/ai-specs/)** - For the innovative approach to AI-driven specification management and development standards.
- **[ACLI RovoDev Sandbox by MayankTahil](https://github.com/MayankTahil/acli-rovodev-sandbox)** - For the foundational work on Atlassian CLI integration and Docker containerization patterns.

## 🤝 Support

For issues and questions:
- GitHub Issues: [Repository Issues](https://github.com/juanfu26/spec-driven-with-rovodev/issues)
- Documentation: [RovoDev Documentation](https://developer.atlassian.com/platform/rovo/)