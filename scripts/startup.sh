#!/bin/bash
# startup.sh - Handles pulling latest code and reading handover documents

echo "🚀 Starting Development Environment..."

echo "📥 Pulling latest code from GitHub..."
git pull origin main

echo "----------------------------------------"
if [ -f handover.md ]; then
    echo "📋 HANDOVER DOCUMENT FOUND:"
    cat handover.md
else
    echo "ℹ️ No handover.md found. Starting fresh."
fi
echo "----------------------------------------"

echo "💡 SUGGESTED NEXT ACTIONS:"
echo "1. Check the active tasks in your OpenSpec directory (openspec/changes/)."
echo "2. Use OpenSpec commands or ask me to run '/opsx-apply' if there are pending plans."
echo "3. Happy Coding!"
