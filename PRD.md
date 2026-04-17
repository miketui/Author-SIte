# Product Requirements Document (PRD) v2.2

## michaeldavidjr.beauty — Author Site + *Curls & Contemplation* Launch Funnel

**Owner:** Michael David Warren Jr. (TAYLKOMB LLC)
**Version:** 2.2
**Date:** 2026-04-16
**Status:** Handoff-ready — single document to drive full Claude Code build
**Supersedes:** PRD v2.1 (2026-04-16), v2.0 (2026-04-16), v1.0 (2026-02-16). v2.2 changelog below.

**v2.2 changelog:**
- Command registry system normalized into one canonical chain. The JSON registry (`chatgpt_command_registry_v1.json`) is canonical. Supplementary PDFs are optional reference material only and never override the JSON.
- New destination-repo artifacts introduced: `config/command-registry.source.json` (frozen canonical snapshot), `docs/command-catalog.md` (human-readable catalog), `docs/command-migration.md` (bucket-plan migration doc), `docs/reference/commands/` (optional supplementary PDF location).
- Canonical source paths locked explicitly: `../book-source/Final edits/OEBPS/`, `../book-source/Final edits/final/`, `../book-source/Final edits/Claude-code/`.
- Motion references cleaned across all wireframes and design sections: `/motion` slash commands removed (Motion+ not active per §14 item 14). Animation work routes through `motion-specialist` subagent + `motion-workflow` skill + Motion Studio MCP doc lookup.
- Phase 4 Superpowers commands updated to reference `../book-source/Final edits/...` consistently and to treat `config/command-registry.source.json` as canonical with JSON-wins conflict resolution.

**v2.1 changelog (retained for continuity):**
- Plugin / MCP / skill / command layers explicitly separated (§8.5 policy).
- Tool installs are direct and individual. The `website-builder-setup` skill is not used.
- UI/UX Pro Max install path clarified: native skill install first, CLI install as fallback.
- 21st.dev Magic: explicit MCP registration via `claude mcp add` or `.mcp.json`.
- Motion policy sharpened: install `motion` only, import from `motion/react` only, Motion Studio MCP registered, Motion+ and Motion AI Kit skipped (§14 item 14).
- `framer-motion` is a banned string anywhere in generated code.
- Plugin name standardized: Anthropic's security plugin is `anthropic/security-guidance`.
- Repo audit input added: downstream session must read the command registry JSON.
- Optional community skills introduced: `pbakaus/impeccable`, `Leonxlnx/taste-skill` (source-verification gate), `emilkowalski/skill` (local source only).
- Router doctrine (`AUTO::DETECT+ROUTE`, `AGM`, `SALES13`, `PROMPTLIB`) codified in project-scoped `CLAUDE.md`.
- Legacy slash commands migrate to project skills under `.claude/skills/`.
- Output repo locked: https://github.com/miketui/Author-SIte.git. Source repo https://github.com/miketui/Last.git (folder `Final edits/`) is read-only.

---

## 0. Executive Summary

A 3D-accented, emotionally magnetic author website for Michael David Warren Jr. — celebrity and editorial hairstylist, Rihanna's day-to-day, and first-time author — built to launch *Curls & Contemplation: A Freelance Hairstylist's Guide to Creative Excellence* with a charge-now pre-order funnel that auto-delivers the EPUB on release day.

The site operates three conversion funnels on a single brand-consistent spine: (1) **Book pre-order** → Stripe charge-now → RELEASE_DATE cron → Resend EPUB delivery, (2) **Email list** → free Chapter 1 + worksheet lead magnet → MailerLite 5-email welcome sequence, (3) **Booking inquiry** → Turnstile-protected form → Michael's inbox + auto-reply with rate sheet.

Visual language is ACISS (Obsidian / Antique Gold / Deep Jade) rendered in React Three Fiber — a floating, mouse-parallax book cover in an Obsidian void with gold rim light anchors the home hero. Scroll drives the camera toward the spine; the page opens to the epigraph. Every primary page carries one load-bearing 3D or scroll-driven moment that creates an emotional hook in the first three seconds.

Built with all six Claude Code plugins (`obra/superpowers`, `anthropic/frontend-design`, `anthropic/code-review`, `anthropic/security-guidance`, `nicholasgasior/claude-mem`, `garrytan/gstack`), the three-tool design stack (Motion for React via Motion Studio MCP, UI/UX Pro Max, 21st.dev Magic MCP), and the 3D layer (React Three Fiber, Drei, Lenis). Deployed to Vercel with Next.js 14 App Router. SEO-tuned for Michael's real positioning: celebrity hairstylist, editorial credits, Black hairstylist mentor, ballroom culture, nervous-system-aware beauty.

---

## 0.5 Two-Repo Architecture

This project spans two GitHub repos. Do not confuse them. Do not write into the source repo.

| Role | Repo / Local Path | What lives there | Access mode |
|------|-------------------|------------------|-------------|
| **Source** | `https://github.com/miketui/Last.git` → cloned locally as `../book-source/` | All read-only source assets under `../book-source/Final edits/`, including XHTML, EPUB, PDF, CSS, images, fonts, and the command registry JSON | **Read-only** |
| **Destination** | `https://github.com/miketui/Author-SIte.git` → local working directory `./` | All website code, setup files, `.env.example`, `.env.local`, `.mcp.json`, `.claude/`, generated docs, scripts, commits, and Vercel deploy origin | **Read-write** |

### Canonical source paths inside the source repo

Always start from:

```text
../book-source/Final edits/
```

Primary subpaths:

```text
../book-source/Final edits/OEBPS/
../book-source/Final edits/final/
../book-source/Final edits/Claude-code/
```

Rules:

- Read from `../book-source/Final edits/...`
- Write only into `./` (Author-SIte)
- Never commit into `../book-source/`
- Never treat source assets as destination working files

### Clone pattern

```bash
# Destination repo
git clone https://github.com/miketui/Author-SIte.git
cd Author-SIte

# Source repo as read-only sibling
cd ..
git clone https://github.com/miketui/Last.git book-source
cd Author-SIte

# Prevent accidental commit of the source repo path
echo "../book-source/" >> .gitignore
```

The downstream session reads from `../book-source/Final edits/` and writes only into `./` (Author-SIte). Every PRD phase, every script, every artifact ends up in Author-SIte.

---

## 1. Project Context & Positioning

### 1.1 Positioning Statement

Michael David Warren Jr. sits at the intersection of four worlds most hairstylist sites only touch one of: celebrity work (Rihanna day-to-day, Billy Porter, Keke Palmer, Gottmik), editorial credits (Harper's Bazaar, W, Vogue, Flaunt, Composure, Refinery29, ESPN), commercial (Nike, Aurora James), and cultural leadership (Haus of Basquiat, ballroom). *Curls & Contemplation* is the book that ties these into a teaching object for the next generation of Black freelance hairstylists. The website must read like his work: precise, editorial, unhurried, emotionally resonant.

### 1.2 Audience Segments

| Segment | Size estimate | Primary action | Content that converts |
|---------|---------------|----------------|----------------------|
| **Tier 1 — Industry peers & press** | Small, high-leverage | Book booking, feature requests, testimonial | Portfolio, press, signature ACISS voice |
| **Tier 2 — Aspiring Black hairstylists** | Core book audience | Pre-order book, join list | Chapter previews, free workbook, mentorship story |
| **Tier 3 — Wellness-curious, beauty-adjacent** | Expansion audience | Join list, share book | Nervous-system framing, editorial credibility, ballroom story |

### 1.3 Competitive Landscape

Three author/stylist sites to beat, and the gap we exploit:

1. **Vernon François (vernonfrancois.com)** — strong product play, thin storytelling. We win on narrative depth and 3D presentation.
2. **Sir John Official (sirjohnofficial.com)** — strong celebrity credits, weak content engine. We win on the journal, chapter previews, and owned-audience capture.
3. **Jen Atkin / Ouai & similar** — product-heavy, no book-as-teaching-object. We win by treating the book as the center of gravity, not a bolt-on.

### 1.4 Emotional Premise — First Three Seconds

Visitor lands and feels: *this is serious work by a serious artist; I am in the presence of craft.* Not "beauty industry guru." Not "celebrity tease." Craft. The book floating in obsidian, the gold rim, the restraint of the type — all saying the same thing.

---

## 2. Book Content Extraction Protocol

### 2.1 Clone & Inspect the Source Repo

```bash
git clone https://github.com/miketui/Last.git book-source
cd book-source
ls -la "Final edits/final"
ls -la "Final edits/OEBPS"
ls -la "Final edits/Claude-code"
```

The `Final edits/final` folder contains the production EPUB and PDF. The `Final edits/OEBPS` folder contains XHTML chapter files, CSS, fonts, and images. If paths have changed (spaces, capitalization), run `find . -iname "*.epub"` and `find . -iname "*.pdf"` to locate them.

### 2.2 EPUB + PDF Parsing

**EPUB parsing** (preferred — cleaner structural metadata):

```bash
pnpm add -D epub2 jsdom
```

Write `scripts/extract-book-content.ts` that:

1. Opens the EPUB with `epub2`.
2. Walks the spine in order.
3. For each chapter XHTML: uses `jsdom` to extract `h1` (chapter title), `h2` (section headers), first `p` (opening hook), all `blockquote` elements (pull-quotes), and any element with class `quiz`, `worksheet`, or `endnote`.
4. Emits a single JSON file at `lib/book-data.json`.

**PDF parsing** (fallback for any chapter that fails EPUB extraction):

```bash
pnpm add -D pdf-parse
```

Use `pdf-parse` to extract text, then apply regex splits on chapter boundaries derived from the TOC.

**XHTML parsing** (if EPUB extraction misses something): source XHTML is in `../book-source/Final edits/OEBPS/`. Read those files directly as a final fallback for any chapter whose hook, pull-quotes, or quiz content didn't surface clean from the EPUB.

### 2.3 What to Extract

| Field | Source | Destination |
|-------|--------|-------------|
| `book.title`, `book.subtitle`, `book.author`, `book.isbn`, `book.dedication`, `book.backCoverCopy` | EPUB `<opf:metadata>` + front matter | `/the-book` hero, `/` hero, schema.org |
| `book.chapters[].title`, `.part`, `.slug`, `.openingHook`, `.pullQuotes[]`, `.quiz[]`, `.worksheet` | EPUB spine per chapter | `/chapters`, `/chapter/:slug`, journal seed content |
| `book.epigraph` | Front matter | `/` hero secondary line |
| `book.acknowledgments` | Back matter | `/about` supporting section |
| `book.authorBio` | Back matter | `/about` bio, author schema |
| `book.tocOrdered` | Built from chapters array | `/chapters` IA |

### 2.4 Output Schema (`lib/book-data.ts`)

```ts
export type Chapter = {
  number: number;           // 1..16
  part: 1 | 2 | 3 | 4;
  partTitle: string;
  title: string;
  slug: string;             // kebab-case
  openingHook: string;      // first ~80 words, cleaned
  pullQuotes: string[];     // up to 5 per chapter
  quiz?: { q: string; options: string[]; answer: number }[];
  worksheet?: { prompt: string; lines: number }[];
  epigraph?: string;
  wordCount: number;
};

export type Book = {
  title: string;
  subtitle: string;
  author: string;
  isbn?: string;
  dedication: string;
  epigraph: string;
  backCoverCopy: string;
  authorBio: string;
  acknowledgments?: string;
  chapters: Chapter[];
  releaseDate: string;      // ISO 8601, from .env RELEASE_DATE
};

export const book: Book = /* generated from extract-book-content.ts */;
```

### 2.5 3D Cover Asset Path

Repo likely contains the 2D cover PNG/JPG in `../book-source/Final edits/OEBPS/` or `../book-source/Final edits/final/`. The 3D hero needs a GLB.

**Option A (preferred — proper 3D model):** Commission Nathaniel Plasabas (existing TAYLKOMB CAD designer) using the brief in Appendix A. He returns `book.glb` at <500KB with embedded textures.

**Option B (fast fallback — extrusion from 2D art):** Use Blender script or online tool (convertio.co, vectary.com) to extrude the cover PNG into a ~0.02m-depth book shape with normal map for spine and page texture. Lower fidelity but acceptable.

Place final file at `public/models/book.glb`. Run `gltf-transform optimize` to squeeze size:

```bash
pnpm dlx @gltf-transform/cli optimize public/models/book.glb public/models/book.glb
```

### 2.6 Command Registry Audit Input

During setup and content extraction, the downstream session must normalize Michael's command system into one canonical chain.

### Canonical source-of-truth

The primary machine-readable source is:

```text
../book-source/Final edits/Claude-code/chatgpt_command_registry_v1.json
```

This file is canonical.

### Secondary references

Supplementary command references may also exist as PDFs or docs, but they never override the JSON registry. If they are available, they are treated as supporting references only.

Recommended destination location for supplementary references:

```text
docs/reference/commands/
```

Examples:

- `Claude Shortcut Codes.pdf`
- `Cluade secret code.pdf`
- `command-cheatsheet.pdf`

### Destination-repo normalized artifacts

The destination repo must contain:

```text
config/command-registry.source.json
docs/command-catalog.md
docs/command-migration.md
CLAUDE.md
.claude/skills/
.claude/commands/
```

Definitions:

- `config/command-registry.source.json` = frozen copy of the canonical JSON registry from the source repo
- `docs/command-catalog.md` = human-readable command catalog
- `docs/command-migration.md` = migration / bucket plan
- `CLAUDE.md` = router doctrine and always-on interpretation layer
- `.claude/skills/` = installed project skills
- `.claude/commands/` = legacy fallback only when a full skill is unnecessary

### Registry buckets

Every entry from the canonical JSON registry must be classified into one of three buckets:

| Bucket | Destination | Example entries |
|--------|-------------|-----------------|
| **A. Install as project skill or legacy command** | `.claude/skills/<name>/SKILL.md` or `.claude/commands/<name>.md` | `ghost`, `godmode`, `layered`, `unpack`, `livecode`, `investigate` |
| **B. Codify in router doctrine** | `CLAUDE.md` | `AUTO::DETECT+ROUTE`, `AGM`, `Normal mode`, `SALES13::*`, `PROMPTLIB::*` |
| **C. Document only** | `docs/command-catalog.md` | output, reasoning, productivity, writing, business, code, and meta tokens such as `BLUF`, `WHY5`, `SWOT`, `AUDIT`, `SEC`, `CHAIN`, `RECAP` |

### Rule

No entry from the JSON registry or supplementary PDFs may be installed as a plugin or MCP server unless the PRD explicitly says so.

---

## 3. Sitemap & Information Architecture

| Route | Primary job | Funnel | 3D/motion signature |
|-------|-------------|--------|---------------------|
| `/` | Anchor the brand, route to all three funnels | All three | Floating 3D book with scroll-driven page-open |
| `/about` | Establish credibility and story | List capture secondary | Scroll-stacked editorial portraits with z-depth parallax |
| `/the-book` | Convert to pre-order | Pre-order primary | Book cover 3D with spine-open animation on scroll |
| `/chapters` | Browse all 16 chapters | Pre-order secondary | 3D ring carousel of 16 chapter cards, drag to rotate |
| `/chapter/:slug` | Preview single chapter, drive purchase | Pre-order + list | Pull-quote reveals on scroll, signature page-turn transition |
| `/workbook` | Deliver lead magnet, capture email | List primary | Layered paper stack 3D card with parallax tilt |
| `/portfolio` | Display editorial + celebrity work | Booking secondary | Masonry grid with z-depth hover lift |
| `/services` | Convert to booking | Booking primary | Rate card with gold-foil shimmer on scroll |
| `/press` | Build third-party credibility | Booking secondary | Logo marquee with desaturate → color hover |
| `/journal` | Long-term SEO + nurture | List tertiary | Hover-tilt 3D article cards |
| `/journal/:slug` | Single post, drive subscribe | List secondary | Reading progress bar + quote reveals |
| `/contact` | Non-booking inquiries | N/A | Minimal — ACISS form |
| `/checkout` | Convert pre-order | Pre-order | No 3D — conversion clarity first |
| `/thank-you` | Confirm, set expectations, extend | Post-purchase | Subtle gold confetti (respects reduced-motion) |
| `/portal/:token` | Order status + downloads | Post-purchase | Book cover 3D (reused asset), countdown to RELEASE_DATE |
| `/privacy`, `/terms`, `/refund-policy` | Legal | N/A | None |

---

## 4. Page-by-Page Wireframes

### 4.1 `/` — Home

**Funnel:** Top-of-funnel, routes to all three conversion paths.

**Section stack:**
1. **Hero** — 3D book floating in Obsidian void, gold rim light, jade specular accent. Headline: "Hair is the craft. Transformation is the calling." `[CONFIRM headline]`. Sub: "Michael David's first book + editorial archive." Dual CTA: primary gold "Pre-order $17.99", secondary outline "Read Chapter 1 free".
2. **Proof bar** — Rihanna, Nike, Harper's Bazaar, W, Vogue, Flaunt logos, grayscale resting, color on hover. `[CONFIRM logo usage rights per publication]`.
3. **The Book teaser** — 3-tile bento: pull-quote from book / "16 chapters, 4 parts" / "EPUB + PDF + free workbook". CTA: `/the-book`.
4. **Editorial reel** — 6 portfolio covers in scroll-parallax z-depth stack. CTA: `/portfolio`.
5. **About excerpt** — portrait + 2-paragraph bio sourced from brand memory + back matter. CTA: `/about`.
6. **Journal teaser** — latest 3 posts. CTA: `/journal`.
7. **Email capture band** — free Chapter 1 lead magnet, exit-intent duplicate.
8. **Footer** — ACISS gold underline rule, IG `@md.warren`, legal links, email.

**Components:** `Hero3D` (custom R3F), `LogoMarquee` (21st.dev Magic), `BentoGrid` (shadcn + custom), `ScrollStack` (Motion for React + CSS transform-3d), `PortraitSplit`, `JournalPreview`, `NewsletterCTA`, `FooterACISS`.

**3D/Motion signature:** Book levitates with mouse parallax (clamped ±8° x and y). On scroll past hero, camera flies toward spine and the book opens to the epigraph page (Chapter 1 opening, extracted from repo). GLB ~420KB, <60 draw calls. Fallback: static hero PNG with CSS gold glow animation when `prefers-reduced-motion: reduce` is set or mobile device memory <4GB.

**Motion for React:** Section reveals at viewport threshold 0.2, stagger 60ms, ease `[0.22, 1, 0.36, 1]`. Use the `motion-specialist` project subagent + `motion-workflow` skill + Motion Studio MCP doc lookup to generate and refine reveal variants. Do not use `/motion` slash commands; Motion+ and Motion AI Kit are not active for this project.

**Copy source:** Book repo (epigraph, chapter count, back-cover copy); brand memory (bio, positioning); `[CONFIRM headline with Michael]`.

**Mobile:** 3D hero disabled below 768px OR when reduced-motion preferred. Replaced with high-res hero image + CSS parallax on title. Proof bar becomes horizontal scroll. Bento collapses to 1-column stack.

**SEO:**
- Title: `Michael David Warren Jr. — Hairstylist & Author of Curls & Contemplation`
- Meta: `Rihanna's day-to-day hairstylist. Editorial work for Nike, Harper's Bazaar, W. Author of Curls & Contemplation — pre-order now.`
- H1 matches headline, internal links to `/the-book`, `/portfolio`, `/about`, `/journal`.

---

### 4.2 `/about`

**Funnel:** Credibility builder; secondary list capture.

**Section stack:**
1. **Full-bleed portrait** — editorial shot from portfolio, ACISS gold underline rule.
2. **Opening essay** — 3 paragraphs, voice-led, no bullet points. Sourced from back-matter bio + brand memory.
3. **Credits block** — clients (Rihanna, Billy Porter, Keke Palmer, Gottmik, Aurora James) + publications, two columns.
4. **Training lineage** — Guido Palau, Jimmy Paul. 1 paragraph each.
5. **Ballroom / Haus of Basquiat** — cultural positioning. 1 paragraph + single scroll image.
6. **The ACISS ethos** — "Black leads. Gold elevates. Jade distinguishes." — set in Cinzel Decorative, gold underline.
7. **CTA** — `/the-book` + subscribe.

**Components:** `FullBleedPortrait`, `EssayColumn`, `CreditsTwoCol`, `QuoteBlockACISS`, `NewsletterCTA`.

**3D/Motion signature:** Scroll-stacked portraits with z-depth parallax — as reader scrolls, portraits shift on z-axis creating spatial depth without heavy 3D geometry. Uses `will-change: transform` and CSS `perspective` only; no R3F.

**Copy source:** Back matter bio, brand memory, `[CONFIRM credits list final form]`.

**Mobile:** Portraits stack vertically; z-depth parallax disabled below 768px.

**SEO:**
- Title: `About Michael David Warren Jr. — Celebrity Hairstylist, Editorial Artist`
- Meta: `Michael David is Rihanna's day-to-day hairstylist. Editorial credits with Nike, Harper's Bazaar, W. Trained under Guido Palau and Jimmy Paul.`

---

### 4.3 `/the-book`

**Funnel:** Primary pre-order conversion page.

**Section stack:**
1. **Hero** — 3D book cover with spine-open animation. Title, subtitle, dual CTA (`Pre-order $17.99` / `Read Chapter 1 free`). Release date countdown.
2. **Proof bar** — publication logos + 1-line quotes from Tier 1 testimonials (when received from Yusef Williams, Naphia White, Naeemah LaFond, Vernon François). `[CONFIRM final testimonials]`.
3. **What's inside** — 4-tile grid, one per Part of the book. Copy pulled from chapter openings. Each tile expands on click to reveal chapter list in that Part.
4. **Author insert** — portrait + 2-paragraph bio, link to `/about`.
5. **Testimonials carousel** — 5 full testimonials. `[CONFIRM list]`.
6. **Pricing card** — Launch $17.99 / Regular $19.99 / Kindle $9.99 link-out / KDP paperback $29.99 link-out. Free workbook bundle badge. "Charge now. Delivered on release day." microcopy.
7. **FAQ accordion** — 8 questions: shipping (digital, no shipping), refund (14-day), EPUB delivery timing (on RELEASE_DATE), Kindle vs paperback, international, gift orders (v2.1), bulk orders, signed copies (paperback only).
8. **Sticky mobile CTA** — persistent "Pre-order $17.99" button below 768px.

**Components:** `Hero3DBook`, `LogoMarquee`, `PartsBento` (custom), `AuthorInsert`, `TestimonialCarousel` (21st.dev), `PricingCard` (shadcn + custom), `FAQAccordion` (shadcn), `StickyCTA`.

**3D/Motion signature:** Book cover 3D (same GLB asset as home, reused for performance). On scroll into view, book rotates 180° to show spine; on further scroll, pages fan open revealing TOC preview. Strongest single emotional moment on the site — this is where the sale happens.

**Motion for React:** Pricing card enters from below with `spring` stiffness 260 damping 20. FAQ accordion uses default shadcn animation.

**Copy source:** Book repo (Part intros, chapter titles, back-cover copy); testimonials `[CONFIRM]`; pricing locked.

**Mobile:** 3D book disabled below 768px, replaced with static 2D cover with gold glow. Pricing card becomes full-width sticky footer.

**SEO:**
- Title: `Curls & Contemplation — The Freelance Hairstylist's Guide by Michael David Warren Jr.`
- Meta: `Pre-order Curls & Contemplation by celebrity hairstylist Michael David Warren Jr. 16 chapters on creative excellence, business, wellness, and leadership for freelance hairstylists. Launch price $17.99.`
- Schema: Book with ISBN `[CONFIRM]`, author Person.

---

### 4.4 `/chapters`

**Funnel:** Pre-order secondary; list capture.

**Section stack:**
1. **Hero** — "16 chapters. 4 parts. One freelance hairstylist's guide."
2. **3D Ring Carousel** — all 16 chapter cards in a 3D ring, drag to rotate. Each card shows chapter number, Part, title, 1-line hook.
3. **Part filter** — tap Part I/II/III/IV to focus carousel on those chapters.
4. **Pre-order CTA band** — sticky.

**Components:** `ChaptersRing3D` (R3F custom), `PartFilter`, `StickyCTA`.

**3D/Motion signature:** The ring itself. Drag inertia, soft auto-rotation when idle 4s. On tap, card flies toward camera and routes to `/chapter/:slug`.

**Copy source:** Book repo — chapter list from v1.0 §8.1, verified against EPUB parse:

- **Part I — Foundations of Creative Excellence:** 1. Unveiling Your Creative Odyssey · 2. Refining Your Creative Toolkit · 3. Reigniting Your Creative Fire · 4. The Art of Networking in Freelance Hairstyling
- **Part II — Growing Your Craft and Career:** 5. Cultivating Creative Excellence Through Mentorship · 6. Mastering the Business of Hairstyling · 7. Embracing Wellness and Self-Care · 8. Advancing Skills Through Continuous Education
- **Part III — Leadership and Legacy:** 9. Stepping Into Leadership · 10. Crafting Enduring Legacies · 11. Advanced Digital Strategies for Freelance Hairstylists · 12. Financial Wisdom: Building Sustainable Ventures
- **Part IV — The Future of the Craft:** 13. Embracing Ethics and Sustainability in Hairstyling · 14. The Impact of AI on the Beauty Industry · 15. Cultivating Resilience and Well-Being in Hairstyling · 16. Tresses and Textures: Embracing Diversity in Hairstyling

**Mobile:** Ring becomes horizontal swipe deck below 768px (keeps tactile feel without GPU cost).

**SEO:**
- Title: `Curls & Contemplation Chapters — All 16 Chapters, 4 Parts`
- Meta: `Preview all 16 chapters of Curls & Contemplation by Michael David Warren Jr. From creative foundations to leadership, wellness, and the future of hairstyling.`

---

### 4.5 `/chapter/:slug`

**Funnel:** Pre-order + list capture via per-chapter hook.

**Section stack:**
1. **Chapter opener** — large Part + number, Cinzel Decorative title, drop-cap first paragraph.
2. **Opening hook** — first ~200 words pulled from EPUB.
3. **Pull-quote reveal** — 3 pull-quotes from chapter, revealed on scroll with gold underline wipe.
4. **Continue reading CTA** — "Pre-order to finish this chapter $17.99" + "Get free Chapter 1 workbook".
5. **Next/prev chapter nav** — arrow links.

**Components:** `ChapterOpener`, `DropCap`, `PullQuoteReveal` (Motion scroll + CSS), `InlineCTA`, `ChapterNav`.

**3D/Motion signature:** Pull-quote reveals — each quote fades in from below with gold underline wiping in left-to-right, timed to ease.

**Copy source:** 100% from EPUB parse. Per chapter: opening hook, 3 pull-quotes.

**Mobile:** Straightforward single-column reading view.

**SEO:**
- Title formula: `{Chapter Title} — Chapter {N} of Curls & Contemplation by Michael David Warren Jr.`
- Meta formula: First ~155 chars of opening hook.
- Internal link rule: prev/next chapter + `/the-book` + `/workbook` + two thematically related journal posts.
- URL pattern: `/chapter/unveiling-your-creative-odyssey` (kebab from title).

---

### 4.6 `/workbook`

**Funnel:** Primary list capture.

**Section stack:**
1. **Hero** — "The *Curls & Contemplation* workbook. Free. Yours." + 3D layered paper stack.
2. **What's inside** — 3 bullet points on worksheet content, pulled from repo.
3. **Email capture form** — name + email. Turnstile protection. Submits to MailerLite group `182303148544623709`, triggers Sequence A.
4. **Post-submit state** — replaces form with "Check your inbox" + resend link.
5. **Social proof mini** — "Join X other stylists" counter pulled from MailerLite API (cached 1h).

**Components:** `Hero3DPaperStack`, `BulletList`, `SubscribeForm` (custom, Turnstile-wrapped), `SubscribeSuccess`, `SubscriberCount`.

**3D/Motion signature:** Paper stack 3D — 4 layered cards with slight offset, parallax on mouse tilt. Low-cost 3D using CSS transforms, no R3F needed.

**Copy source:** Book repo — pull worksheet titles to populate bullets.

**Mobile:** Paper stack simplified to 2 cards with tilt; form stacks vertically.

**SEO:**
- Title: `Free Hairstylist Workbook — Curls & Contemplation Companion`
- Meta: `Download the free workbook that accompanies Curls & Contemplation by Michael David Warren Jr. Hairstylist worksheets on pricing, mentorship, and business.`

---

### 4.7 `/portfolio`

**Funnel:** Booking secondary; credibility.

**Section stack:**
1. **Hero** — minimal, "Editorial. Celebrity. Commercial." Cinzel Decorative.
2. **Category filter** — Covers / Editorial / Beauty / Red Carpet / Commercial / Motion.
3. **Masonry grid** — 72 credited portfolio images from v1.0 designer handoff. Each tile shows publication + year + client on hover.
4. **CTA band** — `/services` booking.

**Components:** `CategoryTabs`, `MasonryGrid` (21st.dev Magic + custom), `ImageLightbox` (shadcn).

**3D/Motion signature:** Grid tiles lift on hover (z-translate + shadow deepening) — restrained, lets the work speak.

**Copy source:** v1.0 designer handoff + `lib/portfolio.ts`.

**Mobile:** 2-column masonry.

**SEO:**
- Title: `Portfolio — Michael David Warren Jr. Celebrity and Editorial Hairstylist`
- Meta: `Editorial, celebrity, commercial, and red carpet hair work by Michael David Warren Jr. Harper's Bazaar, W, Vogue, Nike, Rihanna.`

---

### 4.8 `/services`

**Funnel:** Primary booking inquiry.

**Section stack:**
1. **Hero** — "Book Michael."
2. **Service tiers** — Editorial day rate / Red carpet / Commercial / Brand consultation. Rate ranges sourced from v1.0 rate sheet work.
3. **Process** — 4 steps (inquire → scope → contract → shoot day).
4. **Inquiry form** — name, email, project type, shoot date, budget range, notes. Turnstile protection.
5. **FAQ** — booking-specific (travel, kits, crew, rush, international).

**Components:** `ServiceTiers`, `ProcessSteps`, `InquiryForm`, `FAQAccordion`.

**3D/Motion signature:** Rate card with gold-foil shimmer on scroll — CSS gradient animation, no 3D.

**Copy source:** v1.0 rate sheet for Luzid Productions ($350–500 do-and-go / $750–1,200 day rate) as anchor; `[CONFIRM current rates]`.

**Mobile:** Service tiers stack.

**SEO:**
- Title: `Book Michael David Warren Jr. — Hair Services for Editorial, Celebrity, Commercial`
- Meta: `Book Michael David Warren Jr. for editorial, red carpet, commercial, and brand hair work. Based in Los Angeles, available for travel.`

---

### 4.9 `/press`

**Funnel:** Booking + credibility secondary.

**Section stack:**
1. **Hero** — "Seen in."
2. **Logo marquee** — publications.
3. **Feature grid** — 6-9 press features with publication, date, title, outbound link.
4. **Press inquiry CTA** — `/contact?type=press`.

**Components:** `LogoMarquee`, `FeatureGrid`, `TextCTA`.

**Copy source:** `[CONFIRM current press list]`.

**SEO:**
- Title: `Press — Michael David Warren Jr. in the Media`
- Meta: `Press features on celebrity hairstylist Michael David Warren Jr. Editorial and interview coverage.`

---

### 4.10 `/journal`, `/journal/:slug`

**Funnel:** List nurture + SEO engine.

**Journal index:** Hero + filter by topic (Craft / Business / Wellness / Culture / The Book) + card grid.

**Journal post:** Reading progress bar top-sticky, pull-quote reveals, subscribe CTA at 40% and 90%, related posts at bottom.

**3D/Motion signature (index):** Article cards hover-tilt 3% with shadow deepening.

**3D/Motion signature (post):** Reading progress bar fills in gold; pull-quotes fade in on scroll.

**Seed content (launch window):** 3 posts mapped from book chapters:
1. "Pricing With Confidence: What Freelance Hairstylists Get Wrong" (Chapter 6 + 12)
2. "Networking Without Selling Out" (Chapter 4)
3. "Burnout Is a Business Problem, Not a Personal One" (Chapter 7 + 15)

**Ongoing cadence:** 2 posts/month year 1.

**SEO:**
- Title formula: `{Post Title} — Journal by Michael David Warren Jr.`
- URL pattern: `/journal/pricing-with-confidence-freelance-hairstylists`

---

### 4.11 `/contact`, `/checkout`, `/thank-you`, `/portal/:token`

**`/contact`:** General inquiries form. Minimal. Routes by dropdown to press / licensing / other.

**`/checkout`:** Two-step. Step 1: email + name + optional newsletter opt-in. Step 2: Stripe Payment Element + optional coupon. No 3D — conversion clarity wins.

**`/thank-you`:** Confirmation message, order summary, "Check your inbox for portal link", countdown to RELEASE_DATE, subtle gold confetti animation (respects reduced-motion).

**`/portal/:token`:** Pre-launch state shows order details + countdown + "Your book arrives on `{RELEASE_DATE}`". Post-launch state shows EPUB + PDF + workbook download buttons (each token-gated, 3 downloads, 7-day expiry per v1.0 §F25). 3D book cover reused as visual anchor.

---

### 4.12 `/privacy`, `/terms`, `/refund-policy`

Standard legal pages. Refund policy: 14-day for digital, pre-order refundable any time before RELEASE_DATE, post-launch refundable within 14 days if <30% downloaded. ACISS typography applied to legal for brand consistency. `[CONFIRM final copy with legal counsel or template service]`.

---

## 5. Three-Funnel Architecture

### 5.1 Funnel A — Book Pre-Order (Primary Revenue)

**UX flow:**

```
/ or /the-book
    ↓ CTA "Pre-order $17.99"
/checkout
    ↓ Step 1: email + name + opt-in
    ↓ Step 2: Stripe Payment Element → charge NOW
/thank-you
    ↓ portal_token emailed via Resend
/portal/:token (pre-launch state: countdown + order details)
    ↓ [T = RELEASE_DATE]
    ↓ cron /api/cron/release-ebook fires ONCE
    ↓ creates download_tokens for all pre-orders (epub + pdf + workbook)
    ↓ queues delivery emails (Resend)
    ↓ portal flips to post-launch state (download buttons active)
```

**Stripe setup (one-time, during build):**

```bash
stripe products create --name "Curls & Contemplation — Pre-Order" \
  --description "EPUB + PDF + free workbook. Charged now, delivered on release day." \
  --metadata[release_date]="2026-XX-XX" \
  --metadata[format]="epub+pdf+workbook"

stripe prices create --product prod_XXX --unit-amount 1799 --currency usd
```

Store the resulting `price_id` in `.env` as `STRIPE_PRICE_BOOK_PREORDER`.

**Charge-now rationale:** (1) Clean cashflow from day one. (2) Standard for digital-first products — buyer expectation. (3) Lower pre-launch cart-abandon risk than "we'll charge you later". (4) Simpler refund logic.

**RELEASE_DATE cron:**

```
POST /api/cron/release-ebook
Auth: Bearer ${CRON_SECRET}
Schedule: Manual trigger on launch day (Michael taps "GO" on admin endpoint) — avoids scheduled-cron failure modes
Action:
  1. SELECT all orders WHERE status='succeeded' AND NOT EXISTS (related download_token)
  2. FOR each order:
     - create 3 download_tokens (epub, pdf, workbook) with 7-day expiry, 3-use max
     - enqueue Resend email with signed download links
  3. Update site state flag (RELEASED=true)
  4. Log count + failures
```

Dry-run on staging T-1 day with test orders.

**Edge cases:**

| Case | Behavior |
|------|----------|
| Refund before RELEASE_DATE | Stripe refund → webhook → order.status='refunded' → no token created on launch day |
| Refund after RELEASE_DATE | Stripe refund → webhook → revoke existing download_tokens → send refund confirmation |
| Failed card at checkout | Stripe default error display → no order created |
| Duplicate order (same email, 2 orders) | Allowed. Second order gets second portal_token. Both fulfilled on launch. |
| International buyer | Accept. No VAT collection in MVP — `[CONFIRM legal risk; add Stripe Tax in v2.1 if needed]` |
| Gift purchase | Deferred to v2.1. Current flow delivers to payer's email. |
| Bulk order (>5 copies) | Deferred. Contact form routes to Michael. |

---

### 5.2 Funnel B — Email List + Lead Magnet

**UX flow:**

```
/workbook or exit-intent on /the-book or inline CTA on /chapter/:slug
    ↓ SubscribeForm submit (Turnstile verified)
POST /api/subscribe
    ↓ add to MailerLite group 182303148544623709
    ↓ tag: lead-magnet="workbook"
    ↓ trigger Sequence A
Resend immediate delivery: free Chapter 1 + worksheet PDF with signed download link
MailerLite Sequence A (welcome series, 5 emails, 12 days):
  Day 0 — Welcome + workbook delivered
  Day 2 — "Why I wrote this book" (story)
  Day 5 — Value post: pricing pitfalls (Chapter 6 excerpt)
  Day 8 — Social proof: celebrity work + testimonial
  Day 12 — Soft sell: pre-order invite with launch discount reminder
```

**MailerLite group:** Website Signups, ID `182303148544623709` (existing).

**MailerLite tags:** `lead-magnet:workbook`, `source:site`, `campaign:cc-launch`.

**Secondary captures:** Exit-intent modal on `/the-book` after 5s in viewport; inline CTA on every `/chapter/:slug`; footer subscribe on every page.

---

### 5.3 Funnel C — Booking Inquiry

**UX flow:**

```
/services
    ↓ InquiryForm submit (Turnstile verified)
POST /api/booking
    ↓ Resend transactional email to Michael (hello@michaeldavidjr.beauty)
    ↓ MailerLite tag "inquiry" on subscriber (creates if new)
    ↓ Resend auto-reply to submitter with rate sheet PDF + 48-hour response promise
```

**Form fields:** name (required), email (required), project type (select: editorial / red carpet / commercial / brand / press / other), shoot date (date picker, optional), budget range (select: $1k-3k / $3k-7k / $7k-15k / $15k+ / to discuss), notes (textarea, 500 char max).

**Auto-reply:** Template from brand memory, signed "Michael David", 48-hour response promise, rate sheet PDF attached (signed URL).

---

## 6. Design System — ACISS Implementation

### 6.1 Tailwind Config (ACISS Tokens)

`tailwind.config.ts`:

```ts
export default {
  theme: {
    extend: {
      colors: {
        obsidian: { DEFAULT: '#111111', 900: '#0A0A0A', 800: '#1A1A1A', 700: '#2B2B2B' },
        gold: { DEFAULT: '#B08D57', 600: '#9B7B4A', 400: '#C9A980', 300: '#D9BE9A', 100: '#F0E4D1' },
        jade: { DEFAULT: '#145B4B', 800: '#0F4338', 600: '#1A7961', 400: '#2DA185' },
        bone: '#F6F1E7',
        ink: '#0B0B0B',
      },
      fontFamily: {
        display: ['"Cinzel Decorative"', 'serif'],
        serif: ['"Cormorant Garamond"', 'serif'],
        sans: ['"Inter"', 'system-ui', 'sans-serif'],
      },
      letterSpacing: { tightest: '-0.04em', display: '0.02em' },
    },
  },
};
```

### 6.2 Typography Scale

| Token | Size (rem) | Line-height | Use |
|-------|-----------|-------------|-----|
| display | 4.5 | 1.05 | Hero headlines |
| h1 | 3.0 | 1.1 | Page titles |
| h2 | 2.25 | 1.15 | Section headers |
| h3 | 1.5 | 1.3 | Card titles |
| body-lg | 1.125 | 1.6 | Editorial prose (Cormorant) |
| body | 1.0 | 1.6 | UI text (Inter) |
| caption | 0.875 | 1.4 | Captions, microcopy |

Fluid scaling via `clamp()` — display at mobile: `clamp(2.5rem, 8vw, 4.5rem)`.

### 6.3 Component Primitives

| Primitive | Source | Import |
|-----------|--------|--------|
| Button | shadcn | `@/components/ui/button` |
| Accordion | shadcn | `@/components/ui/accordion` |
| Dialog | shadcn | `@/components/ui/dialog` |
| Input / Form | shadcn + react-hook-form | `@/components/ui/input`, `@/components/ui/form` |
| Hero with 3D | Custom (R3F) | `@/components/hero/Hero3D` |
| Logo marquee | 21st.dev Magic | `/magic logomarquee` |
| Testimonial carousel | 21st.dev Magic | `/magic testimonial-carousel` |
| Bento grid | 21st.dev Magic + custom | `/magic bento-grid` |
| Pricing card | shadcn + custom ACISS styling | `@/components/pricing/PricingCard` |
| Sticky CTA | Custom | `@/components/cta/StickyCTA` |
| Footer | Custom | `@/components/layout/FooterACISS` |

### 6.4 Motion Language

**Library:** Motion for React (`motion`), imported from `"motion/react"`. Do NOT install or import from `framer-motion` — that package is the legacy name; upstream has migrated. Motion requires React 18.2+.

**Install (handled in Phase 3, listed here for clarity):**

```bash
pnpm add motion
```

```ts
import { motion, useReducedMotion, useScroll } from "motion/react"
```

For server components in Next.js 14 App Router, use `motion/react-client` (re-export that is safe to tree-shake into client boundaries) and ensure the component wrapping Motion usage has `"use client"`.

**Easing tokens** (`app/motion.ts`):

```ts
export const ease = {
  smooth: [0.22, 1, 0.36, 1],      // default reveal
  emphasis: [0.65, 0, 0.35, 1],    // CTA press
  swift: [0.4, 0, 0.2, 1],         // UI transitions
};

export const duration = {
  fast: 0.18,
  base: 0.32,
  slow: 0.56,
  emphasis: 0.82,
};
```

**Defaults:** Section reveals `viewport={{ once: true, amount: 0.2 }}`, stagger children 60ms, ease `smooth`, duration `base`.

**Reduced motion:** `useReducedMotion()` hook wraps every motion component. When true: opacity-only reveals, no scale, no translate, no 3D mount.

**Claude Code integration (details in §8 Phase 8):**
- Motion Studio MCP registered with Claude Code → latest Motion docs and official examples available during implementation
- `motion-specialist` project subagent — repeat-use animation worker
- `motion-workflow` project skill — reusable playbook invoked through the project skill layer
- Motion+ and Motion AI Kit are skipped for this project
- `/motion` slash-command workflows are disabled unless Motion+ is later activated

### 6.5 3D Language — The Emotional Hook

**Global setup:**
- **Lenis smooth scroll** (`@studio-freight/lenis`), lerp 0.1, wraps `<body>`.
- **React Three Fiber** canvas mounted only on routes that use 3D; never global — avoid paying the cost site-wide.
- **Drei** for `useGLTF`, `Environment`, `PerspectiveCamera`, `Html`, `OrbitControls` (dev only).
- **Performance budget per scene:** <80 draw calls, <200k triangles, GLB <500KB, zero animation loops on idle (static until interaction).

**Per-page 3D moments:**

| Page | 3D moment | Asset | Cost |
|------|-----------|-------|------|
| `/` hero | Floating book, mouse parallax, scroll-driven page-open | `book.glb` | ~420KB, 60 DC |
| `/the-book` hero | Book rotates to spine, pages fan open | `book.glb` (reused) | 0KB marginal |
| `/chapters` ring | 16 card meshes in ring, drag rotation | inline planes + text | ~200KB |
| `/portal/:token` | Book cover static with jade glow | `book.glb` (reused) | 0KB marginal |
| `/about` | CSS-only z-depth parallax (not R3F) | — | 0KB |
| `/workbook` | CSS paper stack tilt (not R3F) | — | 0KB |

**Global 3D fallback rules:**
- `prefers-reduced-motion: reduce` → all R3F scenes replaced with static hero images
- `navigator.deviceMemory < 4` → same fallback
- Viewport width < 768px AND mobile user agent → static fallback on home hero; simplified 3D retained on `/the-book`
- 3D canvas lazy-mounts *after* LCP to protect performance score

**Lighting recipe (Obsidian/Gold/Jade):**

```
PerspectiveCamera: fov 35, position [0, 0, 3.2]
Environment: "studio" preset, intensity 0.3
directionalLight: gold #B08D57, intensity 1.2, position [2, 2, 3]  // rim
pointLight: jade #145B4B, intensity 0.4, position [-2, -1, 1]      // specular accent
Background: Obsidian #111111 (transparent canvas over hero bg)
```

---

## 7. SEO & Discoverability Strategy

### 7.1 Keyword Map

**Primary (target top-3 ranking within 12 months):**

1. `Curls and Contemplation book`
2. `Michael David Warren hairstylist`
3. `Rihanna hairstylist` (competitive; realistic target: featured on page 1)
4. `Black celebrity hairstylist Los Angeles`
5. `freelance hairstylist book`

**Secondary (target top-10 within 6 months):**

1. `editorial hair stylist Los Angeles`
2. `celebrity hairstylist author`
3. `hairstylist mentorship book`
4. `Black hairstylist mentor`
5. `Haus of Basquiat`
6. `ballroom hairstylist`
7. `nervous system beauty`
8. `hair stylist wellness book`
9. `freelance hairstylist business`
10. `hairstylist creative burnout`

**Long-tail (20+ from book chapters):**

- `how freelance hairstylists price their work`
- `networking for Black hairstylists`
- `hairstylist creative fire burnout`
- `mentorship for Black hairstylists`
- `financial wisdom for freelance hairstylists`
- `AI impact on beauty industry`
- `sustainability in hairstyling`
- `celebrity hairstylist day rate`
- `hairstylist leadership book`
- `freelance hairstylist wellness`
- `Rihanna day to day hairstylist name`
- `Curls and Contemplation Michael David Warren`
- `how to become a celebrity hairstylist`
- `editorial hair techniques book`
- `Guido Palau student hairstylist`
- `hairstylist self care routine`
- `hair stylist business advice book`
- `diverse hair texture styling book`
- `hairstylist continuing education`
- `hairstylist legacy building`

### 7.2 On-Page SEO Formulas

| Element | Formula |
|---------|---------|
| Title tag | `{Page-specific benefit} — {Michael David Warren Jr. \| Curls & Contemplation}` · 50-60 chars |
| Meta description | Benefit + specific credit + CTA · 140-155 chars |
| H1 | One per page, matches user-visible hero headline |
| H2 | Section headers, 3-7 per page, keyword-natural |
| Internal link rule | Every page links to `/the-book` + one thematically adjacent page |
| Image alt rule | `{subject}, {context}, by Michael David Warren Jr.` — e.g. `Rihanna with sculpted low bun, British Vogue cover 2024, by Michael David Warren Jr.` |
| Canonical | Self-referential on all pages |

### 7.3 Schema.org JSON-LD

Emit on every relevant page:

```jsonc
// /the-book — Book schema
{
  "@context": "https://schema.org",
  "@type": "Book",
  "name": "Curls & Contemplation: A Freelance Hairstylist's Guide to Creative Excellence",
  "author": { "@type": "Person", "@id": "https://michaeldavidjr.beauty/#michael" },
  "isbn": "[CONFIRM]",
  "bookFormat": "https://schema.org/EBook",
  "numberOfPages": 496,
  "datePublished": "[RELEASE_DATE]",
  "publisher": { "@type": "Organization", "name": "TAYLKOMB LLC" },
  "offers": { "@type": "Offer", "price": "17.99", "priceCurrency": "USD", "availability": "https://schema.org/PreOrder" }
}
```

Also emit: `Person` (Michael, on `/about`), `Organization` (TAYLKOMB LLC, on footer), `LocalBusiness` (services in LA, on `/services`), `FAQPage` (on `/the-book` FAQ section), `Article` (on every `/journal/:slug`).

### 7.4 Technical SEO

- **`sitemap.xml`** — auto-generated by Next.js 14 App Router `app/sitemap.ts`. Includes all static routes + dynamic `/chapter/:slug` + `/journal/:slug`.
- **`robots.txt`** — disallow `/admin`, `/portal`, `/api`, `/thank-you`. Explicit `Sitemap:` directive.
- **Canonical strategy** — self-referential.
- **Open Graph + Twitter cards** — per-page, with 1200×630 images. Home uses 3D render of book composite; others use editorial portraits.
- **Favicon set** — generated from ACISS gold "MD" mark: 16×16, 32×32, 180×180 apple-touch, 512×512 PWA.
- **Core Web Vitals gate** — LCP <2.5s, FID <100ms, CLS <0.1. 3D canvas lazy-mount after LCP.

### 7.5 Content Velocity Plan

**Journal cadence year 1:** 2 posts/month = 24 posts. Each 1,200-2,000 words, targeting one long-tail keyword from §7.1. Internal-link rule: each post links to `/the-book`, `/workbook`, and 2 other journal posts.

**Seed 3 posts at launch** (already listed in §4.10). Produce next 3 drafts before launch so Week 2-5 publishing is queued.

---

## 8. Plugin & Tool Pipeline — Build Order

Thirteen phases (Phase 0 prerequisite + twelve build phases). Each states tool, command, expected output, verification, and failure remediation.

### Phase 0 — Claude Code Installed & Repos Ready

Before any `/plugin install` runs, the Claude Code CLI itself must be installed and both repos accessible.

**Install Claude Code (two paths, pick one):**

```bash
# Path A — npm global install
npm install -g @anthropic-ai/claude-code
claude doctor
```

```bash
# Path B — native installer
curl -fsSL https://claude.ai/install.sh | bash
claude doctor
```

**Clone the output repo and bring in source content:**

```bash
# Clone the output repo (this is where all code lives)
git clone https://github.com/miketui/Author-SIte.git
cd Author-SIte

# Clone the source repo to a sibling directory for content extraction
cd ..
git clone https://github.com/miketui/Last.git book-source
cd Author-SIte

# Point Claude Code at the project
claude
```

**Verification:**
- `claude doctor` returns green across install, login, network, and permissions.
- `git remote -v` in `Author-SIte/` shows origin = `https://github.com/miketui/Author-SIte.git`.
- `../book-source/Final edits/` exists and contains the EPUB, PDF, OEBPS/, and `Claude-code/chatgpt_command_registry_v1.json`.

**Failure remediation:** if `claude doctor` reports a macOS permissions error, run `sudo chown -R $(whoami) ~/.claude`. If the native installer URL returns 404, fall back to Path A.

### Phase 1 — Install All 6 Claude Code Plugins

**One-line install (run inside Claude Code CLI):**

```bash
# Claude Code plugin install syntax: /plugin install <source>
/plugin install obra/superpowers
/plugin install anthropic/frontend-design
/plugin install anthropic/code-review
/plugin install anthropic/security-guidance
/plugin install nicholasgasior/claude-mem
/plugin install garrytan/gstack
```

> **Note on syntax:** exact command depends on Claude Code version. If `/plugin install` isn't recognized, check `claude --help` or the plugin page at `claude.com/plugins/<n>`. For GitHub-sourced plugins (Superpowers, claude-mem, gstack) the fallback is `git clone` into `~/.claude/plugins/` followed by `/plugin reload`.

**Verification:** `/plugins` lists all six. Each `/help` for that plugin returns its commands.

**Failure remediation:** If any plugin fails to install, log which and continue. `security-guidance` and `code-review` are non-blocking for build; they run in Phase 10-11.

### Phase 2 — Design Stack (Direct Install, Three Tools)

Three tools, three direct install paths. No `website-builder-setup` — that helper installs legacy `framer-motion` and conflicts with this project's Motion policy.

**2.1 UI/UX Pro Max — CLI path (preferred) or manual path.**

```bash
# CLI path (cleanest)
npm install -g uipro-cli
uipro init --ai claude
```

```bash
# Manual path (fallback if CLI fails)
git clone https://github.com/nextlevelbuilder/ui-ux-pro-max-skill.git /tmp/uiux
mkdir -p .claude/skills
cp -R /tmp/uiux/.claude/skills/ui-ux-pro-max .claude/skills/
rm -rf /tmp/uiux
```

Environment variable (both paths): `UIUX_PRO_MAX_KEY` in `.env.local`. Michael already owns this key.

**Verification:** `ls .claude/skills/ui-ux-pro-max/SKILL.md` returns the file. Inside Claude Code, `/skills` lists `ui-ux-pro-max`.

**2.2 21st.dev Magic — CLI path (preferred) or direct MCP registration.**

```bash
# CLI path (uses 21st's official installer)
export MAGIC_API_KEY="<Michael's 21st.dev API key>"
npx @21st-dev/cli@latest install claude --api-key $MAGIC_API_KEY
```

```bash
# Direct MCP path (fallback, or if CLI is unavailable)
export MAGIC_API_KEY="<Michael's 21st.dev API key>"
claude mcp add --scope project --transport stdio @21st-dev/magic \
  --env API_KEY=$MAGIC_API_KEY \
  -- npx -y @21st-dev/magic@latest
```

Manual JSON equivalent (written to repo `.mcp.json`):

```json
{
  "mcpServers": {
    "@21st-dev/magic": {
      "command": "npx",
      "args": ["-y", "@21st-dev/magic@latest"],
      "env": { "API_KEY": "${MAGIC_API_KEY}" }
    }
  }
}
```

**Verification:** `claude mcp list` shows `@21st-dev/magic`. Inside Claude Code, `/magic hero --stack nextjs` returns a component scaffold.

**2.3 Motion + Motion Studio MCP — package install + MCP register. Skip Motion+.**

```bash
# Package install (import from "motion/react", never "framer-motion")
pnpm add motion
```

```bash
# Register Motion Studio MCP (project scope — repo is git-tracked and shared)
claude mcp add-json --scope project motion '{
  "type": "stdio",
  "command": "npx",
  "args": ["-y", "https://api.motion.dev/registry.tgz?package=motion-studio-mcp&version=latest"]
}'
```

Manual JSON equivalent (written to repo `.mcp.json`):

```json
{
  "mcpServers": {
    "motion": {
      "type": "stdio",
      "command": "npx",
      "args": [
        "-y",
        "https://api.motion.dev/registry.tgz?package=motion-studio-mcp&version=latest"
      ]
    }
  }
}
```

**Motion+ and Motion AI Kit: SKIP.** Per §14 item 14, Michael has no Motion+ subscription. The `motion-specialist` project subagent (§8 Phase 8) + `motion-workflow` project skill + Motion Studio MCP doc lookup cover all animation work without the AI Kit.

**Verification for Phase 2:**

```bash
grep -R "framer-motion" . || echo "clean: no framer-motion references"
grep '"motion"' package.json
claude mcp list | grep -E "motion|21st"
ls .claude/skills/ui-ux-pro-max/SKILL.md
```

Expected: no `framer-motion` matches; `motion` present in `package.json`; `claude mcp list` shows `motion` and `@21st-dev/magic`; `ui-ux-pro-max/SKILL.md` exists.

**Failure remediation:**
- If `uipro init` fails → use manual path (git clone + copy).
- If `@21st-dev/cli` is unresolvable → use direct MCP path with raw `npx`.
- If Motion Studio MCP `npx` resolution times out → set `NPM_CONFIG_REGISTRY=https://registry.npmjs.org/` in shell env and retry.

### Phase 3 — Stack Scaffold with gstack

```bash
/gstack init michaeldavidjr-site \
  --framework nextjs@14 \
  --router app \
  --styling tailwind+shadcn \
  --3d "react-three-fiber,drei,three" \
  --scroll lenis \
  --motion motion \
  --payments stripe \
  --email resend \
  --marketing mailerlite \
  --db vercel-postgres \
  --analytics ga4,vercel \
  --error-tracking sentry \
  --bot-protection cloudflare-turnstile
```

**Expected output:** fresh Next.js 14 repo scaffolded with all listed dependencies, `.env.example` prepopulated, `tailwind.config.ts` with extend slot, README with run commands.

**Verification:** `pnpm install && pnpm dev` serves on localhost:3000 with starter page.

**Failure remediation:** If `gstack` doesn't support all flags, fall back to manual scaffold:

```bash
pnpm dlx create-next-app@latest michaeldavidjr-site --ts --tailwind --app --src-dir --import-alias "@/*"
cd michaeldavidjr-site
pnpm add three @react-three/fiber @react-three/drei @studio-freight/lenis motion stripe resend @mailerlite/mailerlite-nodejs @sentry/nextjs @vercel/postgres
pnpm dlx shadcn@latest init
```

> **Note:** Install `motion` (the current package), not `framer-motion` (legacy name). If the codebase has any `framer-motion` imports lingering from an earlier version, migrate them to `motion/react` during Phase 11 code review.

### Phase 4 — Content Extraction & Command Registry Audit

Two inputs feed this phase: (a) the book EPUB/PDF/XHTML for all chapter content, and (b) the canonical command registry.

**4.1 Book content extraction (primary):**

```
/superpowers research "parse ../book-source/Final edits/final/ EPUB plus any needed XHTML/CSS assets from ../book-source/Final edits/OEBPS/, extract TOC + pull-quotes + chapter openings per schema in PRD §2.4, write lib/book-data.ts"
```

**4.2 Command registry normalization (doctrine migration input):**

```
/superpowers research "read ../book-source/Final edits/Claude-code/chatgpt_command_registry_v1.json as the canonical source-of-truth for Michael's command system. Copy it into config/command-registry.source.json, cross-reference any supplementary references found in docs/reference/commands/, treat the JSON as canonical if conflicts exist, and produce: (1) docs/command-migration.md, (2) docs/command-catalog.md, (3) the Bucket A skill/command install plan, (4) the Bucket B router doctrine list for CLAUDE.md, and (5) the Bucket C token catalog."
```

**Expected outputs:**
- `lib/book-data.ts` populated with the full `book` object.
- `config/command-registry.source.json` — frozen copy of canonical JSON registry.
- `docs/command-migration.md` — three-category migration plan.
- `docs/command-catalog.md` — human-readable token reference catalog.
- `.claude/skills/{ghost,godmode,layered,unpack,livecode,investigate}/SKILL.md` — the six project skills (use the stubs shipped alongside this PRD as the starting point; enrich from registry).
- `CLAUDE.md` at repo root contains the router doctrine block from §8.5.

**Verification:**
- `pnpm test lib/book-data.test.ts` passes schema assertions (16 chapters, 4 parts, required fields present).
- `ls .claude/skills/` shows the six migrated command skills.
- `ls config/command-registry.source.json` returns the frozen copy.
- `grep -l "AUTO::DETECT+ROUTE" CLAUDE.md` returns a match.
- If any supplementary reference in `docs/reference/commands/` conflicts with the JSON, the JSON wins and the conflict is logged in `docs/command-migration.md`.

### Phase 5 — Design Generation with Frontend Design + UI/UX Pro Max

```
/frontend-design generate --page home --brief "ACISS palette obsidian #111111 / gold #B08D57 / jade #145B4B, Cinzel Decorative display, Cormorant Garamond serif, Inter UI. Hero: 3D book floating in obsidian void with gold rim light. Tone: editorial, restrained, craft-first."
```

```
/uiux-pro-max apply --theme aciss --pairing cinzel-cormorant-inter --style editorial-luxury
```

**Expected output:** component mockups (JSX scaffolds) and a `styles/tokens.css` file with ACISS custom properties.

### Phase 6 — Component Assembly with 21st.dev Magic

```
/magic hero --style editorial
/magic logomarquee --count 6
/magic testimonial-carousel
/magic bento-grid --cols 3
/magic faq-accordion
/magic sticky-cta
/magic footer --style editorial
```

Each command returns a component file. Drop into `components/magic/` and compose into pages.

### Phase 7 — 3D Layer Assembly

Hand-authored (3D requires design intent beyond current /magic coverage):

- `components/hero/Hero3D.tsx` — R3F Canvas with `useGLTF('/models/book.glb')`, mouse parallax via `useFrame`, scroll trigger via `@react-three/drei` `ScrollControls`.
- `components/chapters/ChaptersRing3D.tsx` — 16 chapter cards arranged on circle geometry, drag rotation via `useGesture`.
- `components/workbook/PaperStack3D.tsx` — CSS-only, no R3F.
- `components/layout/LenisProvider.tsx` — wraps app, initializes Lenis.

### Phase 8 — Motion Layer (Motion for React + Motion Studio MCP)

This phase turns Claude Code into a Motion expert instead of a Motion guesser. Five moves, in order.

**8.1 Install Motion in the app (if Phase 3 used manual fallback):**

```bash
pnpm add motion
```

Requires React 18.2+. Import path is always `"motion/react"`. If any `framer-motion` imports exist in the repo from prior work, migrate them to `motion/react` now (same API surface for the 95% case).

**8.2 Register Motion Studio MCP with Claude Code.**

Scope decision (confirm with Michael):
- **Local scope (default, recommended for solo work):** server available only in this project, stored in `~/.claude.json`. Not shared with teammates.
- **Project scope:** writes `.mcp.json` at repo root, checked into git, shared across anyone who clones the repo.

Local scope install:

```bash
claude mcp add-json motion '{
  "type": "stdio",
  "command": "npx",
  "args": ["-y", "https://api.motion.dev/registry.tgz?package=motion-studio-mcp&version=latest"]
}'
```

Project scope (team-shared) variant:

```bash
claude mcp add-json --scope project motion '{
  "type": "stdio",
  "command": "npx",
  "args": ["-y", "https://api.motion.dev/registry.tgz?package=motion-studio-mcp&version=latest"]
}'
```

**Verify:** inside Claude Code run `/mcp`, or from terminal run `claude mcp list` and `claude mcp get motion`.

**Why this matters:** Motion Studio MCP gives Claude Code direct access to the latest Motion docs and the source of 330+ official examples. That eliminates the hallucinated import / wrong API / stale syntax failure mode that plagues animation work.

**Security note (Anthropic's official caution):** MCP servers are user-configurable and not audited by Anthropic. Only enable providers you trust. Motion is a trusted vendor, but apply the same diligence for any other MCP you add.

**8.3 Install the Motion AI Kit — SKIP.** Michael does not have a Motion+ subscription (per §14 item 14). Do NOT run this step. Do NOT attempt `/motion` skill invocations downstream — they require the AI Kit. Animation work is covered by 8.4 (motion-specialist subagent) + 8.5 (motion-workflow skill) + the Motion Studio MCP registered in 8.2 for doc lookup. The original 8.3 command is preserved below, commented out, in case Motion+ is added later.

```bash
# SKIP unless Motion+ subscription is active:
# curl -sL "https://api.motion.dev/registry/skills/motion-ai-kit?token=YOUR_MOTION_PLUS_TOKEN" -o /tmp/ai-kit.sh && bash /tmp/ai-kit.sh
```

**8.4 Create the project subagent.**

File: `.claude/agents/motion-specialist.md`

```md
---
name: motion-specialist
description: Expert Motion for React implementation agent. Use for animation architecture, refactors, debugging, layout animation, gestures, and scroll-driven interactions.
tools: Read, Edit, MultiEdit, Write, Glob, Grep, Bash
model: inherit
---
You are the Motion specialist for this codebase.

Rules:
- Always import from "motion/react" (never "framer-motion").
- Preserve existing ACISS design tokens and component APIs.
- Favor transform and opacity animation; avoid layout-thrashing properties.
- Respect prefers-reduced-motion: use useReducedMotion() to short-circuit non-essential motion.
- For Next.js 14 App Router, ensure Motion usage sits inside a "use client" boundary.
- When an effect is simple enough for CSS alone, say so — do not force Motion.
- When changing behavior, report: what changed, why, tradeoffs, and any perf implications.
- Never introduce new dependencies without flagging them.
```

**8.5 Create the project skill.**

File: `.claude/skills/motion-workflow/SKILL.md`

```md
# Motion workflow

Use this skill when the task involves Motion for React animation design, refactoring, migration, or debugging.

Checklist:
1. Identify framework context: Vite, Next.js Pages Router, or Next.js App Router.
2. Confirm correct import path ("motion/react" or "motion/react-client").
3. Choose the right primitive:
   - animate / initial / exit for entrances and exits
   - whileHover / whileTap / drag for gestures
   - whileInView / useScroll for scroll-driven reveals
   - layout / layoutId for shared element transitions
4. Prefer small reusable motion wrappers (e.g., components/motion/Reveal.tsx) over inline animation objects repeated across files.
5. Preserve accessibility — check prefers-reduced-motion.
6. After changes, summarize:
   - Files changed
   - Animation pattern used
   - Performance considerations
   - Testing notes
```

**8.6 Add Motion rules to root `CLAUDE.md`.**

Append to the existing `CLAUDE.md`:

```md
## Motion rules for this repo

- Use Motion for React from "motion/react". Never "framer-motion".
- For Next.js App Router, keep Motion usage in client-compatible files ("use client" directive).
- Prefer reusable variants and shared transition objects for repeated patterns.
- Use layout/layoutId only when the UI genuinely benefits from shared layout animation.
- Keep default durations restrained (durations defined in app/motion.ts).
- Explain any performance-sensitive animation decisions in PR descriptions.
- Respect prefers-reduced-motion.
```

**8.7 Apply motion to every page per §6.4 defaults.**

Use `components/motion/Reveal.tsx` as the canonical reveal wrapper for section reveals. Hand-author the big set pieces (hero reveal, chapter ring rotation, pricing card spring) using the `motion-specialist` subagent + `motion-workflow` skill.

Example invocations:

```
Use motion-specialist to build a refined card hover interaction for the pricing tile. Subtle, premium, mobile-safe.
Use motion-specialist to convert /about scroll reveals into a reusable Reveal wrapper.
Use motion-specialist to add staggered section reveals on the home page. Keep it accessible.
```

**8.8 Motion audit for performance triage.**

Run before launch and after any major motion work. Because the AI Kit is not active, do a manual audit using the `motion-specialist` subagent:

```
Use motion-specialist to audit all Motion usage under src/components and src/app. Check for layout thrash, excessive repaints, oversized transforms, missing useReducedMotion gates, and any framer-motion imports. Produce a findings report at docs/motion-audit.md.
```

**Verification checklist for Phase 8:**
- [ ] `pnpm list motion` returns a version; no `framer-motion` in `pnpm list`
- [ ] `/mcp` inside Claude Code shows `motion` connected
- [ ] `.claude/agents/motion-specialist.md` present
- [ ] `.claude/skills/motion-workflow/SKILL.md` present
- [ ] `CLAUDE.md` has Motion rules block
- [ ] No `framer-motion` string anywhere in `app/`, `components/`, or `lib/`
- [ ] All motion-using components have `"use client"` directive
- [ ] `useReducedMotion()` wired into global reveal wrapper

### Phase 9 — Integrations

**Stripe:** Webhook endpoint `app/api/stripe/webhooks/route.ts` verifies signature, routes `payment_intent.succeeded` → create order → create portal_token → send Resend confirmation with portal link. `charge.refunded` → revoke tokens.

**Resend:** Templates in `emails/` using `react-email`. Verify domain `michaeldavidjr.beauty` in Resend dashboard (SPF, DKIM, DMARC — see §9).

**MailerLite:** `lib/mailerlite.ts` wraps SDK. Subscribe endpoint adds to group `182303148544623709` + fires Sequence A.

**Sentry:** `pnpm dlx @sentry/wizard@latest -i nextjs`. Sets up error boundaries.

**GA4 + Vercel Analytics:** Add `<Analytics />` from `@vercel/analytics/react` + GA4 script via `next/script` strategy `afterInteractive`.

**Cloudflare Turnstile:** Site key in frontend form, secret in backend validator.

### Phase 10 — Security Pass

```
/security-review scan --depth deep
```

Targets:
- No secrets in client bundles (`pnpm run build && grep -r "sk_" .next/` returns nothing)
- All `/api/admin/*` endpoints auth-gated
- Rate limits on `/api/subscribe`, `/api/booking`, `/download/:token`
- CSRF tokens on forms (Next.js App Router default + Turnstile supplements)
- Download tokens time-limited AND usage-limited
- Private book files outside `public/` (store in `private/` at repo root, serve via signed URL route only)

### Phase 11 — Code Review Pass

```
/code-review --scope all --focus accessibility,performance,types,dead-code
```

Address findings. Minimum bar: no `any` types in src, no components >300 lines, Lighthouse a11y ≥95 on every route.

### Phase 12 — Memory Capture + Deploy

```
/claude-mem save --project michaeldavidjr-site --topics "ACISS palette, 3D book hero, charge-now pre-order, MailerLite group 182303148544623709, RELEASE_DATE cron, canonical command registry at config/command-registry.source.json"
```

Deploy:

```bash
pnpm dlx vercel link
pnpm dlx vercel --prod
```

DNS at Namecheap: CNAME `www` → `cname.vercel-dns.com`; A `@` → `76.76.21.21`. SSL auto-provisioned.

---

### 8.5 Skills, Commands & MCP Policy

This project has four distinct tool layers. Keep them separated. Do not collapse them.

| Layer | What it is | Where it lives | How it's invoked | Examples in this project |
|-------|------------|----------------|------------------|--------------------------|
| **Plugin** | A first-class Claude Code extension installed via `/plugin install <source>`. Loads commands, agents, and skills as one bundle. | `~/.claude/plugins/<n>/` (global) | `/plugin` commands, plus any slash commands the plugin exports | `obra/superpowers`, `anthropic/frontend-design`, `anthropic/code-review`, `anthropic/security-guidance`, `nicholasgasior/claude-mem`, `garrytan/gstack` |
| **MCP server** | A running process Claude Code talks to via stdio or SSE. Exposes tools at call time. | `.mcp.json` (project scope) or `~/.claude.json` (local scope) | Claude Code calls MCP tools directly during reasoning | `motion` (Motion Studio), `@21st-dev/magic` |
| **Skill** | A reusable procedure defined in `SKILL.md`. Loads context when triggered. Project skills are scoped to this repo only. | `.claude/skills/<name>/SKILL.md` | Trigger keywords from the SKILL description, or explicit `/skills` invocation | `ui-ux-pro-max`, `motion-workflow`, `ghost`, `godmode`, `layered`, `unpack`, `livecode`, `investigate`, plus any community skill that passes source verification |
| **Command** | A legacy slash-command file. Simpler than a skill — just a prompt template. | `.claude/commands/<name>.md` | Direct slash invocation (e.g., `/ghost`) | Migration target for any registry entry not complex enough to warrant a full skill |

**Rule 1 — Router doctrine lives in `CLAUDE.md`, not in a plugin or skill.**

Michael's `AUTO::DETECT+ROUTE`, `AGM` (Genius Mode), `SALES13`, and `PROMPTLIB` behaviors are **router directives**, not standalone tools. They tell Claude *how to interpret input*. They belong at the top of the project-root `CLAUDE.md` file. Example block:

```md
## Router Doctrine (project-scoped, always-on)

AUTO::DETECT+ROUTE — silently classify every message and route to the appropriate skill/tool/command. Announce the route in one line before responding.

AGM (Activate Genius Mode) — when user types "AGM" or "Activate Genius Mode", apply the Engineer's Template: rewrite raw input into a structured prompt with SYSTEM CONTEXT, CHAIN-OF-THOUGHT REQUIREMENT, OUTPUT FORMAT, CALIBRATION EXAMPLE, TASK, SECURITY NOTE. Present under "ENGINEERED PROMPT — AWAITING APPROVAL" and wait for "go" before executing.

SALES13 — on any offer/launch/pitch/copy/brand task, apply the 13-point persuasion doctrine silently: emotion first, transformation over features, risk reduction, social proof restraint, composed pricing, trust protection.

PROMPTLIB::ROUTE — if a task matches a workflow in Michael's prompt library (book-launch, marketing-assets, cover-design-brief, etc.), invoke that workflow's skill explicitly and cite the match in one line.
```

This block is **always on** inside the project. No user activation needed beyond the literal trigger words (`AGM`, `AUTO::DETECT+ROUTE`, etc.). The router doctrine is NOT installed as a plugin. It's prose in `CLAUDE.md`.

**Rule 2 — Command registry migration.**

The canonical source is `config/command-registry.source.json` (frozen copy of `../book-source/Final edits/Claude-code/chatgpt_command_registry_v1.json`). Supplementary PDFs in `docs/reference/commands/`, if present, are optional reference material only and never override the JSON. During Phase 4, the Superpowers plugin reads the canonical JSON and produces `docs/command-migration.md` classifying each entry into one of three buckets:

| Bucket | Destination | Example entries |
|--------|-------------|-----------------|
| **A. Install as project skill** | `.claude/skills/<n>/SKILL.md` (full skill with triggers, tools, rules) | `ghost` (human voice, no AI clichés), `godmode` (first-principles, unfiltered), `layered` (3-level explanation), `unpack` (full deconstruction), `livecode` (production code with comments), `investigate` (journalist deep-dive) |
| **B. Codify in CLAUDE.md router** | The always-on block shown in Rule 1 | `AUTO::DETECT+ROUTE`, `AGM`, `SALES13`, `PROMPTLIB`, `ACTIVATE::SALES13+PROMPTLIB` |
| **C. Document in reference catalog** | `docs/command-catalog.md` (reference doc, no install) | Reasoning/output tokens: `BLUF`, `TLDR`, `WHY5`, `INVERT`, `STEEL`, `DEVIL`, `BAYES`, `2ND`, `FIRST`, `OODA`, `TREE`, `SCOPE`; writing/business shortcuts: `SWOT`, `PRD`, `JTBD`, `OKR`, `RICE`, `PITCH`, `AUDIT`, `SEC`. These are tokens Claude interprets inline, not skills that load files. |

**Rule 3 — Optional community skills.** Three additional skills were surfaced in user feedback. Each gets a specific install posture:

| Skill | Source | Posture | Rationale |
|-------|--------|---------|-----------|
| **`emilkowalski/skill`** | Emil Kowalski's animation skill | **Local source only** — clone to `/tmp/`, review `SKILL.md` manually, only copy into `.claude/skills/` if its instructions do not conflict with the Motion policy (no `framer-motion`, always `motion/react`). If it conflicts, document-only in `docs/community-skills-reviewed.md`. | Emil's work is high-quality but may predate the `motion` rename. Verify before activating. |
| **`pbakaus/impeccable`** | Paul Bakaus's "impeccable" design-quality skill | **Install to project** after one-pass review | Aesthetic discipline skill — aligns with the editorial quality bar in the kickoff prompt. Safe to activate. |
| **`Leonxlnx/taste-skill`** | Leon's "taste" skill | **Source-verification gate** — verify repo owner identity, last commit date, open issues before install. If any flag is red (dormant repo, unknown author, suspicious dependencies), document-only. | "Taste" is subjective — the skill's prompts must be read end-to-end before they shape Michael's outputs. |

**Install sequence (runs in Phase 2.4 as an addendum):**

```bash
# emilkowalski/skill — local source review
git clone https://github.com/emilkowalski/skill.git /tmp/emil-skill
# Manual review step: read /tmp/emil-skill/SKILL.md. If no framer-motion / motion/react conflicts:
cp -R /tmp/emil-skill/.claude/skills/* .claude/skills/ 2>/dev/null || \
  echo "emilkowalski/skill: conflicts or missing — documenting in docs/community-skills-reviewed.md"
rm -rf /tmp/emil-skill

# pbakaus/impeccable — install with one-pass review
git clone https://github.com/pbakaus/impeccable.git /tmp/impeccable
# Review, then:
cp -R /tmp/impeccable/.claude/skills/impeccable .claude/skills/
rm -rf /tmp/impeccable

# Leonxlnx/taste-skill — source-verification gate
git clone https://github.com/Leonxlnx/taste-skill.git /tmp/taste
# Verify: check repo author, last commit, SKILL.md content end-to-end
# If green:
cp -R /tmp/taste/.claude/skills/taste .claude/skills/
# If red: document only, do not activate:
mkdir -p docs && cp /tmp/taste/SKILL.md docs/community-skills-reviewed-taste.md
rm -rf /tmp/taste
```

**Rule 4 — No skill ever installs a library on its own behalf.** If a community skill's `SKILL.md` says "install X dependency," do NOT run it blindly. Any library install goes through `package.json`. Any MCP goes through §8.5 policy. The skill layer does not get implicit package-install authority.

**Rule 5 — Layer separation at review time.** When the Phase 11 code review pass runs, it must confirm:

- No `framer-motion` string anywhere in generated code.
- No MCP server registered that isn't in the approved set: `motion`, `@21st-dev/magic`, plus any explicitly-added third-party (log each).
- No plugin installed outside the approved six.
- No skill in `.claude/skills/` that wasn't approved in this §8.5 (i.e., no silent community installs).
- `CLAUDE.md` contains the router doctrine block.
- `config/command-registry.source.json` exists and matches the source repo JSON byte-for-byte (or with a documented delta).
- `docs/command-migration.md` exists and accounts for every entry in the canonical JSON registry.
- Any supplementary PDF in `docs/reference/commands/` is treated as reference only — no command derived exclusively from a PDF is installed as a skill unless the JSON also includes it.

---

## 9. Installation & API Key Walkthrough

### 9.0 Inventory — Owned vs. Needs Setup vs. Conditional

Before the Phase 9 wiring begins, know what's already handled:

**Owned (env var only, skip signup):**
- 21st.dev Magic — API key in hand
- UI/UX Pro Max — API key in hand
- MailerLite — account + Website Signups group (ID `182303148544623709`) already live
- Vercel — account active, portfolio already deploys here
- Namecheap — `michaeldavidjr.beauty` domain owned, DNS access confirmed

**Needs setup (signup + key retrieval):**
- Stripe (test + live keys, webhook endpoint)
- Resend (account + domain verification with SPF/DKIM/DMARC records into Namecheap)
- Cloudflare Turnstile (site key + secret)
- Sentry (via wizard)
- Google Analytics 4 (measurement ID)
- Google Search Console (DNS TXT verify + sitemap submit)

**Conditional (based on subscription):**
- Motion Studio MCP — free, always install (see §9.13)
- Motion+ token + Motion AI Kit — only if Michael has a Motion+ subscription

### 9.1 Stripe (payments)

- **Does:** processes pre-order charges.
- **Signup:** stripe.com → "Start now".
- **Key path:** Dashboard → Developers → API keys. Use "Standard keys", not "Restricted". Copy `Secret key` (sk_live_...) and `Publishable key` (pk_live_...). For dev, use test mode keys (sk_test_, pk_test_).
- **Webhook secret:** Dashboard → Developers → Webhooks → Add endpoint → URL `https://michaeldavidjr.beauty/api/stripe/webhooks`, events `payment_intent.succeeded`, `charge.refunded`, `charge.dispute.created`. Copy signing secret (whsec_...).
- **Env vars:** `STRIPE_SECRET_KEY`, `STRIPE_PUBLISHABLE_KEY`, `STRIPE_WEBHOOK_SECRET`, `STRIPE_PRICE_BOOK_PREORDER`.
- **Power-user note:** use restricted keys scoped to `PaymentIntents:write`, `Customers:write`, `Prices:read` in production.

### 9.2 MailerLite (marketing email)

- **Does:** list + automations.
- **Signup:** already active (Website Signups group ID `182303148544623709`).
- **Key path:** Dashboard → Integrations → Developer API → Generate new token.
- **Env vars:** `MAILERLITE_API_KEY`, `MAILERLITE_GROUP_WEBSITE_SIGNUPS=182303148544623709`.

### 9.3 Resend (transactional email)

- **Does:** order confirmations, portal links, launch-day delivery, booking auto-reply.
- **Signup:** resend.com → Sign up.
- **Key path:** Dashboard → API Keys → Create API key. Select "Sending access" scope.
- **Domain verify:** Dashboard → Domains → Add `michaeldavidjr.beauty`. Copy the SPF, DKIM, DMARC records into Namecheap DNS. Verify in Resend until all green.
- **Env vars:** `RESEND_API_KEY`, `RESEND_FROM_EMAIL=hello@michaeldavidjr.beauty`, `RESEND_FROM_NAME=Michael David`.

### 9.4 Vercel (hosting)

- **Does:** hosts Next.js site, Vercel Postgres, cron jobs.
- **Signup:** vercel.com → Sign up with GitHub.
- **Key path:** only needed for CLI: `vercel login`.
- **Postgres:** Dashboard → Storage → Create Database → Postgres. Vercel auto-injects `POSTGRES_URL`, `POSTGRES_PRISMA_URL`, etc. into project env.
- **Cron:** `vercel.json` with `"crons"` field — configure `/api/cron/process-emails` every 5 min, `/api/cron/release-ebook` manual (no schedule, invoked by token-gated POST).

### 9.5 Sentry (error tracking)

- **Does:** error monitoring and alerts.
- **Signup:** sentry.io → Sign up → "Next.js" project.
- **Key path:** wizard command sets it up: `pnpm dlx @sentry/wizard@latest -i nextjs`.
- **Env vars:** `SENTRY_DSN`, `SENTRY_ORG`, `SENTRY_PROJECT`, `SENTRY_AUTH_TOKEN`.

### 9.6 Google Analytics 4

- **Does:** traffic + conversions.
- **Signup:** analytics.google.com → Admin → Create property.
- **Key path:** Admin → Data streams → Web → copy Measurement ID (G-XXXXXXX).
- **Env var:** `NEXT_PUBLIC_GA4_ID`.

### 9.7 Google Search Console

- **Does:** indexing + search performance.
- **Signup:** search.google.com/search-console → Add property → `michaeldavidjr.beauty`.
- **Verification:** use DNS TXT record (preferred) or upload file.
- **Submit sitemap** after deploy: `https://michaeldavidjr.beauty/sitemap.xml`.

### 9.8 Cloudflare Turnstile

- **Does:** bot protection on forms.
- **Signup:** Cloudflare dashboard → Turnstile → Add site.
- **Site key + secret:** generated on site creation.
- **Env vars:** `NEXT_PUBLIC_TURNSTILE_SITE_KEY`, `TURNSTILE_SECRET_KEY`.

### 9.9 21st.dev Magic

- **Does:** production React components on demand.
- **Key:** already owned by Michael.
- **Env var:** `MAGIC_API_KEY` (scoped to MCP/CLI usage).

### 9.10 UI/UX Pro Max

- **Does:** palette + typography generation.
- **Key:** already owned by Michael.
- **Env var:** `UIUX_PRO_MAX_KEY` (if skill reads from env) OR configured in `~/.claude/config.json`.

### 9.11 Admin Auth (minimal — no full dashboard in v2.0)

- **Env vars:** `ADMIN_USERNAME`, `ADMIN_PASSWORD`, `ADMIN_API_KEY` (for programmatic access), `CRON_SECRET` (token-gates cron endpoints).

### 9.12 Motion (Motion Studio MCP + optional Motion+)

- **Does:** Motion for React animation library + MCP-linked direct access to latest Motion docs and 330+ examples from inside Claude Code.
- **Signup:** package is free, `pnpm add motion`. MCP install is free. Motion+ subscription (optional) unlocks AI Kit + Motion Studio token-gated features at motion.dev.
- **Key path:** only needed if Motion+ subscribed → motion.dev account settings → copy token.
- **Install commands:** full sequence in §8 Phase 8 (register MCP, optionally install AI Kit, create subagent + skill, add CLAUDE.md rules).
- **Env vars:** `MOTION_PLUS_TOKEN` (optional, only for Motion+ subscribers).

### 9.13 `.env.example` (Ready to Copy)

```bash
# Site
NEXT_PUBLIC_SITE_URL=https://michaeldavidjr.beauty
NODE_ENV=development
RELEASE_DATE=2026-XX-XXT08:00:00-07:00  # ISO 8601 with timezone

# Stripe
STRIPE_SECRET_KEY=sk_test_...
NEXT_PUBLIC_STRIPE_PUBLISHABLE_KEY=pk_test_...
STRIPE_WEBHOOK_SECRET=whsec_...
STRIPE_PRICE_BOOK_PREORDER=price_...

# Resend
RESEND_API_KEY=re_...
RESEND_FROM_EMAIL=hello@michaeldavidjr.beauty
RESEND_FROM_NAME=Michael David

# MailerLite
MAILERLITE_API_KEY=...
MAILERLITE_GROUP_WEBSITE_SIGNUPS=182303148544623709

# Database (Vercel Postgres auto-populates in production)
POSTGRES_URL=
POSTGRES_PRISMA_URL=
POSTGRES_URL_NON_POOLING=

# Analytics & Errors
NEXT_PUBLIC_GA4_ID=G-XXXXXXXXXX
SENTRY_DSN=https://...@sentry.io/...
SENTRY_ORG=taylkomb
SENTRY_PROJECT=michaeldavidjr-site
SENTRY_AUTH_TOKEN=...

# Bot Protection
NEXT_PUBLIC_TURNSTILE_SITE_KEY=...
TURNSTILE_SECRET_KEY=...

# Admin & Cron
ADMIN_USERNAME=michael
ADMIN_PASSWORD=<generate 24+ char random>
ADMIN_API_KEY=<generate 32+ char random>
CRON_SECRET=<generate 32+ char random>

# Design tool keys (already owned)
MAGIC_API_KEY=...
UIUX_PRO_MAX_KEY=...
```

---

## 10. Database & API Specification

### 10.1 Database Schema

Inherit v1.0 §5 tables (customers, orders, portal_tokens, download_tokens, webhook_events, subscribers, email_queue, email_sequences, broadcasts, page_views, admin_sessions). Production runs on Vercel Postgres. Local dev uses SQLite via `better-sqlite3` with a compat layer in `lib/db.ts`.

**Migration path:** Drizzle ORM. Schema in `db/schema.ts`. `pnpm drizzle-kit generate` produces SQL for both SQLite (dev) and Postgres (prod).

### 10.2 API Endpoints

Inherit v1.0 §6 public, admin, cron endpoints. Additions for v2.0:

| Method | Endpoint | Purpose | Auth |
|--------|----------|---------|------|
| POST | `/api/booking` | Booking inquiry submission | Turnstile |
| GET | `/api/book-data` | Return cached book metadata | Public |
| GET | `/api/3d-assets/signed-url` | Signed URL for GLB (if CDN-hosted) | Public, rate-limited |

### 10.3 Auth & Rate-Limit Matrix

| Endpoint | Auth | Rate limit |
|----------|------|------------|
| `/api/subscribe`, `/api/booking`, `/api/free-resource` | Turnstile | 5/min per IP |
| `/api/checkout` | Turnstile | 10/min per IP |
| `/api/stripe/webhooks` | Stripe signature | unlimited (Stripe validates) |
| `/download/:token` | Token | 10/5min per IP |
| `/api/portal/:token` | Token | 30/min per IP |
| `/api/cron/*` | Bearer `CRON_SECRET` | unlimited |
| `/api/admin/*` | Session or API key | 60/min per session |

Rate-limit implementation: `@upstash/ratelimit` + Upstash Redis (Vercel Marketplace, free tier).

---

## 11. Email Automation (Resend + MailerLite)

### 11.1 Transactional (Resend)

| Template | Trigger | Subject |
|----------|---------|---------|
| `order-confirmation.tsx` | Stripe webhook `payment_intent.succeeded` | "Your pre-order is in, `{name}`." |
| `portal-link.tsx` | Same webhook | Included in above email |
| `release-day-delivery.tsx` | `/api/cron/release-ebook` fires | "*Curls & Contemplation* is yours." |
| `refund-notice.tsx` | Stripe webhook `charge.refunded` | "Refund processed." |
| `lead-magnet-delivery.tsx` | `/api/subscribe` with magnet flag | "Your free Chapter 1 + workbook." |
| `booking-auto-reply.tsx` | `/api/booking` | "Michael will be in touch within 48 hours." |
| `booking-internal-notification.tsx` | Same endpoint | To Michael: "New booking inquiry — `{name}`." |

**From:** Michael David `<hello@michaeldavidjr.beauty>`.
**Preview text:** Set per template, ~90 chars.
**Design:** react-email components with ACISS tokens — gold accent rule, Cinzel display heading, Cormorant body.

### 11.2 Marketing (MailerLite)

**Sequence A — Welcome + Lead Magnet (5 emails, 12 days)**

| Day | Subject | Purpose |
|-----|---------|---------|
| 0 | Your free Chapter 1 + workbook is inside | Deliver magnet + set expectations |
| 2 | Why I wrote this book | Story + connection |
| 5 | The pricing mistake that costs hairstylists their career | Value post pulled from Ch 6 |
| 8 | The Rihanna test: what celebrity work taught me about craft | Social proof |
| 12 | Pre-order is open — here's what you get | Soft sell with launch-price reminder |

**Sequence B — Pre-Order Confirmation (MailerLite mirror of Resend transactional for audience tagging)**

| Day | Subject | Purpose |
|-----|---------|---------|
| 0 | Tag: `pre-order-confirmed` applied | Internal — no send |
| T-7 | Your book arrives in one week | Excitement build |
| T-1 | Tomorrow. | Single-word subject, high open rate |
| T+0 | Your book is live | Direct to portal link |

**Sequence C — Broadcasts** — admin-triggered, MailerLite UI.

---

## 12. Launch-Day Playbook

### T-30 days
- Pre-order opens to MailerLite list (soft launch)
- Social posts drop
- Monitor Stripe test charges one more time, then switch to live
- First batch of testimonials in hand `[CONFIRM Tier 1]`

### T-14 days
- Testimonial deadline for Tier 1 (Yusef Williams, Naphia White, Naeemah LaFond, Vernon François)
- Press outreach round 1
- Journal posts 1-3 publish

### T-7 days
- Final QA: Stripe test card matrix, mobile Safari/Chrome/Firefox, all three funnels
- EPUB + PDF + workbook uploaded to Vercel Blob (private bucket)
- Lighthouse run — Performance ≥90, Accessibility ≥95, SEO ≥95, Best Practices ≥95
- Resend domain deliverability check (Mail-Tester.com score ≥9/10)

### T-1 day
- Dry-run `/api/cron/release-ebook` on staging with 3 test orders
- Broken-link sweep (`pnpm dlx linkinator https://michaeldavidjr.beauty`)
- Final go/no-go checklist

### Launch day
- **Manual trigger** (Michael taps "GO" button on minimal admin page that POSTs to cron endpoint with `CRON_SECRET`) — avoids scheduled-cron failure modes
- Watch Sentry dashboard for 30 minutes
- Social announcement after first successful delivery confirmed
- MailerLite Sequence B Day T+0 fires

### T+7 days
- Analytics review: traffic, conversion rate, email opens
- First optimization cycle (copy, CTA placement)
- Journal post 4 publishes

### T+30 days
- KDP paperback goes live → link in on `/the-book` pricing card
- Begin affirmation cards integration (optional)

---

## 13. Verification & Acceptance Tests

### 13.1 Lighthouse (every page)
- Performance ≥90
- Accessibility ≥95
- SEO ≥95
- Best Practices ≥95

### 13.2 Manual QA Matrix

| Browser | Device | Flow |
|---------|--------|------|
| Safari | iPhone 13+ | Purchase, subscribe, booking |
| Chrome | Pixel 7 | Purchase, subscribe, booking |
| Firefox | Desktop | Purchase, subscribe |
| Chrome | Desktop | Full regression |
| Safari | Desktop | 3D performance visual check |

### 13.3 Stripe Test Cards
- `4242 4242 4242 4242` — success
- `4000 0000 0000 0002` — declined
- `4000 0000 0000 9995` — insufficient funds
- `4000 0027 6000 3184` — 3DS required (non-US)

### 13.4 Email Deliverability
- SPF passes (Resend-provided record)
- DKIM passes (Resend-generated CNAME records verified)
- DMARC: `v=DMARC1; p=quarantine; rua=mailto:dmarc@michaeldavidjr.beauty`
- Mail-Tester score ≥9/10

### 13.5 WCAG 2.1 AA
- axe-core automated: zero violations per page
- Manual: VoiceOver pass on home, `/the-book`, checkout
- Color contrast: ACISS palette verified in WebAIM Contrast Checker (gold on obsidian ≥4.5:1 for body)

### 13.6 3D Performance Check
- Chrome DevTools → Performance tab on mid-tier Android (Pixel 5 or similar)
- Home hero 3D at 60fps during mouse parallax
- `prefers-reduced-motion: reduce` in DevTools → canvas not mounted, static image served

### 13.7 Command Registry Integrity Check
- `config/command-registry.source.json` exists and is valid JSON
- Every entry in the canonical JSON has an assigned bucket in `docs/command-migration.md`
- `docs/command-catalog.md` lists every Bucket C token with its interpretation rule
- If `docs/reference/commands/` contains PDFs, none of them introduce commands not present in the JSON (or any additions are explicitly logged as "reference-only, not installed")
- `CLAUDE.md` Router Doctrine block matches Bucket B entries 1:1

---

## 14. Risks, Open Questions, [CONFIRM WITH MICHAEL]

1. **RELEASE_DATE** — exact timestamp + timezone needed for cron + countdown.
2. **ISBN** — assigned yet? Required for Book schema.
3. **3D book cover asset — RESOLVED: Nathaniel brief.** Michael is sending Nathaniel Plasabas the standalone Appendix A brief (separate file: `Nathaniel-3D-Book-Brief.md`). Expected delivery: 3–5 business days from acceptance. Until the GLB arrives, the downstream build session uses a placeholder box with cover PNG as `baseColor` so layout + lighting develop in parallel. When `book.glb` lands, drop it into `public/models/book.glb` and replace the placeholder with a one-line swap in `components/Hero3D.tsx`.
4. **Tier 1 testimonial status** — responses received? Which testimonials cleared for use? (Tier 1: Yusef Williams, Naphia White, Naeemah LaFond, Vernon François.)
5. **Home hero headline** — "Hair is the craft. Transformation is the calling." is placeholder. Final line?
6. **Logo usage rights** — confirm Harper's Bazaar, W, Vogue, Nike, etc. allow logo display on author site (usually yes for editorial work, but worth confirming).
7. **International pre-order VAT** — MVP ships without Stripe Tax. Risk accepted?
8. **Affirmation cards** — included at launch or deferred?
9. **Current day rates** — v1.0 referenced Luzid Productions rate sheet ($350–500 do-and-go / $750–1,200 day rate). Confirm current rates for `/services`.
10. **Paperback external links** — Amazon ASIN assigned? B&N, Waterstones, Indigo links?
11. **Legal copy** — Privacy, Terms, Refund — use template service or legal counsel?
12. **Admin dashboard — RESOLVED: deferred to v2.1.** First 90 days run off Stripe Dashboard + MailerLite Dashboard + Vercel Analytics. Only `/admin/queue-health` ships in v2.0. Scaffold the auth middleware in Phase 9 but skip the full dashboard build.
13. **Signed copies program** — offer paperback signed copies as upsell post-launch?
14. **Motion+ subscription — RESOLVED: NO.** Downstream build session **skips §8 step 8.3** (Motion AI Kit install) entirely. Animation work routes through the `motion-specialist` project subagent + `motion-workflow` project skill + Motion Studio MCP for doc lookup. Do NOT attempt `/motion` slash commands — they require the AI Kit. If Motion+ is added later, re-enable 8.3 and swap subagent prompts to `/motion` invocations.
15. **Motion MCP scope — RESOLVED: project.** The destination repo (`Author-SIte.git`) is git-tracked and may be shared with collaborators. Register Motion Studio MCP with `--scope project` so the config lands in repo-level `.mcp.json` and travels with the code. This aligns with Phase 2.3.
16. **Next.js 14 App Router confirmed as target** — locks Motion import pattern to `motion/react` for client components and `motion/react-client` where tree-shaking into a client boundary matters. Any deviation (e.g., Pages Router or Vite) requires a §6.4 and §8 Phase 8 rewrite.
17. **Optional community skills — decision matrix in §8.5 Rule 3.** `emilkowalski/skill` (local source only, review first), `pbakaus/impeccable` (install after one-pass review), `Leonxlnx/taste-skill` (source-verification gate before install). Downstream session logs its install/skip decision for each in `docs/community-skills-reviewed.md`.
18. **Supplementary command PDFs — optional.** If Michael wants `Claude Shortcut Codes.pdf`, `Cluade secret code.pdf`, or any other reference PDFs preserved inside the destination repo, he places them manually into `docs/reference/commands/`. They are supplementary only and never override `config/command-registry.source.json`. Any conflict resolves in favor of the JSON.

---

## 15. File Manifest (Next.js 14 App Router + R3F)

```
michaeldavidjr-site/
├── app/
│   ├── (marketing)/
│   │   ├── page.tsx                    # /
│   │   ├── about/page.tsx
│   │   ├── the-book/page.tsx
│   │   ├── chapters/page.tsx
│   │   ├── chapter/[slug]/page.tsx
│   │   ├── workbook/page.tsx
│   │   ├── portfolio/page.tsx
│   │   ├── services/page.tsx
│   │   ├── press/page.tsx
│   │   ├── journal/
│   │   │   ├── page.tsx
│   │   │   └── [slug]/page.tsx
│   │   └── contact/page.tsx
│   ├── (commerce)/
│   │   ├── checkout/page.tsx
│   │   ├── thank-you/page.tsx
│   │   └── portal/[token]/page.tsx
│   ├── (legal)/
│   │   ├── privacy/page.tsx
│   │   ├── terms/page.tsx
│   │   └── refund-policy/page.tsx
│   ├── api/
│   │   ├── subscribe/route.ts
│   │   ├── booking/route.ts
│   │   ├── checkout/route.ts
│   │   ├── validate-coupon/route.ts
│   │   ├── stripe/webhooks/route.ts
│   │   ├── portal/[token]/route.ts
│   │   ├── track/route.ts
│   │   ├── health/route.ts
│   │   ├── cron/
│   │   │   ├── process-emails/route.ts
│   │   │   └── release-ebook/route.ts
│   │   └── admin/
│   │       └── trigger-release/route.ts  # minimal admin for launch day "GO"
│   ├── sitemap.ts
│   ├── robots.ts
│   ├── layout.tsx
│   └── globals.css
├── components/
│   ├── hero/Hero3D.tsx
│   ├── chapters/ChaptersRing3D.tsx
│   ├── workbook/PaperStack3D.tsx
│   ├── layout/LenisProvider.tsx
│   ├── layout/FooterACISS.tsx
│   ├── layout/Nav.tsx
│   ├── cta/StickyCTA.tsx
│   ├── forms/SubscribeForm.tsx
│   ├── forms/InquiryForm.tsx
│   ├── pricing/PricingCard.tsx
│   ├── magic/            # 21st.dev generated components
│   ├── motion/Reveal.tsx
│   └── ui/               # shadcn components
├── lib/
│   ├── db.ts
│   ├── stripe.ts
│   ├── resend.ts
│   ├── mailerlite.ts
│   ├── turnstile.ts
│   ├── ratelimit.ts
│   ├── book-data.ts       # generated from EPUB
│   ├── portfolio.ts
│   ├── journal.ts
│   ├── faq-data.ts
│   └── seo.ts
├── db/
│   ├── schema.ts
│   └── migrations/
├── emails/
│   ├── order-confirmation.tsx
│   ├── portal-link.tsx
│   ├── release-day-delivery.tsx
│   ├── refund-notice.tsx
│   ├── lead-magnet-delivery.tsx
│   ├── booking-auto-reply.tsx
│   └── booking-internal-notification.tsx
├── scripts/
│   ├── extract-book-content.ts
│   └── seed-test-data.ts
├── config/
│   └── command-registry.source.json   # frozen canonical JSON registry
├── docs/
│   ├── command-migration.md           # three-bucket plan
│   ├── command-catalog.md             # human-readable token catalog
│   ├── community-skills-reviewed.md   # install/skip log for community skills
│   ├── motion-audit.md                # optional, from Phase 8.8
│   └── reference/
│       └── commands/                  # optional supplementary PDFs
├── public/
│   ├── models/book.glb
│   ├── images/
│   ├── downloads/              # free PDFs (chapter 1, workbook)
│   └── fonts/
├── private/                    # EPUB + PDF + workbook, NOT public
│   ├── CurlsAndContemplation.epub
│   ├── CurlsAndContemplation.pdf
│   └── Workbook.pdf
├── .claude/
│   ├── agents/
│   │   └── motion-specialist.md
│   ├── skills/
│   │   ├── motion-workflow/SKILL.md
│   │   ├── ui-ux-pro-max/SKILL.md
│   │   ├── ghost/SKILL.md
│   │   ├── godmode/SKILL.md
│   │   ├── layered/SKILL.md
│   │   ├── unpack/SKILL.md
│   │   ├── livecode/SKILL.md
│   │   └── investigate/SKILL.md
│   └── commands/               # legacy fallback only
├── .env.example
├── .env.local                  # gitignored
├── .mcp.json                   # motion + @21st-dev/magic
├── CLAUDE.md                   # router doctrine + motion rules
├── next.config.mjs
├── tailwind.config.ts
├── tsconfig.json
├── package.json
├── pnpm-lock.yaml
├── vercel.json
├── drizzle.config.ts
├── PRD.md                      # this document
└── README.md
```

---

## 16. Final Deliverable Format (Downstream Report)

After build completes, the downstream Claude Code session must report:

1. **Files created/changed** — full list.
2. **Commands run** — every install, build, test, deploy.
3. **Verification performed** — Lighthouse scores, Stripe test results, email deliverability, 3D performance, WCAG pass, command-registry integrity check.
4. **API keys still pending** — any in §9 not yet supplied by Michael.
5. **Launch-date go/no-go checklist** — from §12 T-7 and T-1.
6. **claude-mem persistence** — confirm key decisions saved (including canonical command-registry path).
7. **Risks remaining** — any §14 items still open.

---

## Appendix A — 3D Book Cover Asset Brief (for Nathaniel Plasabas or equivalent 3D designer)

**Deliverable:** A single optimized GLB file at `public/models/book.glb` rendering a 3D representation of the *Curls & Contemplation* book cover.

**Specs:**

| Property | Target |
|----------|--------|
| Format | glTF 2.0 binary (.glb), single file with embedded textures |
| File size | ≤500KB (optimize via `gltf-transform optimize`) |
| Triangle count | ≤30,000 |
| Texture resolution | 2K front cover, 1K spine, 1K back cover, 512 pages texture |
| Dimensions | 6.69" × 9.61" × 1.117" (Royal trim, matches KDP spec from brand memory) — scale to Three.js units where 1 unit = 1 inch |
| Pivot point | Center of book |
| Up axis | Y-up |
| PBR materials | Metallic-Roughness workflow; front/back covers use cover art as baseColor + subtle normal for texture; spine uses title embossed via normal map; pages use cream color + procedural edge noise |

**Source assets to provide Nathaniel:**
- Front cover PNG (high-res, from book production files in `../book-source/Final edits/OEBPS/` or `../book-source/Final edits/final/`)
- Back cover PNG (same)
- Spine text (from repo or brand style guide)
- ACISS palette reference

**Optional enhancements (if budget allows):**
- Gold foil effect on title (metallic roughness map + emissive)
- Slight page fan animation (separate GLTF animation channel) that Claude Code can trigger via `useAnimations`

**Delivery format:** Single `.glb` file plus a 10-second turntable render MP4 for QA reference.

**Timeline:** 3-5 business days from brief acceptance.

**Review criteria:** Faithful to 2D cover art, loads under 500KB, looks correct under ACISS lighting recipe (§6.5), performs at 60fps on mid-tier mobile.

---

## Appendix B — Downstream Claude Code Kickoff Prompt

The handoff prompt the downstream session should be invoked with is maintained as a standalone file: `Claude-Code-Kickoff-Prompt.md`. Setup is handled by `Install-Prompt.md`. Both are shipped alongside this PRD.

---

**END OF PRD v2.2**
