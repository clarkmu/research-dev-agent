# Research development agent (DGX Spark, ARM64)

Builds a non-root Debian-based container with Node 22, Python 3, Git, Codex CLI, and Claude Code.

## Build

```bash
cp .env.example .env
# Edit SPARK_CHAT_REPO to the actual absolute host path.
docker compose build
```

## Verify CLIs

```bash
docker compose run --rm agent sh -lc 'uname -m; node --version; python3 --version; codex --version; claude --version'
```

## Start a session

```bash
docker compose run --rm agent bash
# Inside: codex OR claude
```

The agent has a bind-mounted working tree and a persistent home volume. Authenticate interactively using the respective CLI instructions; do not bake tokens into the image. The volume persists CLI credentials, so treat it as sensitive.

## Security boundaries

- No Docker socket or privileged mode.
- No GPU passthrough.
- No production/research data mounts.
- Outbound network is currently enabled for hosted-model authentication and requests; this is NOT a hardened network sandbox.
- A bind-mounted repository is writable and the container can change/delete its contents. Use a clean Git worktree and backup important data before agent execution.
- Docker resource limits are preliminary; adjust for host load.
- The named home volume may contain private credentials and should not be shared across users.
- If the host repo is owned by a different UID than 10001, correct access with a suitable group/ACL or change the build user UID; do not chmod the repo world-writable.

## Caveat

This image has not been built or tested on the Spark from this environment. The Claude installer may change and must support the ARM64 environment. Build/CLI verification is required before use.
