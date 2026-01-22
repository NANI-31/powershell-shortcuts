function m {
    Invoke-FolderScript -TargetFolder "mobile" -Command "npx expo start -c --tunnel"
}
function CreateExpo {
    param(
        [string]$projectName,
        [switch]$Force
    )

    # Determine if we are using the current folder
    $useCurrentFolder = (-not $projectName) -or ($projectName -eq ".")

    if ($useCurrentFolder) {
        # Check if current folder is empty
        $folderNotEmpty = Get-ChildItem -Force | Where-Object { $_.Name -notin '.', '..' }

        if ($folderNotEmpty -and -not $Force) {
            $confirm = Read-Host "Current folder is not empty. Are you sure you want to create the project here? (y/n)"
            if ($confirm -ne 'y') {
                Write-Host "Aborted!" -ForegroundColor Yellow
                return
            }
        }

        Write-Host "Creating Expo (React Native) project in the current folder..." -ForegroundColor Cyan
        npx create-expo-app . 
    } else {
        # Check if target folder exists
        if ((Test-Path $projectName) -and -not $Force) {
            $confirm = Read-Host "Folder '$projectName' already exists. Are you sure you want to create the project here? (y/n)"
            if ($confirm -ne 'y') {
                Write-Host "Aborted!" -ForegroundColor Yellow
                return
            }
        }

        Write-Host "Creating Expo (React Native) project in folder '$projectName'..." -ForegroundColor Cyan
        npx create-expo-app $projectName
    }
}

# function npxs{
#     param(
#         [Parameter(ValueFromRemainingArguments = $true)]
#         [string[]]$args
#     )

#     npx @args
# }

function expos{
    npx expo start
}

function expost{
    npx expo start --tunnel
}

function expob{
    npx expo build:android
}

function expoi{
    npx expo install @args
}

function expoip{
    npx expo install @args
    npx expo install @types/@args
}

function expou{
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$pkgs
    )

    if (-not $pkgs -or $pkgs.Count -eq 0) {
        Write-Host "Please specify one or more packages to uninstall." -ForegroundColor Yellow
        return
    }

    npx expo uninstall @pkgs
}

function expoup{
    npx expo upgrade
}

function std{
    npm install @react-navigation/stack
    npm install @react-navigation/bottom-tabs
    npm install @react-navigation/drawer
    npm install react-native-screens react-native-safe-area-context 
}
function expocc {
    expo start -c
}

function expo {
    param(
        [switch]$re
    )
    if ($re) {
        npm run reset-project
    } 
}