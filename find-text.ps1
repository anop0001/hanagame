Add-Type -AssemblyName System.Drawing

$bmp = [System.Drawing.Bitmap]::FromFile('C:/Users/sam/.gemini/antigravity/brain/7af71346-43bc-434c-ba68-9c0de09bfc51/.user_uploaded/media_1792074548573_57b87a28.jpg')

# Find the bounding box of the orange text "20秒モード：悶絶スタンダード"
# Orange/yellow fill typically has high Red (>200), medium Green (100-180), low Blue (<50)
$minX = 1000; $maxX = 0; $minY = 1000; $maxY = 0;
for ($x = 20; $x -le 350; $x++) {
  for ($y = 280; $y -le 380; $y++) {
    $c = $bmp.GetPixel($x, $y)
    if ($c.R -ge 180 -and $c.G -ge 90 -and $c.G -le 190 -and $c.B -le 60) {
      if ($x -lt $minX) { $minX = $x }
      if ($x -gt $maxX) { $maxX = $x }
      if ($y -lt $minY) { $minY = $y }
      if ($y -gt $maxY) { $maxY = $y }
    }
  }
}
Write-Output "Text bbox: x=$minX..$maxX, y=$minY..$maxY"
$bmp.Dispose()
