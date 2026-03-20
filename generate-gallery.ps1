# Photo Gallery Generator - PowerShell Version
# This script automatically generates HTML for your photo gallery

param(
    [string]$AlbumsPath = (Join-Path $PSScriptRoot "albums"),
    [string]$StylePath = (Join-Path $PSScriptRoot "css/style.css"),
    [string]$IndexPath = (Join-Path $PSScriptRoot "index.html")
)

$ImageExtensions = @(".jpg", ".jpeg", ".png", ".gif", ".webp")

# Function to format album names
function Format-AlbumName {
    param([string]$FolderName)
    
    $name = $FolderName
    
    # Handle camelCase (but not consecutive capitals)
    $name = [regex]::Replace($name, '([a-z])([A-Z])', '$1 $2')
    
    # Replace underscores and hyphens with spaces
    $name = $name -replace '[_-]+', ' '
    
    # Title case - capitalize first letter, lowercase the rest
    $parts = $name.Split(' ') | ForEach-Object {
        if ($_.Length -gt 0) {
            $_.Substring(0,1).ToUpper() + $_.Substring(1).ToLower()
        }
    }
    
    return ($parts -join ' ').Trim()
}

# Function to get images from a directory
function Get-Images {
    param([string]$DirectoryPath)
    
    if (-not (Test-Path $DirectoryPath)) {
        return @()
    }
    
    $images = Get-ChildItem -Path $DirectoryPath -File | 
        Where-Object { $ImageExtensions -contains $_.Extension.ToLower() } |
        Sort-Object Name |
        Select-Object -ExpandProperty Name
    
    return $images
}

# Function to get all albums
function Get-Albums {
    if (-not (Test-Path $AlbumsPath)) {
        New-Item -ItemType Directory -Path $AlbumsPath -Force | Out-Null
        return @()
    }
    
    $albums = Get-ChildItem -Path $AlbumsPath -Directory |
        Sort-Object Name |
        Select-Object -ExpandProperty Name
    
    return $albums
}

# Function to update album index
function Update-AlbumIndex {
    param([string]$Album)
    
    $albumPath = Join-Path $AlbumsPath $Album
    $albumIndexPath = Join-Path $albumPath "index.html"
    $photosDir = Join-Path $albumPath "photos"
    $albumName = Format-AlbumName $Album
    
    # Determine where photos are stored
    $images = @()
    $photosPath = ""
    
    if (Test-Path $photosDir) {
        # Photos in photos/ subfolder
        $images = Get-Images $photosDir
        $photosPath = "photos/"
    } else {
        # Photos directly in album folder
        $images = Get-Images $albumPath | Where-Object { $_ -notlike "*.html" }
        $photosPath = ""
    }
    
    # Generate photos HTML
    $photosHTML = ""
    for ($i = 0; $i -lt $images.Count; $i++) {
        $image = $images[$i]
        $photoNum = $i + 1
        $alt = "$albumName - Photo $photoNum"
        $photosHTML += "            <div class=""photo"">`r`n"
        $photosHTML += "                <img src=""$photosPath$image"" alt=""$alt"">`r`n"
        $photosHTML += "            </div>`r`n"
    }
    
    if (-not (Test-Path $albumIndexPath)) {
        # Create new album index
        $baseHTML = @"
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>$albumName - Photo Portfolio</title>
    <link rel="stylesheet" href="../../css/style.css">
</head>
<body>
    <header>
        <h1>$albumName</h1>
        <nav>
            <a href="../../index.html">Albums</a>
            <a href="../../all-photos.html">All Photos</a>
        </nav>
    </header>
    <main>
        <div class="photos">
$photosHTML        </div>
    </main>
    <script src="../../js/gallery.js"></script>
</body>
</html>
"@
        Set-Content -Path $albumIndexPath -Value $baseHTML -Encoding UTF8
        Write-Host "[+] Created $Album/index.html"
    } else {
        # Update existing album index
        $htmlContent = Get-Content -Path $albumIndexPath -Raw
        $startIdx = $htmlContent.IndexOf('<div class="photos">')
        $endIdx = $htmlContent.IndexOf('</div>', $startIdx + 20) + 6
        $endMainIdx = $htmlContent.IndexOf('</main>', $endIdx)
        
        if ($startIdx -ge 0 -and $endMainIdx -ge 0) {
            $before = $htmlContent.Substring(0, $startIdx)
            $after = $htmlContent.Substring($endMainIdx)
            $htmlContent = $before + "<div class=`"photos`">`r`n" + $photosHTML + "        </div>`r`n    " + $after
            Set-Content -Path $albumIndexPath -Value $htmlContent -Encoding UTF8
            Write-Host "` Updated $Album/index.html"
        }
    }
}

# Function to update main index.html
function Update-MainIndex {
    $albums = Get-Albums
    
    $albumsHTML = ""
    foreach ($album in $albums) {
        $albumPath = Join-Path $AlbumsPath $album
        $photosDir = Join-Path $albumPath "photos"
        $albumName = Format-AlbumName $album
        
        # Get images
        $images = @()
        $photosPath = ""
        
        if (Test-Path $photosDir) {
            $images = Get-Images $photosDir
            $photosPath = "albums/$album/photos/"
        } else {
            $images = Get-Images $albumPath | Where-Object { $_ -notlike "*.html" }
            $photosPath = "albums/$album/"
        }
        
        $photoCount = $images.Count
        $thumbnailHTML = ""
        
        if ($photoCount -gt 0) {
            $firstImage = $images[0]
            $thumbnailHTML = "<img src=`"$photosPath$firstImage`" alt=`"$albumName`" class=`"album-thumbnail`">"
        } else {
            $thumbnailHTML = "<div class=`"album-thumbnail-placeholder`">No photos</div>"
        }
        
        $photoText = if ($photoCount -eq 1) { "1 photo" } else { "$photoCount photos" }
        
        $albumsHTML += "            <div class=`"album`">`r`n"
        $albumsHTML += "                <a href=`"albums/$album/index.html`">`r`n"
        $albumsHTML += "                    $thumbnailHTML`r`n"
        $albumsHTML += "                    <h3>$albumName</h3>`r`n"
        $albumsHTML += "                    <p>$photoText</p>`r`n"
        $albumsHTML += "                </a>`r`n"
        $albumsHTML += "            </div>`r`n"
    }
    
    # Read and update index.html
    $htmlContent = Get-Content -Path $IndexPath -Raw
    $startIdx = $htmlContent.IndexOf('<div class="albums">')
    $endIdx = $htmlContent.IndexOf('</div>', $startIdx + 20) + 6
    $endMainIdx = $htmlContent.IndexOf('</main>', $endIdx)
    
    if ($startIdx -ge 0 -and $endMainIdx -ge 0) {
        $before = $htmlContent.Substring(0, $startIdx)
        $after = $htmlContent.Substring($endMainIdx)
        $htmlContent = $before + "<div class=`"albums`">`r`n" + $albumsHTML + "        </div>`r`n    " + $after
        Set-Content -Path $IndexPath -Value $htmlContent -Encoding UTF8
        Write-Host "` Updated main index.html"
    }
}

# Main execution
Write-Host "[*] Generating photo galleries...`n"

$albums = Get-Albums

if ($albums.Count -eq 0) {
    Write-Host "[!] No albums found. Create folders in the 'albums' directory."
    exit
}

# Update each album
foreach ($album in $albums) {
    Update-AlbumIndex $album
}

# Update main index
Update-MainIndex

Write-Host "`n[SUCCESS] Gallery generation complete!"
