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

adjust_user_ids() {
  # Align container user/group IDs with host-provided ones to avoid file permission issues on bind mounts
  if [[ -n "${HOST_UID:-}" && -n "${HOST_GID:-}" ]] && [[ "$HOST_UID" =~ ^[0-9]+$ ]] && [[ "$HOST_GID" =~ ^[0-9]+$ ]]; then
    log_section "Adjusting container user/group IDs"
    local cur_uid cur_gid
    cur_uid=$(id -u rovodev 2>/dev/null || echo 0)
    cur_gid=$(id -g rovodev 2>/dev/null || echo 0)

    if [[ "$cur_gid" != "$HOST_GID" ]]; then
      log_info "Updating group ID: rovodev gid $cur_gid -> $HOST_GID"
      sudo groupmod -g "$HOST_GID" rovodev 2>/dev/null || true
    fi

    if [[ "$cur_uid" != "$HOST_UID" ]]; then
      log_info "Updating user ID: rovodev uid $cur_uid -> $HOST_UID"
      sudo usermod -u "$HOST_UID" -g "$HOST_GID" rovodev 2>/dev/null || true
    fi

    # Fix ownership of home and private volume (bind mounts won't be chowned)
    sudo chown -R rovodev:rovodev /home/rovodev 2>/dev/null || true

    umask 0002
    log_success "User/group IDs aligned (uid=$(id -u), gid=$(id -g))"
  fi
}

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
# BASE CONFIGURATION SETUP (RovoDev)
# - Resolve CODE_ROOT (code vs workspace)
# - Ensure base config exists in /home/rovodev/.rovodev
# - Provide helpers for later normalization/bootstrapping
# =============================================================================

setup_workspace_templates() {

    # Determine code root (/workspace/code if present, else /workspace)
    local CODE_ROOT="/workspace"
    if [ -d "/workspace/code" ]; then
        CODE_ROOT="/workspace/code"
    fi

    # Ensure base config exists (populated at build time)
    if [ ! -d "/home/rovodev/.rovodev" ]; then
        mkdir -p /home/rovodev/.rovodev
        chown -R rovodev:rovodev /home/rovodev/.rovodev 2>/dev/null || true
        log_warning "/home/rovodev/.rovodev did not exist; created empty directory"
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
# Utility: prepare wiki directories if mounted
# =============================================================================
prepare_wiki() {
  if [[ -n "$WIKI_ROOT" && -d "$WIKI_ROOT" ]]; then
    # If wiki seems empty (no files), bootstrap minimal OpenSpec structure
    if [ -z "$(ls -A "$WIKI_ROOT" 2>/dev/null)" ]; then
      log_info "Wiki root detected and empty. Bootstrapping minimal OpenSpec structure..."
      if [ -d "/opt/templates/openspec" ]; then
        mkdir -p "$WIKI_ROOT/openspec" && cp -r /opt/templates/openspec/* "$WIKI_ROOT/openspec/" 2>/dev/null || true
        chown -R rovodev:rovodev "$WIKI_ROOT/openspec" 2>/dev/null || true
        # Create changes directory and keep file
        mkdir -p "$WIKI_ROOT/openspec/changes" && touch "$WIKI_ROOT/openspec/changes/.keep" 2>/dev/null || true
        # Create simple index if not present
        if [[ ! -f "$WIKI_ROOT/openspec/index.md" ]]; then
          cat > "$WIKI_ROOT/openspec/index.md" << 'EOF'
# OpenSpec Index

- standards/: templates and standards
- changes/: specs per ticket (draft → validated → finalized)
EOF
        fi
        log_success "Wiki OpenSpec bootstrap completed"
      else
        log_warning "OpenSpec templates not found in image; created empty structure"
        mkdir -p "$WIKI_ROOT/openspec/changes" || true
      fi
    else
      # Wiki has content; just ensure changes directory exists and do nothing else
      mkdir -p "$WIKI_ROOT/openspec/changes" || true
      log_info "Wiki root detected with content. No bootstrap changes applied."
    fi
  fi
}

# =============================================================================
# MOUNTS/ENV SUMMARY (for quick debugging)
# =============================================================================
print_mounts_status() {
  echo ""
  echo "[mounts] Workspace layout"
  printf "  • /workspace exists: %s\n" "$( [ -d /workspace ] && echo yes || echo no )"
  printf "  • /workspace/code mounted: %s\n" "$( [ -d /workspace/code ] && echo yes || echo no )"
  printf "  • /workspace/wiki mounted: %s\n" "$( [ -d /workspace/wiki ] && echo yes || echo no )"
  printf "  • Project .rovodev present: %s\n" "$( [ -d /workspace/code/.rovodev ] && echo yes || echo no )"
  echo "[env] Key variables"
  printf "  • WIKI_ROOT=%s\n" "${WIKI_ROOT:-<unset>}"
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
    : # persistence disabled
    setup_git_config
    prepare_wiki
    print_mounts_status
    
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