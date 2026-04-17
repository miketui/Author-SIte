# Claude Code Install Prompt — michaeldavidjr.beauty

**Version:** 2.2 (aligned to PRD v2.2)

**Purpose:** This prompt is what you paste into a **fresh Claude Code session** to run the environment setup (Phases 0-2 of PRD v2.2). It is distinct from the build kickoff prompt. The install prompt puts the tools in place and normalizes the command registry. The kickoff prompt builds the site.

**Order of operations:**
1. Clone the destination repo locally (or let Claude Code do it)
2. Open Claude Code inside the repo
3. Paste the prompt below as your first message
4. Answer any judgment-call questions Claude Code asks
5. Once it reports "Setup complete — ready for build," open a fresh session and paste the kickoff prompt

---

## THE PROMPT (paste everything between the fences)

````text
<role>
You are a senior infrastructure engineer setting up the build environment for michaeldavidjr.beauty per PRD v2.2. You will execute the bootstrap setup, normalize the command registry into one canonical system, make judgment calls on community skills, collect missing configuration, and report readiness. You will not write application code in this session — that happens in a separate build session after setup is green.
</role>

<inputs>
You should find in the current directory:
- `PRD-v2.md` — the full spec (read §0, §0.5, §2.6, §8, §8.5, §9, §14 first — setup-critical sections)
- `setup.sh` — the executable bootstrap script
- `.env.example` — the full environment variable list
- `Nathaniel-3D-Book-Brief.md` — 3D artist brief (not part of install — reference only)
- optional: `docs/reference/commands/` — supplementary command-reference PDFs or docs if Michael has copied them into the destination repo

After `setup.sh` runs successfully, you should also expect:
- `config/command-registry.source.json` — frozen copy of the canonical source JSON registry
- sibling source repo path: `../book-source/Final edits/`

If any required file is missing, stop and tell the user which one.
</inputs>

<non_negotiable_rules>
1. **Do not install `framer-motion`.** If setup.sh ever reports `framer-motion` contamination, stop and report — do not proceed.
2. **Do not install `website-builder-setup`.** It conflicts with the Motion policy. The three design tools install directly per PRD Phase 2.
3. **Do not activate any community skill without review.** `emilkowalski/skill`, `pbakaus/impeccable`, `Leonxlnx/taste-skill` are staged in `docs/community-skills-reviewed-*/` by setup.sh. You review each one with the user before activation.
4. **Do not populate secrets into files Claude Code can see.** API keys go into `.env.local` which is gitignored. Never echo a full secret key back to the user — only confirm presence/absence.
5. **Do not skip `claude doctor` or the verification step.** Both must run. Report output.
6. **Do not treat any PDF as canonical.** The canonical command source is `config/command-registry.source.json` (frozen from `../book-source/Final edits/Claude-code/chatgpt_command_registry_v1.json`). PDFs in `docs/reference/commands/` are supplementary only and never override the JSON.
</non_negotiable_rules>

<execution_plan>

## Step 1 — Read the PRD setup-critical sections
Read these in order: §0 (Executive Summary), §0.5 (Two-Repo Architecture), §2.6 (Command Registry Audit Input), §8 Phase 0-2 (Install sequence), §8.5 (Skills/Commands/MCP Policy), §9 (API Keys), §14 (Risks/CONFIRM items). Confirm you understand the two-repo model, the canonical source paths under `../book-source/Final edits/{OEBPS,final,Claude-code}/`, the JSON-canonical / PDF-supplementary command registry policy, the Motion policy, and the community skill review gates.

## Step 2 — Run setup.sh
Execute `./setup.sh`. The script is idempotent and safe to re-run. Do not edit it mid-run. Capture and summarize:
- Which plugins installed successfully
- Which MCPs registered
- Which community skills were staged vs. auto-installed
- Whether `config/command-registry.source.json` was created
- Whether `../book-source/Final edits/{OEBPS,final,Claude-code}/` were all found
- Everything in the SKIPPED and FLAGGED arrays at the end

## Step 3 — Collect missing API keys
Check `.env.local` for missing values. For each, ask the user in this order:
1. **MAGIC_API_KEY** (21st.dev) — "Owned" per PRD §9.0. Ask for the key.
2. **UIUX_PRO_MAX_KEY** — "Owned" per PRD §9.0. Ask for the key.
3. **MAILERLITE_API_KEY** — "Owned" per PRD §9.0. Guide Michael through MailerLite → Integrations → Developer API → Generate token if needed.
4. **STRIPE_SECRET_KEY + STRIPE_PUBLISHABLE_KEY** — use TEST keys for now (sk_test_, pk_test_). Walk through the signup path in PRD §9.1 if needed.
5. **RESEND_API_KEY + domain verification** — flag that domain verification DNS changes take 4-24 hours to propagate. Recommend starting this one first if not done.
6. **NEXT_PUBLIC_TURNSTILE_SITE_KEY + TURNSTILE_SECRET_KEY** — Cloudflare (free).
7. **Generated secrets** (`ADMIN_PASSWORD`, `ADMIN_API_KEY`, `CRON_SECRET`) — run `openssl rand -hex 32` three times and insert the values.

Do NOT print the keys back. Just confirm "MAGIC_API_KEY: set / not set".

## Step 4 — Community skill reviews (judgment calls)
For each staged directory under `docs/community-skills-reviewed-*/`:

**4a. `emilkowalski/skill`** — Read its SKILL.md. Check for:
- Any `framer-motion` reference → if present, do NOT activate. Leave in docs/ as reference only.
- Any conflicting rules against Motion for React patterns → if present, do NOT activate.
- If clean → ask the user: "emilkowalski/skill appears clean — activate by moving into `.claude/skills/`? (y/n)"

**4b. `pbakaus/impeccable`** — If auto-installed by setup.sh, verify presence in `.claude/skills/impeccable/`. If staged instead (non-standard repo structure), read and ask the user: "Activate impeccable? (y/n)"

**4c. `Leonxlnx/taste-skill`** — Always staged. Read:
- Repo owner's GitHub profile (last activity, other repos)
- Last commit date on taste-skill (dormant repos = flag)
- Full content of SKILL.md
- Any dependencies it declares
Report your finding and ask: "Taste-skill verification: [your assessment]. Activate? (y/n)"

## Step 5 — Command registry normalization dry run

Primary canonical source:
- `config/command-registry.source.json`

Fallback source if the normalized copy is missing:
- `../book-source/Final edits/Claude-code/chatgpt_command_registry_v1.json`

Supplementary references:
- any PDFs or docs under `docs/reference/commands/` if present

Rules:
- The JSON registry is canonical
- Supplementary PDFs may clarify wording or intent but never override the JSON
- Do not install any command-registry item yet in this install session
- This step produces the normalized plan only

Tasks:
1. Read `config/command-registry.source.json` if present; otherwise read the source JSON from `../book-source/Final edits/Claude-code/chatgpt_command_registry_v1.json`
2. If `docs/reference/commands/` exists, read those references as secondary material only
3. Produce:
   - `docs/command-migration.md`
   - `docs/command-catalog.md`
4. Classify every registry entry into:
   - Bucket A = install as project skill or legacy command
   - Bucket B = codify in `CLAUDE.md` router doctrine
   - Bucket C = document-only tokens
5. If any supplementary PDF conflicts with the JSON registry, report the conflict and keep the JSON as source-of-truth

This is a normalization plan only. Do not activate the migrated command set yet.

## Step 6 — Verification pass

Run each of these and report:

```bash
# Tool layer
claude --version
claude doctor
claude mcp list
node -v
pnpm -v

# Project structure
ls -la .claude/agents .claude/skills
ls CLAUDE.md .mcp.json .env.local
grep -c "Router Doctrine" CLAUDE.md
grep -R "framer-motion" . --include="*.ts" --include="*.tsx" --include="*.json" | head

# Registry normalization
ls config/command-registry.source.json
ls docs/command-migration.md docs/command-catalog.md 2>/dev/null || echo "migration docs not yet produced"

# Env
test -f .env.local && echo "env file present" || echo "env file MISSING"
```

Expected results:
- Claude Code version prints
- `claude doctor` clean or minor warnings only
- `claude mcp list` shows `motion` AND `@21st-dev/magic` (plus any system MCPs)
- `.claude/agents/motion-specialist.md` exists
- `.claude/skills/motion-workflow/SKILL.md` exists
- `.claude/skills/ui-ux-pro-max/SKILL.md` exists (from setup.sh Step 4.1)
- `CLAUDE.md` contains "Router Doctrine" section
- `.mcp.json` exists at repo root
- `.env.local` exists
- Zero `framer-motion` matches
- `config/command-registry.source.json` exists
- if command normalization ran, `docs/command-migration.md` exists
- if command normalization ran, `docs/command-catalog.md` exists

## Step 7 — Final readiness report

Produce a single, scannable report in this shape:

```
### INSTALL READINESS REPORT

✅ Green (ready)
- [list each item green]

⚠️ Yellow (works but flagged)
- [list each item yellow with what to watch]

❌ Red (blocking build)
- [list each item red with what must be fixed]

### API Keys Status
- [each key: set / not set]

### Community Skills Decisions
- emilkowalski: [activated / document-only / skipped because X]
- impeccable:   [activated / staged / skipped because X]
- taste-skill:  [activated / document-only / skipped because X]

### Command Registry Normalization
- Canonical source present (config/command-registry.source.json): [yes / no]
- Fallback source present (../book-source/Final edits/Claude-code/chatgpt_command_registry_v1.json): [yes / no]
- Supplementary PDFs present (docs/reference/commands/): [yes / no / list filenames]
- Plan written to docs/command-migration.md: [yes / no]
- Catalog written to docs/command-catalog.md: [yes / no]
- Bucket A (skills) count: N
- Bucket B (router directives) count: N
- Bucket C (reference tokens) count: N
- JSON-vs-PDF conflicts: [none / list]

### Ready for Build?
[YES / NO — with one-line reason]

### Next Action for Michael
[One sentence — paste the kickoff prompt, or fix the red item first, or populate the missing key]
```

Stop after this report. Do not proceed into Phase 3. The build happens in a separate session with the kickoff prompt.
</execution_plan>

<behavior_rules>
- Work silently through simple steps. Only surface to Michael for judgment calls (community skill activation) and missing secrets.
- Do not chain long bash commands silently — show what you're running and what the output says.
- If setup.sh fails on a step, stop and diagnose. Do not skip-and-continue on install failures.
- Do not propose fixes to the PRD during setup. If you see a PRD issue, flag it in the final report under "Yellow" but keep setting up.
- Keep output tight. No motivational language. No "let's" phrasing. Engineer-to-engineer.
</behavior_rules>

<start>
Begin with Step 1 (read the PRD setup-critical sections). Produce a one-paragraph comprehension check before running setup.sh, confirming the two-repo model, the canonical source paths, the JSON-canonical registry policy, the Motion policy, and the community skill review gates in your own words. Then wait for "go" before running setup.sh.
</start>
````

---

## What happens after you paste this prompt

1. **Claude Code reads the PRD** and confirms understanding in one paragraph.
2. **You reply "go"** → Claude Code runs `./setup.sh` and reports results.
3. **You answer key-collection questions** — have the API keys from `.env.example` ready.
4. **Claude Code asks for judgment calls** on the three community skills — answer y/n for each after it reports what it found.
5. **Command registry normalization plan produced** — `docs/command-migration.md` + `docs/command-catalog.md` written from `config/command-registry.source.json` (with PDFs as reference only if present).
6. **Verification pass runs** — 30 seconds.
7. **Final readiness report** — one screen, clear green/yellow/red.

When the report says "Ready for Build? YES," open a **fresh Claude Code session** (not the same one — fresh context) and paste `Claude-Code-Kickoff-Prompt.md`. That's when the actual site gets built.

---

## If something goes wrong

- **Plugin install fails:** Claude Code will flag it. Try manually: `git clone <plugin-repo> ~/.claude/plugins/<n>` then `/plugin reload` inside Claude Code.
- **MCP registration fails:** Check `~/.npmrc` and verify the registry is `https://registry.npmjs.org/`. Some corporate networks block `npx -y` auto-installs.
- **`framer-motion` found:** Setup will stop. It means something in your repo (maybe a leftover from an earlier scaffold) has the legacy import. Run `grep -R "framer-motion" .` yourself, remove every reference, and re-run setup.sh.
- **`.env.local` keys missing:** Setup continues but SKIPPED array lists them. Safe to populate later — the build kickoff prompt will halt if it hits a missing key at a required integration phase.
- **Canonical registry missing:** If `config/command-registry.source.json` is absent after setup.sh, verify `../book-source/Final edits/Claude-code/chatgpt_command_registry_v1.json` exists. If the source file is missing, the source repo clone is incomplete — re-clone.
- **PDF-vs-JSON conflict:** The JSON wins. Always. The supplementary PDF may clarify intent but never overrides a Bucket classification or command definition established from the JSON. Log the conflict in `docs/command-migration.md` under a "Reconciled conflicts" section.
