#!/bin/bash

# =============================================================================
# 🚀 RovoDev - AI-Powered Development Environment
# =============================================================================
# This script launches a containerized development environment with AI assistance
# that automatically configures your project with development standards and tools.
#
# What it does:
# • Downloads and runs the RovoDev Docker container
# • Creates openspec/ folder with development standards (if it doesn't exist)
# • Uses an internal Docker volume for .rovodev (no files written to host)
# • Creates .env file with configuration (if it doesn't exist)
# • Enables AI-powered code assistance via command line
#
# Usage: ./run-rovodev.sh [--help]
# =============================================================================

set -e  # Exit on any error

# Configuration
DOCKER_IMAGE="juanfu26/spec-driven-with-rovodev:latest"
WORKSPACE_DIR=$(pwd)
WIKI_HOST_PATH=""
CONTAINER_NAME_DEFAULT="$(basename \"$WORKSPACE_DIR\")"
# On host, .env and template are created in the working directory (the code mount)
ENV_FILE_PATH="${WORKSPACE_DIR}/.env"
ENV_TEMPLATE="${WORKSPACE_DIR}/.env.template"

# Colors for beautiful output
GREEN='\033[0;32m' YELLOW='\033[1;33m' RED='\033[0;31m' BLUE='\033[0;34m' NC='\033[0m'

# =============================================================================
# 📝 HELPER FUNCTIONS
# =============================================================================

info()    { echo -e "${GREEN}ℹ️  $1${NC}"; }
warn()    { echo -e "${YELLOW}⚠️  $1${NC}"; }
error()   { echo -e "${RED}❌ $1${NC}"; exit 1; }
success() { echo -e "${GREEN}✅ $1${NC}"; }

# Convert any string into a valid Docker container name
sanitize_container_name() {
    local name="$1"
    # Replace invalid chars with '-'
    name=$(echo -n "$name" | sed -E 's/[^a-zA-Z0-9_.-]+/-/g')
    # Trim leading/trailing non-alphanumerics
    name=$(echo -n "$name" | sed -E 's/^[^a-zA-Z0-9]+//; s/[^a-zA-Z0-9]+$//')
    # Default fallback
    if [[ -z "$name" ]]; then
        name="rovodev-workspace"
    fi
    echo -n "$name"
}

show_help() {
    cat << 'EOF'
🚀 RovoDev - AI-Powered Development Environment

USAGE:
    ./run-rovodev.sh [OPTIONS]

OPTIONS:
    --workspace=PATH       Host path to workspace (default: current directory)
    --wiki=PATH            Host path to wiki repo (optional). If not provided, auto-detect sibling '<repo>-wiki'
    --container-name=NAME  Container name (default: rovodev-workspace)
    -h, --help             Show this help

EXAMPLES:
    ./run-rovodev.sh                          # Basic usage

WHAT HAPPENS:
    1. 📋 Creates openspec/ folder with development standards  
    2. ⚙️  Creates .env file with configuration
    3. 🤖 Launches AI assistant for your project
    4. 🔧 Automatically configures development tools

REQUIREMENTS:
    • Docker installed and running
    • Atlassian credentials (configured in .env)

FIRST TIME SETUP:
    1. Run script to generate .env.template
    2. Copy template: cp .env.template .env
    3. Edit .env with your credentials
    4. Run script again

PROJECT STRUCTURE:
    your-project/
    ├── .env.template       # Generated template (safe for git)
    ├── .env               # Your credentials (add to .gitignore)
    ├── .rovodev/          # Project-specific overrides (optional, takes precedence)
    └── openspec/          # Development standards

For more info: https://github.com/your-repo/rovodev-docker
EOF
}

# =============================================================================
# 🔧 SETUP FUNCTIONS
# =============================================================================

setup_environment() {
    info "Setting up RovoDev environment..."
    
    # Check if .env file exists
    if [[ ! -f "$ENV_FILE_PATH" ]]; then
        # Create .env.template in the root directory
        info "Creating configuration template: ${ENV_TEMPLATE}"
        
        cat > "$ENV_TEMPLATE" << 'EOF'
# =============================================================================
# RovoDev Configuration Template
# =============================================================================
# 
# 📝 INSTRUCTIONS:
# 1. Copy this file to .env: cp .env.template .env
# 2. Fill in your credentials below (replace example values)
# 3. Run the script again: ./run-rovodev.sh
#
# 💡 TIP: Keep .env.template for reference, but add .env to .gitignore
# =============================================================================

# 🔐 ATLASSIAN AUTHENTICATION (Required)
# Get your API token at: https://id.atlassian.com/manage-profile/security/api-tokens
ATLASSIAN_USERNAME=your.email@company.com
ATLASSIAN_API_TOKEN=your_token_here

JIRA_SITE=yourdomain.atlassian.net

# Optional: Container name for easier management
CONTAINER_NAME=rovodev-workspace

# ================================
# MCP CONFIGURATION (Optional)
# These variables are consumed by MCP servers defined in .rovodev/mcp.json
# Do NOT commit real credentials. Populate in your local .env only.
# ================================

# Docker MCP (disabled by default)
#DOCKER_HOST=unix:///var/run/docker.sock
#MCP_DOCKER_ALLOWED_IMAGES=alpine:latest,postgres:16
#MCP_DOCKER_READONLY=true

# Redis MCP (disabled by default)
# For docker-run based MCP, we pass through these environment variables
#REDIS_HOST=localhost
#REDIS_PORT=6379
#REDIS_USERNAME=
#REDIS_PWD=
#REDIS_TLS=false
#MCP_REDIS_READONLY=true

# InfluxDB MCP (disabled by default)
# Variables will be passed through to the dockerized MCP server
#INFLUXDB_URL=http://localhost:8086
#INFLUXDB_TOKEN=
#INFLUXDB_ORG=
#INFLUXDB_BUCKET=
#MCP_INFLUXDB_READONLY=true
#MCP_INFLUXDB_MAX_POINTS=10000
#MCP_INFLUXDB_TIMEOUT_MS=10000

# Portainer MCP (disabled by default)
# Variables will be passed through to the dockerized MCP server
#PORTAINER_URL=http://localhost:9000
#PORTAINER_API_KEY=
#MCP_PORTAINER_ALLOWED_ENDPOINTS=
#MCP_PORTAINER_READONLY=true

# PostgreSQL MCP (disabled by default)
#POSTGRES_URL=postgresql://user:pass@localhost:5432/db
#MCP_POSTGRES_ALLOWED_SCHEMAS=public
#MCP_POSTGRES_READONLY=true

# Keycloak MCP (disabled by default)
#KEYCLOAK_URL=http://localhost:8080
#KEYCLOAK_REALM=
#KEYCLOAK_CLIENT_ID=
#KEYCLOAK_CLIENT_SECRET=
#MCP_KEYCLOAK_READONLY=true
# =============================================================================

EOF
        
        echo ""
        echo "🚫 CONFIGURATION REQUIRED"
        echo "========================="
        warn "Configuration template created: ${ENV_TEMPLATE}"
        echo ""
        echo "📋 NEXT STEPS:"
        echo "   1. Copy template to .env:"
        echo "      cp .env.template .env"
        echo ""
        echo "   2. Edit .env file with your credentials:"
        echo "      nano .env  # or use your preferred editor"
        echo ""
        echo "   3. Get Atlassian API token from:"
        echo "      https://id.atlassian.com/manage-profile/security/api-tokens"
        echo ""
        echo "   4. Replace example values with your actual credentials"
        echo ""
        echo "   5. Run script again:"
        echo "      ./run-rovodev.sh"
        echo ""
        echo "📁 FINAL PROJECT STRUCTURE:"
        echo "   your-project/"
        echo "   ├── .env.template       # Template (safe for git)"
        echo "   ├── .env               # Your config (add to .gitignore)"
        echo "   your-project-wiki/"
        echo "   └── openspec/          # Development standards"
        echo ""
        echo "   (.rovodev lives in a Docker volume, not on host)"
        echo ""
        error "Please configure .env file and run again"
    fi
    
    success "Environment configuration found"
}

validate_requirements() {
    info "Checking requirements..."
    
    # Check if Docker is running
    if ! docker info >/dev/null 2>&1; then
        error "Docker is not running. Please start Docker and try again."
    fi
    
    # Load environment variables
    source "$ENV_FILE_PATH"
    
    # Check required credentials
    if [[ -z "$ATLASSIAN_USERNAME" || -z "$ATLASSIAN_API_TOKEN" ]]; then
        error "Missing credentials in ${ENV_FILE_PATH}

Please edit the file and replace:
• ATLASSIAN_USERNAME (replace 'your.email@company.com' with your actual email)
• ATLASSIAN_API_TOKEN (replace 'your_token_here' with your actual token)

Get your API token from:
https://id.atlassian.com/manage-profile/security/api-tokens"
    fi
    
    # Validate that credentials are not just the template values
    if [[ "$ATLASSIAN_USERNAME" == "your.email@company.com" || "$ATLASSIAN_API_TOKEN" == "your_token_here" ]]; then
        error "Please replace template values in ${ENV_FILE_PATH} with your actual credentials"
    fi
    
    success "Requirements validated"
}

parse_arguments() {
    : # no persistence options
    CUSTOM_CONTAINER_NAME=""
    CUSTOM_WORKSPACE=""
    CUSTOM_WIKI=""
    
    for arg in "$@"; do
        case "$arg" in
            -h|--help)
                show_help
                exit 0
                ;;
            --workspace=*)
                CUSTOM_WORKSPACE="${arg#*=}"
                ;;
            --wiki=*)
                CUSTOM_WIKI="${arg#*=}"
                ;;
            --container-name=*)
                CUSTOM_CONTAINER_NAME="${arg#*=}"
                ;;
            --*)
                warn "Unknown option: $arg (ignored)"
                ;;
        esac
    done
}

detect_platform() {
    case "$(uname -m)" in
        arm64|aarch64)
            PLATFORM_ARGS=(--platform linux/arm64)
            info "Detected Apple Silicon / ARM64"
            ;;
        x86_64)
            PLATFORM_ARGS=(--platform linux/amd64)
            info "Detected Intel/AMD x86_64"
            ;;
        *)
            PLATFORM_ARGS=()
            warn "Unknown architecture: $(uname -m)"
            ;;
    esac
}

detect_wiki_root() {
    # Determine wiki path if not explicitly provided
    if [[ -n "$CUSTOM_WIKI" ]]; then
        WIKI_HOST_PATH="$CUSTOM_WIKI"
        return 0
    fi

    # Auto-detect: sibling repo named '<repo>-wiki'
    local ws_path="$WORKSPACE_DIR"
    local parent_dir
    parent_dir="$(dirname "$ws_path")"
    local repo_name
    repo_name="$(basename "$ws_path")"
    local candidate="${parent_dir}/${repo_name}-wiki"
    if [[ -d "$candidate" ]]; then
        WIKI_HOST_PATH="$candidate"
        return 0
    fi

    # Default to ./wiki inside the workspace if sibling not found
    local local_wiki="${WORKSPACE_DIR}/wiki"
    if [[ ! -d "$local_wiki" ]]; then
        mkdir -p "$local_wiki"
    fi
    WIKI_HOST_PATH="$local_wiki"
}

setup_docker_integration() {
    DOCKER_MOUNT_ARGS=()
    local uname_s="$(uname -s)"

    if [[ "$uname_s" == "Darwin" ]]; then
        # macOS with Docker Desktop
        DOCKER_MOUNT_ARGS=(--privileged -e DOCKER_HOST=unix:///var/run/docker.sock -v /var/run/docker.sock:/var/run/docker.sock)
        info "Configured Docker integration for macOS (socket mount)"

    elif [[ "$uname_s" == *"MINGW"* || "$uname_s" == *"MSYS"* || "$uname_s" == *"CYGWIN"* || -n "$OS" && "$OS" == "Windows_NT" ]]; then
        # Windows host: use TCP to Docker Desktop daemon
        # Requirement: Docker Desktop > Settings > General > 'Expose daemon on tcp://localhost:2375 without TLS'
        DOCKER_MOUNT_ARGS=(-e DOCKER_HOST=tcp://host.docker.internal:2375)
        info "Configured Docker integration for Windows via DOCKER_HOST=tcp://host.docker.internal:2375"
        warn "Ensure Docker Desktop has 'Expose daemon on tcp://localhost:2375 without TLS' enabled"

    elif [[ -e "/var/run/docker.sock" ]]; then
        # Linux with Docker socket
        DOCKER_MOUNT_ARGS=(-v /var/run/docker.sock:/var/run/docker.sock)
        info "Configured Docker socket mounting for Linux"

    else
        info "Docker integration not available (no socket/TCP). Continuing without it."
    fi
}

cleanup_existing_container() {
    # Sanitize container name before use
    local raw_name="${CONTAINER_NAME:-$CONTAINER_NAME_DEFAULT}"
    local container_name
    container_name=$(sanitize_container_name "$raw_name")

    if docker ps -a --format 'table {{.Names}}' | grep -q "^${container_name}$"; then
        info "Cleaning up existing container: $container_name"
        docker stop "$container_name" >/dev/null 2>&1 || true
        docker rm "$container_name" >/dev/null 2>&1 || true
    fi
}

# =============================================================================
# 🚀 MAIN EXECUTION
# =============================================================================

main() {
    clear
    echo ""
    echo "🚀 RovoDev - AI-Powered Development Environment"
    echo "================================================="
    echo "Current directory: $WORKSPACE_DIR"
    echo ""
    
    # Process command line arguments
    parse_arguments "$@"
    
    # Setup environment and validate
    setup_environment
    validate_requirements
    
    # Configure system
    : # persistence disabled
    detect_platform
    setup_docker_integration
    cleanup_existing_container
    
    # Load final configuration
    source "$ENV_FILE_PATH"

    # Apply CLI overrides
    if [[ -n "$CUSTOM_WORKSPACE" ]]; then
        WORKSPACE_DIR="$CUSTOM_WORKSPACE"
    fi
    if [[ -n "$CUSTOM_CONTAINER_NAME" ]]; then
        CONTAINER_NAME="$CUSTOM_CONTAINER_NAME"
    fi

    # Recompute host .env paths based on WORKSPACE_DIR
    ENV_FILE_PATH="${WORKSPACE_DIR}/.env"
    ENV_TEMPLATE="${WORKSPACE_DIR}/.env.template"

    # If .env moved, ensure it's present
    if [[ ! -f "$ENV_FILE_PATH" ]]; then
        warn ".env not found in overridden workspace: $ENV_FILE_PATH"
    fi

    # Detect wiki root if present
    detect_wiki_root

   # Default container name is the current workspace folder name (unless overridden)
   CONTAINER_NAME_DEFAULT="$(basename \"$WORKSPACE_DIR\")"

   # Sanitize final container name
   local raw_name="${CONTAINER_NAME:-$CONTAINER_NAME_DEFAULT}"
   local container_name
   container_name=$(sanitize_container_name "$raw_name")
   if [[ "$raw_name" != "$container_name" ]]; then
       warn "Normalized container name from '$raw_name' to '$container_name'"
   fi

    echo ""
    echo "🎯 Starting RovoDev container..."
    echo "   • Code mount: $WORKSPACE_DIR → /workspace/code"
    echo "   • Container: $container_name"
    echo "   • Image: $DOCKER_IMAGE"
    
    # Launch container
    EXTRA_ENVS=""
    EXTRA_MOUNTS=""
    if [[ -n "$WIKI_HOST_PATH" ]]; then
        echo "   • Wiki: $WIKI_HOST_PATH → /workspace/wiki"
        echo ""
        EXTRA_ENVS="$EXTRA_ENVS -e WIKI_ROOT=/workspace/wiki"
        EXTRA_MOUNTS="$EXTRA_MOUNTS -v \"$WIKI_HOST_PATH:/workspace/wiki\""
    fi

    CONFIG_VOLUME_MOUNT=""

    # Pass host UID/GID to align container user IDs and prevent permission issues
    HOST_IDS="-e HOST_UID=$(id -u) -e HOST_GID=$(id -g)"

    # Build docker run command using arrays to avoid quoting issues
    DOCKER_CMD=(docker run -it --name "$container_name")

    # Platform
    if [[ -n "${PLATFORM_ARGS[*]}" ]]; then
        DOCKER_CMD+=("${PLATFORM_ARGS[@]}")
    fi

    # Host UID/GID
    DOCKER_CMD+=(-e "HOST_UID=$(id -u)" -e "HOST_GID=$(id -g)")

    # Env file
    DOCKER_CMD+=(--env-file "$ENV_FILE_PATH")

    # Wiki mount and env
    if [[ -n "$WIKI_HOST_PATH" ]]; then
        DOCKER_CMD+=(-e WIKI_ROOT=/workspace/wiki -v "$WIKI_HOST_PATH:/workspace/wiki")
    fi

    # Code mount
    DOCKER_CMD+=(-v "$WORKSPACE_DIR:/workspace/code")

    # Docker socket mounts/flags
    if [[ -n "${DOCKER_MOUNT_ARGS[*]}" ]]; then
        DOCKER_CMD+=("${DOCKER_MOUNT_ARGS[@]}")
    fi

    # Workdir and image
    DOCKER_CMD+=(-w /workspace/code "$DOCKER_IMAGE")


    # Execute the command (array-safe)
    "${DOCKER_CMD[@]}"
    
    echo ""
    success "RovoDev session completed"
    echo ""
}

# Execute main function with all arguments
main "$@"