Add-Type -AssemblyName System.Drawing

$files = @(
  @{ name = "10s_gal"; path = "C:/Users/sam/.gemini/antigravity/brain/7af71346-43bc-434c-ba68-9c0de09bfc51/.user_uploaded/media_1792074548580_a28ecefa.jpg" },
  @{ name = "20s_res"; path = "C:/Users/sam/.gemini/antigravity/brain/7af71346-43bc-434c-ba68-9c0de09bfc51/.user_uploaded/media_1792074548573_57b87a28.jpg" },
  @{ name = "30s_cel"; path = "C:/Users/sam/.gemini/antigravity/brain/7af71346-43bc-434c-ba68-9c0de09bfc51/.user_uploaded/media_1792074548589_cf192fb4.jpg" }
)

foreach ($f in $files) {
  $bmp = [System.Drawing.Bitmap]::FromFile($f.path)
  Write-Output "=== $($f.name) ($($bmp.Width) x $($bmp.Height)) ==="
  $bmp.Dispose()
}
