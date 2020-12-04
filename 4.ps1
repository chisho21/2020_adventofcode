##import raw data
$rawdata = gc 4.txt | Out-String
##split passports into chucks by two consecutive line breaks
$passports = $rawdata -split "`n`n"
## iterate through each and add to a common table
$passtable = @()
$count = 0
foreach ($pass in $passports){
    $count ++
    $p = $pass -split " "
    $p = $p -split "`n"
    $object = $null
    $object = [PSCustomObject]@{
        passnum = $count
        byr = ($p | Where-Object {$_ -like "byr:*"}) -split ":" | Select-Object -Last 1 ##(Birth Year)
        iyr = ($p | Where-Object {$_ -like "iyr:*"}) -split ":" | Select-Object -Last 1 ##(Issue Year)
        eyr = ($p | Where-Object {$_ -like "eyr:*"}) -split ":" | Select-Object -Last 1 ##(Expiration Year)
        hgt = ($p | Where-Object {$_ -like "hgt:*"}) -split ":" | Select-Object -Last 1 ##(Height)
        hcl = ($p | Where-Object {$_ -like "hcl:*"}) -split ":" | Select-Object -Last 1 ##(Hair Color)
        ecl = ($p | Where-Object {$_ -like "ecl:*"}) -split ":" | Select-Object -Last 1 ##(Eye Color)
        pid = ($p | Where-Object {$_ -like "pid:*"}) -split ":" | Select-Object -Last 1 ##(Passport ID)
        cid = ($p | Where-Object {$_ -like "cid:*"}) -split ":" | Select-Object -Last 1 ##(Country ID)
    }
    if ($object.byr -and $object.iyr -and $object.eyr -and $object.hgt -and $object.hcl -and $object.ecl -and $object.pid){
        $object | Add-member -MemberType NoteProperty -Name isValid -Value $true
    }
    else {
        $object | Add-member -MemberType NoteProperty -Name isValid -Value $false
    }
    
    $passtable += $object
}
##apply the logic to $passtable
Write-Host "Valid Count:"
($passtable | Where-Object {$_.isValid -eq $true}).count