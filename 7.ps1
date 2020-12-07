$bags = gc .\7.txt

$bagtable = @()
foreach ($bag in $bags){

    $splitobj = ($bag -split " ")
    $PrimaryBagColor = $splitobj[0] + " " + $splitobj[1]
    
    $innerobj = ($bag -split "contain")[1]
    $innerobj = $innerobj -split ","
    foreach ($ob in $innerobj){
        $ob = $ob -split " " | Where-Object {$_ -ne $null -and $_ -notlike "bag*"}
        $object = $null
        $object = [PSCustomObject]@{
            PrimaryBagColor = $PrimaryBagColor
            InnerBagCount = $ob[1]
            InnerBagColor = ($ob[2] + " " + $ob[3])
        }
        $bagtable += $object
    }
    
}
$goldcontainers = $bagtable | Where-Object {$_.innerbagcolor -eq "shiny gold"}

$filteredcontainers = $bagtable | Where-Object {$goldcontainers.PrimaryBagColor -contains $_.InnerBagColor}

$finalsum = $goldcontainers.count + $filteredcontainers.count