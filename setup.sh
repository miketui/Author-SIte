#!/usr/bin/env bash
# ============================================================
# michaeldavidjr.beauty — Bootstrap Setup Script
# Version: 2.2 (aligned to PRD v2.2)
# ============================================================
# Runs PRD v2.2 Phases 0-2: repo clone, Claude Code install,
# 6 plugins, 3 design tools, MCP registration, .claude/ scaffolds,
# community skill review gates, command registry normalization,
# and verification.
#
# Canonical command registry:
#   ../book-source/Final edits/Claude-code/chatgpt_command_registry_v1.json
#   → copied into: config/command-registry.source.json (frozen snapshot)
# Supplementary PDFs (optional, manual):
#   docs/reference/commands/
#
# Usage:
#   1. Have your API keys ready (see .env.example)
#   2. chmod +x setup.sh
#   3. ./setup.sh
#
# Re-runs are safe. Steps are idempotent.
# ============================================================

set -euo pipefail

# ────────────────────────────────────────────────────────────
# CONFIG
# ────────────────────────────────────────────────────────────

DEST_REPO="https://github.com/miketui/Author-SIte.git"
SOURCE_REPO="https://github.com/miketui/Last.git"
DEST_DIR="Author-SIte"
SOURCE_DIR="book-source"

# Colors for readable output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m' # No Color

log()   { echo -e "${BLUE}[setup]${NC} $*"; }
ok()    { echo -e "${GREEN}[ok]${NC}    $*"; }
warn()  { echo -e "${YELLOW}[warn]${NC}  $*"; }
err()   { echo -e "${RED}[err]${NC}   $*" >&2; }
step()  { echo -e "\n${BOLD}${BLUE}━━━ $* ━━━${NC}\n"; }

# Track what we skipped or flagged
declare -a SKIPPED=()
declare -a FLAGGED=()

# ────────────────────────────────────────────────────────────
# STEP 0 — PREREQUISITES
# ────────────────────────────────────────────────────────────

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

# pnpm is preferred; npm is the fallback
if command -v pnpm >/dev/null 2>&1; then
  PKG_MGR="pnpm"
  ok "Found: pnpm (preferred)"
else
  warn "pnpm not found. Installing globally..."
  npm install -g pnpm
  PKG_MGR="pnpm"
fi

# Node version gate — Motion requires React 18.2+, which needs Node 18+
NODE_MAJOR=$(node -v | sed 's/v//;s/\..*//')
if [[ "$NODE_MAJOR" -lt 18 ]]; then
  err "Node.js 18+ required (found $(node -v)). Upgrade and re-run."
  exit 1
fi
ok "Node version OK: $(node -v)"

# ────────────────────────────────────────────────────────────
# STEP 1 — CLAUDE CODE INSTALL
# ────────────────────────────────────────────────────────────

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
ln -sf "../book-source/Final edits" "./Final edits"# ────────────────────────────────────────────────────────────
# STEP 2 — REPO CLONE (DESTINATION + SOURCE) + REGISTRY NORMALIZE
# ────────────────────────────────────────────────────────────

step "Step 2 — Clone Repos"

# Destination repo (read-write) — this is where we commit code
if [[ -d "$DEST_DIR/.git" ]]; then
  ok "Destination repo already cloned: $DEST_DIR/"
else
  log "Cloning destination repo: $DEST_REPO"
  git clone "$DEST_REPO" "$DEST_DIR"
fi

# Source repo (read-only) — cloned as sibling to DEST, gitignored
if [[ -d "$SOURCE_DIR/.git" ]]; then
  ok "Source repo already cloned: $SOURCE_DIR/"
else
  log "Cloning source repo: $SOURCE_REPO"
  git clone "$SOURCE_REPO" "$SOURCE_DIR"
fi

# Make sure source repo is never accidentally committed from destination
cd "$DEST_DIR"

# Canonical normalized source paths
SOURCE_ROOT="../$SOURCE_DIR/Final edits"
SOURCE_FINAL="$SOURCE_ROOT/final"
SOURCE_OEBPS="$SOURCE_ROOT/OEBPS"
SOURCE_COMMANDS="$SOURCE_ROOT/Claude-code"
SOURCE_REGISTRY="$SOURCE_COMMANDS/chatgpt_command_registry_v1.json"

log "Verifying canonical source paths..."
for p in "$SOURCE_ROOT" "$SOURCE_FINAL" "$SOURCE_COMMANDS"; do
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

# Supplementary PDFs are not required at runtime.
# If Michael wants them normalized into the repo, place them manually under:
#   docs/reference/commands/
# They are supplementary only and must never override config/command-registry.source.json.

if ! grep -q "^../$SOURCE_DIR/" .gitignore 2>/dev/null; then
  echo "" >> .gitignore
  echo "# Book source repo (read-only sibling)" >> .gitignore
  echo "../$SOURCE_DIR/" >> .gitignore
  ok "Added ../$SOURCE_DIR/ to .gitignore"
fi

# ────────────────────────────────────────────────────────────
# STEP 3 — INSTALL 6 CLAUDE CODE PLUGINS
# ────────────────────────────────────────────────────────────

step "Step 3 — Install 6 Claude Code Plugins"

PLUGINS=(
  "obra/superpowers"
  "anthropic/frontend-design"
  "anthropic/code-review"
  "anthropic/security-guidance"
  "nicholasgasior/claude-mem"
  "garrytan/gstack"
)

for plugin in "${PLUGINS[@]}"; do
  log "Installing plugin: $plugin"
  if claude /plugin install "$plugin" 2>/dev/null; then
    ok "Installed: $plugin"
  else
    warn "Plugin install command failed for $plugin — may need manual install"
    FLAGGED+=("plugin:$plugin — install command failed, verify manually inside Claude Code with /plugins")
  fi
done

# ────────────────────────────────────────────────────────────
# STEP 4 — DESIGN STACK (3 TOOLS, DIRECT INSTALLS)
# ────────────────────────────────────────────────────────────

step "Step 4 — Design Stack (UI/UX Pro Max, 21st.dev Magic, Motion)"

# Load environment variables if .env.local exists at this point
if [[ -f ".env.local" ]]; then
  set -a
  source .env.local
  set +a
  ok "Loaded env vars from .env.local"
else
  warn ".env.local not found yet — some installs may prompt for keys"
fi

# ── 4.1 UI/UX Pro Max ──
log "Installing UI/UX Pro Max (CLI path preferred)..."
if npm install -g uipro-cli 2>/dev/null && command -v uipro >/dev/null 2>&1; then
  uipro init --ai claude || warn "uipro init failed — falling back to manual install"
fi

if [[ ! -f ".claude/skills/ui-ux-pro-max/SKILL.md" ]]; then
  log "CLI path did not produce the skill; using manual git clone fallback..."
  git clone https://github.com/nextlevelbuilder/ui-ux-pro-max-skill.git /tmp/uiux 2>/dev/null || true
  mkdir -p .claude/skills
  if [[ -d "/tmp/uiux/.claude/skills/ui-ux-pro-max" ]]; then
    cp -R /tmp/uiux/.claude/skills/ui-ux-pro-max .claude/skills/
    ok "UI/UX Pro Max installed via manual path"
  else
    err "UI/UX Pro Max manual path also failed — check repo structure"
    FLAGGED+=("skill:ui-ux-pro-max — manual review needed")
  fi
  rm -rf /tmp/uiux
else
  ok "UI/UX Pro Max already installed"
fi

# ── 4.2 21st.dev Magic ──
log "Installing 21st.dev Magic..."
if [[ -z "${MAGIC_API_KEY:-}" ]]; then
  warn "MAGIC_API_KEY not set — skipping 21st.dev Magic install"
  SKIPPED+=("21st.dev Magic — set MAGIC_API_KEY in .env.local and re-run")
else
  # Try official CLI path first
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

# ── 4.3 Motion + Motion Studio MCP ──
log "Installing Motion (package + Motion Studio MCP)..."

# Package install — motion (not framer-motion)
if [[ -f "package.json" ]]; then
  $PKG_MGR add motion
  ok "Motion package installed"
else
  warn "No package.json yet — will install motion during Phase 3 stack scaffold"
fi

# Register Motion Studio MCP at project scope
log "Registering Motion Studio MCP..."
claude mcp add-json --scope project motion '{
  "type": "stdio",
  "command": "npx",
  "args": ["-y", "https://api.motion.dev/registry.tgz?package=motion-studio-mcp&version=latest"]
}' 2>/dev/null && ok "Motion Studio MCP registered" || FLAGGED+=("mcp:motion — register failed, check .mcp.json manually")

# Motion+ skipped per PRD v2.2 §14 item 14
SKIPPED+=("Motion+ AI Kit — skipped per PRD §14 item 14 (no Motion+ subscription)")

# ────────────────────────────────────────────────────────────
# STEP 5 — OPTIONAL COMMUNITY SKILLS (PRD §8.5 Rule 3)
# ────────────────────────────────────────────────────────────

step "Step 5 — Optional Community Skills"

mkdir -p .claude/skills docs

# ── 5.1 emilkowalski/skill — Local source only, manual review ──
log "Reviewing emilkowalski/skill (local-source-only posture)..."
git clone https://github.com/emilkowalski/skill.git /tmp/emil-skill 2>/dev/null || true
if [[ -d "/tmp/emil-skill" ]]; then
  # Auto-check for framer-motion conflict
  if grep -r -q "framer-motion" /tmp/emil-skill 2>/dev/null; then
    warn "emilkowalski/skill references framer-motion — documenting only, not installing"
    cp -R /tmp/emil-skill docs/community-skills-reviewed-emilkowalski
    FLAGGED+=("skill:emilkowalski — framer-motion conflict, documented in docs/community-skills-reviewed-emilkowalski/")
  else
    log "No framer-motion conflict detected. Manual review recommended before activation."
    cp -R /tmp/emil-skill docs/community-skills-reviewed-emilkowalski
    FLAGGED+=("skill:emilkowalski — staged in docs/ for manual review before activation")
  fi
  rm -rf /tmp/emil-skill
else
  warn "Could not clone emilkowalski/skill"
fi

# ── 5.2 pbakaus/impeccable — Install after one-pass review ──
log "Installing pbakaus/impeccable..."
git clone https://github.com/pbakaus/impeccable.git /tmp/impeccable 2>/dev/null || true
if [[ -d "/tmp/impeccable/.claude/skills/impeccable" ]]; then
  cp -R /tmp/impeccable/.claude/skills/impeccable .claude/skills/
  ok "pbakaus/impeccable installed"
elif [[ -d "/tmp/impeccable" ]]; then
  # Repo structure may differ — stage for review
  cp -R /tmp/impeccable docs/community-skills-reviewed-impeccable
  FLAGGED+=("skill:impeccable — non-standard repo structure, staged for review")
fi
rm -rf /tmp/impeccable

# ── 5.3 Leonxlnx/taste-skill — Source-verification gate ──
log "Reviewing Leonxlnx/taste-skill (verification gate)..."
git clone https://github.com/Leonxlnx/taste-skill.git /tmp/taste 2>/dev/null || true
if [[ -d "/tmp/taste" ]]; then
  # Always stage for manual review — do not auto-install
  cp -R /tmp/taste docs/community-skills-reviewed-taste
  FLAGGED+=("skill:taste-skill — staged in docs/community-skills-reviewed-taste/ — verify author + last commit before activating")
  rm -rf /tmp/taste
else
  warn "Could not clone Leonxlnx/taste-skill"
fi

# ────────────────────────────────────────────────────────────
# STEP 6 — .claude/ SCAFFOLD (router, subagent, skill)
# ────────────────────────────────────────────────────────────

step "Step 6 — .claude/ Scaffold"

mkdir -p .claude/agents .claude/skills/motion-workflow .claude/commands

# ── 6.1 motion-specialist subagent ──
if [[ ! -f ".claude/agents/motion-specialist.md" ]]; then
  cat > .claude/agents/motion-specialist.md <<'EOF'
---
name: motion-specialist
description: Expert Motion for React implementation agent. Use for animation architecture, refactors, debugging, layout animation, gestures, and scroll-driven interactions.
tools: Read, Edit, MultiEdit, Write, Glob, Grep, Bash
model: inherit
---
You are the Motion specialist for this codebase.

Rules:
- Always import from "motion/react" (never "framer-motion").
- Preserve existing design system and component API.
- Favor transform/opacity-based animation when possible.
- Keep animations accessible — honor prefers-reduced-motion.
- When changing behavior, explain what changed, why, and any tradeoffs.
- For Next.js App Router components, ensure client-component compatibility ("use client" or motion/react-client).
- When an effect is simple enough for CSS alone, say so instead of forcing Motion.
- Consult Motion Studio MCP for current docs + 330+ example patterns before writing new animation code.
EOF
  ok "Created .claude/agents/motion-specialist.md"
else
  ok ".claude/agents/motion-specialist.md already exists"
fi

# ── 6.2 motion-workflow skill ──
if [[ ! -f ".claude/skills/motion-workflow/SKILL.md" ]]; then
  cat > .claude/skills/motion-workflow/SKILL.md <<'EOF'
# Motion workflow

Use this skill when the task involves Motion for React animation design, refactoring, migration, or debugging.

Checklist:
1. Identify framework context: Vite, Next.js Pages Router, or App Router.
2. Confirm correct import path ("motion/react" or "motion/react-client").
3. Check if the task should use:
   - animate / initial / exit
   - whileHover / whileTap / drag
   - whileInView / useScroll
   - layout / layoutId
4. Prefer small reusable motion wrappers over repetitive inline animation objects.
5. Preserve accessibility and avoid unnecessary layout thrash.
6. After changes, summarize:
   - files changed
   - animation pattern used
   - performance considerations
   - testing notes
EOF
  ok "Created .claude/skills/motion-workflow/SKILL.md"
else
  ok ".claude/skills/motion-workflow/SKILL.md already exists"
fi

# ── 6.3 CLAUDE.md router doctrine block ──
if [[ ! -f "CLAUDE.md" ]]; then
  touch CLAUDE.md
fi

if ! grep -q "## Router Doctrine" CLAUDE.md; then
  cat >> CLAUDE.md <<'EOF'

## Router Doctrine (project-scoped, always-on)

AUTO::DETECT+ROUTE — silently classify every message and route to the appropriate skill/tool/command. Announce the route in one line before responding.

AGM (Activate Genius Mode) — when user types "AGM" or "Activate Genius Mode", apply the Engineer's Template: rewrite raw input into a structured prompt with SYSTEM CONTEXT, CHAIN-OF-THOUGHT REQUIREMENT, OUTPUT FORMAT, CALIBRATION EXAMPLE, TASK, SECURITY NOTE. Present under "ENGINEERED PROMPT — AWAITING APPROVAL" and wait for "go" before executing.

SALES13 — on any offer/launch/pitch/copy/brand task, apply the 13-point persuasion doctrine silently: emotion first, transformation over features, risk reduction, social proof restraint, composed pricing, trust protection.

PROMPTLIB::ROUTE — if a task matches a workflow in Michael's prompt library (book-launch, marketing-assets, cover-design-brief, etc.), invoke that workflow's skill explicitly and cite the match in one line.

## Command registry sources

- Canonical: config/command-registry.source.json (frozen copy of ../book-source/Final edits/Claude-code/chatgpt_command_registry_v1.json)
- Supplementary (optional, never overriding): docs/reference/commands/
- Migration plan: docs/command-migration.md
- Human-readable catalog: docs/command-catalog.md

## Motion rules for this repo
- Use Motion for React from "motion/react". Never "framer-motion".
- For Next.js App Router, keep Motion usage in client-compatible files.
- Prefer reusable variants and shared transition objects for repeated patterns.
- Use layout/layoutId only when the UI genuinely benefits from shared layout animation.
- Keep default animation durations restrained unless the design clearly calls for theatrical motion.
- Honor prefers-reduced-motion with the useReducedMotion hook.
- Do NOT use /motion slash commands. Motion+ is not active. Route animation work through the motion-specialist subagent + motion-workflow skill + Motion Studio MCP doc lookup.
EOF
  ok "Added Router Doctrine + Motion rules + Command registry sources to CLAUDE.md"
else
  ok "CLAUDE.md already has Router Doctrine block"
fi

# ────────────────────────────────────────────────────────────
# STEP 7 — .env.local BOOTSTRAP
# ────────────────────────────────────────────────────────────

step "Step 7 — .env.local"

if [[ ! -f ".env.local" ]]; then
  if [[ -f ".env.example" ]]; then
    cp .env.example .env.local
    ok "Copied .env.example → .env.local (populate your keys now)"
  else
    warn ".env.example not found — create one per PRD §9.13"
    FLAGGED+=(".env.example missing — copy from PRD §9.13")
  fi
else
  ok ".env.local already exists"
fi

# Ensure .env.local is gitignored
if ! grep -q "^.env.local$" .gitignore 2>/dev/null; then
  echo ".env.local" >> .gitignore
  ok "Added .env.local to .gitignore"
fi

# ────────────────────────────────────────────────────────────
# STEP 8 — VERIFICATION
# ────────────────────────────────────────────────────────────

step "Step 8 — Verification"

log "Checking for framer-motion contamination..."
if grep -R "framer-motion" . --include="*.ts" --include="*.tsx" --include="*.js" --include="*.jsx" --include="package.json" 2>/dev/null; then
  err "framer-motion found in codebase — must be removed before build"
  FLAGGED+=("framer-motion:found — ban violation, must migrate to motion/react")
else
  ok "No framer-motion references in source code"
fi

log "Checking registered MCPs..."
if command -v claude >/dev/null 2>&1; then
  claude mcp list 2>/dev/null || warn "claude mcp list failed — verify manually"
fi

log "Checking installed plugins..."
# Note: /plugins command runs inside Claude Code, not bash. Document manual step.
warn "Open Claude Code and run: /plugins — verify all 6 plugins are listed"

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
  CLAUDE.md \
  .mcp.json
do
  if [[ -f "$f" || -d "$f" ]]; then
    ok "Present: $f"
  else
    warn "Missing: $f"
    FLAGGED+=("file:$f — missing")
  fi
done

# ────────────────────────────────────────────────────────────
# STEP 9 — REPORT
# ────────────────────────────────────────────────────────────

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

1. Populate .env.local with your API keys (see .env.example)
   — Stripe test keys, Resend key, MailerLite key, Turnstile keys,
   — Sentry DSN, GA4 ID, MAGIC_API_KEY, UIUX_PRO_MAX_KEY

2. Confirm normalized source inputs:
   - ../book-source/Final edits/final/
   - ../book-source/Final edits/OEBPS/
   - ../book-source/Final edits/Claude-code/chatgpt_command_registry_v1.json
   - config/command-registry.source.json

3. If you want the uploaded command PDFs included in the repo system,
   manually place them under:
   docs/reference/commands/
   They are supplementary only and never override the JSON registry.

4. Open Claude Code in this directory:
   claude

5. Inside Claude Code, run:
   /plugins              # verify all 6 plugins listed
   /mcp                  # verify motion + @21st-dev/magic listed
   /skills               # verify ui-ux-pro-max, motion-workflow listed

6. Review staged community skills in docs/:
   docs/community-skills-reviewed-emilkowalski/
   docs/community-skills-reviewed-impeccable/
   docs/community-skills-reviewed-taste/

7. Paste the install prompt first (Install-Prompt.md). After install
   readiness is green, paste the build kickoff prompt
   (Claude-Code-Kickoff-Prompt.md) in a fresh session.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
