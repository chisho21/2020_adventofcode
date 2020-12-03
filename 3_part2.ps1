$map = Get-Content 3.txt
$width = $map[0].Length -1

$treecounttable = @()

$trialtable = @()
$trialtable += [PSCustomObject]@{TrialNum = '1'; x = '1'; y = '1'}
$trialtable += [PSCustomObject]@{TrialNum = '2'; x = '3'; y = '1'}
$trialtable += [PSCustomObject]@{TrialNum = '3'; x = '5'; y = '1'}
$trialtable += [PSCustomObject]@{TrialNum = '4'; x = '7'; y = '1'}
$trialtable += [PSCustomObject]@{TrialNum = '5'; x = '1'; y = '2'}

foreach ($trial in $trialtable){
    #create open counters
    $treecount = 0
    $opencount = 0
    $errorcount = 0
    $skipcount = 0

    foreach ($m in $map){
        $sigfig = $null
        if ($map.indexof($m) -eq 0){
            $sigfig = $m[0]
            $lastposition = 0
        }
        else {
            if (($map.indexof($m)) % $trial.y -eq 0){
                $position = $lastposition + $trial.x
                if ($position -gt $width){
                    $position = $position - ($width + 1)
                }
                $sigfig = $m[$position]
                $lastposition = $position
            }
            else {
                $sigfig = "skip"
            } 
        }
        ## Determine if tree or not and add to count
        switch ($sigfig){
            '.' {$opencount++; Write-host "." -nonewline -ForegroundColor green}
            '#' {$treecount++; Write-host "#" -nonewline -ForegroundColor RED}
            'skip' {$skipcount++; Write-host "S" -nonewline -ForegroundColor yellow}
            default {$errorcount++; Write-host "?" -nonewline -ForegroundColor cyan}
        }
    
    }#end for each level of map
    # Write display stats and add count to table
    $treecounttable += $treecount
    Write-Host "
==============TriallNum = $($trial.Trialnum)=========================================="
    Write-Host "    Tree Total : $treecount" -ForegroundColor RED
    Write-Host "    Open Total : $opencount" -ForegroundColor Green
    Write-Host "    Skip Total : $skipcount" -ForegroundColor Yellow
    Write-Host "    Error Total : $errorcount" -ForegroundColor Cyan

}#end foreach trial

$treecounttable
## multiply final products
$final = 0
    foreach ($tc in $treecounttable){
        if (!$final){
            $final = $tc
        }
        else {
            $final = $final * $tc
        }
    }

Write-Host "Product of all counts ==> $final" -BackgroundColor Green -ForegroundColor Red