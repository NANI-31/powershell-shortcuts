Import-Module Invoke-FolderScript
Import-Module Invoke-ReactCodes
# $ModulesRoot = "C:\Users\Chowd\OneDrive\Documents\WindowsPowerShell\Modules"

# if ($env:PSModulePath -notlike "*$ModulesRoot*") {
#     $env:PSModulePath += ";$ModulesRoot"
# }


# Set-Alias s Invoke-FolderScript
# Import-Module FlutterTools
Import-Module GitTools
# Import-Module NodeTools
# Import-Module ReactNativeTools
# Import-Module ReactTools
# Import-Module PythonTools

# $modulePath = "C:\Users\Chowd\OneDrive\Documents\WindowsPowerShell\Modules\ReactTools"
# Import-Module "$modulePath\ReactTools.psm1"
# Import-Module "$modulePath\ReactNativeTools.psm1"
# Import-Module "$modulePath\ReactLibraries.psm1"

# Path to the folder containing all your modules
# $ModulesRoot = "C:\Users\Chowd\OneDrive\Documents\WindowsPowerShell\Modules"

# if (Test-Path $ModulesRoot) {

#     Get-ChildItem -Path $ModulesRoot -Recurse -Filter *.psm1 | ForEach-Object {
#         try {
#             Import-Module $_.FullName -Force -ErrorAction Stop
#             # Write-Host "Imported module: $($_.Name)" -ForegroundColor Green
#         }
#         catch {
#             Write-Host "Failed to import module: $($_.Name)" -ForegroundColor Red
#         }
#     }

# } else {
#     Write-Host "Modules folder not found: $ModulesRoot" -ForegroundColor Yellow
# }


[Console]::OutputEncoding = [Text.UTF8Encoding]::new()
# Set-PSReadLineOption -PredictionSource History
function a { Set-Location .. }
# Set-Alias .. ..
function ..\ { Set-Location .. }
function ..\.. { Set-Location ..\.. }

function cc { code .}
function k { clear }

function aa {
   antigravity
}

# function co {
#     param([string]$path = ".")
#     & "C:\Users\Chowd\AppData\Local\Programs\Microsoft VS Code\Code.exe" $path
# }

Remove-Item Alias:cd -ErrorAction SilentlyContinue

function cd {
    param([string]$path)
    switch ($path) {
        's' { Set-Location 'server' }
        'c' { Set-Location 'client' }
	'f' { Set-Location 'CollegeBusTrackingFlutterApp' }
        default { Set-Location $path }
    }
}
function e { Set-Location .. }
# function c { Set-Location 'client' }
# function c { Set-Location -Path ".\client" }
# function s { Set-Location 'server' }
# now i want to cd.. 

# Stateful c function




# Import the Chocolatey Profile that contains the necessary code to enable
# tab-completions to function for `choco`.
# Be aware that if you are missing these lines from your profile, tab completion
# for `choco` will not function.
# See https://ch0.co/tab-completion for details.
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}


function findport {
    param([int]$port)
    netstat -aon | Select-String ":$port\s"
}

function killport {
    param([int]$port)
    # taskkill /PID 1234 /F
    # /F → forces the process to terminate
    # Get-Process -Id (Get-NetTCPConnection -LocalPort 8080).OwningProcess
    $processes = netstat -aon | Select-String ":$port\s" | ForEach-Object {
        $fields = $_ -split '\s+'
        $processId = $fields[-1]
        Get-Process -Id $processId -ErrorAction SilentlyContinue
    } | Where-Object { $_ -ne $null }

    foreach ($process in $processes) {
        Write-Host "Killing process $($process.ProcessName) with PID $($process.Id) using port $port"
        Stop-Process -Id $process.Id -Force
    }
}
