#!/usr/bin/env bash
# ApertureTube Full-Stack Development Runner
# Boots the FastAPI backend and launches the Flutter application

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"
BACKEND_DIR="$ROOT_DIR/backend"

echo "=================================================="
echo "🎞️ ApertureTube • Cinema & RAW Masters Dev Runner"
echo "=================================================="

# Function to cleanup background processes on exit
cleanup() {
    echo ""
    echo "🛑 Shutting down backend services..."
    if [ -n "$BACKEND_PID" ]; then
        kill "$BACKEND_PID" 2>/dev/null || true
    fi
    exit 0
}
trap cleanup SIGINT SIGTERM EXIT

# 1. Clean up port 8000 if already bound
lsof -ti :8000 | xargs kill -9 2>/dev/null || true

# Start FastAPI Backend in background
echo "🚀 Starting FastAPI Backend at http://localhost:8000..."
cd "$BACKEND_DIR"
if [ -d ".venv" ]; then
    .venv/bin/uvicorn main:app --reload --host 0.0.0.0 --port 8000 &
    BACKEND_PID=$!
else
    uvicorn main:app --reload --host 0.0.0.0 --port 8000 &
    BACKEND_PID=$!
fi

# Wait briefly for FastAPI to initialize
sleep 2

# Check if backend is alive
echo "🔍 Checking backend health..."
curl -s http://localhost:8000/health || echo "Backend starting up..."

echo "✨ FastAPI documentation available at: http://localhost:8000/docs"
echo "=================================================="

# 2. Launch Flutter App
cd "$ROOT_DIR"
MODE="${1:---release}"
echo "📱 Launching Flutter Client ($MODE)..."
flutter run -d chrome "$MODE"


