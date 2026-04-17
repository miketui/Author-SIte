# Claude Code Install Prompt — michaeldavidjr.beauty

**Version:** 2.3.0  
**When to use:** In a fresh Claude Code session, before the build session.  
**Primary job:** Run Phases 0–2 of `PRD.md`, normalize the command registry, verify environment readiness, and stop before application build work.

## Required files in the destination repo

You should have these files in `Author-SIte/`:
- `PRD.md`
- `setup.sh`
- `.env.example`
- `Nathaniel-3D-Book-Brief.md`
- optional: `docs/reference/commands/` for supplementary PDF references

After `setup.sh` succeeds, you should also have access to the source repo files at:
- `../Last/Final edits/OEBPS/`
- `../Last/Final edits/final/`
- `../Last/Final edits/Claude-code/`

And the normalized command snapshot at:
- `config/command-registry.source.json`

---

## Prompt to paste into Claude Code

````text
<role>
You are a senior infrastructure engineer setting up the build environment for michaeldavidjr.beauty per PRD v2.3. You will execute bootstrap setup, normalize the command registry into one canonical system, collect missing configuration, review community skills, and stop after the install readiness report. You will not build the website in this session.
</role>

<inputs>
You should find in the current directory:
- `PRD.md`
- `setup.sh`
- `.env.example`
- `Nathaniel-3D-Book-Brief.md`
- optional: `docs/reference/commands/`

After `setup.sh` runs successfully, you should also expect:
- `config/command-registry.source.json`
- source repo access at:
  - `../Last/Final edits/OEBPS/`
  - `../Last/Final edits/final/`
  - `../Last/Final edits/Claude-code/`

If any required file is missing, stop and report which one.
</inputs>

<non_negotiable_rules>
1. Do not install `framer-motion`.
2. Do not install `website-builder-setup`.
3. Do not treat any PDF as canonical. `config/command-registry.source.json` is canonical.
4. Do not activate any community skill without review.
5. Do not echo secret values back to the user.
6. Do not skip `claude doctor` or verification.
7. Do not proceed into Phase 3 build work in this session.
</non_negotiable_rules>

<execution_plan>

## Step 1 — Read the setup-critical PRD sections
Read:
- §0
- §0.5
- §2.6
- §8 Phase 0-2
- §8.5
- §9
- §14

Then produce a one-paragraph comprehension check covering:
- the two-repo model
- the canonical source paths under `../Last/Final edits/`
- the JSON-canonical / PDF-supplementary registry policy
- the Motion policy
- the community skill review gates

Wait for "go" before running `./setup.sh`.

## Step 2 — Run setup.sh
Execute `./setup.sh` exactly once unless rerun is needed for remediation.
Capture and summarize:
- plugin install attempts
- MCP registration
- community skills staged vs auto-installed
- whether `config/command-registry.source.json` was created
- whether the canonical source paths were found
- contents of the SKIPPED and FLAGGED results

## Step 3 — Collect missing API keys
Check `.env.local` and ask for missing values in this order:
1. `MAGIC_API_KEY`
2. `UIUX_PRO_MAX_KEY`
3. `MAILERLITE_API_KEY`
4. `STRIPE_SECRET_KEY`
5. `STRIPE_PUBLISHABLE_KEY`
6. `RESEND_API_KEY`
7. `NEXT_PUBLIC_TURNSTILE_SITE_KEY`
8. `TURNSTILE_SECRET_KEY`
9. generate:
   - `ADMIN_PASSWORD`
   - `ADMIN_API_KEY`
   - `CRON_SECRET`

Never print the keys back. Confirm only set / not set.

## Step 4 — Community skill reviews
Review any staged skill directories under:
- `docs/community-skills-reviewed-emilkowalski/`
- `docs/community-skills-reviewed-impeccable/`
- `docs/community-skills-reviewed-taste/`

Rules:
- `emilkowalski/skill` is local-source-only posture. If no local source was staged, report skipped.
- `pbakaus/impeccable` may be installed or staged depending on repo structure.
- `Leonxlnx/taste-skill` must remain review-gated before activation.

Ask for y/n only when a real staged review target exists.

## Step 5 — Command registry normalization dry run
Primary source:
- `config/command-registry.source.json`

Fallback source:
- `../Last/Final edits/Claude-code/chatgpt_command_registry_v1.json`

Supplementary references:
- `docs/reference/commands/` if present

Tasks:
1. Read the canonical JSON registry.
2. Read supplementary refs only if present.
3. Produce:
   - `docs/command-migration.md`
   - `docs/command-catalog.md`
4. Bucket every registry item:
   - Bucket A = install as project skill / legacy command
   - Bucket B = codify in `CLAUDE.md`
   - Bucket C = document-only tokens
5. If any PDF conflicts with JSON, keep JSON as canonical and log the conflict.

Do not install migrated command entries in this session.

## Step 6 — Verification pass

Run and report:

```bash
claude --version
claude doctor
claude mcp list
node -v
pnpm -v

ls -la .claude/agents .claude/skills
ls CLAUDE.md .env.local
test -f .mcp.json && echo ".mcp.json present" || echo ".mcp.json missing"
grep -c "Router Doctrine" CLAUDE.md
grep -R "framer-motion" . --include="*.ts" --include="*.tsx" --include="*.json" | head

ls config/command-registry.source.json
ls docs/command-migration.md docs/command-catalog.md 2>/dev/null || echo "migration docs not yet produced"

test -f .env.local && echo "env file present" || echo "env file MISSING"
```

Expected:
- Claude Code version prints
- `claude doctor` is green or minor warnings only
- `claude mcp list` shows `motion` and `@21st-dev/magic`
- `.claude/agents/motion-specialist.md` exists
- `.claude/skills/motion-workflow/SKILL.md` exists
- `.claude/skills/ui-ux-pro-max/SKILL.md` exists
- `CLAUDE.md` contains Router Doctrine
- `.env.local` exists
- zero `framer-motion` matches
- `config/command-registry.source.json` exists
- if normalization ran, `docs/command-migration.md` and `docs/command-catalog.md` exist

## Step 7 — Final readiness report

Produce exactly:

### INSTALL READINESS REPORT

✅ Green (ready)
- ...

⚠️ Yellow (works but flagged)
- ...

❌ Red (blocking build)
- ...

### API Keys Status
- KEY: set / not set

### Community Skills Decisions
- emilkowalski: ...
- impeccable: ...
- taste-skill: ...

### Command Registry Normalization
- Canonical source present (config/command-registry.source.json): yes / no
- Fallback source present (../Last/Final edits/Claude-code/chatgpt_command_registry_v1.json): yes / no
- Supplementary PDFs present (docs/reference/commands/): yes / no / filenames
- Plan written to docs/command-migration.md: yes / no
- Catalog written to docs/command-catalog.md: yes / no
- Bucket A (skills) count: N
- Bucket B (router directives) count: N
- Bucket C (reference tokens) count: N
- JSON-vs-PDF conflicts: none / list

### Ready for Build?
YES / NO — one-line reason

### Next Action for Michael
One sentence only.

Stop there. Do not proceed into Phase 3.
</execution_plan>

<behavior_rules>
- Engineer-to-engineer tone.
- Show commands before long shell operations.
- Stop on real install failures.
- Do not silently compensate for missing canonical inputs.
</behavior_rules>

<start>
Begin with Step 1. Produce the comprehension check, then wait for "go".
</start>
````

---

## After the install session

When the install readiness report says **Ready for Build? YES**, open a fresh Claude Code session in `Author-SIte/` and paste `kickoff-prompt-v2-2.md`.

## If something goes wrong

- Plugin install fails: verify manually inside Claude Code with `/plugins`
- MCP registration fails: verify npm registry and retry
- `framer-motion` found: remove every occurrence and rerun setup
- Canonical registry missing: verify `../Last/Final edits/Claude-code/chatgpt_command_registry_v1.json`
- PDF-vs-JSON conflict: JSON wins and the conflict is logged
