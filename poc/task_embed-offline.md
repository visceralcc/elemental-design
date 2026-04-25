# Task: Make POC Fully Offline — Embed Fonts and Image

**POC Version:** v0.2.6 → v0.2.7
**File:** `poc/elemental-poc.html`

---

## What to do

The demo currently requires internet for two things:
1. **Fonts** — Barlow, Barlow Condensed, and Vollkorn are loaded from Google Fonts CDN
2. **Hero image** — loaded from an Unsplash URL

Embed both so the HTML file works with **zero network dependencies**. Someone can double-click it on an airplane and it works.

---

## Part 1: Embed the fonts

Replace the Google Fonts `<link>` tag:
```html
<link href="https://fonts.googleapis.com/css2?family=Barlow:wght@300;400;500;600;700&family=Barlow+Condensed:wght@300;500&family=Vollkorn:ital,wght@0,400;1,700&display=swap" rel="stylesheet">
```

With `@font-face` declarations using base64-encoded WOFF2 data inside a `<style>` block.

### Fonts to embed

Download the WOFF2 files from Google Fonts and base64-encode them. The specific weights needed:

| Family | Weights | Used for |
|--------|---------|----------|
| Barlow | 300, 400, 500, 600, 700 | All UI chrome |
| Barlow Condensed | 300, 500 | Wordmark |
| Vollkorn | 400 regular, 700 bold italic | Agent conversation text (Volkhov substitute) |

For each font, create a `@font-face` rule like:

```css
@font-face {
  font-family: 'Barlow';
  font-weight: 300;
  font-style: normal;
  font-display: swap;
  src: url(data:font/woff2;base64,...) format('woff2');
}
```

### How to get the WOFF2 files

1. Fetch the Google Fonts CSS URL (the same one from the `<link>` tag) — it returns `@font-face` rules with URLs to the actual `.woff2` files
2. Download each `.woff2` file
3. Base64-encode each one
4. Inline them as data URIs in `@font-face` rules

### Important
- Remove the `<link>` tag entirely after adding the inline `@font-face` rules
- The `@font-face` rules should go inside the existing `<style>` block, before the `*` reset rule
- Keep the same `font-family` names so nothing else in the CSS needs to change

---

## Part 2: Embed the hero image

Find the Unsplash URL in the `COMPONENTS` array:
```js
src:'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=600&h=400&fit=crop'
```

1. Download the image from that URL
2. Convert to base64 JPEG
3. Replace the URL with a data URI: `data:image/jpeg;base64,...`

---

## If font/image downloads fail due to network restrictions

If the container can't reach Google Fonts or Unsplash:

**For fonts:** Use system font fallbacks as a last resort. Replace the Google Fonts link with:
```css
:root {
  --font-ui: -apple-system, BlinkMacSystemFont, 'Segoe UI', system-ui, sans-serif;
  --font-condensed: -apple-system, BlinkMacSystemFont, 'Segoe UI', system-ui, sans-serif;
  --font-serif: Georgia, 'Times New Roman', serif;
}
```
And update the `font-family` references throughout the CSS. But try downloading first — embedded fonts are much better.

**For the image:** Create a gradient placeholder as an SVG data URI that gives the feel of a mountain landscape. Something like:
```
data:image/svg+xml,...
```
But again, try downloading the real image first.

---

## What NOT to change

- Do not change any layout, styling, behavior, or interactivity
- Do not change font-family names (keep 'Barlow', 'Barlow Condensed', 'Vollkorn')
- Do not split into multiple files — everything stays in one HTML file
- Do not change the image dimensions, fit mode, or corner radius

---

## Verification

1. Disconnect from internet (or open in a private/offline context)
2. Open `elemental-poc.html` — all fonts render correctly (Barlow for UI, Vollkorn for conversation text)
3. The hero image appears (mountain landscape)
4. Everything else works the same as before
5. The file will be significantly larger (base64 fonts + image) — that's expected and fine
6. No console errors, no failed network requests

---

## Files to read first

- `poc/CLAUDE.md` — POC rules
- `poc/elemental-poc.html` — the file you're editing
