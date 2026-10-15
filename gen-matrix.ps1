Add-Type -AssemblyName System.Drawing

# Let's test a uniform crop box for all 3 characters!
# The sister stage in CSS has height min 190px, max 275px, width typically 380-420px.
# In the original 1024x571 images:
# Left character (Normal): center is around x = 265, y = 80 to 520 (height ~440)
# Right character (Pain): center is around x = 755, y = 80 to 520 (height ~440)

# Let's try uniform width = 360, height = 440:
# Left (Normal): sx = 265 - 180 = 85, sy = 80, sw = 360, sh = 440 (x: 85..445, y: 80..520)
# Right (Pain):  sx = 755 - 180 = 575, sy = 80, sw = 360, sh = 440 (x: 575..935, y: 80..520)

$files = @(
  @{ name="10s_gal"; path="C:/Users/sam/.gemini/antigravity/brain/7af71346-43bc-434c-ba68-9c0de09bfc51/.user_uploaded/media_1792074548580_a28ecefa.jpg" },
  @{ name="20s_res"; path="C:/Users/sam/.gemini/antigravity/brain/7af71346-43bc-434c-ba68-9c0de09bfc51/.user_uploaded/media_1792074548573_57b87a28.jpg" },
  @{ name="30s_cel"; path="C:/Users/sam/.gemini/antigravity/brain/7af71346-43bc-434c-ba68-9c0de09bfc51/.user_uploaded/media_1792074548589_cf192fb4.jpg" }
)

$sw = 360
$sh = 440
$sy = 75
$normSx = 85
$painSx = 575

$compBmp = New-Object System.Drawing.Bitmap ($sw * 2), ($sh * 3)
$cg = [System.Drawing.Graphics]::FromImage($compBmp)

for ($i = 0; $i -lt $files.Count; $i++) {
  $f = $files[$i]
  $srcBmp = [System.Drawing.Bitmap]::FromFile($f.path)
  
  # Normal
  $destNorm = New-Object System.Drawing.Rectangle 0, ($i * $sh), $sw, $sh
  $srcNorm = New-Object System.Drawing.Rectangle $normSx, $sy, $sw, $sh
  $cg.DrawImage($srcBmp, $destNorm, $srcNorm, [System.Drawing.GraphicsUnit]::Pixel)
  
  # Pain
  $destPain = New-Object System.Drawing.Rectangle $sw, ($i * $sh), $sw, $sh
  $srcPain = New-Object System.Drawing.Rectangle $painSx, $sy, $sw, $sh
  $cg.DrawImage($srcBmp, $destPain, $srcPain, [System.Drawing.GraphicsUnit]::Pixel)
  
  $srcBmp.Dispose()
}

$cg.Dispose()
$outPath = "C:/Users/sam/.gemini/antigravity/scratch/hanage-game/test_crops/comparison_matrix.png"
$compBmp.Save($outPath, [System.Drawing.Imaging.ImageFormat]::Png)
$compBmp.Dispose()
Write-Output "Saved comparison_matrix.png"
