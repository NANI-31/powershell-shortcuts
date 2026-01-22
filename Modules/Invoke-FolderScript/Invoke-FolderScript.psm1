function Invoke-FolderScript {
    param (
        [Parameter(Mandatory = $true)]
        [string]$TargetFolder,

        [Parameter(Mandatory = $true)]
        [string]$Command
    )

    $currentPath = Get-Location
    $folderName = Split-Path -Leaf $currentPath

    if ($folderName -ne $TargetFolder) {
        # Search in current directory
        $targetDir = Get-ChildItem -Path $currentPath -Directory -Filter $TargetFolder -ErrorAction SilentlyContinue

        # If not found, search upward
        if (-not $targetDir) {
            $ancestor = $currentPath
            while ($ancestor.Parent -ne $null) {
                $candidate = Join-Path $ancestor.FullName $TargetFolder
                if (Test-Path $candidate) {
                    $targetDir = Get-Item $candidate
                    break
                }
                $ancestor = $ancestor.Parent
            }
        }

        if ($targetDir) {
            $targetPath = $targetDir.FullName
            Set-Location $targetPath
            Write-Host "Moved to $TargetFolder directory at $targetPath" -ForegroundColor Cyan
        } else {
            Write-Host "No '$TargetFolder' directory found in current or parent folders." -ForegroundColor Yellow
            return
        }
    }

    Write-Host "Running '$Command' in $(Get-Location)" -ForegroundColor Green
    Invoke-Expression $Command
}
