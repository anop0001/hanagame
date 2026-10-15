Add-Type -AssemblyName System.Drawing

$files = @(
  @{
    id = "gal"
    name = "10s_gal"
    path = "C:/Users/sam/.gemini/antigravity/brain/7af71346-43bc-434c-ba68-9c0de09bfc51/.user_uploaded/media_1792074548580_a28ecefa.jpg"
    # Gal center is ~255. Gal hair is at top ~95. Let's start at sy=95 to completely avoid top-left '10s' text!
    normSx = 130; normSy = 92;
    # Gal pain center is ~740. sy=95 to completely avoid '痛覚最大!!' text!
    painSx = 620; painSy = 92;
  },
  @{
    id = "res"
    name = "20s_res"
    path = "C:/Users/sam/.gemini/antigravity/brain/7af71346-43bc-434c-ba68-9c0de09bfc51/.user_uploaded/media_1792074548573_57b87a28.jpg"
    # Researcher center is ~268
    normSx = 135; normSy = 88;
    # Pain center is ~755
    painSx = 615; painSy = 88;
  },
  @{
    id = "cel"
    name = "30s_cel"
    path = "C:/Users/sam/.gemini/antigravity/brain/7af71346-43bc-434c-ba68-9c0de09bfc51/.user_uploaded/media_1792074548589_cf192fb4.jpg"
    # Celeb center is ~265
    normSx = 135; normSy = 88;
    # Pain center is ~755
    painSx = 615; painSy = 88;
  }
)

# UNIFORM CROPPING DIMENSIONS:
# Identical sw and sh guarantee EXACT same character size and scale!
$sw = 280
$sh = 330

$stageW = 380
$stageH = 230

$previewBmp = New-Object System.Drawing.Bitmap ($stageW * 2), ($stageH * 3)
$g = [System.Drawing.Graphics]::FromImage($previewBmp)
$g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic

for ($i = 0; $i -lt $files.Count; $i++) {
  $f = $files[$i]
  $srcBmp = [System.Drawing.Bitmap]::FromFile($f.path)
  
  $scale = [Math]::Min($stageW / $sw, $stageH / $sh)
  $drawW = [int]($sw * $scale)
  $drawH = [int]($sh * $scale)
  $drawX = [int](($stageW - $drawW) / 2)
  $drawY = [int]($stageH - $drawH)
  
  # Fill background
  $normBg = New-Object System.Drawing.Rectangle 0, ($i * $stageH), $stageW, $stageH
  $painBg = New-Object System.Drawing.Rectangle $stageW, ($i * $stageH), $stageW, $stageH
  $brush = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(255, 11, 17, 30))
  $g.FillRectangle($brush, $normBg)
  $g.FillRectangle($brush, $painBg)
  $brush.Dispose()
  
  # Normal
  $destNorm = New-Object System.Drawing.Rectangle $drawX, ($i * $stageH + $drawY), $drawW, $drawH
  $srcNorm = New-Object System.Drawing.Rectangle $f.normSx, $f.normSy, $sw, $sh
  $g.DrawImage($srcBmp, $destNorm, $srcNorm, [System.Drawing.GraphicsUnit]::Pixel)
  
  # Pain
  $destPain = New-Object System.Drawing.Rectangle ($stageW + $drawX), ($i * $stageH + $drawY), $drawW, $drawH
  $srcPain = New-Object System.Drawing.Rectangle $f.painSx, $f.painSy, $sw, $sh
  $g.DrawImage($srcBmp, $destPain, $srcPain, [System.Drawing.GraphicsUnit]::Pixel)
  
  $srcBmp.Dispose()
}

$g.Dispose()
$outPath = "C:/Users/sam/.gemini/antigravity/scratch/hanage-game/test_crops/optimized_preview.png"
$previewBmp.Save($outPath, [System.Drawing.Imaging.ImageFormat]::Png)
$previewBmp.Dispose()
Write-Output "Saved optimized_preview.png"
