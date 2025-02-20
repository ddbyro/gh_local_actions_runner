#!/bin/bash
set -e  # Exit on error

echo "Starting GitHub Actions workflow in a container..."
cd "$GITHUB_WORKSPACE"

# Default to 'main' branch if not provided
BRANCH=${GITHUB_REF##*/}  # Extract branch name from ref (refs/heads/main -> main)
BRANCH=${BRANCH:-main}

# Get cloning method (SSH or HTTPS) from the environment variable
CLONE_METHOD=${CLONE_METHOD:-"SSH"}  # Default to SSH if not specified

# If using SSH, ensure SSH keys are available and known hosts are configured
if [ "$CLONE_METHOD" == "SSH" ]; then
    echo "Using GitHub repository via SSH: git@github.com:$GITHUB_REPOSITORY.git"

    # Create the known_hosts file if it doesn't exist
    mkdir -p ~/.ssh
    touch ~/.ssh/known_hosts

    # Add GitHub's SSH key to known_hosts
    ssh-keyscan github.com >> ~/.ssh/known_hosts
else
    # HTTPS cloning fallback (in case needed)
    GITHUB_URL="https://github.com/$GITHUB_REPOSITORY.git"
    echo "Using GitHub repository via HTTPS: $GITHUB_URL"
fi

# Construct the GitHub repository URL based on the chosen cloning method
GITHUB_URL="git@github.com:$GITHUB_REPOSITORY.git"
echo "Using GitHub repository: $GITHUB_URL"

# Ensure the repository exists
if [ -d ".git" ]; then
    echo "Repository already exists. Fetching latest changes..."
    git fetch origin "$BRANCH"
    git reset --hard "origin/$BRANCH"
else
    echo "Cloning repository..."
    git clone --branch "$BRANCH" "$GITHUB_URL" .
fi

#
