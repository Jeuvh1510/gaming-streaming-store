Add-Type -AssemblyName System.Drawing
$img = [System.Drawing.Bitmap]::FromFile('C:\Users\Jesus\Downloads\pagina\referencia.jpg')

# Analyze specific regions to find text/denomination
# Check the center and right side where denomination usually appears
Write-Host "=== Region analysis ==="

# Sample rows to find white text areas
for ($y = 0; $y -lt $img.Height; $y += 4) {
    $whiteCount = 0
    for ($x = 0; $x -lt $img.Width; $x += 4) {
        $c = $img.GetPixel($x, $y)
        if ($c.R -gt 200 -and $c.G -gt 200 -and $c.B -gt 200) { $whiteCount++ }
    }
    if ($whiteCount -gt 5) {
        Write-Host "Row $y : white pixels = $whiteCount"
    }
}

# Check for any red/gold/yellow accents (typical for card denominations)
Write-Host "`n=== Accent colors ==="
$accents = @{}
for ($x = 0; $x -lt $img.Width; $x += 2) {
    for ($y = 0; $y -lt $img.Height; $y += 2) {
        $c = $img.GetPixel($x, $y)
        # Check for yellow/gold
        if ($c.R -gt 150 -and $c.G -gt 100 -and $c.B -lt 100) {
            $key = "yellow"
            if ($accents.ContainsKey($key)) { $accents[$key]++ } else { $accents[$key] = 1 }
        }
        # Check for red
        elseif ($c.R -gt 150 -and $c.G -lt 100 -and $c.B -lt 100) {
            $key = "red"
            if ($accents.ContainsKey($key)) { $accents[$key]++ } else { $accents[$key] = 1 }
        }
        # Check for light blue (PSN logo)
        elseif ($c.B -gt 150 -and $c.R -lt 100 -and $c.G -gt 100) {
            $key = "lightblue"
            if ($accents.ContainsKey($key)) { $accents[$key]++ } else { $accents[$key] = 1 }
        }
    }
}
$accents.GetEnumerator() | ForEach-Object { Write-Host "$($_.Key): $($_.Value)" }

$img.Dispose()