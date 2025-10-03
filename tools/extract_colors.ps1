param(
  [string]$Path1 = "..\logomolina.png",
  [string]$Path2 = "..\logomolina2.png",
  [int]$Top = 8,
  [int]$SampleStep = 2
)
Add-Type -AssemblyName System.Drawing

function Get-DominantColors([string]$path, [int]$top, [int]$step){
  $full = Resolve-Path -Path (Join-Path -Path $PSScriptRoot -ChildPath $path)
  $bmp = [System.Drawing.Bitmap]::FromFile($full)
  $h = @{}
  for($x=0; $x -lt $bmp.Width; $x+=$step){
    for($y=0; $y -lt $bmp.Height; $y+=$step){
      $p = $bmp.GetPixel($x,$y)
      if($p.A -gt 0){
        $r=$p.R; $g=$p.G; $b=$p.B
        # ignorar blanco/negro casi puros
        if(-not (($r -gt 245 -and $g -gt 245 -and $b -gt 245) -or ($r -lt 10 -and $g -lt 10 -and $b -lt 10))){
          $hex = ('#{0:X2}{1:X2}{2:X2}' -f $r,$g,$b).ToLower()
          if($h.ContainsKey($hex)){ $h[$hex]++ } else { $h[$hex]=1 }
        }
      }
    }
  }
  $bmp.Dispose()
  return ($h.GetEnumerator() | Sort-Object -Property Value -Descending | Select-Object -First $top | ForEach-Object { $_.Key })
}

Write-Output "logomolina.png"
Get-DominantColors $Path1 $Top $SampleStep | ForEach-Object { $_ }
Write-Output "logomolina2.png"
Get-DominantColors $Path2 $Top $SampleStep | ForEach-Object { $_ }
