#!/bin/bash

# set -ex for debugging
set -ex  # Enable debugging and exit on failure

# Configuration variables
DEV_BRANCH="dev"
MAIN_BRANCH="main"
COMMIT_MESSAGE="Update main branch"
TAG_PREFIX="backup-"

# Ensure we return to the dev branch, even on error
trap 'echo "Returning to $DEV_BRANCH branch (trap)..."; git checkout $DEV_BRANCH || true' EXIT

# Ensure all local changes are committed
echo "Checking for uncommitted changes..."
if ! git diff-index --quiet HEAD; then
    echo "Uncommitted changes detected. Staging and committing changes..."
    git add -A
    git commit -m "Auto-commit: Save local changes before switching branches"
fi

echo "Switching to '$DEV_BRANCH' branch..."
git checkout $DEV_BRANCH

echo "Pulling latest changes from '$DEV_BRANCH' branch..."
git pull --rebase origin $DEV_BRANCH

echo "Switching to '$MAIN_BRANCH' branch..."
git checkout $MAIN_BRANCH

echo "Pulling latest changes from '$MAIN_BRANCH' branch..."
git pull origin $MAIN_BRANCH

echo "Displaying differences before merge..."
git diff $MAIN_BRANCH..$DEV_BRANCH

echo "Merging '$DEV_BRANCH' into '$MAIN_BRANCH' with default commit message..."
git merge $DEV_BRANCH -m "$COMMIT_MESSAGE"

echo "Pushing updates to '$MAIN_BRANCH' branch..."
git push origin $MAIN_BRANCH

# Tagging the backup
TAG_NAME="${TAG_PREFIX}$(date +%Y%m%d%H%M%S)"
echo "Creating a new tag: $TAG_NAME"
git tag -a $TAG_NAME -m "Backup created on $(date)"
git push origin $TAG_NAME

echo "Cleaning up old branches (optional)..."
git branch --merged | grep -v "\*" | grep -v "$MAIN_BRANCH" | xargs -r git branch -d

echo "Backup complete! Latest tag: $TAG_NAME"

# Explicitly switch back to dev branch
echo "Returning to $DEV_BRANCH branch (explicit)..."
git checkout $DEV_BRANCH
