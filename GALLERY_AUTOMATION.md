# Photo Gallery Automation

This automation system allows you to generate UI elements automatically whenever you add photos to your album folders.

## How It Works

The `generate-gallery.ps1` PowerShell script scans your `albums/` directory and:
1. **Discovers albums** - Finds all folders in the `albums/` directory
2. **Scans for photos** - Looks for images (`.jpg`, `.png`, `.gif`, `.webp`, `.jpeg`) in each album
3. **Auto-generates HTML** - Creates or updates HTML files with proper photo gallery markup
4. **Updates indexes** - Refreshes the main portfolio page with album links and photo counts

## How It Works

The `generate-gallery.ps1` PowerShell script scans your `albums/` directory and:
1. **Discovers albums** - Finds all folders in the `albums/` directory
2. **Scans for photos** - Looks for images (`.jpg`, `.png`, `.gif`, `.webp`, `.jpeg`) in each album
3. **Auto-generates HTML** - Creates or updates HTML files with proper photo gallery markup
4. **Updates indexes** - Refreshes the main portfolio page with album links and photo counts

## Folder Structure

Your portfolio can be organized in two ways:

**Option 1: Photos in a `photos` subfolder** (Recommended for organization)
```
portfolio/
├── albums/
│   ├── YourAlbum1/
│   │   ├── photos/
│   │   │   ├── photo1.jpg
│   │   │   ├── photo2.jpg
│   │   │   └── ...
│   │   └── index.html (auto-generated)
│   └── ...
```

**Option 2: Photos directly in album folder** (Current structure)
```
portfolio/
├── albums/
│   ├── MErchandize/
│   │   ├── photo1.jpg
│   │   ├── photo2.jpg
│   │   ├── photo3.jpg
│   │   └── index.html (auto-generated)
│   └── ...
```

The script automatically detects which structure you're using!

## Usage

### Windows Users
**Double-click `generate-gallery.bat`** - A window will open and run the script automatically.

Or from PowerShell/Command Prompt:
```bash
generate-gallery.bat
```

### Command Line (All Platforms)
```bash
powershell -ExecutionPolicy Bypass -File "generate-gallery.ps1"
```

## Step-by-Step Workflow

### 1. Create a New Album
```
Right-click in File Explorer > New Folder
Name it something like "Vacation2024" or "Wedding"
```

### 2. Add Photos
Copy your photo files into the album folder (or into a `photos` subfolder):
```
albums/Vacation2024/
├── beach1.jpg
├── sunset.jpg
└── mountains.png
```

### 3. Run the Generator
**Double-click `generate-gallery.bat`**

Or use command line:
```bash
powershell -ExecutionPolicy Bypass -File "generate-gallery.ps1"
```

### 4. Done!
Your portfolio is automatically updated with:
- New album entry on the main page
- Photo gallery page for the album
- Album thumbnail from the first photo
- Photo count displayed

## Features

✓ **Automatic Album Detection** - No manual HTML editing needed  
✓ **Smart Naming** - Converts folder names to readable titles:
   - `myVacation` → `My Vacation`
   - `beach-photos` → `Beach Photos`
   - `Photo_Collection` → `Photo Collection`

✓ **Flexible Structure** - Works with photos in album folder or in a `photos` subfolder  
✓ **Thumbnail Generation** - First photo in album becomes the thumbnail  
✓ **Photo Count** - Shows how many photos are in each album  
✓ **Responsive Design** - Works on desktop, tablet, and mobile  
✓ **Lightbox Gallery** - Click photos to view them larger  
✓ **No Installation** - Uses built-in Windows PowerShell

## Image Format Support

The script recognizes these image formats:
- `.jpg` / `.jpeg`
- `.png`
- `.gif`
- `.webp`

Names are case-insensitive, so `Photo.JPG` works the same as `photo.jpg`.

## Photo Ordering

Photos appear in **alphabetical order** by filename. To control the order:
- Name them numerically: `01-photo.jpg`, `02-photo.jpg`, etc.
- Or use dates: `2024-01-15-beach.jpg`, `2024-01-16-sunset.jpg`

## Requirements

**Windows 7 and later**: PowerShell is built-in (no installation needed!)

The script uses only built-in Windows components, so there's nothing to install.

## Troubleshooting

### Script doesn't run or shows "permission denied"
- Right-click `generate-gallery.bat` → Run as administrator
- Or double-click normally - Windows may ask for permission

### Photos not appearing
- Make sure image files are in the album folder (not in a subfolder, unless using `photos/`)
- Check that filenames use supported formats: `.jpg`, `.png`, `.gif`, or `.webp`
- Run the script again after adding photos

### Album title looks wrong
- The script converts folder names automatically:
  - Underscores, hyphens → spaces
  - camelCase → Title Case
- Rename your folder if you want a different display name

### Generated HTML files get overwritten
- Yes, this is intentional! The script regenerates your gallery pages each time
- Don't manually edit the auto-generated `index.html` files in album folders
- The main `index.html` at the root is also regenerated

## How to Organize Photos

### Recommended Structure
For best results, organize your photos like this:

```
albums/
├── MyVacation/
│   ├── photos/
│   │   ├── 01-arrival.jpg
│   │   ├── 02-beach-day.jpg
│   │   ├── 03-sunset.jpg
│   │   └── 04-evening.jpg
│   └── index.html (auto-generated)
├── Wedding/
│   ├── photos/
│   │   ├── 001-getting-ready.jpg
│   │   ├── 002-ceremony.jpg
│   │   └── ...
│   └── index.html (auto-generated)
```

This keeps your portfolio well-organized and easy to manage.

## Tips & Tricks

- **Batch Import**: Add multiple photos to an album folder, then run the script once - it will update everything automatically
- **Update Portfolio**: Run the script anytime you add/remove photos - it will change instantly
- **Safe to Run Multiple Times**: The script is safe to run as many times as you want - it won't delete anything
- **Preserve Original Photos**: The script only reads your photos, it never modifies them

---

Enjoy your automated photo portfolio! 📸

