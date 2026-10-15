Add-Type -AssemblyName System.Drawing

# Let's inspect the vertical and horizontal positions of:
# 1. Top of head (hair top)
# 2. Eyes
# 3. Chin
# 4. Cleavage / Chest
# 5. Left and right boundaries
$data = @()
$files = @(
  @{ id="gal"; path="C:/Users/sam/.gemini/antigravity/brain/7af71346-43bc-434c-ba68-9c0de09bfc51/.user_uploaded/media_1792074548580_a28ecefa.jpg" },
  @{ id="res"; path="C:/Users/sam/.gemini/antigravity/brain/7af71346-43bc-434c-ba68-9c0de09bfc51/.user_uploaded/media_1792074548573_57b87a28.jpg" },
  @{ id="cel"; path="C:/Users/sam/.gemini/antigravity/brain/7af71346-43bc-434c-ba68-9c0de09bfc51/.user_uploaded/media_1792074548589_cf192fb4.jpg" }
)

Write-Output "Measuring character alignment across all 3 images..."
