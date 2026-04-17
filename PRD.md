# Product Requirements Document (PRD) v2.3

## michaeldavidjr.beauty — Author Site + *Curls & Contemplation* Launch Funnel

**Owner:** Michael David Warren Jr. (TAYLKOMB LLC)
**Version:** 2.3
**Date:** 2026-04-17
**Status:** Lock-ready — single document to drive full Claude Code build
**Supersedes:** PRD v2.2 (2026-04-16), v2.1, v2.0, v1.0. v2.3 changelog below.

**v2.3 changelog:**
- Repo paths collapsed. All references to the source repo wrapper (`book-source/`) removed. The source repo is cloned as `Last/` and referenced everywhere as `../Last/Final edits/...`.
- Clone pattern updated: `git clone https://github.com/miketui/Last.git Last`.
- `.gitignore` entry updated: `../Last/`.
- §8.5 gains a **Bucket execution rules** subsection specifying destinations, artifacts, and rules per bucket. The bucket classification table is retained; the new subsection makes the system actionable.
- §8.5 Rule 3 emilkowalski posture rewritten as **local-source-only** (no GitHub clone). If Michael provides a reviewed local copy under `community-skills/emilkowalski/`, setup stages it; otherwise it is skipped and documented.
- Appendix A source asset paths updated to `../Last/Final edits/...`.
- Appendix B replaced with the final handoff-file manifest using locked filenames: `PRD.md`, `setup.sh`, `install-prompt.md`, `kickoff-prompt-v2-2.md`, `Nathaniel-3D-Book-Brief.md`.
- §14 item 17 updated to reflect the local-source-only emilkowalski posture.
- All setup-script and prompt references aligned with v2.2.2 of `setup.sh`, `install-prompt.md`, and `kickoff-prompt-v2-2.md`.

**v2.2 changelog (retained):**
- Command registry system normalized into one canonical chain. The JSON registry is canonical. Supplementary PDFs are optional reference material only and never override the JSON.
- Destination-repo artifacts introduced: `config/command-registry.source.json`, `docs/command-catalog.md`, `docs/command-migration.md`, `docs/reference/commands/`.
- Motion references cleaned: `/motion` slash commands removed (Motion+ not active per §14 item 14). Animation work routes through `motion-specialist` + `motion-workflow` + Motion Studio MCP doc lookup.

**v2.1 changelog (retained):** plugin/MCP/skill/command layers separated; direct tool installs; `framer-motion` banned string; router doctrine codified in `CLAUDE.md`; legacy slash commands migrate to project skills.

---

## 0. Executive Summary

A 3D-accented, emotionally magnetic author website for Michael David Warren Jr. — celebrity and editorial hairstylist, Rihanna's day-to-day, and first-time author — built to launch *Curls & Contemplation: A Freelance Hairstylist's Guide to Creative Excellence* with a charge-now pre-order funnel that auto-delivers the EPUB on release day.

The site operates three conversion funnels on a single brand-consistent spine: (1) **Book pre-order** → Stripe charge-now → RELEASE_DATE cron → Resend EPUB delivery, (2) **Email list** → free Chapter 1 + worksheet lead magnet → MailerLite 5-email welcome sequence, (3) **Booking inquiry** → Turnstile-protected form → Michael's inbox + auto-reply with rate sheet.

Visual language is ACISS (Obsidian / Antique Gold / Deep Jade) rendered in React Three Fiber — a floating, mouse-parallax book cover in an Obsidian void with gold rim light anchors the home hero. Scroll drives the camera toward the spine; the page opens to the epigraph. Every primary page carries one load-bearing 3D or scroll-driven moment that creates an emotional hook in the first three seconds.

Built with all six Claude Code plugins (`obra/superpowers`, `anthropic/frontend-design`, `anthropic/code-review`, `anthropic/security-guidance`, `nicholasgasior/claude-mem`, `garrytan/gstack`), the three-tool design stack (Motion for React via Motion Studio MCP, UI/UX Pro Max, 21st.dev Magic MCP), and the 3D layer (React Three Fiber, Drei, Lenis). Deployed to Vercel with Next.js 14 App Router.

---

## 0.5 Two-Repo Architecture

This project spans two GitHub repos. Do not confuse them. Do not write into the source repo.

| Role | Repo / Local Path | What lives there | Access mode |
|------|-------------------|------------------|-------------|
| **Source** | `https://github.com/miketui/Last.git` → cloned locally as `../Last/` | All read-only source assets under `../Last/Final edits/`, including XHTML, EPUB, PDF, CSS, images, fonts, and the command registry JSON | **Read-only** |
| **Destination** | `https://github.com/miketui/Author-SIte.git` → local working directory `./` (inside `Author-SIte/`) | All website code, setup files, `.env.example`, `.env.local`, `.mcp.json`, `.claude/`, generated docs, scripts, commits, and Vercel deploy origin | **Read-write** |

### Canonical source paths inside the source repo

Always start from:

```text
../Last/Final edits/
```

Primary subpaths:

```text
../Last/Final edits/OEBPS/
../Last/Final edits/final/
../Last/Final edits/Claude-code/
```

Subpath contents:
- `OEBPS/` — XHTML chapters, CSS, fonts, images, production assets
- `final/` — EPUB and PDF output artifacts
- `Claude-code/` — canonical command registry (`chatgpt_command_registry_v1.json`)

Rules:
- Read from `../Last/Final edits/...`
- Write only into `./` (Author-SIte)
- Never commit into `../Last/`
- Never treat source assets as destination working files

### Clone pattern

```bash
# Destination repo
git clone https://github.com/miketui/Author-SIte.git
cd Author-SIte

# Source repo as read-only sibling
cd ..
git clone https://github.com/miketui/Last.git Last
cd Author-SIte

# Prevent accidental commit of the source repo path
echo "../Last/" >> .gitignore
```

The downstream session reads from `../Last/Final edits/` and writes only into `./` (Author-SIte). Every PRD phase, every script, every artifact ends up in Author-SIte.

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

1. **Vernon François (vernonfrancois.com)** — strong product play, thin storytelling. We win on narrative depth and 3D presentation.
2. **Sir John Official (sirjohnofficial.com)** — strong celebrity credits, weak content engine. We win on the journal, chapter previews, and owned-audience capture.
3. **Jen Atkin / Ouai & similar** — product-heavy, no book-as-teaching-object. We win by treating the book as the center of gravity, not a bolt-on.

### 1.4 Emotional Premise — First Three Seconds

Visitor lands and feels: *this is serious work by a serious artist; I am in the presence of craft.* Not "beauty industry guru." Not "celebrity tease." Craft. The book floating in obsidian, the gold rim, the restraint of the type — all saying the same thing.

---

## 2. Book Content Extraction Protocol

### 2.1 Clone & Inspect the Source Repo

```bash
git clone https://github.com/miketui/Last.git Last
cd Last
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

**PDF parsing** (fallback):

```bash
pnpm add -D pdf-parse
```

**XHTML parsing** (final fallback): source XHTML is in `../Last/Final edits/OEBPS/`. Read those files directly for any chapter whose hook, pull-quotes, or quiz content didn't surface clean from the EPUB.

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
  number: number;
  part: 1 | 2 | 3 | 4;
  partTitle: string;
  title: string;
  slug: string;
  openingHook: string;
  pullQuotes: string[];
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
  releaseDate: string;
};

export const book: Book = /* generated from extract-book-content.ts */;
```

### 2.5 3D Cover Asset Path

Cover art PNG/JPG likely lives in `../Last/Final edits/OEBPS/` or `../Last/Final edits/final/`. The 3D hero needs a GLB.

**Option A (preferred):** Commission Nathaniel Plasabas using the brief in Appendix A. Returns `book.glb` at <500KB with embedded textures.

**Option B (fallback):** Extrude the cover PNG into a ~0.02m-depth book shape with normal map for spine and page texture.

Place final file at `public/models/book.glb`. Optimize:

```bash
pnpm dlx @gltf-transform/cli optimize public/models/book.glb public/models/book.glb
```

### 2.6 Command Registry Audit Input

During setup and content extraction, the downstream session must normalize Michael's command system into one canonical chain.

### Canonical source-of-truth

```text
../Last/Final edits/Claude-code/chatgpt_command_registry_v1.json
```

This file is canonical.

### Secondary references

Supplementary command references may also exist as PDFs or docs, but they never override the JSON registry. Recommended destination location:

```text
docs/reference/commands/
```

Examples: `Claude Shortcut Codes.pdf`, `Cluade secret code.pdf`, `command-cheatsheet.pdf`.

### Destination-repo normalized artifacts

```text
config/command-registry.source.json
docs/command-catalog.md
docs/command-migration.md
CLAUDE.md
.claude/skills/
.claude/commands/
```

Definitions:
- `config/command-registry.source.json` = frozen copy of the canonical JSON registry
- `docs/command-catalog.md` = human-readable command catalog
- `docs/command-migration.md` = migration / bucket plan
- `CLAUDE.md` = router doctrine and always-on interpretation layer
- `.claude/skills/` = installed project skills
- `.claude/commands/` = legacy fallback only when a full skill is unnecessary

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
2. **Proof bar** — Rihanna, Nike, Harper's Bazaar, W, Vogue, Flaunt logos, grayscale resting, color on hover. `[CONFIRM logo usage rights]`.
3. **The Book teaser** — 3-tile bento. CTA: `/the-book`.
4. **Editorial reel** — 6 portfolio covers in scroll-parallax z-depth stack. CTA: `/portfolio`.
5. **About excerpt** — portrait + 2-paragraph bio. CTA: `/about`.
6. **Journal teaser** — latest 3 posts. CTA: `/journal`.
7. **Email capture band** — free Chapter 1 lead magnet, exit-intent duplicate.
8. **Footer** — ACISS gold underline rule, IG `@md.warren`, legal links, email.

**Components:** `Hero3D` (custom R3F), `LogoMarquee` (21st.dev Magic), `BentoGrid` (shadcn + custom), `ScrollStack` (Motion for React + CSS transform-3d), `PortraitSplit`, `JournalPreview`, `NewsletterCTA`, `FooterACISS`.

**3D/Motion signature:** Book levitates with mouse parallax (clamped ±8° x and y). On scroll past hero, camera flies toward spine and the book opens to the epigraph page. GLB ~420KB, <60 draw calls. Fallback: static hero PNG with CSS gold glow animation when `prefers-reduced-motion: reduce` is set or mobile device memory <4GB.

**Motion for React:** Section reveals at viewport threshold 0.2, stagger 60ms, ease `[0.22, 1, 0.36, 1]`. Use the `motion-specialist` project subagent + `motion-workflow` skill + Motion Studio MCP doc lookup to generate and refine reveal variants. Do not use `/motion` slash commands; Motion+ and Motion AI Kit are not active for this project.

**Copy source:** `../Last/Final edits/final/` EPUB (epigraph, chapter count, back-cover copy); brand memory (bio, positioning); `[CONFIRM headline with Michael]`.

**Mobile:** 3D hero disabled below 768px OR when reduced-motion preferred. Replaced with high-res hero image + CSS parallax on title.

**SEO:**
- Title: `Michael David Warren Jr. — Hairstylist & Author of Curls & Contemplation`
- Meta: `Rihanna's day-to-day hairstylist. Editorial work for Nike, Harper's Bazaar, W. Author of Curls & Contemplation — pre-order now.`

---

### 4.2 `/about`

**Funnel:** Credibility builder; secondary list capture.

**Section stack:**
1. **Full-bleed portrait** — editorial shot, ACISS gold underline rule.
2. **Opening essay** — 3 paragraphs, voice-led, no bullet points.
3. **Credits block** — clients + publications, two columns.
4. **Training lineage** — Guido Palau, Jimmy Paul. 1 paragraph each.
5. **Ballroom / Haus of Basquiat** — 1 paragraph + single scroll image.
6. **The ACISS ethos** — "Black leads. Gold elevates. Jade distinguishes." — set in Cinzel Decorative, gold underline.
7. **CTA** — `/the-book` + subscribe.

**Components:** `FullBleedPortrait`, `EssayColumn`, `CreditsTwoCol`, `QuoteBlockACISS`, `NewsletterCTA`.

**3D/Motion signature:** Scroll-stacked portraits with z-depth parallax using `will-change: transform` and CSS `perspective` only; no R3F.

**Copy source:** `../Last/Final edits/final/` EPUB back matter bio, brand memory, `[CONFIRM credits list final form]`.

---

### 4.3 `/the-book`

**Funnel:** Primary pre-order conversion page.

**Section stack:**
1. **Hero** — 3D book cover with spine-open animation. Dual CTA (`Pre-order $17.99` / `Read Chapter 1 free`). Release date countdown.
2. **Proof bar** — publication logos + 1-line quotes from Tier 1 testimonials. `[CONFIRM final testimonials]`.
3. **What's inside** — 4-tile grid, one per Part. Each tile expands on click.
4. **Author insert** — portrait + 2-paragraph bio, link to `/about`.
5. **Testimonials carousel** — 5 full testimonials. `[CONFIRM list]`.
6. **Pricing card** — Launch $17.99 / Regular $19.99 / Kindle $9.99 link-out / KDP paperback $29.99 link-out. Free workbook bundle badge. "Charge now. Delivered on release day."
7. **FAQ accordion** — 8 questions.
8. **Sticky mobile CTA** — persistent "Pre-order $17.99" button below 768px.

**Components:** `Hero3DBook`, `LogoMarquee`, `PartsBento`, `AuthorInsert`, `TestimonialCarousel` (21st.dev), `PricingCard`, `FAQAccordion`, `StickyCTA`.

**3D/Motion signature:** Book cover 3D (same GLB as home, reused). On scroll into view, book rotates 180° to show spine; on further scroll, pages fan open revealing TOC preview.

**Copy source:** `../Last/Final edits/final/` EPUB (Part intros, chapter titles, back-cover copy); testimonials `[CONFIRM]`; pricing locked.

**SEO:**
- Title: `Curls & Contemplation — The Freelance Hairstylist's Guide by Michael David Warren Jr.`
- Schema: Book with ISBN `[CONFIRM]`, author Person.

---

### 4.4 `/chapters`

**Funnel:** Pre-order secondary; list capture.

**Section stack:**
1. **Hero** — "16 chapters. 4 parts. One freelance hairstylist's guide."
2. **3D Ring Carousel** — all 16 chapter cards in a 3D ring, drag to rotate.
3. **Part filter** — tap Part I/II/III/IV.
4. **Pre-order CTA band** — sticky.

**Components:** `ChaptersRing3D` (R3F custom), `PartFilter`, `StickyCTA`.

**Copy source:** `../Last/Final edits/final/` EPUB — chapter list verified against EPUB parse:

- **Part I — Foundations of Creative Excellence:** 1. Unveiling Your Creative Odyssey · 2. Refining Your Creative Toolkit · 3. Reigniting Your Creative Fire · 4. The Art of Networking in Freelance Hairstyling
- **Part II — Growing Your Craft and Career:** 5. Cultivating Creative Excellence Through Mentorship · 6. Mastering the Business of Hairstyling · 7. Embracing Wellness and Self-Care · 8. Advancing Skills Through Continuous Education
- **Part III — Leadership and Legacy:** 9. Stepping Into Leadership · 10. Crafting Enduring Legacies · 11. Advanced Digital Strategies for Freelance Hairstylists · 12. Financial Wisdom: Building Sustainable Ventures
- **Part IV — The Future of the Craft:** 13. Embracing Ethics and Sustainability in Hairstyling · 14. The Impact of AI on the Beauty Industry · 15. Cultivating Resilience and Well-Being in Hairstyling · 16. Tresses and Textures: Embracing Diversity in Hairstyling

**Mobile:** Ring becomes horizontal swipe deck below 768px.

---

### 4.5 `/chapter/:slug`

**Funnel:** Pre-order + list capture via per-chapter hook.

**Section stack:**
1. **Chapter opener** — large Part + number, Cinzel Decorative title, drop-cap first paragraph.
2. **Opening hook** — first ~200 words pulled from `../Last/Final edits/final/` EPUB.
3. **Pull-quote reveal** — 3 pull-quotes, revealed on scroll with gold underline wipe.
4. **Continue reading CTA** — pre-order button + free workbook.
5. **Next/prev chapter nav** — arrow links.

**Components:** `ChapterOpener`, `DropCap`, `PullQuoteReveal`, `InlineCTA`, `ChapterNav`.

**Copy source:** 100% from `../Last/Final edits/final/` EPUB parse. Per chapter: opening hook, 3 pull-quotes.

---

### 4.6 `/workbook`

**Funnel:** Primary list capture.

**Section stack:**
1. **Hero** — "The *Curls & Contemplation* workbook. Free. Yours." + 3D layered paper stack.
2. **What's inside** — 3 bullet points from `../Last/Final edits/final/` EPUB worksheet content.
3. **Email capture form** — name + email. Turnstile. Submits to MailerLite group `182303148544623709`, triggers Sequence A.
4. **Post-submit state** — "Check your inbox" + resend link.
5. **Social proof mini** — "Join X other stylists" counter pulled from MailerLite API (cached 1h).

**Components:** `Hero3DPaperStack`, `BulletList`, `SubscribeForm`, `SubscribeSuccess`, `SubscriberCount`.

---

### 4.7 `/portfolio`

**Funnel:** Booking secondary; credibility.

**Section stack:**
1. **Hero** — "Editorial. Celebrity. Commercial."
2. **Category filter** — Covers / Editorial / Beauty / Red Carpet / Commercial / Motion.
3. **Masonry grid** — 72 credited portfolio images from v1.0 designer handoff.
4. **CTA band** — `/services` booking.

**Components:** `CategoryTabs`, `MasonryGrid` (21st.dev + custom), `ImageLightbox`.

---

### 4.8 `/services`

**Funnel:** Primary booking inquiry.

**Section stack:**
1. **Hero** — "Book Michael."
2. **Service tiers** — Editorial day rate / Red carpet / Commercial / Brand consultation.
3. **Process** — 4 steps.
4. **Inquiry form** — Turnstile.
5. **FAQ** — booking-specific.

**Components:** `ServiceTiers`, `ProcessSteps`, `InquiryForm`, `FAQAccordion`.

---

### 4.9 `/press`

**Funnel:** Booking + credibility secondary.

**Section stack:** Hero → logo marquee → feature grid → press inquiry CTA.

---

### 4.10 `/journal`, `/journal/:slug`

**Journal index:** Hero + topic filter + card grid.
**Journal post:** Reading progress bar, pull-quote reveals, subscribe CTA at 40% and 90%, related posts at bottom.

**Seed content (launch window):** 3 posts mapped from book chapters:
1. "Pricing With Confidence: What Freelance Hairstylists Get Wrong" (Chapter 6 + 12)
2. "Networking Without Selling Out" (Chapter 4)
3. "Burnout Is a Business Problem, Not a Personal One" (Chapter 7 + 15)

**Ongoing cadence:** 2 posts/month year 1.

---

### 4.11 `/contact`, `/checkout`, `/thank-you`, `/portal/:token`

**`/contact`:** General inquiries form. Routes by dropdown.
**`/checkout`:** Two-step. Email + name → Stripe Payment Element. No 3D.
**`/thank-you`:** Confirmation, order summary, portal link, countdown, subtle gold confetti.
**`/portal/:token`:** Pre-launch: countdown + order details. Post-launch: EPUB + PDF + workbook download buttons (token-gated, 3 downloads, 7-day expiry).

---

### 4.12 `/privacy`, `/terms`, `/refund-policy`

Standard legal pages. Refund policy: 14-day for digital, pre-order refundable any time before RELEASE_DATE, post-launch refundable within 14 days if <30% downloaded. `[CONFIRM final copy]`.

---

## 5. Three-Funnel Architecture

### 5.1 Funnel A — Book Pre-Order (Primary Revenue)

```
/ or /the-book → CTA → /checkout → Stripe charge-now → /thank-you
  → portal_token emailed via Resend → /portal/:token (pre-launch state)
  → [T = RELEASE_DATE] → cron /api/cron/release-ebook fires ONCE
  → download_tokens created → Resend delivery emails queued
  → portal flips to post-launch state
```

**Stripe setup:**

```bash
stripe products create --name "Curls & Contemplation — Pre-Order" \
  --description "EPUB + PDF + free workbook. Charged now, delivered on release day." \
  --metadata[release_date]="2026-XX-XX" \
  --metadata[format]="epub+pdf+workbook"
stripe prices create --product prod_XXX --unit-amount 1799 --currency usd
```

Store `price_id` as `STRIPE_PRICE_BOOK_PREORDER`.

**RELEASE_DATE cron:**

```
POST /api/cron/release-ebook
Auth: Bearer ${CRON_SECRET}
Schedule: Manual trigger on launch day
Action:
  1. SELECT all orders WHERE status='succeeded' AND NOT EXISTS (related download_token)
  2. FOR each order: create 3 download_tokens (epub, pdf, workbook) with 7-day expiry, 3-use max
  3. enqueue Resend email with signed download links
  4. Update site state flag (RELEASED=true)
  5. Log count + failures
```

**Edge cases:**

| Case | Behavior |
|------|----------|
| Refund before RELEASE_DATE | Stripe refund → webhook → order.status='refunded' → no token created |
| Refund after RELEASE_DATE | Stripe refund → webhook → revoke download_tokens → refund confirmation |
| Failed card | Stripe error display → no order created |
| Duplicate order | Allowed. Second order gets second portal_token |
| International buyer | Accept. No VAT collection in MVP |
| Gift purchase | Deferred. Current flow delivers to payer's email |
| Bulk order (>5 copies) | Deferred. Contact form routes to Michael |

### 5.2 Funnel B — Email List + Lead Magnet

```
/workbook or exit-intent → SubscribeForm (Turnstile) → POST /api/subscribe
  → add to MailerLite group 182303148544623709 + tag lead-magnet="workbook"
  → trigger Sequence A
  → Resend immediate delivery: free Chapter 1 + worksheet PDF
```

**MailerLite Sequence A (5 emails, 12 days):** Day 0 welcome + magnet, Day 2 story, Day 5 value (Ch 6 excerpt), Day 8 social proof, Day 12 soft sell.

### 5.3 Funnel C — Booking Inquiry

```
/services → InquiryForm (Turnstile) → POST /api/booking
  → Resend transactional to hello@michaeldavidjr.beauty
  → MailerLite tag "inquiry"
  → Resend auto-reply with rate sheet PDF + 48-hour response promise
```

---

## 6. Design System — ACISS Implementation

### 6.1 Tailwind Config

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

### 6.3 Component Primitives

| Primitive | Source |
|-----------|--------|
| Button, Accordion, Dialog, Input/Form | shadcn |
| Hero with 3D | Custom (R3F) |
| Logo marquee, Testimonial carousel, Bento grid | 21st.dev Magic |
| Pricing card, Sticky CTA, Footer | Custom ACISS |

### 6.4 Motion Language

**Library:** Motion for React (`motion`), imported from `"motion/react"`. Do NOT install or import from `framer-motion`.

```bash
pnpm add motion
```

```ts
import { motion, useReducedMotion, useScroll } from "motion/react"
```

For server components in Next.js 14 App Router, use `motion/react-client`.

**Easing tokens** (`app/motion.ts`):

```ts
export const ease = {
  smooth: [0.22, 1, 0.36, 1],
  emphasis: [0.65, 0, 0.35, 1],
  swift: [0.4, 0, 0.2, 1],
};
export const duration = {
  fast: 0.18, base: 0.32, slow: 0.56, emphasis: 0.82,
};
```

**Defaults:** Section reveals `viewport={{ once: true, amount: 0.2 }}`, stagger 60ms, ease `smooth`, duration `base`.

**Reduced motion:** `useReducedMotion()` wraps every motion component. When true: opacity-only reveals.

**Claude Code integration:**
- Motion Studio MCP registered → latest Motion docs and examples
- `motion-specialist` project subagent — repeat-use animation worker
- `motion-workflow` project skill — reusable playbook
- Motion+ and Motion AI Kit are skipped for this project
- `/motion` slash-command workflows disabled unless Motion+ is later activated

### 6.5 3D Language

**Global setup:**
- Lenis smooth scroll, lerp 0.1, wraps `<body>`
- R3F canvas mounted only on routes that use 3D
- Drei for `useGLTF`, `Environment`, `PerspectiveCamera`, `Html`
- **Performance budget per scene:** <80 draw calls, <200k triangles, GLB <500KB, zero animation loops on idle

**Per-page 3D moments:**

| Page | 3D moment | Asset | Cost |
|------|-----------|-------|------|
| `/` hero | Floating book, mouse parallax, scroll-driven page-open | `book.glb` | ~420KB, 60 DC |
| `/the-book` hero | Book rotates to spine, pages fan open | `book.glb` (reused) | 0KB marginal |
| `/chapters` ring | 16 card meshes, drag rotation | inline | ~200KB |
| `/portal/:token` | Book cover static with jade glow | `book.glb` (reused) | 0KB marginal |
| `/about` | CSS-only z-depth parallax | — | 0KB |
| `/workbook` | CSS paper stack tilt | — | 0KB |

**3D fallback rules:** `prefers-reduced-motion: reduce` OR `navigator.deviceMemory < 4` OR viewport <768px+mobile UA → static fallback. 3D canvas lazy-mounts after LCP.

**Lighting recipe:**
```
PerspectiveCamera: fov 35, position [0, 0, 3.2]
Environment: "studio", intensity 0.3
directionalLight: gold #B08D57, intensity 1.2, position [2, 2, 3]
pointLight: jade #145B4B, intensity 0.4, position [-2, -1, 1]
Background: Obsidian #111111
```

---

## 7. SEO & Discoverability Strategy

### 7.1 Keyword Map

**Primary (target top-3 within 12 months):** `Curls and Contemplation book`, `Michael David Warren hairstylist`, `Rihanna hairstylist`, `Black celebrity hairstylist Los Angeles`, `freelance hairstylist book`.

**Secondary (target top-10 within 6 months):** `editorial hair stylist Los Angeles`, `celebrity hairstylist author`, `hairstylist mentorship book`, `Black hairstylist mentor`, `Haus of Basquiat`, `ballroom hairstylist`, `nervous system beauty`, `hair stylist wellness book`, `freelance hairstylist business`, `hairstylist creative burnout`.

**Long-tail (20+ from book chapters):** pricing, networking, burnout, mentorship, financial wisdom, AI in beauty, sustainability, day rates, leadership, wellness, Rihanna day-to-day, how to become celebrity hairstylist, editorial techniques, Guido Palau student, self-care routine, business advice, diverse hair textures, continuing education, legacy building.

### 7.2 On-Page SEO Formulas

| Element | Formula |
|---------|---------|
| Title tag | `{Page benefit} — {Michael David Warren Jr. / Curls & Contemplation}` · 50-60 chars |
| Meta description | Benefit + credit + CTA · 140-155 chars |
| H1 | One per page, matches hero headline |
| H2 | 3-7 per page, keyword-natural |
| Internal link rule | Every page → `/the-book` + one adjacent page |
| Image alt | `{subject}, {context}, by Michael David Warren Jr.` |
| Canonical | Self-referential |

### 7.3 Schema.org JSON-LD

Emit on every relevant page:

```jsonc
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

Also emit: Person, Organization, LocalBusiness, FAQPage, Article.

### 7.4 Technical SEO

- `sitemap.xml` — auto-generated by `app/sitemap.ts`
- `robots.txt` — disallow `/admin`, `/portal`, `/api`, `/thank-you`
- Open Graph + Twitter cards per-page with 1200×630 images
- Core Web Vitals gate — LCP <2.5s, FID <100ms, CLS <0.1

### 7.5 Content Velocity Plan

2 posts/month = 24 posts year 1. Each 1,200-2,000 words targeting one long-tail keyword. Seed 3 posts at launch; next 3 drafts queued for Weeks 2-5.

---

## 8. Plugin & Tool Pipeline — Build Order

Thirteen phases (Phase 0 prerequisite + twelve build phases).

### Phase 0 — Claude Code Installed & Repos Ready

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

```bash
# Clone destination + source
git clone https://github.com/miketui/Author-SIte.git
cd Author-SIte
cd ..
git clone https://github.com/miketui/Last.git Last
cd Author-SIte
claude
```

**Verification:**
- `claude doctor` green
- `git remote -v` in `Author-SIte/` shows origin = `https://github.com/miketui/Author-SIte.git`
- `../Last/Final edits/` exists and contains EPUB, PDF, OEBPS/, and `Claude-code/chatgpt_command_registry_v1.json`

### Phase 1 — Install All 6 Claude Code Plugins

```bash
/plugin install obra/superpowers
/plugin install anthropic/frontend-design
/plugin install anthropic/code-review
/plugin install anthropic/security-guidance
/plugin install nicholasgasior/claude-mem
/plugin install garrytan/gstack
```

**Verification:** `/plugins` lists all six.

### Phase 2 — Design Stack (Direct Install)

**2.1 UI/UX Pro Max:**

```bash
npm install -g uipro-cli
uipro init --ai claude
```

Manual fallback:

```bash
git clone https://github.com/nextlevelbuilder/ui-ux-pro-max-skill.git /tmp/uiux
mkdir -p .claude/skills
cp -R /tmp/uiux/.claude/skills/ui-ux-pro-max .claude/skills/
rm -rf /tmp/uiux
```

**2.2 21st.dev Magic:**

```bash
export MAGIC_API_KEY="<key>"
npx @21st-dev/cli@latest install claude --api-key $MAGIC_API_KEY
```

Fallback (direct MCP):

```bash
claude mcp add --scope project --transport stdio @21st-dev/magic \
  --env API_KEY=$MAGIC_API_KEY \
  -- npx -y @21st-dev/magic@latest
```

**2.3 Motion + Motion Studio MCP:**

```bash
pnpm add motion
claude mcp add-json --scope project motion '{
  "type": "stdio",
  "command": "npx",
  "args": ["-y", "https://api.motion.dev/registry.tgz?package=motion-studio-mcp&version=latest"]
}'
```

**Motion+ and Motion AI Kit: SKIP** per §14 item 14.

**Verification:**
```bash
grep -R "framer-motion" . || echo "clean"
grep '"motion"' package.json
claude mcp list | grep -E "motion|21st"
ls .claude/skills/ui-ux-pro-max/SKILL.md
```

### Phase 3 — Stack Scaffold with gstack

```bash
/gstack init michaeldavidjr-site \
  --framework nextjs@14 --router app \
  --styling tailwind+shadcn \
  --3d "react-three-fiber,drei,three" \
  --scroll lenis --motion motion \
  --payments stripe --email resend --marketing mailerlite \
  --db vercel-postgres --analytics ga4,vercel \
  --error-tracking sentry --bot-protection cloudflare-turnstile
```

Fallback manual scaffold via `create-next-app` + explicit `pnpm add`.

### Phase 4 — Content Extraction & Command Registry Audit

**4.1 Book content:**

```
/superpowers research "parse ../Last/Final edits/final/ EPUB plus any needed XHTML/CSS assets from ../Last/Final edits/OEBPS/, extract TOC + pull-quotes + chapter openings per schema in PRD §2.4, write lib/book-data.ts"
```

**4.2 Command registry normalization:**

```
/superpowers research "read ../Last/Final edits/Claude-code/chatgpt_command_registry_v1.json as the canonical source-of-truth for Michael's command system. Copy it into config/command-registry.source.json, cross-reference any supplementary references found in docs/reference/commands/, treat the JSON as canonical if conflicts exist, and produce: (1) docs/command-migration.md, (2) docs/command-catalog.md, (3) the Bucket A skill/command install plan, (4) the Bucket B router doctrine list for CLAUDE.md, and (5) the Bucket C token catalog per §8.5 Bucket execution rules."
```

**Expected outputs:**
- `lib/book-data.ts` populated
- `config/command-registry.source.json` frozen
- `docs/command-migration.md` with three-bucket plan + "Reconciled conflicts" section
- `docs/command-catalog.md` grouped by category with one example per token
- `.claude/skills/{ghost,godmode,layered,unpack,livecode,investigate}/SKILL.md` created
- `CLAUDE.md` router doctrine block populated

**Verification:**
- `pnpm test lib/book-data.test.ts` passes
- `ls .claude/skills/` shows the six migrated command skills
- `ls config/command-registry.source.json` returns the frozen copy
- `grep -l "AUTO::DETECT+ROUTE" CLAUDE.md` returns a match

### Phase 5 — Design Generation

```
/frontend-design generate --page home --brief "ACISS palette obsidian #111111 / gold #B08D57 / jade #145B4B, Cinzel Decorative display, Cormorant Garamond serif, Inter UI. Hero: 3D book floating in obsidian void with gold rim light. Tone: editorial, restrained, craft-first."
/uiux-pro-max apply --theme aciss --pairing cinzel-cormorant-inter --style editorial-luxury
```

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

### Phase 7 — 3D Layer Assembly

Hand-authored:
- `components/hero/Hero3D.tsx` — R3F Canvas with `useGLTF('/models/book.glb')`
- `components/chapters/ChaptersRing3D.tsx` — 16 cards on circle, drag rotation
- `components/workbook/PaperStack3D.tsx` — CSS-only
- `components/layout/LenisProvider.tsx`

### Phase 8 — Motion Layer

**8.1** Install `motion` (if Phase 3 used manual fallback): `pnpm add motion`.

**8.2** Motion Studio MCP at project scope:

```bash
claude mcp add-json --scope project motion '{
  "type": "stdio",
  "command": "npx",
  "args": ["-y", "https://api.motion.dev/registry.tgz?package=motion-studio-mcp&version=latest"]
}'
```

**8.3** Motion AI Kit — **SKIP** (Motion+ not active).

**8.4** Create `.claude/agents/motion-specialist.md` (Motion-specialist subagent).

**8.5** Create `.claude/skills/motion-workflow/SKILL.md`.

**8.6** Append Motion rules to `CLAUDE.md`.

**8.7** Apply motion to every page per §6.4 defaults using `motion-specialist` subagent + `motion-workflow` skill.

**8.8** Manual motion audit via `motion-specialist`:

```
Use motion-specialist to audit all Motion usage under src/components and src/app. Check for layout thrash, excessive repaints, oversized transforms, missing useReducedMotion gates, and any framer-motion imports. Produce a findings report at docs/motion-audit.md.
```

**Verification:**
- `pnpm list motion` returns a version; no `framer-motion`
- `/mcp` shows `motion` connected
- `.claude/agents/motion-specialist.md` + `.claude/skills/motion-workflow/SKILL.md` present
- `CLAUDE.md` has Motion rules block
- All motion-using components have `"use client"`

### Phase 9 — Integrations

**Stripe:** Webhook `app/api/stripe/webhooks/route.ts` verifies signature, routes `payment_intent.succeeded` → create order → portal_token → Resend confirmation.

**Resend:** Templates in `emails/`. Verify domain in Resend dashboard.

**MailerLite:** `lib/mailerlite.ts` wraps SDK. Subscribe endpoint adds to group `182303148544623709` + Sequence A.

**Sentry:** `pnpm dlx @sentry/wizard@latest -i nextjs`.

**GA4 + Vercel Analytics:** `<Analytics />` + GA4 via `next/script`.

**Cloudflare Turnstile:** Site key in frontend, secret in backend validator.

### Phase 10 — Security Pass

```
/security-review scan --depth deep
```

Targets: no secrets in client bundles, `/api/admin/*` auth-gated, rate limits on public endpoints, CSRF tokens, time-limited+usage-limited download tokens, private book files in `private/`.

### Phase 11 — Code Review Pass

```
/code-review --scope all --focus accessibility,performance,types,dead-code
```

Minimum bar: no `any` types, no components >300 lines, Lighthouse a11y ≥95.

### Phase 12 — Memory Capture + Deploy

```
/claude-mem save --project michaeldavidjr-site --topics "ACISS palette, 3D book hero, charge-now pre-order, MailerLite group 182303148544623709, RELEASE_DATE cron, canonical command registry at config/command-registry.source.json"
```

```bash
pnpm dlx vercel link
pnpm dlx vercel --prod
```

DNS at Namecheap: CNAME `www` → `cname.vercel-dns.com`; A `@` → `76.76.21.21`.

---

### 8.5 Skills, Commands & MCP Policy

Four distinct tool layers. Keep them separated.

| Layer | What it is | Where it lives | How it's invoked | Examples |
|-------|------------|----------------|------------------|----------|
| **Plugin** | Claude Code extension via `/plugin install <source>` | `~/.claude/plugins/<n>/` | `/plugin` commands | `obra/superpowers`, `anthropic/frontend-design`, `anthropic/code-review`, `anthropic/security-guidance`, `nicholasgasior/claude-mem`, `garrytan/gstack` |
| **MCP server** | Running process Claude Code talks to via stdio/SSE | `.mcp.json` (project) or `~/.claude.json` (local) | Tool calls during reasoning | `motion` (Motion Studio), `@21st-dev/magic` |
| **Skill** | Reusable procedure in `SKILL.md` | `.claude/skills/<n>/SKILL.md` | Trigger keywords or `/skills` | `ui-ux-pro-max`, `motion-workflow`, `ghost`, `godmode`, `layered`, `unpack`, `livecode`, `investigate` |
| **Command** | Legacy slash-command file | `.claude/commands/<n>.md` | Direct slash invocation | Fallback only |

**Rule 1 — Router doctrine lives in `CLAUDE.md`.** `AUTO::DETECT+ROUTE`, `AGM`, `SALES13`, `PROMPTLIB` are router directives, not tools.

```md
## Router Doctrine (project-scoped, always-on)

AUTO::DETECT+ROUTE — silently classify every message and route to the appropriate skill/tool/command. Announce the route in one line before responding.

AGM (Activate Genius Mode) — when user types "AGM" or "Activate Genius Mode", apply the Engineer's Template: rewrite raw input into a structured prompt with SYSTEM CONTEXT, CHAIN-OF-THOUGHT REQUIREMENT, OUTPUT FORMAT, CALIBRATION EXAMPLE, TASK, SECURITY NOTE. Present under "ENGINEERED PROMPT — AWAITING APPROVAL" and wait for "go" before executing.

SALES13 — on any offer/launch/pitch/copy/brand task, apply the 13-point persuasion doctrine silently.

PROMPTLIB::ROUTE — if a task matches a workflow in Michael's prompt library, invoke that workflow's skill explicitly and cite the match in one line.
```

**Rule 2 — Command registry migration.** The canonical source is `config/command-registry.source.json` (frozen from `../Last/Final edits/Claude-code/chatgpt_command_registry_v1.json`). Supplementary PDFs in `docs/reference/commands/` are optional reference only and never override the JSON. Phase 4 produces `docs/command-migration.md` classifying each entry into one of three buckets:

| Bucket | Destination | Example entries |
|--------|-------------|-----------------|
| **A. Install as project skill** | `.claude/skills/<n>/SKILL.md` | `ghost`, `godmode`, `layered`, `unpack`, `livecode`, `investigate` |
| **B. Codify in CLAUDE.md router** | Router Doctrine block | `AUTO::DETECT+ROUTE`, `AGM`, `SALES13`, `PROMPTLIB`, `ACTIVATE::SALES13+PROMPTLIB`, `Normal mode` |
| **C. Document in reference catalog** | `docs/command-catalog.md` | `BLUF`, `TLDR`, `WHY5`, `INVERT`, `STEEL`, `DEVIL`, `BAYES`, `2ND`, `FIRST`, `OODA`, `TREE`, `SCOPE`, `SWOT`, `PRD`, `JTBD`, `OKR`, `RICE`, `PITCH`, `AUDIT`, `SEC`, `CHAIN`, `RECAP` |

### Bucket execution rules

#### Bucket A — install as project skill or legacy command

These are executable behaviors and become project-scoped Claude assets inside the destination repo.

Preferred destination:
- `.claude/skills/<n>/SKILL.md`

Legacy fallback only when the behavior is extremely small and does not justify a full skill:
- `.claude/commands/<n>.md`

Initial Bucket A set:
- `ghost`
- `godmode`
- `layered`
- `unpack`
- `livecode`
- `investigate`

Rules:
- Prefer one skill folder per behavior.
- Preserve behavior from the canonical JSON registry first.
- If a supplementary PDF adds helpful wording, merge it only when it does not conflict with the JSON.
- Do not install Bucket A entries as plugins.
- Do not install Bucket A entries as MCP servers.

Artifacts to produce:
- `.claude/skills/ghost/SKILL.md`
- `.claude/skills/godmode/SKILL.md`
- `.claude/skills/layered/SKILL.md`
- `.claude/skills/unpack/SKILL.md`
- `.claude/skills/livecode/SKILL.md`
- `.claude/skills/investigate/SKILL.md`

#### Bucket B — codify in router doctrine

These are not installables. They are behavioral directives and routing logic.

Destination:
- `CLAUDE.md`

Initial Bucket B set:
- `AUTO::DETECT+ROUTE`
- `AGM`
- `Normal mode`
- `ACTIVATE::SALES13+PROMPTLIB`
- `SALES13::*`
- `PROMPTLIB::*`

Rules:
- Codify these as doctrine, activation rules, and routing logic in `CLAUDE.md`.
- Do not create MCP entries for them.
- Do not create plugin installs for them.
- Only create a `.claude/skills/router/` skill if the downstream session needs a reusable router workflow, but the source of truth remains `CLAUDE.md`.

Artifacts to produce:
- `CLAUDE.md` router-doctrine block
- optional: `.claude/skills/router/SKILL.md` only if needed for reuse

#### Bucket C — document only

These are modifiers, reasoning tokens, formatting tokens, and planning cues. They should be documented, not installed as standalone tools.

Destination:
- `docs/command-catalog.md`

Examples:
- output tokens: `BLUF`, `TLDR`, `LONG`, `DENSE`
- reasoning tokens: `WHY5`, `FIRST`, `OODA`, `TREE`
- business/code/meta tokens: `SWOT`, `AUDIT`, `SEC`, `CHAIN`, `RECAP`

Rules:
- Document exact meaning from the canonical JSON registry.
- Group by category.
- Add one short example per token when helpful.
- Do not install Bucket C items as plugins, MCP servers, or separate skills unless the PRD is later amended.

Artifacts to produce:
- `docs/command-catalog.md`

**Rule 3 — Optional community skills.**

| Skill | Source | Posture | Rationale |
|-------|--------|---------|-----------|
| **`emilkowalski/skill`** | Emil Kowalski's animation skill | **Local-source-only.** If Michael provides a reviewed local copy under `community-skills/emilkowalski/`, setup stages it into `docs/community-skills-reviewed-emilkowalski/` for manual review before activation. If no local source is provided, skip and document in `docs/community-skills-reviewed.md`. | Skill may predate the `motion` rename. No GitHub clone during install — local review only. |
| **`pbakaus/impeccable`** | Paul Bakaus's design-quality skill | **Install to project** after one-pass review | Aesthetic discipline skill. Safe to activate. |
| **`Leonxlnx/taste-skill`** | Leon's "taste" skill | **Source-verification gate** — verify repo owner, last commit, open issues before install. Red flags → document-only. | "Taste" is subjective. Read end-to-end before activating. |

**Install sequence:**

```bash
# emilkowalski/skill — local-source-only
if [ -d "community-skills/emilkowalski" ]; then
  cp -R community-skills/emilkowalski docs/community-skills-reviewed-emilkowalski
  echo "Staged for manual review"
else
  echo "emilkowalski: no local source provided — skipped and documented"
fi

# pbakaus/impeccable — install with one-pass review
git clone https://github.com/pbakaus/impeccable.git /tmp/impeccable
cp -R /tmp/impeccable/.claude/skills/impeccable .claude/skills/
rm -rf /tmp/impeccable

# Leonxlnx/taste-skill — source-verification gate
git clone https://github.com/Leonxlnx/taste-skill.git /tmp/taste
cp -R /tmp/taste docs/community-skills-reviewed-taste
# Activate only after manual verify
rm -rf /tmp/taste
```

**Rule 4 — No skill ever installs a library on its own behalf.** If a community skill's `SKILL.md` says "install X dependency," do NOT run it blindly. Library installs go through `package.json`. MCP installs go through §8.5 policy.

**Rule 5 — Layer separation at review time.** Phase 11 code review must confirm:

- No `framer-motion` string anywhere in generated code.
- No MCP server registered outside the approved set: `motion`, `@21st-dev/magic`, plus any explicitly-added third-party.
- No plugin outside the approved six.
- No skill in `.claude/skills/` not approved in this §8.5.
- `CLAUDE.md` contains Router Doctrine block + Bucket B entries 1:1.
- `config/command-registry.source.json` exists and matches source repo JSON byte-for-byte (or with documented delta).
- `docs/command-migration.md` accounts for every entry in canonical JSON.
- `docs/command-catalog.md` lists every Bucket C token.
- No command derived exclusively from a PDF is installed as a skill unless the JSON also includes it.

---

## 9. Installation & API Key Walkthrough

### 9.0 Inventory

**Owned (env var only):** 21st.dev Magic, UI/UX Pro Max, MailerLite (group `182303148544623709`), Vercel, Namecheap (domain).

**Needs setup:** Stripe, Resend (+ domain verification), Cloudflare Turnstile, Sentry, GA4, Google Search Console.

**Conditional:** Motion Studio MCP (free, always install); Motion+ token (only if subscribed).

### 9.1–9.12 Service Setup

Individual service setup details: Stripe API keys + webhook secret + price ID; MailerLite developer API token; Resend API key + domain verification via SPF/DKIM/DMARC records; Vercel hosting + Postgres + cron; Sentry via wizard; GA4 measurement ID; Google Search Console DNS TXT verify; Cloudflare Turnstile site key + secret; 21st.dev/UI-UX Pro Max env keys; admin env vars (`ADMIN_USERNAME`, `ADMIN_PASSWORD`, `ADMIN_API_KEY`, `CRON_SECRET`); Motion package free + optional Motion+ token.

### 9.13 `.env.example`

```bash
# Site
NEXT_PUBLIC_SITE_URL=https://michaeldavidjr.beauty
NODE_ENV=development
RELEASE_DATE=2026-XX-XXT08:00:00-07:00

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

# Database
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

Inherit v1.0 §5 tables. Production on Vercel Postgres. Local dev SQLite via `better-sqlite3` with compat layer. Drizzle ORM.

### 10.2 API Endpoints

Inherit v1.0 §6 endpoints. v2.0 additions:

| Method | Endpoint | Purpose | Auth |
|--------|----------|---------|------|
| POST | `/api/booking` | Booking inquiry | Turnstile |
| GET | `/api/book-data` | Book metadata | Public |
| GET | `/api/3d-assets/signed-url` | Signed URL for GLB | Public, rate-limited |

### 10.3 Auth & Rate-Limit Matrix

| Endpoint | Auth | Rate limit |
|----------|------|------------|
| `/api/subscribe`, `/api/booking`, `/api/free-resource` | Turnstile | 5/min per IP |
| `/api/checkout` | Turnstile | 10/min per IP |
| `/api/stripe/webhooks` | Stripe signature | unlimited |
| `/download/:token` | Token | 10/5min per IP |
| `/api/portal/:token` | Token | 30/min per IP |
| `/api/cron/*` | Bearer `CRON_SECRET` | unlimited |
| `/api/admin/*` | Session or API key | 60/min per session |

---

## 11. Email Automation

### 11.1 Transactional (Resend)

| Template | Trigger | Subject |
|----------|---------|---------|
| `order-confirmation.tsx` | Stripe `payment_intent.succeeded` | "Your pre-order is in, `{name}`." |
| `portal-link.tsx` | Same | Included in above |
| `release-day-delivery.tsx` | `/api/cron/release-ebook` | "*Curls & Contemplation* is yours." |
| `refund-notice.tsx` | Stripe `charge.refunded` | "Refund processed." |
| `lead-magnet-delivery.tsx` | `/api/subscribe` with magnet flag | "Your free Chapter 1 + workbook." |
| `booking-auto-reply.tsx` | `/api/booking` | "Michael will be in touch within 48 hours." |
| `booking-internal-notification.tsx` | Same | "New booking inquiry — `{name}`." |

### 11.2 Marketing (MailerLite)

**Sequence A (5 emails, 12 days):** Day 0 welcome + magnet, Day 2 story, Day 5 value (Ch 6), Day 8 social proof, Day 12 soft sell.

**Sequence B (Pre-Order):** T-7 excitement, T-1 single-word "Tomorrow.", T+0 portal link.

**Sequence C:** admin-triggered broadcasts via MailerLite UI.

---

## 12. Launch-Day Playbook

**T-30:** Pre-order opens to list. Social drops. First testimonials `[CONFIRM Tier 1]`.
**T-14:** Testimonial deadline. Press outreach round 1. Journal posts 1-3 publish.
**T-7:** Final QA, EPUB uploaded to Vercel Blob, Lighthouse run, Mail-Tester score ≥9/10.
**T-1:** Dry-run release cron on staging. Broken-link sweep.
**Launch:** Michael manually triggers `/api/cron/release-ebook`. Sentry monitored for 30 min.
**T+7:** Analytics review, first optimization cycle.
**T+30:** KDP paperback goes live on pricing card.

---

## 13. Verification & Acceptance Tests

**13.1 Lighthouse:** Performance ≥90, Accessibility ≥95, SEO ≥95, Best Practices ≥95.

**13.2 Manual QA:** Safari iPhone 13+ / Chrome Pixel 7 / Firefox desktop / Chrome desktop / Safari desktop.

**13.3 Stripe Test Cards:** `4242...` success, `4000...0002` declined, `4000...9995` insufficient, `4000...3184` 3DS.

**13.4 Email Deliverability:** SPF + DKIM + DMARC pass, Mail-Tester ≥9/10.

**13.5 WCAG 2.1 AA:** axe-core zero violations, VoiceOver pass, gold-on-obsidian ≥4.5:1.

**13.6 3D Performance:** 60fps on mid-tier Android, reduced-motion fallback verified.

**13.7 Command Registry Integrity:**
- `config/command-registry.source.json` exists and is valid JSON
- Every canonical JSON entry has a bucket assignment in `docs/command-migration.md`
- `docs/command-catalog.md` lists every Bucket C token with interpretation rule
- Any PDFs in `docs/reference/commands/` do not introduce commands missing from JSON (or are logged as "reference-only")
- `CLAUDE.md` Router Doctrine matches Bucket B entries 1:1

---

## 14. Risks, Open Questions, [CONFIRM WITH MICHAEL]

1. **RELEASE_DATE** — exact timestamp + timezone for cron + countdown.
2. **ISBN** — assigned yet? Required for Book schema.
3. **3D book cover asset — RESOLVED: Nathaniel brief.** Standalone file `Nathaniel-3D-Book-Brief.md`. 3–5 business days from acceptance. Placeholder box used until `book.glb` arrives.
4. **Tier 1 testimonial status** — responses received? (Yusef Williams, Naphia White, Naeemah LaFond, Vernon François.)
5. **Home hero headline** — placeholder is "Hair is the craft. Transformation is the calling."
6. **Logo usage rights** — confirm publications allow logo display.
7. **International pre-order VAT** — MVP ships without Stripe Tax. Risk accepted?
8. **Affirmation cards** — at launch or deferred?
9. **Current day rates** — confirm for `/services`.
10. **Paperback external links** — Amazon ASIN + B&N + Waterstones + Indigo?
11. **Legal copy** — template service or legal counsel?
12. **Admin dashboard — RESOLVED: deferred.** Only `/admin/queue-health` ships in v2.0.
13. **Signed copies program** — post-launch upsell?
14. **Motion+ subscription — RESOLVED: NO.** Skip §8 step 8.3. Route through `motion-specialist` + `motion-workflow` + Motion Studio MCP.
15. **Motion MCP scope — RESOLVED: project.** Register with `--scope project`.
16. **Next.js 14 App Router confirmed as target** — locks Motion import pattern.
17. **Optional community skills — decisions:**
    - `emilkowalski/skill` — **local-source-only**. If Michael provides a local copy under `community-skills/emilkowalski/`, setup.sh stages it for review. No GitHub clone during install. If no local source, skipped and documented.
    - `pbakaus/impeccable` — install after one-pass review.
    - `Leonxlnx/taste-skill` — source-verification gate.
    Downstream session logs decisions in `docs/community-skills-reviewed.md`.
18. **Supplementary command PDFs — optional.** If Michael wants them in the repo, he places them in `docs/reference/commands/`. Supplementary only; JSON wins conflicts.

---

## 15. File Manifest (Next.js 14 App Router + R3F)

```
Author-SIte/
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
│   │       └── trigger-release/route.ts
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
│   ├── magic/
│   ├── motion/Reveal.tsx
│   └── ui/
├── lib/
│   ├── db.ts
│   ├── stripe.ts
│   ├── resend.ts
│   ├── mailerlite.ts
│   ├── turnstile.ts
│   ├── ratelimit.ts
│   ├── book-data.ts
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
│   └── command-registry.source.json
├── community-skills/
│   └── emilkowalski/                   # optional, only if Michael provides a local copy
├── docs/
│   ├── command-migration.md
│   ├── command-catalog.md
│   ├── community-skills-reviewed.md
│   ├── community-skills-reviewed-emilkowalski/
│   ├── community-skills-reviewed-impeccable/
│   ├── community-skills-reviewed-taste/
│   ├── motion-audit.md
│   └── reference/
│       └── commands/
├── public/
│   ├── models/book.glb
│   ├── images/
│   ├── downloads/
│   └── fonts/
├── private/
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
│   └── commands/
├── .env.example
├── .env.local
├── .mcp.json
├── CLAUDE.md
├── PRD.md
├── setup.sh
├── install-prompt.md
├── kickoff-prompt-v2-2.md
├── Nathaniel-3D-Book-Brief.md
├── next.config.mjs
├── tailwind.config.ts
├── tsconfig.json
├── package.json
├── pnpm-lock.yaml
├── vercel.json
├── drizzle.config.ts
└── README.md
```

---

## 16. Final Deliverable Format (Downstream Report)

After build, downstream session reports:

1. Files created/changed.
2. Commands run.
3. Verification performed — Lighthouse, Stripe, email deliverability, 3D perf, WCAG, command registry integrity (§13.7).
4. API keys still pending.
5. Launch-date go/no-go checklist (§12).
6. claude-mem persistence confirmation.
7. Risks remaining (§14 items still open).

---

## Appendix A — 3D Book Cover Asset Brief

**Deliverable:** Single optimized GLB at `public/models/book.glb`.

**Specs:**

| Property | Target |
|----------|--------|
| Format | glTF 2.0 binary (.glb), embedded textures |
| File size | ≤500KB |
| Triangle count | ≤30,000 |
| Texture resolution | 2K front, 1K spine, 1K back, 512 pages |
| Dimensions | 6.69" × 9.61" × 1.117" (Royal trim) |
| Three.js scale | 1 unit = 1 inch |
| Pivot | Center |
| Up axis | Y-up |
| PBR | Metallic-Roughness |

**Source assets:** provide from `../Last/Final edits/OEBPS/` or `../Last/Final edits/final/`:
- Front cover PNG (high-res)
- Back cover PNG (high-res)
- Spine text spec
- ACISS palette reference

**Optional enhancements:** gold foil emissive on title; page-fan animation channel.

**Delivery:** single `.glb` + 10-second turntable MP4 for QA.

**Timeline:** 3–5 business days.

**Review criteria:** faithful to 2D cover, <500KB, correct under ACISS lighting (§6.5), 60fps on mid-tier mobile.

---

## Appendix B — Downstream Claude Code Handoff Files

The destination repo (`Author-SIte/`) must contain these handoff files with these exact names:

- `PRD.md`
- `setup.sh`
- `install-prompt.md`
- `kickoff-prompt-v2-2.md`
- `Nathaniel-3D-Book-Brief.md`

### File roles

| File | Role |
|------|------|
| `PRD.md` | canonical build spec |
| `setup.sh` | bootstrap setup script for Phases 0–2 |
| `install-prompt.md` | fresh-session install / readiness prompt |
| `kickoff-prompt-v2-2.md` | fresh-session build prompt for Phases 3–12 |
| `Nathaniel-3D-Book-Brief.md` | external 3D asset brief |

### Handoff rules

- `install-prompt.md` is used first, in a fresh Claude Code session, after cloning the destination repo.
- `kickoff-prompt-v2-2.md` is used only after the install session reports **Ready for Build? YES**.
- These files live in the destination repo, not in the source repo.
- The source repo is read-only and is consumed through:
  - `../Last/Final edits/OEBPS/`
  - `../Last/Final edits/final/`
  - `../Last/Final edits/Claude-code/`

### Canonical command registry rule

The canonical command source is:

```text
../Last/Final edits/Claude-code/chatgpt_command_registry_v1.json
```

A frozen destination snapshot must be created at:

```text
config/command-registry.source.json
```

Supplementary command PDFs, if used, belong under:

```text
docs/reference/commands/
```

They are reference-only and never override the JSON registry.

---

**END OF PRD v2.3**
