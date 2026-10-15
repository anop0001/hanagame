Add-Type -AssemblyName System.Drawing

$files = @(
  @{ name="gal"; path="C:/Users/sam/.gemini/antigravity/brain/7af71346-43bc-434c-ba68-9c0de09bfc51/.user_uploaded/media_1792074548580_a28ecefa.jpg" },
  @{ name="res"; path="C:/Users/sam/.gemini/antigravity/brain/7af71346-43bc-434c-ba68-9c0de09bfc51/.user_uploaded/media_1792074548573_57b87a28.jpg" },
  @{ name="cel"; path="C:/Users/sam/.gemini/antigravity/brain/7af71346-43bc-434c-ba68-9c0de09bfc51/.user_uploaded/media_1792074548589_cf192fb4.jpg" }
)

# Let's save smaller annotated overviews (e.g. 512x285) to view easily
foreach ($f in $files) {
  $bmp = [System.Drawing.Bitmap]::FromFile($f.path)
  $thumb = New-Object System.Drawing.Bitmap 512, 285
  $g = [System.Drawing.Graphics]::FromImage($thumb)
  $g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
  $g.DrawImage($bmp, 0, 0, 512, 285)
  $g.Dispose()
  $outPath = "C:/Users/sam/.gemini/antigravity/scratch/hanage-game/test_crops/overview_$($f.name).png"
  $thumb.Save($outPath, [System.Drawing.Imaging.ImageFormat]::Png)
  $thumb.Dispose()
  $bmp.Dispose()
  Write-Output "Saved $outPath"
}
