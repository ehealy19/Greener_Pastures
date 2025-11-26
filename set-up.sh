#!/bin/bash
# =======================================================
# Greener Pastures: Environment + Routing Setup Script
# =======================================================

set -e  # stop on first error
echo "Starting setup for Greener Pastures..."

# ------------------------------
# 1. Conda Environment Setup
# ------------------------------
if ! command -v conda &> /dev/null; then
    echo "Conda not found. Please install Miniconda or Anaconda first."
    exit 1
fi

if [ -f "environment.yml" ]; then
    ENV_NAME=$(head -1 environment.yml | cut -d' ' -f2)
    echo "Setting up Conda environment: $ENV_NAME"
    eval "$(conda shell.bash hook)"
    if conda env list | grep -q "$ENV_NAME"; then
        echo "✅ Environment '$ENV_NAME' already exists. Activating..."
    else
        conda env create -f environment.yml
    fi
    conda activate "$ENV_NAME"
else
    echo "No environment.yml found."
    exit 1
fi

# ------------------------------
# 2. Homebrew + Tools
# ------------------------------
if ! command -v brew &> /dev/null; then
    echo "Homebrew not found. Please install it from https://brew.sh first."
    exit 1
else
    echo "✅ Homebrew installed."
fi

if ! command -v docker &> /dev/null; then
    echo "Installing Docker..."
    brew install --cask docker
else
    echo "✅ Docker installed."
fi

if ! command -v vroom &> /dev/null; then
    echo "Installing VROOM..."
    brew install vroom
else
    echo "✅ VROOM installed."
fi

if ! command -v colima &> /dev/null; then
    echo "Installing Colima..."
    brew install colima
else
    echo "✅ Colima installed."
fi

# ------------------------------
# 3. Start Colima (with resources)
# ------------------------------
if ! colima status >/dev/null 2>&1; then
    echo "Starting Colima (6 CPU / 10 GB RAM)..."
    colima start --cpu 6 --memory 10
else
    echo "Restarting Colima with correct config..."
    colima stop
    colima start --cpu 6 --memory 10
fi

# ------------------------------
# 4. OSRM Setup (Reuse existing files)
# ------------------------------
docker pull ghcr.io/project-osrm/osrm-backend:latest

DATA_DIR="data/osrm"
MAP_FILE="pennsylvania-latest.osm.pbf"

# Copy map file into data/osrm if not already there
if [ -f "$MAP_FILE" ] && [ ! -f "$DATA_DIR/$MAP_FILE" ]; then
    cp "$MAP_FILE" "$DATA_DIR/"
fi

cd "$DATA_DIR"

# --- Fix missing datasource_names ---
if [ ! -f "pennsylvania-latest.osrm.datasource_names" ]; then
    echo "Creating missing datasource_names file..."
    echo "extract" > pennsylvania-latest.osrm.datasource_names
    chmod 644 pennsylvania-latest.osrm.datasource_names
else
    echo "✅ datasource_names file exists."
fi

cd ../..

# ------------------------------
# 5. Run OSRM backend
# ------------------------------
PORT=5000
if lsof -i:$PORT >/dev/null 2>&1; then
    echo "Port 5000 is in use — switching to 5050."
    PORT=5050
fi

# Remove old container if it exists
if docker ps -a --format '{{.Names}}' | grep -q "osrm-backend"; then
    echo "Removing existing OSRM container..."
    docker rm -f osrm-backend >/dev/null 2>&1 || true
fi

echo "Starting OSRM routing backend on port $PORT..."
docker run -d --name osrm-backend -p ${PORT}:5000 -v "$(pwd)/data/osrm:/data" \
    ghcr.io/project-osrm/osrm-backend:latest \
    osrm-routed --algorithm mld /data/pennsylvania-latest.osrm

sleep 5

# ------------------------------
# 6. Verify OSRM is running
# ------------------------------
echo "🔍 Verifying OSRM backend..."
if curl -s "http://localhost:${PORT}/route/v1/driving/-75.1652,39.9526;-75.1733,39.9551" | grep -q '"code":"Ok"'; then
    echo "✅ OSRM is responding successfully at http://localhost:${PORT}"
else
    echo "OSRM did not respond correctly. Check logs with:"
    echo "   docker logs osrm-backend | tail -n 50"
fi

echo "✅Setup Complete! When finished, run clean-up.sh."

# CHECKING
docker ps
