$rawdata = Get-Content 2.txt
$correcttally = 0
$bothtally = 0
$neithertally = 0
foreach ($d in $rawdata) {
    #chop up characters
        $split = $null
        $split = $d -split " "
        $lowerlimit = ($split[0] -split "-")[0] - 1 #subtract 1 for null indexing
        $upperlimit = ($split[0] -split "-")[1] - 1 #subtract 1 for null indexing
        $letter = ($split[1]).trim(":")
        $array = $split[2].ToCharArray()
    #get the nth characters in array
        $lowerval = $array[$lowerlimit]
        $upperval = $array[$upperlimit]
    #compare nth characters in array. Criteria: has to be in ONLY one slot.
    if ($lowerval -eq $letter -or $upperval -eq $letter){
        if ($lowerval -eq $letter -and $upperval -eq $letter){
            #Nope: letter can't be in both positions
            $bothtally ++
            Write-host "." -ForegroundColor Magenta -NoNewline  
        }
        else{
            $correcttally ++
            Write-host "+" -ForegroundColor green -NoNewline
        }
    }
    else {
        #Nope: letter is not even in string
        $neithertally ++
        Write-host "." -ForegroundColor red -NoNewline
    }
}
Write-Host "
========================================================"
Write-Host "Correct Total : $correcttally" -ForegroundColor Green
Write-Host "Both Total : $bothtally" -ForegroundColor Magenta
Write-Host "Neither Total : $neithertally" -ForegroundColor Red