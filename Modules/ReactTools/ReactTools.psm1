Get-ChildItem -Path "$PSScriptRoot\Public\*.*" -Include *.ps1, *.psm1 -File | ForEach-Object {
    . $_.FullName
}
function c {
    Invoke-FolderScript -TargetFolder "client" -Command "npm run dev"
}

function s {
    Invoke-FolderScript -TargetFolder "server" -Command "npm run dev"
}

function cvi {
    param(
        [string]$projectName,
        [switch]$Force
    )

    $useCurrentFolder = (-not $projectName) -or ($projectName -eq ".")

    if ($useCurrentFolder) {
        $folderNotEmpty = Get-ChildItem -Force | Where-Object { $_.Name -notin '.', '..' }

        if ($folderNotEmpty -and -not $Force) {
            Write-Host "Current folder is not empty! Use -Force to override." -ForegroundColor Red
            return
        }

        $pkgName = Split-Path (Get-Location) -Leaf

        Write-Host "Creating Vite project in current folder ($pkgName)..." -ForegroundColor Cyan

        npm create vite@latest . `
            -- --template react-ts `
            --name $pkgName `
            --yes `
            --no-rolldown `
            --no-start
    }
    else {
        if ((Test-Path $projectName) -and -not $Force) {
            Write-Host "Folder '$projectName' already exists! Use -Force to override." -ForegroundColor Red
            return
        }

        Write-Host "Creating Vite project in folder '$projectName'..." -ForegroundColor Cyan

        npm create vite@latest $projectName `
            -- --template react-ts `
            --name $projectName `
            --yes `
            --no-rolldown `
            --no-start
    }

    npm install axios react-redux react-router-dom @reduxjs/toolkit react-icons
    npm install -D tailwindcss @tailwindcss/vite @types/react-redux @types/react-router-dom @types/tailwindcss
    $projectPath = if ($useCurrentFolder) {
      Get-Location
    } else {
        $projectName
}

Initialize-ReactTemplate -ProjectPath $projectPath



}



function i { npm install @args}

function ui {
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$pkgs
    )

    if (-not $pkgs -or $pkgs.Count -eq 0) {
        Write-Host "Please specify one or more packages to uninstall." -ForegroundColor Yellow
        return
    }

    npm uninstall @pkgs
}

function ns11 {
    Invoke-FolderScript -TargetFolder "server" -Command "npm run seed"
}



function ks {
  $nodeProcs = Get-Process node -ErrorAction SilentlyContinue
  $nodemonProcs = Get-Process nodemon -ErrorAction SilentlyContinue

  if ($nodeProcs -or $nodemonProcs) {
    if ($nodeProcs) {
      foreach ($proc in $nodeProcs) {
        Write-Host "Stopping Node.js process (PID: $($proc.Id))..." -ForegroundColor Red
        Stop-Process -Id $proc.Id -Force
      }
    }
    if ($nodemonProcs) {
      foreach ($proc in $nodemonProcs) {
        Write-Host "Stopping Nodemon process (PID: $($proc.Id))..." -ForegroundColor Red
        Stop-Process -Id $proc.Id -Force
      }
    }
    Write-Host "`nServer stopped." -ForegroundColor Green
  } else {
    Write-Host "No Node.js or Nodemon processes running." -ForegroundColor Yellow
  }
}

function ksANOTHERTERMINAL {
  $nodemonProcs = Get-CimInstance Win32_Process | Where-Object { 
    $_.Name -eq "node.exe" -and $_.CommandLine -match "nodemon" 
  }

  if ($nodemonProcs) {
    foreach ($proc in $nodemonProcs) {
      Write-Host "Stopping nodemon process (PID: $($proc.ProcessId))..." -ForegroundColor Red
      Stop-Process -Id $proc.ProcessId -Force
    }
    Write-Host "`nNodemon server stopped." -ForegroundColor Green
  } else {
    Write-Host "No nodemon processes running." -ForegroundColor Yellow
  }
}
