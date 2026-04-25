# Task: Embed Hero Image as Base64

**POC Version:** v0.2.6 → v0.2.7
**File:** `poc/elemental-poc.html`

---

## What to do

The hero image currently loads from an external Unsplash URL:

```
https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=600&h=400&fit=crop
```

This means the demo breaks if the viewer is offline or if Unsplash changes/removes the image.

**Embed the image as a base64 data URI** so the demo is fully self-contained.

---

## Steps

1. **Download the image** from the Unsplash URL above
2. **Convert it to base64** — use a JPEG format to keep the size reasonable
3. **Replace the `src` URL** in the component data. Find this line in the `COMPONENTS` array:
   ```js
   src:'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=600&h=400&fit=crop'
   ```
   Replace it with:
   ```js
   src:'data:image/jpeg;base64,/9j/4AAQ...[the full base64 string]...'
   ```

That's it. One string replacement.

---

## If the download doesn't work

If you can't fetch the Unsplash image (network restrictions), use any reasonable placeholder approach:
- A solid gradient rectangle as an SVG data URI
- A different small JPEG encoded as base64

The important thing is that `elemental-poc.html` works with zero network dependencies.

---

## What NOT to change

- Do not change anything else in the file
- Do not change the image dimensions, fit mode, or corner radius
- Do not add any external files — everything stays in the single HTML file

---

## Verification

1. Open `elemental-poc.html` with internet disabled — the hero image still appears
2. The image looks the same as before (mountain landscape)
3. File size will increase (base64 images are larger) — that's expected and fine for a POC
4. No console errors
