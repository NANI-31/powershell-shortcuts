Get-ChildItem "$PSScriptRoot\Public\*.*" -Include *.ps1, *.psm1 -File | ForEach-Object {
    . $_.FullName
}
Export-ModuleMember -Function *