#!/usr/bin/env bash
# LoftIQ — push notebook + docs update to GitHub
# Run this from the root of your local clone of IR4E/LoftIQ

set -e

echo "== LoftIQ update push =="

# 1. Confirm you're in the right repo
if [ ! -d ".git" ]; then
  echo "ERROR: not a git repo. cd into your local LoftIQ clone first."
  exit 1
fi

REMOTE_URL=$(git remote get-url origin 2>/dev/null || echo "")
echo "Remote: $REMOTE_URL"

# 2. Pull latest first, avoid clobbering anything
git pull origin main

# 3. Sanity check: make sure the private alias file is NOT staged
if git status --porcelain | grep -i "PRIVATE"; then
  echo "ERROR: a PRIVATE file is staged. Aborting to protect real bird data."
  exit 1
fi

# 4. Stage the update
git add .gitignore CHANGELOG.md README.md *.ipynb

# 5. Show what's about to be committed — review before confirming
git status
echo ""
read -p "Does this look correct? Commit and push? (y/n) " CONFIRM
if [ "$CONFIRM" != "y" ]; then
  echo "Aborted."
  exit 0
fi

# 6. Commit + push
git commit -m "Update: ensemble model, composite scoring, audit + pair-performance outputs"
git push origin main

echo "Done. Check https://github.com/IR4E/LoftIQ"
