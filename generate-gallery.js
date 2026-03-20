#!/usr/bin/env node

const fs = require('fs');
const path = require('path');

const ALBUMS_DIR = path.join(__dirname, 'albums');
const INDEX_FILE = path.join(__dirname, 'index.html');
const IMAGE_EXTENSIONS = ['.jpg', '.jpeg', '.png', '.gif', '.webp'];

/**
 * Get all image files from a directory
 */
function getImages(dir) {
    if (!fs.existsSync(dir)) return [];
    
    return fs.readdirSync(dir)
        .filter(file => {
            const fullPath = path.join(dir, file);
            return fs.statSync(fullPath).isFile() && 
                   IMAGE_EXTENSIONS.includes(path.extname(file).toLowerCase());
        })
        .sort();
}

/**
 * Get all album directories
 */
function getAlbums() {
    if (!fs.existsSync(ALBUMS_DIR)) {
        fs.mkdirSync(ALBUMS_DIR, { recursive: true });
        return [];
    }
    
    return fs.readdirSync(ALBUMS_DIR)
        .filter(file => {
            const fullPath = path.join(ALBUMS_DIR, file);
            return fs.statSync(fullPath).isDirectory();
        })
        .sort();
}

/**
 * Convert folder name to readable album title
 */
function formatAlbumName(folderName) {
    return folderName
        .replace(/([A-Z])/g, ' $1') // Handle camelCase
        .replace(/-|_/g, ' ') // Replace hyphens and underscores with spaces
        .trim()
        .split(' ')
        .map(word => word.charAt(0).toUpperCase() + word.slice(1).toLowerCase())
        .join(' ');
}

/**
 * Update main index.html with album entries
 */
function updateMainIndex() {
    const albums = getAlbums();
    
    let albumsHTML = '';
    albums.forEach(album => {
        const albumPath = path.join(ALBUMS_DIR, album);
        
        // Look for photos in both direct folder and photos subfolder
        const photosDir = path.join(albumPath, 'photos');
        let images = fs.existsSync(photosDir) ? getImages(photosDir) : getImages(albumPath).filter(f => f);
        
        // If photos are directly in album folder, filter out the index.html
        if (!fs.existsSync(photosDir)) {
            images = images.filter(f => !f.endsWith('.html'));
        }
        
        const photoCount = images.length;
        const albumName = formatAlbumName(album);
        
        let firstImagePath = '';
        if (photoCount > 0) {
            if (fs.existsSync(photosDir)) {
                firstImagePath = `albums/${album}/photos/${images[0]}`;
            } else {
                firstImagePath = `albums/${album}/${images[0]}`;
            }
        }
        
        albumsHTML += `            <div class="album">
                <a href="albums/${album}/index.html">
                    ${firstImagePath ? `<img src="${firstImagePath}" alt="${albumName}" class="album-thumbnail">` : '<div class="album-thumbnail-placeholder">No photos</div>'}
                    <h3>${albumName}</h3>
                    <p>${photoCount} photo${photoCount !== 1 ? 's' : ''}</p>
                </a>
            </div>\n`;
    });
    
    // Read the current index.html
    let htmlContent = fs.readFileSync(INDEX_FILE, 'utf8');
    
    // Replace the albums div content
    const albumsRegex = /<div class="albums">[\s\S]*?<\/div>\s*<\/main>/;
    const replacement = `<div class="albums">\n${albumsHTML}        </div>\n    </main>`;
    
    htmlContent = htmlContent.replace(albumsRegex, replacement);
    
    fs.writeFileSync(INDEX_FILE, htmlContent, 'utf8');
    console.log('✓ Updated main index.html');
}

/**
 * Update album index.html with photo entries
 */
function updateAlbumIndex(album) {
    const albumPath = path.join(ALBUMS_DIR, album);
    const photosDir = path.join(albumPath, 'photos');
    const albumIndexPath = path.join(albumPath, 'index.html');
    const albumName = formatAlbumName(album);
    
    // Determine where photos are stored
    let images = [];
    let photosPath = '';
    
    if (fs.existsSync(photosDir)) {
        // Photos in photos/ subfolder
        images = getImages(photosDir);
        photosPath = 'photos/';
    } else {
        // Photos directly in album folder
        images = getImages(albumPath).filter(f => !f.endsWith('.html'));
        photosPath = '';
    }
    
    let photosHTML = '';
    images.forEach((image, index) => {
        const alt = `${albumName} - Photo ${index + 1}`;
        photosHTML += `            <div class="photo">
                <img src="${photosPath}${image}" alt="${alt}">
            </div>\n`;
    });
    
    // Create album index if it doesn't exist
    if (!fs.existsSync(albumIndexPath)) {
        const baseHTML = `<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${albumName} - Photo Portfolio</title>
    <link rel="stylesheet" href="../../css/style.css">
</head>
<body>
    <header>
        <h1>${albumName}</h1>
        <nav>
            <a href="../../index.html">Albums</a>
            <a href="../../all-photos.html">All Photos</a>
        </nav>
    </header>
    <main>
        <div class="photos">
${photosHTML}        </div>
    </main>
    <script src="../../js/gallery.js"></script>
</body>
</html>`;
        fs.writeFileSync(albumIndexPath, baseHTML, 'utf8');
        console.log(`✓ Created ${album}/index.html`);
    } else {
        // Update existing album index
        let htmlContent = fs.readFileSync(albumIndexPath, 'utf8');
        const photosRegex = /<div class="photos">[\s\S]*?<\/div>\s*<\/main>/;
        const replacement = `<div class="photos">\n${photosHTML}        </div>\n    </main>`;
        
        htmlContent = htmlContent.replace(photosRegex, replacement);
        fs.writeFileSync(albumIndexPath, htmlContent, 'utf8');
        console.log(`✓ Updated ${album}/index.html`);
    }
}

/**
 * Generate all photo galleries
 */
function generateGalleries() {
    console.log('🔄 Generating photo galleries...\n');
    
    const albums = getAlbums();
    
    if (albums.length === 0) {
        console.log('⚠️  No albums found. Create folders in the "albums" directory.');
        return;
    }
    
    // Update each album
    albums.forEach(album => {
        updateAlbumIndex(album);
    });
    
    // Update main index
    updateMainIndex();
    
    console.log('\n✅ Gallery generation complete!');
}

// Run the script
generateGalleries();
