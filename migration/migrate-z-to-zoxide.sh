#!/bin/bash
#
# Migrate z.sh history to zoxide
# Run this ONCE after installing zoxide, then delete this directory

set -e

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

step() { echo -e "${BLUE}➜${NC} $1"; }
success() { echo -e "${GREEN}✓${NC} $1"; }
warn() { echo -e "${YELLOW}⚠${NC} $1"; }
error() { echo -e "${RED}✗${NC} $1"; exit 1; }

echo ""
step "Migrating z.sh history to zoxide"
echo ""

# Check if zoxide is installed
if ! command -v zoxide &>/dev/null; then
   error "zoxide is not installed. Run bin/install first."
fi

# Check if z.sh datafile exists
if [ ! -f ~/.z ]; then
   warn "No z.sh history found at ~/.z"
   echo "Nothing to migrate."
   exit 0
fi

# Count entries
TOTAL=$(wc -l < ~/.z)
echo "Found $TOTAL directories in z.sh history"
echo ""

# Initialize zoxide
eval "$(zoxide init bash)"

# Migrate
MIGRATED=0
SKIPPED=0

while IFS='|' read -r path rank time; do
   # Skip empty lines
   [ -z "$path" ] && continue

   # Check if directory still exists
   if [ -d "$path" ]; then
      # Calculate visits from rank
      visits=$((rank / 10))
      visits=$((visits > 0 ? visits : 1))

      # Add to zoxide multiple times based on rank
      for ((i=0; i<visits; i++)); do
         zoxide add "$path" 2>/dev/null
      done

      ((MIGRATED++))
   else
      ((SKIPPED++))
   fi
done < ~/.z

echo ""
success "Migration complete!"
echo "  Migrated: $MIGRATED directories"
echo "  Skipped: $SKIPPED directories (no longer exist)"
echo ""

# Backup the old file
mv ~/.z ~/.z.migrated
success "Original z.sh data backed up to ~/.z.migrated"

echo ""
step "What's next:"
echo "  1. Test zoxide: z dotfiles"
echo "  2. If it works, delete: rm -rf ~/.dotfiles/migration/"
echo "  3. Optional: rm ~/.z.migrated"
echo ""
