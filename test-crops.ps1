Add-Type -AssemblyName System.Drawing

$testCrops = @(
  @{
    name = "10s_gal_normal"
    path = "C:/Users/sam/.gemini/antigravity/brain/7af71346-43bc-434c-ba68-9c0de09bfc51/.user_uploaded/media_1792074548580_a28ecefa.jpg"
    rect = [System.Drawing.Rectangle]::new(115, 85, 290, 380)
  },
  @{
    name = "10s_gal_pain"
    path = "C:/Users/sam/.gemini/antigravity/brain/7af71346-43bc-434c-ba68-9c0de09bfc51/.user_uploaded/media_1792074548580_a28ecefa.jpg"
    rect = [System.Drawing.Rectangle]::new(610, 85, 290, 380)
  },
  @{
    name = "20s_res_normal"
    path = "C:/Users/sam/.gemini/antigravity/brain/7af71346-43bc-434c-ba68-9c0de09bfc51/.user_uploaded/media_1792074548573_57b87a28.jpg"
    rect = [System.Drawing.Rectangle]::new(115, 85, 290, 380)
  },
  @{
    name = "20s_res_pain"
    path = "C:/Users/sam/.gemini/antigravity/brain/7af71346-43bc-434c-ba68-9c0de09bfc51/.user_uploaded/media_1792074548573_57b87a28.jpg"
    rect = [System.Drawing.Rectangle]::new(610, 85, 290, 380)
  },
  @{
    name = "30s_cel_normal"
    path = "C:/Users/sam/.gemini/antigravity/brain/7af71346-43bc-434c-ba68-9c0de09bfc51/.user_uploaded/media_1792074548589_cf192fb4.jpg"
    rect = [System.Drawing.Rectangle]::new(115, 85, 290, 380)
  },
  @{
    name = "30s_cel_pain"
    path = "C:/Users/sam/.gemini/antigravity/brain/7af71346-43bc-434c-ba68-9c0de09bfc51/.user_uploaded/media_1792074548589_cf192fb4.jpg"
    rect = [System.Drawing.Rectangle]::new(610, 85, 290, 380)
  }
)

$outDir = "C:/Users/sam/.gemini/antigravity/scratch/hanage-game/test_crops"
if (-not (Test-Path $outDir)) { New-Item -ItemType Directory -Path $outDir }

foreach ($tc in $testCrops) {
  $srcBmp = [System.Drawing.Bitmap]::FromFile($tc.path)
  $cropBmp = New-Object System.Drawing.Bitmap $tc.rect.Width, $tc.rect.Height
  $g = [System.Drawing.Graphics]::FromImage($cropBmp)
  $destRect = [System.Drawing.Rectangle]::new(0, 0, $tc.rect.Width, $tc.rect.Height)
  $g.DrawImage($srcBmp, $destRect, $tc.rect, [System.Drawing.GraphicsUnit]::Pixel)
  $g.Dispose()
  
  $outPath = Join-Path $outDir "$($tc.name).png"
  $cropBmp.Save($outPath, [System.Drawing.Imaging.ImageFormat]::Png)
  $cropBmp.Dispose()
  $srcBmp.Dispose()
  Write-Output "Saved $outPath"
}
