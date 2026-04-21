#!/bin/bash
# ending.sh - Handles wrapping up a development session

echo "🛑 Wrapping up Development Session..."

# Get commit message from user or use default
COMMIT_MSG=${1:-"chore: dev session wrap-up and save progress"}

echo "📝 AI Agent / Developer Reminders (Ensure these are done before committing!):"
echo "- Update tasks.md in your current OpenSpec change."
echo "- Run 'openspec' commands to archive the change if it is fully completed."
echo "- Write a 'handover.md' in the root folder outlining current status, blockers, and next steps."
echo "----------------------------------------"

echo "📤 Staging, Committing, and Pushing code to GitHub..."
git add .
git commit -m "$COMMIT_MSG"
git push origin main

echo "✅ Wrap-up complete!"
