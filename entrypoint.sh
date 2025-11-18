#!/bin/bash

# =============================================================================
# RovoDev Container Entrypoint Script
# =============================================================================
# This script handles container initialization and setup for the RovoDev
# development environment. It provides modular functions for different
# setup tasks that can be easily maintained and extended.
# =============================================================================

set -e  # Exit on any error

# =============================================================================
# UTILITY FUNCTIONS
# =============================================================================

log_info() {
    echo "ℹ️  $1"
}

log_success() {
    echo "✅ $1"
}

log_warning() {
    echo "⚠️  $1"
}

log_error() {
    echo "❌ $1"
}

log_section() {
    echo ""
    echo "🔧 $1"
    echo "----------------------------------------"
}

# =============================================================================
# WORKSPACE TEMPLATE SETUP
# =============================================================================

setup_workspace_templates() {
    log_section "Setting up Workspace Templates"
    
    # Copy .rovodev if it doesn't exist
    if [ ! -d "/workspace/.rovodev" ]; then
        log_info "Creating .rovodev directory with default configuration..."
        if [ -d "/opt/rovodev-template/.rovodev" ]; then
            cp -r /opt/rovodev-template/.rovodev /workspace/
            # Fix ownership to match workspace
            if [ -w "/workspace" ]; then
                chown -R $(stat -c '%u:%g' /workspace 2>/dev/null || echo "rovodev:rovodev") /workspace/.rovodev 2>/dev/null || true
            fi
            log_success ".rovodev directory created with templates!"
        else
            log_warning ".rovodev template not found in image, creating basic structure..."
            mkdir -p /workspace/.rovodev
        fi
    else
        log_info ".rovodev directory already exists, skipping template copy..."
    fi
    
    # Copy openspec if it doesn't exist  
    if [ ! -d "/workspace/openspec" ]; then
        log_info "Creating openspec directory with default standards..."
        if [ -d "/opt/rovodev-template/openspec" ]; then
            cp -r /opt/rovodev-template/openspec /workspace/
            # Fix ownership to match workspace
            if [ -w "/workspace" ]; then
                chown -R $(stat -c '%u:%g' /workspace 2>/dev/null || echo "rovodev:rovodev") /workspace/openspec 2>/dev/null || true
            fi
            log_success "openspec directory created with default standards!"
        else
            log_warning "openspec template not found in image, creating basic structure..."
            mkdir -p /workspace/openspec/specs/standards
        fi
    else
        log_info "openspec directory already exists, skipping template copy..."
    fi
}

# =============================================================================
# ATLASSIAN AUTHENTICATION SETUP
# =============================================================================

setup_atlassian_auth() {
    log_section "Setting up Atlassian Authentication"
    
    setup_rovodev_auth
    setup_jira_auth
}

setup_rovodev_auth() {
    # Check required variables
    if [ -z "$ATLASSIAN_API_TOKEN" ] || [ -z "$ATLASSIAN_USERNAME" ]; then
        log_warning "Rovo Dev authentication environment variables not set."
        log_info "Please set ATLASSIAN_API_TOKEN and ATLASSIAN_USERNAME"
        log_info "You can authenticate manually using: acli rovodev auth login"
        return 0
    fi
    
    # Attempt authentication
    log_info "Setting up Rovo Dev authentication..."
    mkdir -p /home/rovodev/.config/acli
    
    echo "$ATLASSIAN_API_TOKEN" | acli rovodev auth login --email "$ATLASSIAN_USERNAME" --token && \
        log_success "Rovo Dev authentication successful!" || \
        log_error "Rovo Dev authentication failed. Please check your credentials."
}

setup_jira_auth() {
    # Check required variables
    if [ -z "$JIRA_SITE" ] || [ -z "$ATLASSIAN_API_TOKEN" ] || [ -z "$ATLASSIAN_USERNAME" ]; then
        log_warning "Jira authentication environment variables not set."
        log_info "Please set JIRA_SITE, ATLASSIAN_API_TOKEN, and ATLASSIAN_USERNAME"
        log_info "You can authenticate manually using: acli jira auth login"
        return 0
    fi
    
    # Attempt authentication
    log_info "Setting up Jira authentication..."
    mkdir -p /home/rovodev/.config/acli
    
    echo "$ATLASSIAN_API_TOKEN" | acli jira auth login --site "$JIRA_SITE" --email "$ATLASSIAN_USERNAME" --token && \
        log_success "Jira authentication successful!" || \
        log_error "Jira authentication failed. Please check your credentials."
}

# =============================================================================
# DOCKER SETUP AND VERIFICATION
# =============================================================================

setup_docker_access() {
    log_section "Setting up Docker Access"
    
    # Test if Docker is already working
    if docker info >/dev/null 2>&1; then
        log_success "Docker is working correctly!"
        show_docker_info
        return 0
    fi
    
    # Docker is not working, let's diagnose and try to fix
    diagnose_docker_issue
}

show_docker_info() {
    log_info "Docker version information:"
    docker version --format "Client: {{.Client.Version}}, Server: {{.Server.Version}}" 2>/dev/null || \
    docker version | grep -E "Version:" | head -2
}

diagnose_docker_issue() {
    log_warning "Docker is not accessible. Diagnosing the issue..."
    
    # Check if Docker socket exists
    if [ -S /var/run/docker.sock ]; then
        handle_socket_permissions
    elif [ -n "$DOCKER_HOST" ]; then
        handle_remote_docker
    else
        handle_no_docker
    fi
}

handle_socket_permissions() {
    log_info "Docker socket found at /var/run/docker.sock"
    
    # Show current socket info
    local socket_info=$(ls -la /var/run/docker.sock 2>/dev/null)
    log_info "Socket permissions: $socket_info"
    log_info "Current user: $(whoami) (groups: $(groups | tr ' ' ','))"
    
    # Try to fix permissions if we have sudo
    if command -v sudo >/dev/null 2>&1; then
        log_info "Attempting to fix Docker socket permissions..."
        if sudo chmod 666 /var/run/docker.sock 2>/dev/null; then
            log_success "Socket permissions updated!"
            
            # Test again
            if docker info >/dev/null 2>&1; then
                log_success "Docker is now working!"
                show_docker_info
                return 0
            fi
        fi
    fi
    
    # If we get here, the fix didn't work
    log_error "Could not fix Docker socket permissions"
    show_docker_troubleshooting_tips
}

handle_remote_docker() {
    log_info "Using remote Docker host: $DOCKER_HOST"
    log_error "Cannot connect to Docker daemon at $DOCKER_HOST"
    log_info "Please verify that:"
    echo "  • Docker daemon is running on the remote host"
    echo "  • The host is accessible from this container"
    echo "  • DOCKER_HOST URL is correct"
}

handle_no_docker() {
    log_warning "No Docker socket found and DOCKER_HOST not set"
    log_info "Docker functionality will not be available inside this container"
    log_info "This is normal if Docker-in-Docker is not needed for your use case"
}

show_docker_troubleshooting_tips() {
    echo ""
    log_info "Docker Troubleshooting Tips:"
    echo "  1. Ensure Docker daemon is running on the host system"
    echo "  2. For Docker Desktop: Enable 'Expose daemon on tcp://localhost:2376 without TLS'"
    echo "  3. Try running container with: --privileged or -v /var/run/docker.sock:/var/run/docker.sock"
    echo "  4. For macOS: Ensure Docker Desktop has proper file sharing permissions"
    echo ""
    log_info "System Information:"
    echo "  OS: $(uname -s) $(uname -r)"
    echo "  Architecture: $(uname -m)"
    echo "  Container Runtime: $([ -f /.dockerenv ] && echo 'Docker' || echo 'Unknown')"
}

# =============================================================================
# PERSISTENCE SETUP
# =============================================================================

setup_persistence() {
    log_section "Setting up Persistence"
    
    setup_mounted_persistence
    setup_workspace_persistence
}

setup_mounted_persistence() {
    if [ ! -d "/persistence" ]; then
        log_info "No persistence directory mounted. Starting with fresh state."
        return 0
    fi
    
    log_info "Persistence directory detected."
    
    if [ -z "$PERSISTENCE_MODE" ]; then
        log_warning "Persistence directory exists but no mode specified."
        log_info "Available persistence modes: shared, instance"
        log_info "Set PERSISTENCE_MODE environment variable to enable persistence."
        return 0
    fi
    
    log_info "Persistence mode: $PERSISTENCE_MODE"
    
    case "$PERSISTENCE_MODE" in
        "shared")
            setup_shared_persistence
            ;;
        "instance")
            setup_instance_persistence
            ;;
        *)
            log_error "Unknown persistence mode: $PERSISTENCE_MODE"
            log_info "Available modes: shared, instance"
            ;;
    esac
}

setup_shared_persistence() {
    local shared_dir="/persistence/shared"
    mkdir -p "$shared_dir"
    log_info "Using shared persistence storage"
    
    if [ ! -f "$shared_dir/initialized" ]; then
        log_info "Initializing shared persistence storage"
        echo "$(date)" > "$shared_dir/initialized"
        echo "creator: RovoDev Container" >> "$shared_dir/initialized"
    fi
    
    if [ -d "$shared_dir" ] && [ "$(ls -A $shared_dir)" ]; then
        log_info "Loading shared persistence data..."
        # Add specific loading logic here if needed
    fi
}

setup_instance_persistence() {
    local instance_id=${INSTANCE_ID:-$(date +%s)}
    local instance_dir="/persistence/instance-${instance_id}"
    
    mkdir -p "$instance_dir"
    log_info "Using instance-specific persistence storage (ID: ${instance_id})"
    
    if [ ! -f "$instance_dir/initialized" ]; then
        log_info "Initializing instance persistence storage"
        echo "$(date)" > "$instance_dir/initialized"
        echo "instance_id: ${instance_id}" >> "$instance_dir/initialized"
        echo "creator: RovoDev Container" >> "$instance_dir/initialized"
    fi
    
    if [ -d "$instance_dir" ] && [ "$(ls -A $instance_dir)" ]; then
        log_info "Loading instance persistence data..."
        # Add specific loading logic here if needed
    fi
}

setup_workspace_persistence() {
    if [ ! -d "/workspace/persistence" ]; then
        return 0
    fi
    
    log_info "Found workspace persistence directory"
    
    if [ -f "/workspace/persistence/README.md" ]; then
        log_info "Reading workspace persistence README.md"
        echo "----------------------------------------"
        cat "/workspace/persistence/README.md"
        echo "----------------------------------------"
    fi
}

# =============================================================================
# GIT CONFIGURATION SETUP
# =============================================================================

setup_git_config() {
    log_section "Setting up Git Configuration"
    
    setup_git_credentials
    setup_git_user_info
    verify_git_setup
}

setup_git_credentials() {
    if [ -n "$GIT_USERNAME" ] && [ -n "$GIT_PASSWORD" ]; then
        git config --global credential.helper '!f() { echo "username=$GIT_USERNAME"; echo "password=$GIT_PASSWORD"; }; f'
        log_success "Git credentials configured successfully!"
    else
        log_warning "Git credentials not found in environment variables."
        log_info "To use Git without password prompts, set GIT_USERNAME and GIT_PASSWORD in your .env file."
    fi
}

setup_git_user_info() {
    if [ -n "$GIT_USER_NAME" ]; then
        git config --global user.name "$GIT_USER_NAME"
        log_success "Git user.name set to: $GIT_USER_NAME"
    fi
    
    if [ -n "$GIT_USER_EMAIL" ]; then
        git config --global user.email "$GIT_USER_EMAIL"
        log_success "Git user.email set to: $GIT_USER_EMAIL"
    fi
}

verify_git_setup() {
    
    if [ -n "$GIT_USERNAME" ] && [ -n "$GIT_PASSWORD" ]; then
        if git config --global --get credential.helper | grep -q '!f()'; then
            log_success "Git credential helper is properly configured"
        else
            log_warning "Git credential helper configuration issue. Please check the setup."
        fi
    fi
}

# =============================================================================
# ROVODEV APPLICATION STARTUP
# =============================================================================

start_rovodev() {
    log_section "Starting RovoDev Application"
    
    if ! acli rovodev --help &> /dev/null; then
        log_warning "rovodev utility not found. Please ensure you have the latest acli version."
        log_info "Available acli commands:"
        acli --help 2>/dev/null || echo "acli command not found"
        echo ""
        log_info "Starting interactive shell instead..."
        exec /bin/bash
    fi
    
    log_success "acli rovodev is available!"
    log_info "Starting Rovo Dev..."
    log_info "Current directory: $(pwd)"
    log_info "Files in workspace:"
    ls -la
    echo ""
    log_info "Launching Rovo Dev AI Assistant..."
    exec acli rovodev run
}

# =============================================================================
# MAIN EXECUTION FLOW
# =============================================================================

main() {
    echo "🚀 RovoDev Container Starting..."
    echo "======================================="
    
    # Run all setup functions
    setup_workspace_templates
    setup_atlassian_auth
    setup_docker_access
    setup_persistence
    setup_git_config
    
    echo ""
    log_success "Container initialization complete!"
    echo "======================================="
    
    # Execute the command passed to docker run, or start rovodev automatically
    if [ "$#" -eq 0 ]; then
        start_rovodev
    else
        log_info "Executing custom command: $*"
        exec "$@"
    fi
}

# Run main function with all arguments
main "$@"