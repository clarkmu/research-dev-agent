FROM node:22-bookworm

ARG TARGETARCH
RUN apt-get update && apt-get install -y --no-install-recommends \
    bash ca-certificates curl git openssh-client python3 python3-pip python3-venv \
    build-essential ripgrep jq tini acl && rm -rf /var/lib/apt/lists/*

# Pinned uv plus a preinstalled, read-only managed CPython 3.12.
# Projects create their own venvs; runtime interpreter downloads are disabled.
COPY --from=ghcr.io/astral-sh/uv:0.13.5 /uv /uvx /usr/local/bin/
ENV UV_PYTHON_INSTALL_DIR=/opt/uv/python \
    UV_PYTHON_DOWNLOADS=manual
RUN uv python install 3.12 && chmod -R a+rX /opt/uv && rm -rf /root/.cache/uv

RUN npm install -g @openai/codex

RUN mkdir -p /workspace /home/agent && chown -R node:node /workspace /home/agent
USER node
ENV HOME=/home/agent PATH=/home/agent/.local/bin:$PATH
RUN curl -fsSL https://claude.ai/install.sh | bash
WORKDIR /workspace
CMD ["bash"]
