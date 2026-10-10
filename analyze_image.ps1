Add-Type -AssemblyName System.Drawing
$img = [System.Drawing.Bitmap]::FromFile('C:\Users\Jesus\Downloads\pagina\referencia.jpg')
Write-Host "Size: $($img.Width)x$($img.Height)"
Write-Host "PixelFormat: $($img.PixelFormat)"

# Sample colors to understand the image
$colors = @{}
for ($x = 0; $x -lt $img.Width; $x += 8) {
    for ($y = 0; $y -lt $img.Height; $y += 8) {
        $c = $img.GetPixel($x, $y)
        $r = [math]::Round($c.R / 32) * 32
        $g = [math]::Round($c.G / 32) * 32
        $b = [math]::Round($c.B / 32) * 32
        $key = "$r,$g,$b"
        if ($colors.ContainsKey($key)) { $colors[$key]++ } else { $colors[$key] = 1 }
    }
}

Write-Host "`nTop colors (R,G,B):"
$colors.GetEnumerator() | Sort-Object Value -Descending | Select-Object -First 15 | ForEach-Object {
    Write-Host "$($_.Key) count=$($_.Value)"
}

# Check brightness distribution
$bright = 0; $dark = 0; $mid = 0
for ($x = 0; $x -lt $img.Width; $x += 8) {
    for ($y = 0; $y -lt $img.Height; $y += 8) {
        $c = $img.GetPixel($x, $y)
        $lum = (0.299 * $c.R + 0.587 * $c.G + 0.114 * $c.B)
        if ($lum -gt 180) { $bright++ }
        elseif ($lum -lt 80) { $dark++ }
        else { $mid++ }
    }
}
Write-Host "`nBrightness: bright=$bright mid=$mid dark=$dark"
$img.Dispose()