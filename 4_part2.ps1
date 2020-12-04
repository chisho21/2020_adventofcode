##import raw data
$rawdata = gc 4.txt | Out-String
##split passports into chucks by two consecutive line breaks
$passports = $rawdata -split "`n`n"
## iterate through each and add to a common table
$passtable = @()
$count = 0
#eye color set
$validecl = "amb","blu","brn","gry","grn","hzl","oth"

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
    <#
    byr (Birth Year) - four digits; at least 1920 and at most 2002.
    iyr (Issue Year) - four digits; at least 2010 and at most 2020.
    eyr (Expiration Year) - four digits; at least 2020 and at most 2030.
    hgt (Height) - a number followed by either cm or in:
    If cm, the number must be at least 150 and at most 193.
    If in, the number must be at least 59 and at most 76.
    hcl (Hair Color) - a # followed by exactly six characters 0-9 or a-f.
    ecl (Eye Color) - exactly one of: amb blu brn gry grn hzl oth.
    pid (Passport ID) - a nine-digit number, including leading zeroes.
    cid (Country ID) - ignored, missing or not.
    #>
    
    
    if ($object.byr -and $object.iyr -and $object.eyr -and $object.hgt -and $object.hcl -and $object.ecl -and $object.pid){
        ## if all needed fields are present add 1 to sum for every valid field
        $reason = $null
        $sum = 0
        if ($object.byr -ge 1920 -and $object.byr -le 2002 ) {$sum ++} else {$reason += "byr,"}
        if ($object.iyr -ge 2010 -and $object.iyr -le 2020  ) {$sum ++} else {$reason += "iyr,"}
        if ($object.eyr -ge 2020 -and $object.eyr -le 2030  ) {$sum ++} else {$reason += "eyr,"}
        if ($object.hgt -like "*cm" -or $object.hgt -like "*in"  ) {
            if ($object.hgt -like "*cm"){
                [int]$num = $object.hgt -split "c" |Select-Object -First 1
                if ($num -ge 150 -and $num -le 193) {$sum ++} else {$reason += "hgt-cm-range,"}
            } 
            if ($object.hgt -like "*in"){
                [int]$num = $object.hgt -split "i" |Select-Object -First 1
                if ($num -ge 59 -and $num -le 76) {$sum ++} else {$reason += "hgt-in-range,"}
            } 
        }
        else {
            $reason += "hgt-missingCMorIN,"
        }
        if ($object.hcl -match "#\w\w\w\w\w\w"  ) {$sum ++}else {$reason += "hcl,"}
        if ($validecl -contains $object.ecl  ) {$sum ++} else {$reason += "ecl,"}
        if ($object.pid -match "\d\d\d\d\d\d\d\d\d" ) {$sum ++} else {$reason += "pid,"}
        
        if ($sum -eq 8){
            $object | Add-member -MemberType NoteProperty -Name isValid -Value $true
        }
       else {
            $object | Add-member -MemberType NoteProperty -Name isValid -Value $false
            $object | Add-member -MemberType NoteProperty -Name isValidReason -Value $reason
       }
    }
    else {
        $object | Add-member -MemberType NoteProperty -Name isValid -Value $false
        $object | Add-member -MemberType NoteProperty -Name isValidReason -Value "Blank Property"
    }
    
    $passtable += $object
}
##apply the logic to $passtable
Write-Host "Valid Count:"
($passtable | Where-Object {$_.isValid -eq $true}).count
$passtable | export-excel