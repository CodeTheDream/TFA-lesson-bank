#!/bin/bash
set -e

# Remove a potentially pre-existing server.pid for Rails.
rm -f /TFA-lesson-bank/tmp/pids/server.pid
cd /TFA-lesson-bank

# Then exec the container's main process (what's set as CMD in the Dockerfile).
exec "$@"

