Add-Type -AssemblyName System.Drawing

$bmp = [System.Drawing.Bitmap]::FromFile('C:/Users/sam/.gemini/antigravity/brain/7af71346-43bc-434c-ba68-9c0de09bfc51/.user_uploaded/media_1792074548573_57b87a28.jpg')

# Let's inspect column x = 200 from y = 200 to 450 to see where the text colors appear
# The text has yellow/orange fill (#ff8400 / #ffd13b) or black outline
for ($y = 200; $y -le 450; $y += 5) {
  $c = $bmp.GetPixel(200, $y)
  Write-Output "y=$y R=$($c.R) G=$($c.G) B=$($c.B)"
}
$bmp.Dispose()
