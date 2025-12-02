#!/bin/bash
# ============================================
# Greener Pastures: Cleanup Script
# Stops Colima and removes OSRM container
# ============================================

set -e
echo "Cleaning up Greener Pastures..."

# removing and stopping docker
if docker ps -a --format '{{.Names}}' | grep -q "^osrm-backend$"; then
    echo "Removing OSRM container..."
    docker rm -f osrm-backend
else
    echo "✅ No OSRM container found."
fi

# stopping colima
if colima status >/dev/null 2>&1; then
    echo "Stopping Colima..."
    colima stop
else
    echo "✅ Colima already stopped."
fi

# confirming that nothing is running
echo "✅ Cleanup complete!"
