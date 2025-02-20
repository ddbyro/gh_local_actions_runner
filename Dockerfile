# Use an Ubuntu base image similar to GitHub-hosted runners
FROM ubuntu:22.04

# Set non-interactive mode for apt
ENV DEBIAN_FRONTEND=noninteractive

# Install necessary dependencies
RUN apt update && apt install -y \
    git curl jq unzip \
    build-essential \
    python3 python3-pip \
    nodejs npm \
    && rm -rf /var/lib/apt/lists/* \
    && curl -sL https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64 -o /usr/local/bin/yq \
    && chmod +x /usr/local/bin/yq

# Set up working directory
WORKDIR /workspace

# Copy the script that runs workflow steps
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Set environment variables to mimic GitHub Actions
ENV GITHUB_WORKSPACE=/workspace
ENV GITHUB_REPOSITORY="your-org/your-repo"
ENV GITHUB_REF="refs/heads/main"

# Define default command
CMD ["/entrypoint.sh"]
