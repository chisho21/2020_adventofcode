$nums = Get-Content 1.txt

foreach ($num in $nums){
    foreach ($num2 in $nums){
        foreach ($num3 in $nums){
            $sum = [int]$num + [int]$num2 + [int]$num3
            if ($sum -eq 2020){
                $product = [int]$num * [int]$num2 * [int]$num3
                Write-Host "$num and $num2 and $num3 are the answer! Product = $product" -ForegroundColor Green
            }
        }
    }
}