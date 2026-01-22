function helloPrintFunc {
    param (
        [string]$branchName_1,
        [string]$branchName_2
    )
    Write-Host git push origin $branchName_1
    Write-Host git push origin $branchName_2
}