# Photo Portfolio

A simple, minimalist photo portfolio hosted on GitHub Pages.

## Features

- Albums displayed on the main page
- Click albums to view associated photos
- All photos page with chronological sorting
- All photos stored locally in the repository
- Automatic deployments to GitHub Pages
- Simple to develop and maintain

## Adding Albums and Photos

1. Create a new folder under `albums/` for each album (e.g., `albums/my-trip/`)

2. Add your photos to a `photos/` subfolder within the album (e.g., `albums/my-trip/photos/`)

3. Create an `index.html` for the album based on `albums/example/index.html`:
   - Update the title and header
   - Add `<div class="photo"><img src="photos/photo1.jpg" alt="Photo 1"></div>` for each photo

4. Update `index.html` to include the new album in the albums list

5. Update `all-photos.html` to include all photos from all albums, sorted chronologically (e.g., by filename if they start with dates like `2023-01-01-photo.jpg`)

## File Structure

```
portfolio/
├── index.html          # Main page with albums
├── all-photos.html     # All photos page
├── css/
│   └── style.css       # Stylesheet
├── js/
│   └── gallery.js      # Lightbox functionality
└── albums/
    └── example/        # Example album
        ├── index.html
        └── photos/
            └── photo1.jpg
```

## Development

- Edit HTML files directly
- Add CSS to `css/style.css`
- Modify JS in `js/gallery.js`
- Photos are stored in `albums/[album]/photos/`

## Photo Naming

For chronological sorting on the all photos page, name your photos with dates first, e.g.:
- `2023-01-01-sunset.jpg`
- `2023-01-02-mountain.jpg`

This allows easy manual sorting in the HTML.
