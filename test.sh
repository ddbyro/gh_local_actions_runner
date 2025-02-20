podman run -d \
  --name github-actions-runner \
  -v ~/actions-runner:/actions-runner \
  -v $(pwd):/workspace \
  -e RUNNER_WORKDIR="/workspace" \
  --restart always \  # Always restart the container if it stops
  summerwind/actions-runner:v2.317.0-ubuntu-22.04 \
  tail -f /dev/null
