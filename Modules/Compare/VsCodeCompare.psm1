function compare-vscode {
    param (
        [string]$file1,
        [string]$file2
    )

    $vscodePath = "C:\Program Files\Microsoft VS Code\Code.exe"
    if (Test-Path $vscodePath) {
        & $vscodePath --diff $file1 $file2
    } else {
        Write-Error "VS Code not found at path: $vscodePath"
    }
}

function compare {
    param (
        [string]$name
    )
        # === Configuration ===
    $baseFolder = "E:\bytimetxt\$name"
    $BeforeFile  = Join-Path $baseFolder "before.txt"
    $AfterFile   = Join-Path $baseFolder "after.txt"
     # Ensure output folder exists
    if (-not (Test-Path $baseFolder)) {
        New-Item -ItemType Directory -Path $baseFolder | Out-Null
    }

    # === Generate output file with auto-increment if it exists ===
    $ChangesFileBase = Join-Path $baseFolder "$name.txt"
    $ChangesFile = $ChangesFileBase
    $counter = 1
    while (Test-Path $ChangesFile) {
        $ChangesFile = Join-Path $baseFolder ("$name $counter.txt")
        $counter++
    }


    # Check if both input files exist before proceeding
    if (-not (Test-Path $BeforeFile)) {
        Write-Error "Error: 'before.txt' not found at $BeforeFile"
        exit 1
    }
    if (-not (Test-Path $AfterFile)) {
        Write-Error "Error: 'after.txt' not found at $AfterFile"
        exit 1
    }

    # === Compare Files ===
    # Use Get-Content to read the lines from both files
    # Use Compare-Object to find the differences:
    # -Property {$_} is used because we are comparing strings (the full paths) line by line.
    # -PassThru ensures the differing objects are output.
    # -IncludeEqual is NOT used, so only differences are returned.
    $ComparisonResult = Compare-Object `
        -ReferenceObject (Get-Content $BeforeFile) `
        -DifferenceObject (Get-Content $AfterFile) `
        -PassThru

    # === Export Changes to Output File ===
    # Group the results and format them for better readability in the changes.txt file.

    # Added Items (Present in 'after.txt' but not in 'before.txt' - SideIndicator '=>')
    $AddedItems = $ComparisonResult | Where-Object { $_.SideIndicator -eq '=>' } | Select-Object -ExpandProperty InputObject

    # Removed Items (Present in 'before.txt' but not in 'after.txt' - SideIndicator '<=')
    $RemovedItems = $ComparisonResult | Where-Object { $_.SideIndicator -eq '<=' } | Select-Object -ExpandProperty InputObject

    # Output the formatted results to the changes file
    "=== ITEMS ADDED AFTER INSTALLATION ($($AddedItems.Count)) ===" | Out-File $ChangesFile -Encoding UTF8
    $AddedItems | Out-File $ChangesFile -Append -Encoding UTF8
    "" | Out-File $ChangesFile -Append

    "=== ITEMS REMOVED AFTER INSTALLATION ($($RemovedItems.Count)) ===" | Out-File $ChangesFile -Append
    $RemovedItems | Out-File $ChangesFile -Append -Encoding UTF8

    Write-Output "Comparison complete. Changes saved to $ChangesFile"
}