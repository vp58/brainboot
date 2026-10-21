#!/usr/bin/env bash
# Read one credential from the macOS login Keychain without prompting.
# Usage: get-secret.sh <name>
# Service name defaults to "brain-secret"; override with BRAIN_SECRET_SERVICE.
set -euo pipefail
name="${1:?usage: get-secret.sh <name>}"
service="${BRAIN_SECRET_SERVICE:-brain-secret}"
if ! security find-generic-password -s "$service" -a "$name" -w 2>/dev/null; then
  echo "secret '$name' not found in Keychain service '$service'" >&2
  exit 1
fi
