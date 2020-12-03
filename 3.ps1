$map = Get-Content 3.txt

#set slope
$x = 3
$width = 30

$treecount = 0
$opencount = 0
$errorcount = 0

foreach ($m in $map){
    if ($map.indexof($m) -eq 0){
        $sigfig = $m[0]
        $lastposition = 0
    }
    else {
        $position = $lastposition + $x
        if ($position -gt $width){
            $position = $position - ($width + 1)
        }
        $sigfig = $m[$position]
        $lastposition = $position
    }
    ## Determine if tree or not and add to count
    switch ($sigfig){
        '.' {$opencount++; Write-host "." -nonewline -ForegroundColor green}
        '#' {$treecount++; Write-host "#" -nonewline -ForegroundColor RED}
        default {$errorcount++; Write-host "?" -nonewline -ForegroundColor cyan}
    }

}
Write-Host "
========================================================"
Write-Host "Tree Total : $treecount" -ForegroundColor RED
Write-Host "Open Total : $opencount" -ForegroundColor Green
Write-Host "Error Total : $errorcount" -ForegroundColor Cyan
