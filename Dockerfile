# Use official Node.js image as base for Node.js and NPM
FROM node:20.19.0 AS node_base
RUN echo "NODE Version:" && node --version
RUN echo "NPM Version:" && npm --version

# Use Ubuntu minimal as base image for better package management support
# Support both AMD64 and ARM64 architectures
FROM ubuntu:22.04

COPY --from=node_base /usr/local/bin /usr/local/bin
COPY --from=node_base /usr/local/lib/node_modules/npm /usr/local/lib/node_modules/npm

# Set environment variables to avoid interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=UTC
ENV EDITOR=nano

# Create a non-root user for security
RUN groupadd -r rovodev && useradd -r -g rovodev -m -s /bin/bash rovodev

# Install essential packages and dependencies
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    git \
    unzip \
    ca-certificates \
    gnupg \
    lsb-release \
    software-properties-common \
    build-essential \
    python3 \
    python3-pip \
    nodejs \
    npm \
    jq \
    vim \
    nano \
    sudo \
    openssh-client \
    && rm -rf /var/lib/apt/lists/*

RUN add-apt-repository ppa:rmescandon/yq && \
    apt-get update && \
    apt-get install -y yq && \
    rm -rf /var/lib/apt/lists/*

# Install Docker
RUN apt-get update && \
    apt-get install -y apt-transport-https && \
    install -m 0755 -d /etc/apt/keyrings && \
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg && \
    chmod a+r /etc/apt/keyrings/docker.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
    $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null && \
    apt-get update && \
    apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin && \
    rm -rf /var/lib/apt/lists/*

# Install acli (Atlassian CLI) with architecture detection
RUN ARCH=$(uname -m) && \
    if [ "$ARCH" = "x86_64" ]; then \
        ACLI_ARCH="amd64"; \
    elif [ "$ARCH" = "aarch64" ]; then \
        ACLI_ARCH="arm64"; \
    else \
        echo "Unsupported architecture: $ARCH" && exit 1; \
    fi && \
    echo "Downloading acli for architecture: $ACLI_ARCH" && \
    curl -LO "https://acli.atlassian.com/linux/latest/acli_linux_${ACLI_ARCH}/acli" && \
    chmod +x ./acli && \
    mv ./acli /usr/local/bin/acli && \
    echo "acli installed successfully for $ACLI_ARCH"

# Agregar después de las instalaciones existentes de nodejs/npm (línea 24-25)            
# Install Node.js LTS (>= 20.19.0) - actualizar la versión                               
#RUN curl -fsSL https://deb.nodesource.com/setup_lts.x | bash - && \                      
#   apt-get install -y nodejs && \                                                       
#   node --version && npm --version 

 # Install OpenSpec from GitHub                                                           
RUN npm install -g @fission-ai/openspec@latest && \
    openspec --version && \ 
    echo "OpenSpec installed successfully" 

RUN npx playwright install --with-deps && \
    echo "Playwright and dependencies installed successfully"

RUN npm install -g @playwright/mcp && \
    echo "Playwright MCP installed successfully"   

# Create workspace directory with proper permissions
RUN mkdir -p /workspace && chown rovodev:rovodev /workspace

# Copy template content to be used when initializing new projects
COPY .rovodev /opt/rovodev-template/.rovodev
COPY openspec /opt/rovodev-template/openspec
RUN chown -R rovodev:rovodev /opt/rovodev-template

# Create persistence directory with proper permissions
#RUN mkdir -p /persistence && chown rovodev:rovodev /persistence

# Create config directory for acli
RUN mkdir -p /home/rovodev/.config/acli && chown -R rovodev:rovodev /home/rovodev/.config

# Create SSH directory for the user
RUN mkdir -p /home/rovodev/.ssh && chmod 700 /home/rovodev/.ssh && chown -R rovodev:rovodev /home/rovodev/.ssh

# Add rovodev user to sudoers for package installation
RUN echo "rovodev ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Add rovodev user to the docker group to allow running docker commands without sudo
# Note: The Docker socket permissions are also fixed in entrypoint.sh to ensure proper access
RUN groupadd -f docker && usermod -aG docker rovodev

# Copy entrypoint script
COPY entrypoint.sh /home/rovodev/entrypoint.sh

# Make entrypoint script executable and set proper ownership
USER root
RUN chmod +x /home/rovodev/entrypoint.sh && chown rovodev:rovodev /home/rovodev/entrypoint.sh

# Switch to non-root user
USER rovodev

# Set working directory
WORKDIR /workspace

# Set entrypoint
ENTRYPOINT ["/home/rovodev/entrypoint.sh"]

# Default command (interactive shell)
CMD []