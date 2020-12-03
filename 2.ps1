$rawdata = Get-Content 2.txt
$correcttally = 0
$wrongtally = 0
foreach ($d in $rawdata) {
    #chop up characters
    $split = $d -split " "
    $object = $null
    $object = [PSCustomObject]@{
        lowerlimit = ($split[0] -split "-")[0]
        upperlimit = ($split[0] -split "-")[1]
        letter = ($split[1]).trim(":")
        string = $split[2].ToCharArray()
    }
    #Get Count of stuff
    $count = ($object.string | Where-Object {$_ -eq $object.letter}).count
    if ($count -ge $object.lowerlimit -and $count -le $object.upperlimit){
        #Success
        $correcttally ++
        Write-host "." -ForegroundColor green -NoNewline
    }
    else {
        #Nope!
        $wrongtally ++
        Write-host "." -ForegroundColor red -NoNewline
    }
}
Write-Host "
========================================================"
Write-Host "Correct Total : $correcttally" -ForegroundColor Green
Write-Host "Neither Total : $wrongtally" -ForegroundColor Red