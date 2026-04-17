# 3D Book Cover Asset Brief

**Project:** *Curls & Contemplation* — Author website (michaeldavidjr.beauty)
**Client:** Michael David Warren Jr. (TAYLKOMB LLC)
**Recipient:** Nathaniel Plasabas
**Date:** April 16, 2026
**Status:** Brief — awaiting acceptance

---

## Context

The author website for *Curls & Contemplation* is being built with a 3D hero moment: the book cover floats in an obsidian void with gold rim lighting, rotates subtly on mouse parallax, and opens to the first-page epigraph when the visitor scrolls. This is the single most important visual on the site — the emotional hook that sells the pre-order.

For this to land, the book needs to be a real 3D object, not a 2D render composited in. That's the ask.

---

## Deliverable

One optimized GLB file rendering the *Curls & Contemplation* book cover in 3D.

**File name:** `book.glb`
**Final location on site:** `public/models/book.glb`

---

## Technical Specs

| Property | Target |
|----------|--------|
| Format | glTF 2.0 binary (`.glb`), single file, textures embedded |
| File size | **≤500 KB** — optimized via `gltf-transform optimize` |
| Triangle count | **≤30,000** |
| Texture resolution | 2K front cover, 1K spine, 1K back cover, 512px pages |
| Book dimensions | **6.69" × 9.61" × 1.117"** (Royal trim — matches KDP print spec) |
| Three.js scale | 1 unit = 1 inch |
| Pivot point | Center of book |
| Up axis | **Y-up** |
| Materials | PBR metallic-roughness workflow |

### Material breakdown

- **Front and back covers:** cover art PNG as `baseColor`, subtle normal map for the coated paper texture
- **Spine:** title text embossed via normal map (no separate geometry — keep tri count low)
- **Pages (edge):** cream/off-white baseColor with procedural edge noise to read as stacked paper
- **Optional gold foil on title:** metallic roughness map + low-intensity emissive (makes the gold read under the site's gold rim light — see lighting note below)

### Lighting context (for your QA — not baked into the asset)

The site renders the book under:
- 1 key light (warm, top-left, intensity 1.2)
- 1 rim light (gold `#B08D57`, back-right, intensity 0.8) — this is the ACISS brand gold
- Ambient environment at 0.3 (HDRI not used — keep the asset readable under direct lighting only)

Please verify the asset reads correctly under those conditions before delivery.

---

## Source Assets (Michael will provide)

- [ ] Front cover PNG — high-res, final print version
- [ ] Back cover PNG — high-res, final print version
- [ ] Spine text specification (title + author, font, placement)
- [ ] ACISS palette reference card (Obsidian `#111111` / Antique Gold `#B08D57` / Deep Jade `#145B4B`)
- [ ] Reference photo of a physical book for paper stack texture (if helpful)

Michael will send these upon brief acceptance.

---

## Optional Enhancements (if budget/time allow)

These are stretch goals — not required for first delivery:

1. **Page-fan animation** — a separate GLTF animation channel that gently fans the pages open. Downstream build session can trigger this via Three.js `useAnimations`.
2. **Cover opening animation** — second animation channel where the front cover rotates open 90° to reveal page one. Triggered on scroll.
3. **Gold foil emissive on title** — makes the title catch light realistically under the site's rim lighting recipe.

---

## Delivery Format

- One `.glb` file (primary deliverable)
- One 10-second turntable MP4 render (QA reference — 1080p, neutral gray background)
- Brief technical note: triangle count, file size, material list, any compromises made

---

## Timeline

**3–5 business days** from brief acceptance and source asset handoff.

---

## Review Criteria

The asset is accepted when it:

1. Reads as faithful to the 2D cover art (printed book and 3D should look like the same object)
2. Loads under 500 KB after `gltf-transform optimize`
3. Holds ≤30K triangles
4. Looks correct under the ACISS lighting recipe above
5. Performs at **60 fps on mid-tier mobile** (iPhone 13 / Pixel 6 class)
6. Has a clean, centered pivot (book rotates around its own center, not a corner)

---

## Compensation & Next Steps

[Rate and terms — to be confirmed between Michael and Nathaniel]

To accept this brief, reply with:
1. Estimated delivery date
2. Quote
3. Any clarifying questions on the specs above

Michael will then send the source assets and confirm the engagement.

---

**Contact:** Michael David Warren Jr. — [email/phone to be inserted by Michael before sending]
