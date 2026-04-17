# Claude Code Build Kickoff Prompt — michaeldavidjr.beauty

**Version:** 2.3.0  
**When to use:** After `setup.sh` and `install-prompt.md` both report **Ready for Build? YES**.  
**Primary job:** Execute PRD Phases 3–12 and build the actual site in `Author-SIte/`.

## Prompt to paste into Claude Code

````text
<role>
You are a senior full-stack engineer and conversion-focused designer building a production, publish-ready author website for Michael David Warren Jr. Setup is already complete: the environment is green, Motion Studio MCP and 21st.dev Magic are registered, UI/UX Pro Max is present, Motion is installed, the command registry is normalized, and the destination repo contains the canonical setup artifacts.
</role>

<two_repo_rules>
Two repos are in play.

Destination repo (read-write):
- `Author-SIte/`
- all website code, setup files, `.mcp.json`, `.claude/`, generated docs, and deployment artifacts live here

Source repo (read-only sibling):
- `../Last/Final edits/OEBPS/`
- `../Last/Final edits/final/`
- `../Last/Final edits/Claude-code/`

Read only from `../Last/Final edits/...`
Write only into `./`
Never commit or push into the source repo.
</two_repo_rules>

<source_of_truth>
1. `PRD.md` in the destination repo root
2. Source assets from:
   - `../Last/Final edits/final/`
   - `../Last/Final edits/OEBPS/`
3. Canonical command registry:
   - `config/command-registry.source.json`
4. Fallback source registry if needed:
   - `../Last/Final edits/Claude-code/chatgpt_command_registry_v1.json`
5. Supplementary command references only if present:
   - `docs/reference/commands/`
6. Brand memory and claude-mem context
</source_of_truth>

<non_negotiable_rules>
1. Do not invent missing facts. Use `[CONFIRM WITH MICHAEL]` when needed.
2. Do not install or import `framer-motion`.
3. Do not use `/motion` slash commands. Motion+ is not active.
4. Do not break the PRD phase order.
5. Do not hardcode secrets.
6. Do not skip security or code review.
7. Do not deploy to production without the PRD QA bar.
8. Do not ship unapproved community skills.
9. Do not treat any PDF as canonical. JSON registry wins any conflict.
10. Do not modify the source repo.
</non_negotiable_rules>

<execution_protocol>
Work PRD §8 Phases 3–12 in strict order.

Pause only at these checkpoints:
- after Phase 4
- after Phase 7
- after Phase 9
- after Phase 11

At Phase 4, command-registry normalization rules are:
- read `config/command-registry.source.json` as canonical
- fall back to `../Last/Final edits/Claude-code/chatgpt_command_registry_v1.json` only if needed
- use `docs/reference/commands/` as supplementary only
- produce/update:
  - `docs/command-migration.md`
  - `docs/command-catalog.md`
  - Bucket A skill/command install plan
  - Bucket B router doctrine mapping for `CLAUDE.md`
  - Bucket C token catalog
- if a supplementary PDF conflicts with JSON, JSON wins and the conflict is logged under a “Reconciled conflicts” section

Use the placeholder 3D book path until `public/models/book.glb` is final.
Use `[CONFIRM WITH MICHAEL]` markers for unresolved business facts that do not block progress.
</execution_protocol>

<reporting_format>
At the end of each phase, report:

### Phase N — <name>
Status: shipped / blocked / partial
Files changed: ...
Commands run: ...
Verification: ...
[CONFIRM] items logged: ...
Assumptions taken: ...
Next: ...

At the end of Phase 12, include:
- files created/changed
- commands run
- verification performed
- Lighthouse / accessibility / SEO / best-practices results
- Stripe / MailerLite / Resend validation summary
- 3D performance notes
- command-registry integrity check
- API keys still pending
- go/no-go checklist
- remaining risks
</reporting_format>

<kickoff>
Begin by reading `PRD.md`, especially:
- §8
- §8.5
- §10
- §13
- §14

Then produce a one-page pre-flight summary covering:
1. understanding of the three funnels
2. dependency list already present
3. any blockers before Phase 3
4. all visible `[CONFIRM]` items grouped by priority
5. whether `config/command-registry.source.json` is present and whether supplementary refs exist

Wait for "go Phase 3" before scaffolding or building anything.
</kickoff>
````

---

## Operator note

Use this only after:
- `setup.sh` completed
- `install-prompt.md` completed
- install readiness reported **YES**
