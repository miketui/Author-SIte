#!/usr/bin/env bash
# ============================================================
# michaeldavidjr.beauty — Bootstrap Setup Script
# Version: 2.3.0
# Aligned to: PRD v2.3
# ============================================================
# Runs PRD Phases 0-2:
# - repo preparation
# - Claude Code install check
# - plugin best-effort install
# - UI/UX Pro Max + 21st.dev Magic + Motion setup
# - command-registry normalization
# - .claude/ scaffold
# - verification + readiness report
#
# Canonical repo model:
#   source repo       = ../Last/Final edits/
#   destination repo  = ./   (inside Author-SIte)
#
# Canonical command registry:
#   ../Last/Final edits/Claude-code/chatgpt_command_registry_v1.json
#   -> copied to config/command-registry.source.json
#
# Supplementary command PDFs:
#   docs/reference/commands/
#   (optional, manual, non-canonical)
# ============================================================

set -euo pipefail

DEST_REPO="https://github.com/miketui/Author-SIte.git"
SOURCE_REPO="https://github.com/miketui/Last.git"
DEST_DIR="Author-SIte"
SOURCE_DIR="Last"

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m'

log()   { echo -e "${BLUE}[setup]${NC} $*"; }
ok()    { echo -e "${GREEN}[ok]${NC}    $*"; }
warn()  { echo -e "${YELLOW}[warn]${NC}  $*"; }
err()   { echo -e "${RED}[err]${NC}   $*" >&2; }
step()  { echo -e "\n${BOLD}${BLUE}━━━ $* ━━━${NC}\n"; }

declare -a SKIPPED=()
declare -a FLAGGED=()

step "Step 0 — Prerequisites"

require() {
  if ! command -v "$1" >/dev/null 2>&1; then
    err "Required: $1 not found on PATH. Install it and re-run."
    exit 1
  fi
  ok "Found: $1 ($(command -v "$1"))"
}

require git
require node
require npm

if command -v pnpm >/dev/null 2>&1; then
  PKG_MGR="pnpm"
  ok "Found: pnpm (preferred)"
else
  warn "pnpm not found. Installing globally..."
  npm install -g pnpm
  PKG_MGR="pnpm"
fi

NODE_MAJOR=$(node -v | sed 's/v//;s/\..*//')
if [[ "$NODE_MAJOR" -lt 18 ]]; then
  err "Node.js 18+ required (found $(node -v)). Upgrade and re-run."
  exit 1
fi
ok "Node version OK: $(node -v)"

step "Step 1 — Claude Code CLI"

if command -v claude >/dev/null 2>&1; then
  ok "Claude Code already installed: $(claude --version 2>/dev/null || echo 'version check failed')"
else
  log "Installing Claude Code via npm..."
  if ! npm install -g @anthropic-ai/claude-code; then
    warn "npm install failed, trying native installer..."
    curl -fsSL https://claude.ai/install.sh | bash
  fi
fi

log "Running claude doctor..."
claude doctor || warn "claude doctor reported issues — review the output above"

step "Step 2 — Clone Repos + Normalize Registry"

if [[ -d "$DEST_DIR/.git" ]]; then
  ok "Destination repo already cloned: $DEST_DIR/"
else
  log "Cloning destination repo: $DEST_REPO"
  git clone "$DEST_REPO" "$DEST_DIR"
fi

if [[ -d "$SOURCE_DIR/.git" ]]; then
  ok "Source repo already cloned: $SOURCE_DIR/"
else
  log "Cloning source repo: $SOURCE_REPO"
  git clone "$SOURCE_REPO" "$SOURCE_DIR"
fi

cd "$DEST_DIR"

SOURCE_ROOT="../$SOURCE_DIR/Final edits"
SOURCE_OEBPS="$SOURCE_ROOT/OEBPS"
SOURCE_FINAL="$SOURCE_ROOT/final"
SOURCE_COMMANDS="$SOURCE_ROOT/Claude-code"
SOURCE_REGISTRY="$SOURCE_COMMANDS/chatgpt_command_registry_v1.json"

log "Verifying canonical source paths..."
for p in "$SOURCE_ROOT" "$SOURCE_OEBPS" "$SOURCE_FINAL" "$SOURCE_COMMANDS"; do
  if [[ -d "$p" ]]; then
    ok "Found source path: $p"
  else
    warn "Missing source path: $p"
    FLAGGED+=("source-path:$p — missing, verify source repo structure")
  fi
done

if [[ -f "$SOURCE_REGISTRY" ]]; then
  mkdir -p config docs/reference/commands
  cp "$SOURCE_REGISTRY" config/command-registry.source.json
  ok "Copied canonical command registry to config/command-registry.source.json"
else
  warn "Missing canonical source registry: $SOURCE_REGISTRY"
  FLAGGED+=("registry:missing — $SOURCE_REGISTRY not found")
fi

if ! grep -q "^../$SOURCE_DIR/" .gitignore 2>/dev/null; then
  {
    echo ""
    echo "# Read-only source repo sibling"
    echo "../$SOURCE_DIR/"
  } >> .gitignore
  ok "Added ../$SOURCE_DIR/ to .gitignore"
fi

step "Step 3 — Install 6 Claude Code Plugins (best-effort)"

PLUGINS=(
  "obra/superpowers"
  "anthropic/frontend-design"
  "anthropic/code-review"
  "anthropic/security-guidance"
  "nicholasgasior/claude-mem"
  "garrytan/gstack"
)

for plugin in "${PLUGINS[@]}"; do
  log "Attempting plugin install: $plugin"
  if claude /plugin install "$plugin" 2>/dev/null; then
    ok "Installed: $plugin"
  else
    warn "Automatic install failed for $plugin"
    FLAGGED+=("plugin:$plugin — verify manually inside Claude Code with /plugins")
  fi
done

step "Step 4 — Design Stack (UI/UX Pro Max, 21st.dev Magic, Motion)"

if [[ -f ".env.local" ]]; then
  set -a
  # shellcheck disable=SC1091
  source .env.local
  set +a
  ok "Loaded env vars from .env.local"
else
  warn ".env.local not found yet — key-based installs may be skipped"
fi

# 4.1 UI/UX Pro Max
log "Installing UI/UX Pro Max (CLI path preferred)..."
if npm install -g uipro-cli 2>/dev/null && command -v uipro >/dev/null 2>&1; then
  uipro init --ai claude || warn "uipro init failed — trying manual fallback"
fi

if [[ ! -f ".claude/skills/ui-ux-pro-max/SKILL.md" ]]; then
  log "CLI path did not produce the skill; using manual fallback..."
  git clone https://github.com/nextlevelbuilder/ui-ux-pro-max-skill.git /tmp/uiux 2>/dev/null || true
  mkdir -p .claude/skills
  if [[ -d "/tmp/uiux/.claude/skills/ui-ux-pro-max" ]]; then
    cp -R /tmp/uiux/.claude/skills/ui-ux-pro-max .claude/skills/
    ok "UI/UX Pro Max installed via manual path"
  else
    warn "UI/UX Pro Max manual fallback failed"
    FLAGGED+=("skill:ui-ux-pro-max — manual review needed")
  fi
  rm -rf /tmp/uiux
else
  ok "UI/UX Pro Max already installed"
fi

# 4.2 21st.dev Magic
log "Installing 21st.dev Magic..."
if [[ -z "${MAGIC_API_KEY:-}" ]]; then
  warn "MAGIC_API_KEY not set — skipping 21st.dev Magic install"
  SKIPPED+=("21st.dev Magic — set MAGIC_API_KEY in .env.local and re-run")
else
  if npx @21st-dev/cli@latest install claude --api-key "$MAGIC_API_KEY" 2>/dev/null; then
    ok "21st.dev Magic installed via official CLI"
  else
    warn "Official CLI path failed — falling back to direct MCP registration"
    claude mcp add --scope project --transport stdio @21st-dev/magic \
      --env "API_KEY=$MAGIC_API_KEY" \
      -- npx -y @21st-dev/magic@latest \
      || FLAGGED+=("mcp:@21st-dev/magic — direct MCP registration also failed")
  fi
fi

# 4.3 Motion
log "Installing Motion (package + Motion Studio MCP)..."
if [[ -f "package.json" ]]; then
  $PKG_MGR add motion
  ok "Motion package installed"
else
  warn "No package.json yet — motion will be installed during scaffold/build phase"
fi

log "Registering Motion Studio MCP..."
claude mcp add-json --scope project motion '{
  "type": "stdio",
  "command": "npx",
  "args": ["-y", "https://api.motion.dev/registry.tgz?package=motion-studio-mcp&version=latest"]
}' 2>/dev/null && ok "Motion Studio MCP registered" || FLAGGED+=("mcp:motion — registration failed, verify manually")

SKIPPED+=("Motion+ AI Kit — skipped per PRD §14 item 14 (not active)")

step "Step 5 — Optional Community Skills"

mkdir -p .claude/skills docs

# 5.1 emilkowalski — local source only
log "Handling emilkowalski/skill (local-source-only posture)..."
if [[ -d "community-skills/emilkowalski" ]]; then
  cp -R "community-skills/emilkowalski" docs/community-skills-reviewed-emilkowalski
  FLAGGED+=("skill:emilkowalski — local source staged for manual review before activation")
  ok "Staged local emilkowalski skill for manual review"
else
  SKIPPED+=("emilkowalski/skill — local source not provided; skipped")
fi

# 5.2 pbakaus/impeccable
log "Installing pbakaus/impeccable..."
git clone https://github.com/pbakaus/impeccable.git /tmp/impeccable 2>/dev/null || true
if [[ -d "/tmp/impeccable/.claude/skills/impeccable" ]]; then
  cp -R /tmp/impeccable/.claude/skills/impeccable .claude/skills/
  ok "pbakaus/impeccable installed"
elif [[ -d "/tmp/impeccable" ]]; then
  cp -R /tmp/impeccable docs/community-skills-reviewed-impeccable
  FLAGGED+=("skill:impeccable — non-standard repo structure, staged for review")
else
  FLAGGED+=("skill:impeccable — clone failed, verify manually")
fi
rm -rf /tmp/impeccable

# 5.3 Leonxlnx/taste-skill — always staged for review
log "Reviewing Leonxlnx/taste-skill..."
git clone https://github.com/Leonxlnx/taste-skill.git /tmp/taste 2>/dev/null || true
if [[ -d "/tmp/taste" ]]; then
  cp -R /tmp/taste docs/community-skills-reviewed-taste
  FLAGGED+=("skill:taste-skill — staged for manual verify before activation")
  ok "Taste skill staged for review"
else
  FLAGGED+=("skill:taste-skill — clone failed, verify manually")
fi
rm -rf /tmp/taste

step "Step 6 — .claude/ Scaffold"

mkdir -p .claude/agents .claude/skills/motion-workflow .claude/commands

if [[ ! -f ".claude/agents/motion-specialist.md" ]]; then
  cat > .claude/agents/motion-specialist.md <<'EOF'
---
name: motion-specialist
description: Expert Motion for React implementation agent.
tools: Read, Edit, MultiEdit, Write, Glob, Grep, Bash
model: inherit
---
You are the Motion specialist for this codebase.

Rules:
- Always import from "motion/react" or "motion/react-client". Never "framer-motion".
- Preserve the ACISS design system and existing component APIs.
- Favor transform/opacity animation when possible.
- Honor prefers-reduced-motion.
- If CSS alone is sufficient, say so.
- Explain changes, reasons, tradeoffs, and performance impact.
EOF
  ok "Created .claude/agents/motion-specialist.md"
fi

if [[ ! -f ".claude/skills/motion-workflow/SKILL.md" ]]; then
  cat > .claude/skills/motion-workflow/SKILL.md <<'EOF'
# Motion workflow

Use this skill when the task involves Motion for React animation design, migration, refactoring, or debugging.

Checklist:
1. Confirm framework context.
2. Confirm correct import path.
3. Select the right Motion primitive.
4. Prefer reusable motion wrappers.
5. Preserve accessibility.
6. Summarize files changed, animation pattern used, and performance notes.
EOF
  ok "Created .claude/skills/motion-workflow/SKILL.md"
fi

if [[ ! -f "CLAUDE.md" ]]; then
  touch CLAUDE.md
fi

if ! grep -q "## Router Doctrine" CLAUDE.md; then
  cat >> CLAUDE.md <<'EOF'

## Router Doctrine

AUTO::DETECT+ROUTE — silently classify the message and route to the right command, skill, doctrine, or workflow layer.

AGM — when the user explicitly invokes AGM, rewrite the task into an approval-first engineered prompt and wait for approval before execution.

SALES13 — apply persuasion doctrine on offer, launch, brand, copy, pricing, and conversion work.

PROMPTLIB::ROUTE — if a task matches a stored workflow or prompt asset, route to it explicitly.

## Motion rules for this repo
- Use Motion for React from "motion/react" or "motion/react-client".
- Never use "framer-motion".
- Motion+ / Motion AI Kit are not active for this project.
- Use motion-specialist + motion-workflow + Motion Studio MCP instead of /motion slash commands.
EOF
  ok "Added Router Doctrine + Motion rules to CLAUDE.md"
fi

step "Step 7 — .env.local"

if [[ ! -f ".env.local" ]]; then
  if [[ -f ".env.example" ]]; then
    cp .env.example .env.local
    ok "Copied .env.example -> .env.local"
  else
    FLAGGED+=(".env.example missing — create from PRD §9")
    warn ".env.example not found"
  fi
else
  ok ".env.local already exists"
fi

if ! grep -q "^.env.local$" .gitignore 2>/dev/null; then
  echo ".env.local" >> .gitignore
  ok "Added .env.local to .gitignore"
fi

step "Step 8 — Verification"

log "Checking for framer-motion contamination..."
if grep -R "framer-motion" . --include="*.ts" --include="*.tsx" --include="*.js" --include="*.jsx" --include="*.json" --include="package.json" 2>/dev/null; then
  FLAGGED+=("framer-motion:found — banned string present, must migrate to motion/react")
  err "framer-motion found in codebase"
else
  ok "No framer-motion references in checked source files"
fi

log "Checking registered MCPs..."
claude mcp list 2>/dev/null || warn "claude mcp list failed — verify manually"

log "Checking normalized command-registry artifacts..."
for f in \
  config/command-registry.source.json
do
  if [[ -f "$f" ]]; then
    ok "Present: $f"
  else
    warn "Missing: $f"
    FLAGGED+=("file:$f — missing")
  fi
done

log "Checking .claude/ structure..."
for f in \
  .claude/agents/motion-specialist.md \
  .claude/skills/motion-workflow/SKILL.md \
  .claude/skills/ui-ux-pro-max/SKILL.md \
  CLAUDE.md
do
  if [[ -f "$f" ]]; then
    ok "Present: $f"
  else
    warn "Missing: $f"
    FLAGGED+=("file:$f — missing")
  fi
done

warn "Inside Claude Code, manually run /plugins, /mcp, and /skills for final confirmation"

step "Step 9 — Final Report"

echo -e "\n${BOLD}Setup complete.${NC}\n"

if [[ ${#SKIPPED[@]} -gt 0 ]]; then
  echo -e "${YELLOW}Skipped (expected):${NC}"
  for item in "${SKIPPED[@]}"; do echo "  - $item"; done
  echo ""
fi

if [[ ${#FLAGGED[@]} -gt 0 ]]; then
  echo -e "${YELLOW}Flagged for manual review:${NC}"
  for item in "${FLAGGED[@]}"; do echo "  - $item"; done
  echo ""
fi

cat <<'EOF'
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
NEXT STEPS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

1. Populate .env.local with your API keys from .env.example

2. Confirm normalized source inputs:
   - ../Last/Final edits/final/
   - ../Last/Final edits/OEBPS/
   - ../Last/Final edits/Claude-code/chatgpt_command_registry_v1.json
   - config/command-registry.source.json

3. If you want supplementary command PDFs included in the repo system,
   place them under:
   docs/reference/commands/
   They are supplementary only and never override the JSON registry.

4. Open Claude Code in this directory:
   claude

5. Inside Claude Code, run:
   /plugins
   /mcp
   /skills

6. Review staged community skills in docs/:
   docs/community-skills-reviewed-emilkowalski/
   docs/community-skills-reviewed-impeccable/
   docs/community-skills-reviewed-taste/

7. Paste install-prompt.md first. After install readiness is green,
   paste kickoff-prompt-v2-2.md in a fresh session.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
