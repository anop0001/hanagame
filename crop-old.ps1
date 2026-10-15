Add-Type -AssemblyName System.Drawing
$bmpOld = [System.Drawing.Bitmap]::FromFile('C:/Users/sam/.gemini/antigravity/brain/7af71346-43bc-434c-ba68-9c0de09bfc51/.user_uploaded/media_1792070000938_06935698.jpg')
$cropOld = New-Object System.Drawing.Bitmap 270, 345
$g = [System.Drawing.Graphics]::FromImage($cropOld)
$dest = New-Object System.Drawing.Rectangle 0, 0, 270, 345
$src = New-Object System.Drawing.Rectangle 115, 35, 270, 345
$g.DrawImage($bmpOld, $dest, $src, [System.Drawing.GraphicsUnit]::Pixel)
$g.Dispose()
$cropOld.Save('C:/Users/sam/.gemini/antigravity/scratch/hanage-game/test_crops/old_crop_20.png', [System.Drawing.Imaging.ImageFormat]::Png)
$cropOld.Dispose()
$bmpOld.Dispose()
Write-Output 'Saved old_crop_20.png'
