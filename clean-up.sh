#!/bin/bash
# ============================================
# Greener Pastures: Cleanup Script
# Stops Colima and removes OSRM container
# ============================================

set -e
echo "🧹 Cleaning up Greener Pastures..."

# 1. Remove container if it exists
if docker ps -a --format '{{.Names}}' | grep -q "^osrm-backend$"; then
    echo "🗑️ Removing OSRM container..."
    docker rm -f osrm-backend
else
    echo "✅ No OSRM container found."
fi

# 2. Then stop Colima
if colima status >/dev/null 2>&1; then
    echo "🛑 Stopping Colima..."
    colima stop
else
    echo "✅ Colima already stopped."
fi

echo "🎉 Cleanup complete!"
