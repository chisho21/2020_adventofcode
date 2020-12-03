$nums = gc ./1.txt
foreach ($num in $nums){
    foreach ($num2 in $nums){
        $sum = [int]$num + [int]$num2
        if ($sum -eq 2020){
            $product = int]$num * [int]$num2
            Write-Host "$num and $num2 are the answer! Product = $product" -ForegroundColor Green
        }
    }
}