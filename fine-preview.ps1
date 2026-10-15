Add-Type -AssemblyName System.Drawing

$files = @(
  @{
    id = "gal"
    name = "10s_gal"
    path = "C:/Users/sam/.gemini/antigravity/brain/7af71346-43bc-434c-ba68-9c0de09bfc51/.user_uploaded/media_1792074548580_a28ecefa.jpg"
    normSx = 142; normSy = 95;
    painSx = 625; painSy = 105;
  },
  @{
    id = "res"
    name = "20s_res"
    path = "C:/Users/sam/.gemini/antigravity/brain/7af71346-43bc-434c-ba68-9c0de09bfc51/.user_uploaded/media_1792074548573_57b87a28.jpg"
    normSx = 145; normSy = 88;
    painSx = 615; painSy = 88;
  },
  @{
    id = "cel"
    name = "30s_cel"
    path = "C:/Users/sam/.gemini/antigravity/brain/7af71346-43bc-434c-ba68-9c0de09bfc51/.user_uploaded/media_1792074548589_cf192fb4.jpg"
    normSx = 145; normSy = 88;
    painSx = 615; painSy = 88;
  }
)

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
$outPath = "C:/Users/sam/.gemini/antigravity/scratch/hanage-game/test_crops/fine_tuned_preview.png"
$previewBmp.Save($outPath, [System.Drawing.Imaging.ImageFormat]::Png)
$previewBmp.Dispose()
Write-Output "Saved fine_tuned_preview.png"
