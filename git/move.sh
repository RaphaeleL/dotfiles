#!/bin/bash

set -euo pipefail
set -x

# === CONFIGURE THIS ===
REPO_NAME="dotfiles"
GITHUB_USER="RaphaeleL"
TARGET_NAME="Raphaele Salvatore Licciardo"
TARGET_EMAIL="raphaele.salvatore@outlook.de"
# =====================

# Work in a temporary folder
TMP_DIR="${REPO_NAME}.filter"

# Remove previous filter clone if it exists
rm -rf "$TMP_DIR"

# Clone the repo as a bare mirror
git clone --no-tags --mirror "$REPO_NAME" "$TMP_DIR"

cd "$TMP_DIR"

# Rewrite commits where author or committer name contains "raphaele"
git filter-repo --force --commit-callback "
if b'raphaele' in commit.author_name.lower() or b'raphaele' in commit.committer_name.lower():
    commit.author_name  = b'$TARGET_NAME'
    commit.author_email = b'$TARGET_EMAIL'
    commit.committer_name  = b'$TARGET_NAME'
    commit.committer_email = b'$TARGET_EMAIL'
"

# Show shortlog of rewritten commits
git shortlog -sne

# Re-add GitHub remote
git remote add origin "git@github.com:$GITHUB_USER/$REPO_NAME.git"

# Force push rewritten history
git push --force origin --all
git push --force origin --tags

echo "Done! Rewritten history pushed to GitHub."
