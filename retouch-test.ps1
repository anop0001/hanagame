Add-Type -AssemblyName System.Drawing

$srcPath = "C:/Users/sam/.gemini/antigravity/brain/7af71346-43bc-434c-ba68-9c0de09bfc51/.user_uploaded/media_1792074548573_57b87a28.jpg"
$bmp = [System.Drawing.Bitmap]::FromFile($srcPath)
$cleanBmp = New-Object System.Drawing.Bitmap $bmp.Width, $bmp.Height
$g = [System.Drawing.Graphics]::FromImage($cleanBmp)
$g.DrawImage($bmp, 0, 0, $bmp.Width, $bmp.Height)

# The text "20秒モード：悶絶スタンダード\n研究員お姉さん" is at x=40..230, y=300..375
# The center of the sister is x=268
# Let's see: on the right side of the sister (x > 268), the hair and coat are at x = 268 + (268 - x)
# Let's mirror the right hair pixels to the left where the text is!
for ($y = 295; $y -le 375; $y++) {
  for ($x = 40; $x -le 235; $x++) {
    $c = $bmp.GetPixel($x, $y)
    # Check if this pixel is text (orange/yellow text, white text, black outline, or dark shadow of text)
    $isOrange = ($c.R -ge 160 -and $c.G -ge 75 -and $c.B -le 80)
    $isWhite = ($c.R -ge 210 -and $c.G -ge 210 -and $c.B -ge 210)
    $isBlackOutline = ($c.R -le 50 -and $c.G -le 50 -and $c.B -le 50 -and ($x -gt 45 -and $x -lt 230))
    
    # If it is part of the text box
    $dx = 268 - $x
    $srcX = 268 + [int]($dx * 0.95)
    if ($srcX -lt $bmp.Width) {
      $mirrorColor = $bmp.GetPixel($srcX, $y)
      # If x < 140, it's the dark blue grid background
      if ($x -lt 140) {
        # Sample background from x=30, y=$y
        $bgColor = $bmp.GetPixel(30, $y)
        $cleanBmp.SetPixel($x, $y, $bgColor)
      } else {
        # Blend mirror hair
        if ($isOrange -or $isWhite -or $isBlackOutline) {
          $cleanBmp.SetPixel($x, $y, $mirrorColor)
        }
      }
    }
  }
}
$g.Dispose()

# Save test crop
$crop = New-Object System.Drawing.Bitmap 300, 380
$cg = [System.Drawing.Graphics]::FromImage($crop)
$cg.DrawImage($cleanBmp, (New-Object System.Drawing.Rectangle 0, 0, 300, 380), (New-Object System.Drawing.Rectangle 115, 85, 300, 380), [System.Drawing.GraphicsUnit]::Pixel)
$cg.Dispose()
$crop.Save("C:/Users/sam/.gemini/antigravity/scratch/hanage-game/test_crops/test_retouch_res.png", [System.Drawing.Imaging.ImageFormat]::Png)
$crop.Dispose()
$cleanBmp.Dispose()
$bmp.Dispose()
Write-Output "Saved test_retouch_res.png"
