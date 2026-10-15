Add-Type -AssemblyName System.Drawing

# Let's inspect the text regions on the researcher and celeb
# Researcher text: "20秒モード：悶絶スタンダード\n研究員お姉さん"
# It sits on the dark blue grid background and the brown wavy hair.
# Let's see what it looks like if we inspect the pixels around it.
Write-Output "Checking text repair possibilities..."
