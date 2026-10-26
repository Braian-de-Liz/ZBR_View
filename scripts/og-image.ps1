Add-Type -AssemblyName System.Drawing

$ErrorActionPreference = 'Stop'
function U([string]$b64) { [Text.Encoding]::UTF8.GetString([Convert]::FromBase64String($b64)) }

$w = 1200
$h = 630
$bmp = New-Object System.Drawing.Bitmap($w, $h)
$g = [System.Drawing.Graphics]::FromImage($bmp)
$g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
$g.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::ClearTypeGridFit
$g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
$g.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality

# Fundo com gradiente
$rect = New-Object System.Drawing.Rectangle(0, 0, $w, $h)
$bg = New-Object System.Drawing.Drawing2D.LinearGradientBrush($rect, [System.Drawing.Color]::FromArgb(11, 17, 32), [System.Drawing.Color]::FromArgb(13, 26, 46), 45.0)
$g.FillRectangle($bg, $rect)

# Grid sutil
$gridPen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(14, 148, 163, 184), 1)
for ($x = 0; $x -lt $w; $x += 60) { $g.DrawLine($gridPen, $x, 0, $x, $h) }
for ($y = 0; $y -lt $h; $y += 60) { $g.DrawLine($gridPen, 0, $y, $w, $y) }

# Glow suave (elipses concêntricas para simular desfoque)
for ($i = 18; $i -ge 1; $i--) {
  $glow = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(2, 56, 189, 248))
  $g.FillEllipse($glow, 420 - ($i * 26), -330 - ($i * 14), 860 + ($i * 52), 660 + ($i * 28))
  $glow.Dispose()
}
for ($i = 12; $i -ge 1; $i--) {
  $glowGreen = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(2, 52, 211, 153))
  $g.FillEllipse($glowGreen, 780 - ($i * 20), -300 - ($i * 12), 620 + ($i * 40), 520 + ($i * 24))
  $glowGreen.Dispose()
}

# Barra de acento
$accentBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(56, 189, 248))
$g.FillRectangle($accentBrush, 0, 0, $w, 4)

# Logo
$logoPath = Join-Path $PSScriptRoot '..\src\assets\imgs\logo-zbr.png'
if (Test-Path $logoPath) {
  $logo = [System.Drawing.Image]::FromFile((Resolve-Path $logoPath))
  $g.DrawImage($logo, 78, 52, 140, 104)
  $logo.Dispose()
}

# Tipografia
$titleFont = New-Object System.Drawing.Font('Segoe UI', 62, [System.Drawing.FontStyle]::Bold, [System.Drawing.GraphicsUnit]::Pixel)
$subFont = New-Object System.Drawing.Font('Segoe UI', 30, [System.Drawing.FontStyle]::Regular, [System.Drawing.GraphicsUnit]::Pixel)
$tagFont = New-Object System.Drawing.Font('Consolas', 22, [System.Drawing.FontStyle]::Bold, [System.Drawing.GraphicsUnit]::Pixel)
$monoFont = New-Object System.Drawing.Font('Consolas', 24, [System.Drawing.FontStyle]::Regular, [System.Drawing.GraphicsUnit]::Pixel)
$smallFont = New-Object System.Drawing.Font('Segoe UI', 19, [System.Drawing.FontStyle]::Regular, [System.Drawing.GraphicsUnit]::Pixel)

$white = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(233, 238, 248))
$muted = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(154, 168, 191))
$faint = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(123, 138, 163))
$cyan = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(56, 189, 248))
$green = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(52, 211, 153))

$g.DrawString((U 'WkJSIFN0YW5kYXJkcw=='), $titleFont, $white, 78, 196)
$g.DrawString((U 'VmFsaWRhw6fDo28gZGUgZG9jdW1lbnRvcyBicmFzaWxlaXJvcyBjb20gWm9k'), $subFont, $muted, 82, 292)
$g.DrawString((U 'Q1BGICAgwrcgICBDTlBKICAgwrcgICBSRyAgIMK3ICAgQ0VQICAgwrcgICBUZWxlZm9uZQ=='), $tagFont, $cyan, 82, 350)

# Card do comando
$cardRect = New-Object System.Drawing.Rectangle(80, 430, 700, 74)
$cardPath = New-Object System.Drawing.Drawing2D.GraphicsPath
$r = 14
$cardPath.AddArc($cardRect.X, $cardRect.Y, $r * 2, $r * 2, 180, 90)
$cardPath.AddArc($cardRect.Right - $r * 2, $cardRect.Y, $r * 2, $r * 2, 270, 90)
$cardPath.AddArc($cardRect.Right - $r * 2, $cardRect.Bottom - $r * 2, $r * 2, $r * 2, 0, 90)
$cardPath.AddArc($cardRect.X, $cardRect.Bottom - $r * 2, $r * 2, $r * 2, 90, 90)
$cardPath.CloseFigure()

$cardFill = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(8, 13, 24))
$cardPen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(31, 43, 69), 1.5)
$g.FillPath($cardFill, $cardPath)
$g.DrawPath($cardPen, $cardPath)

$g.DrawString('$', $monoFont, $green, 104, 450)
$g.DrawString('npm install br_standards_with_zod', $monoFont, $white, 128, 450)

# Rodapé
$g.DrawString((U 'QWxnb3JpdG1vcyBvZmljaWFpcyAgwrcgIFNhbml0aXphw6fDo28gYXV0b23DoXRpY2EgIMK3ICBUeXBlU2NyaXB0IGZpcnN0'), $smallFont, $faint, 82, 544)

$bmp.Save((Join-Path $PSScriptRoot '..\public\og-image.png'), [System.Drawing.Imaging.ImageFormat]::Png)

$g.Dispose()
$bmp.Dispose()
Write-Output 'og-image.png gerado'
