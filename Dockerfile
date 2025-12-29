# RovoDev base image (slim, readable, and functional)
FROM node:20-bookworm-slim

ENV DEBIAN_FRONTEND=noninteractive TZ=UTC EDITOR=nano

# Create non-root user
RUN groupadd -r rovodev && useradd -r -g rovodev -m -s /bin/bash rovodev

# Runtime packages (use BuildKit caches for speed)
RUN --mount=type=cache,target=/var/cache/apt \
    --mount=type=cache,target=/var/lib/apt \
    apt-get update && apt-get install -y --no-install-recommends \
      ca-certificates curl wget git unzip jq nano sudo openssh-client iproute2 python3 \
    && rm -rf /var/lib/apt/lists/*

# yq (static single binary)
RUN ARCH=$(dpkg --print-architecture) \
    && case "$ARCH" in amd64|arm64) YQ_ARCH=$ARCH ;; *) echo "Unsupported arch: $ARCH"; exit 1 ;; esac \
    && curl -fsSL -o /usr/local/bin/yq "https://github.com/mikefarah/yq/releases/latest/download/yq_linux_${YQ_ARCH}" \
    && chmod +x /usr/local/bin/yq

# Docker CLI (incl. buildx + compose)
RUN --mount=type=cache,target=/var/cache/apt \
    --mount=type=cache,target=/var/lib/apt \
    apt-get update \
    && apt-get install -y --no-install-recommends apt-transport-https gnupg ca-certificates \
    && install -m 0755 -d /etc/apt/keyrings \
    && curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian $(. /etc/os-release && echo "$VERSION_CODENAME") stable" > /etc/apt/sources.list.d/docker.list \
    && apt-get update \
    && apt-get install -y --no-install-recommends docker-ce-cli docker-buildx-plugin docker-compose-plugin \
    && apt-get purge -y gnupg apt-transport-https || true \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/*

# Atlassian CLI (acli)
RUN ARCH=$(dpkg --print-architecture) \
    && case "$ARCH" in amd64|arm64) ACLI_ARCH=$ARCH ;; *) echo "Unsupported arch: $ARCH"; exit 1 ;; esac \
    && curl -fsSL -o /usr/local/bin/acli "https://acli.atlassian.com/linux/latest/acli_linux_${ACLI_ARCH}/acli" \
    && chmod +x /usr/local/bin/acli

# OpenSpec CLI
RUN npm install -g @fission-ai/openspec@latest \
    && openspec --version >/dev/null 2>&1 || true

# MCP servers list (external file next to Dockerfile)
COPY mcp-packages.txt /tmp/mcp-packages.txt

# Install MCP servers listed (comments/blank lines ignored)
RUN --mount=type=cache,target=/root/.npm \
    rm -f /root/.npmrc || true \
    && npm config set registry https://registry.npmjs.org/ \
    && npm config delete '//registry.npmjs.org/:_authToken' || true \
    && (npm logout || true) \
    && if [ -s /tmp/mcp-packages.txt ]; then \
         while IFS= read -r pkg; do \
           case "$pkg" in ''|'#'*) continue ;; *) echo "Installing: $pkg" && npm install -g "$pkg" || echo "WARN: failed $pkg" ;; esac; \
         done < /tmp/mcp-packages.txt; \
       else echo "No MCP packages listed"; fi \
    && npm ls -g --depth=0 | tee /home/rovodev/mcp-versions.txt \
    && npm cache clean --force \
    && rm -rf /home/rovodev/.npm /root/.cache /home/rovodev/.cache || true

# Workspace and templates
RUN mkdir -p /workspace /workspace/code && chown -R rovodev:rovodev /workspace
COPY --chown=rovodev:rovodev .rovodev /home/rovodev/.rovodev
COPY --chown=rovodev:rovodev templates/openspec /opt/templates/openspec

# User config (acli, ssh) and sudo/docker group
RUN mkdir -p /home/rovodev/.config/acli /home/rovodev/.ssh \
    && chmod 700 /home/rovodev/.ssh \
    && chown -R rovodev:rovodev /home/rovodev/.config /home/rovodev/.ssh \
    && echo "rovodev ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers \
    && groupadd -f docker && usermod -aG docker rovodev

# Entrypoint
COPY --chown=rovodev:rovodev --chmod=755 entrypoint.sh /home/rovodev/entrypoint.sh

USER rovodev
WORKDIR /workspace/code

ENTRYPOINT ["/home/rovodev/entrypoint.sh"]
CMD []
