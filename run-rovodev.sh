#!/bin/bash

# =============================================================================
# 🚀 RovoDev - AI-Powered Development Environment
# =============================================================================
# This script launches a containerized development environment with AI assistance
# that automatically configures your project with development standards and tools.
#
# What it does:
# • Downloads and runs the RovoDev Docker container
# • Creates .rovodev/ folder with AI configuration (if it doesn't exist)  
# • Creates openspec/ folder with development standards (if it doesn't exist)
# • Creates .env file with configuration (if it doesn't exist)
# • Enables AI-powered code assistance via command line
#
# Usage: ./run-rovodev.sh [--persistence=shared|instance] [--help]
# =============================================================================

set -e  # Exit on any error

# Configuration
DOCKER_IMAGE="juanfu26/spec-driven-with-rovodev:latest"
WORKSPACE_DIR=$(pwd)
ROVODEV_DIR="${WORKSPACE_DIR}/.rovodev"
ENV_FILE="${WORKSPACE_DIR}/.env"
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

show_help() {
    cat << 'EOF'
🚀 RovoDev - AI-Powered Development Environment

USAGE:
    ./run-rovodev.sh [OPTIONS]

OPTIONS:
    --persistence=MODE      Save data between sessions
                           MODE: shared (all projects) | instance (this project only)
    --instance-id=ID       Custom ID for instance persistence
    -h, --help             Show this help

EXAMPLES:
    ./run-rovodev.sh                          # Basic usage
    ./run-rovodev.sh --persistence=shared     # Keep data across projects
    ./run-rovodev.sh --persistence=instance   # Keep data for this project only

WHAT HAPPENS:
    1. 📂 Creates .rovodev/ folder with AI configuration
    2. 📋 Creates openspec/ folder with development standards  
    3. ⚙️  Creates .env file with configuration
    4. 🤖 Launches AI assistant for your project
    5. 🔧 Automatically configures development tools

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
    ├── .rovodev/          # RovoDev configuration
    └── openspec/          # Development standards

For more info: https://github.com/your-repo/rovodev-docker
EOF
}

# =============================================================================
# 🔧 SETUP FUNCTIONS
# =============================================================================

setup_environment() {
    info "Setting up RovoDev environment..."
    
    # Create .rovodev directory
    mkdir -p "$ROVODEV_DIR"
    
    # Check if .env file exists
    if [[ ! -f "$ENV_FILE" ]]; then
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

# 🏷️ CONTAINER SETTINGS  
CONTAINER_NAME=rovodev-workspace

# 🔧 GIT CONFIGURATION (Optional)
# Used for automatic git commits and operations
GIT_USERNAME=your_git_username
GIT_PASSWORD=your_personal_access_token
GIT_USER_NAME=Your Full Name
GIT_USER_EMAIL=your.email@company.com

# 💾 PERSISTENCE SETTINGS (Optional)
# Uncomment to enable data persistence between sessions
# PERSISTENCE_MODE=shared     # Options: shared, instance
# INSTANCE_ID=my-project      # Only used with instance mode
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
        echo "   ├── .rovodev/          # AI configuration"
        echo "   └── openspec/          # Development standards"
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
    source "$ENV_FILE"
    
    # Check required credentials
    if [[ -z "$ATLASSIAN_USERNAME" || -z "$ATLASSIAN_API_TOKEN" ]]; then
        error "Missing credentials in ${ENV_FILE}

Please edit the file and replace:
• ATLASSIAN_USERNAME (replace 'your.email@company.com' with your actual email)
• ATLASSIAN_API_TOKEN (replace 'your_token_here' with your actual token)

Get your API token from:
https://id.atlassian.com/manage-profile/security/api-tokens"
    fi
    
    # Validate that credentials are not just the template values
    if [[ "$ATLASSIAN_USERNAME" == "your.email@company.com" || "$ATLASSIAN_API_TOKEN" == "your_token_here" ]]; then
        error "Please replace template values in ${ENV_FILE} with your actual credentials"
    fi
    
    success "Requirements validated"
}

parse_arguments() {
    PERSISTENCE_MODE=""
    INSTANCE_ID=""
    
    for arg in "$@"; do
        case "$arg" in
            -h|--help)
                show_help
                exit 0
                ;;
            --persistence=*)
                PERSISTENCE_MODE="${arg#*=}"
                if [[ "$PERSISTENCE_MODE" != "shared" && "$PERSISTENCE_MODE" != "instance" ]]; then
                    error "Invalid persistence mode: $PERSISTENCE_MODE (use 'shared' or 'instance')"
                fi
                ;;
            --instance-id=*)
                INSTANCE_ID="${arg#*=}"
                ;;
            --*)
                warn "Unknown option: $arg (ignored)"
                ;;
        esac
    done
}

setup_persistence() {
    if [[ -z "$PERSISTENCE_MODE" ]]; then
        return 0
    fi
    
    info "Setting up persistence: $PERSISTENCE_MODE mode"
    
    PERSISTENCE_DIR="${ROVODEV_DIR}/persistence"
    mkdir -p "$PERSISTENCE_DIR"
    
    PERSISTENCE_MOUNT="-v ${PERSISTENCE_DIR}:/persistence"
    PERSISTENCE_ENV="-e PERSISTENCE_MODE=${PERSISTENCE_MODE}"
    
    if [[ "$PERSISTENCE_MODE" == "instance" && -n "$INSTANCE_ID" ]]; then
        PERSISTENCE_ENV="${PERSISTENCE_ENV} -e INSTANCE_ID=${INSTANCE_ID}"
        info "Using instance ID: $INSTANCE_ID"
    fi
    
    # Create persistence info file
    if [[ ! -f "${PERSISTENCE_DIR}/README.md" ]]; then
        cat > "${PERSISTENCE_DIR}/README.md" << EOF
# RovoDev Persistence

- **Mode**: ${PERSISTENCE_MODE}
- **Created**: $(date)
$([ -n "$INSTANCE_ID" ] && echo "- **Instance ID**: ${INSTANCE_ID}")

This directory stores data that persists between RovoDev sessions.
Do not delete unless you want to reset persistent data.
EOF
    fi
    
    success "Persistence configured: ${PERSISTENCE_DIR}"
}

detect_platform() {
    case "$(uname -m)" in
        arm64|aarch64) 
            PLATFORM="--platform linux/arm64"
            info "Detected Apple Silicon / ARM64"
            ;;
        x86_64) 
            PLATFORM="--platform linux/amd64"
            info "Detected Intel/AMD x86_64"
            ;;
        *)
            PLATFORM=""
            warn "Unknown architecture: $(uname -m)"
            ;;
    esac
}

setup_docker_integration() {
    DOCKER_MOUNT=""
    
    if [[ "$(uname -s)" == "Darwin" ]]; then
        # macOS with Docker Desktop
        DOCKER_MOUNT="--privileged -e DOCKER_HOST=unix:///var/run/docker.sock -v /var/run/docker.sock:/var/run/docker.sock"
        info "Configured Docker-in-Docker for macOS"
    elif [[ -e "/var/run/docker.sock" ]]; then
        # Linux with Docker socket
        DOCKER_MOUNT="-v /var/run/docker.sock:/var/run/docker.sock"
        info "Configured Docker socket mounting for Linux"
    else
        info "Docker-in-Docker not available (this is normal)"
    fi
}

cleanup_existing_container() {
    local container_name="${CONTAINER_NAME:-rovodev-workspace}"
    
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
    setup_persistence
    detect_platform
    setup_docker_integration
    cleanup_existing_container
    
    # Load final configuration
    source "$ENV_FILE"
    local container_name="${CONTAINER_NAME:-rovodev-workspace}"
    
    echo ""
    echo "🎯 Starting RovoDev container..."
    echo "   • Workspace: $WORKSPACE_DIR → /workspace"
    echo "   • Container: $container_name"
    echo "   • Image: $DOCKER_IMAGE"
    [[ -n "$PERSISTENCE_MODE" ]] && echo "   • Persistence: $PERSISTENCE_MODE"
    echo ""
    
    # Launch container
    docker run -it \
        --name "$container_name" \
        $PLATFORM \
        --env-file "$ENV_FILE" \
        $PERSISTENCE_ENV \
        -v "$WORKSPACE_DIR:/workspace" \
        $PERSISTENCE_MOUNT \
        $DOCKER_MOUNT \
        -w /workspace \
        "$DOCKER_IMAGE"
    
    echo ""
    success "RovoDev session completed"
    echo ""
}

# Execute main function with all arguments
main "$@"