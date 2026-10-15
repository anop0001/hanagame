Add-Type -AssemblyName System.Drawing

$bmp = [System.Drawing.Bitmap]::FromFile('C:/Users/sam/.gemini/antigravity/brain/7af71346-43bc-434c-ba68-9c0de09bfc51/.user_uploaded/media_1792074548573_57b87a28.jpg')

$minX = 1000; $maxX = 0; $minY = 1000; $maxY = 0;
for ($x = 20; $x -le 250; $x++) {
  for ($y = 330; $y -le 370; $y++) {
    $c = $bmp.GetPixel($x, $y)
    # White text has high R, G, B with black outline nearby
    if ($c.R -ge 230 -and $c.G -ge 230 -and $c.B -ge 230) {
      if ($x -lt $minX) { $minX = $x }
      if ($x -gt $maxX) { $maxX = $x }
      if ($y -lt $minY) { $minY = $y }
      if ($y -gt $maxY) { $maxY = $y }
    }
  }
}
Write-Output "White text bbox: x=$minX..$maxX, y=$minY..$maxY"
$bmp.Dispose()
