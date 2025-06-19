#!/bin/zsh

echo "Watching for file changes in $(pwd)..."

fswatch -or --exclude '\.git/' --exclude '.*\.swp$' . | while read f; do
  if [[ -n $(git status --porcelain) ]]; then
    clear
    echo "Change detected. Updating changelog and pushing..."

    TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

    # Ensure README exists
    if [[ ! -f README.md ]]; then
      echo "# Project Title" > README.md
      echo "" >> README.md
    fi

    # Add a ## Changelog section if not present
    if ! grep -q "## Changelog" README.md; then
      echo -e "\n## Changelog\n" >> README.md
    fi

    # Append new changelog entry
    echo "- Auto-update at $TIMESTAMP" >> README.md

    git add .
    git commit -m "Auto-update: $TIMESTAMP"
    git push
  else
    echo "Change detected, but nothing new to commit."
  fi
done
