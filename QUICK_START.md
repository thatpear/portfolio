# Quick Start Guide - Photo Gallery Automation

## What Was Created

Three files have been added to automate your photo gallery:

1. **`generate-gallery.ps1`** - The main PowerShell script (does the actual work)
2. **`generate-gallery.bat`** - The launcher file (double-click this!)
3. **`GALLERY_AUTOMATION.md`** - Complete documentation

## How to Use (Quick Version)

### Step 1: Add Photos to an Album
```
albums/MErchandize/
├── winter-collection.jpg
├── spring-collection.jpg
└── summer-collection.jpg
```

### Step 2: Run the Generator
**Double-click `generate-gallery.bat`**

That's it! Your portfolio updates automatically.

---

## For New Albums

### Step 1: Create the Album Folder
Create a new folder in the `albums/` directory:
```
New Folder > Rename to "YourAlbumName"
```

### Step 2: Add Your Photos
Copy photos into the album folder:
```
albums/YourAlbumName/
├── photo1.jpg
├── photo2.jpg
└── photo3.jpg
```

### Step 3: Run the Generator
**Double-click `generate-gallery.bat`**

Your album appears on the main page with a thumbnail and photo count!

---

## What the Script Does

✓ Scans your `albums/` folder  
✓ Finds all folders and photos  
✓ Creates `index.html` for each album with your photos  
✓ Updates the main `index.html` with album thumbnails  
✓ Calculates photo counts automatically  
✓ Formats folder names nicely (e.g., "my-vacation" → "My Vacation")  

---

## Features

- **No Installation Needed** - Works with built-in Windows PowerShell
- **Safe to Run Multiple Times** - Photos are never deleted or modified
- **Smart Naming** - Automatically converts folder names to readable titles
- **Flexible** - Works with photos directly in album folder or in a `photos/` subfolder
- **Responsive** - Works perfectly on mobile, tablet, and desktop

---

## 📸 Your Next Steps

1. **[Try it now]** Double-click `generate-gallery.bat`
2. **[Add photos]** Put some photos in one of your album folders
3. **[Run again]** Double-click `generate-gallery.bat` again
4. **[View results]** Open `index.html` in your browser to see the updated gallery

---

For more detailed information, see `GALLERY_AUTOMATION.md`
