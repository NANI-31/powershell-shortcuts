Get-ChildItem "$PSScriptRoot\Public\*.ps1" | ForEach-Object {
    . $_.FullName
}
function ns {
    param(
        [string]$ServerFolder = "server"
    )

    # Check if we're already in the server folder
    $currentFolder = Split-Path -Leaf (Get-Location)
    if ($currentFolder -ne $ServerFolder) {
        Set-Location $ServerFolder
    }

    # Run the commands
    npm run seed
    Clear-Host
    npm run dev
}

function ninit {
  npm init -y
  niscommont
}

function nimail {
    Ensure-PackageJson
    npm install nodemailer
}function nissocketiot {
    Ensure-PackageJson
    npm install socket.io
    npm install -D @types/socket.io
}

function nissocketio {
    Ensure-PackageJson
    npm install socket.io
}

function Ensure-PackageJson {
    if (-not (Test-Path "package.json")) {
        Write-Output "package.json not found. Initializing with npm init -y..."
        npm init -y
    }
}

function Write-NoBOM {
    param (
        [string]$Path,
        [string]$Content
    )
    $utf8NoBOM = New-Object System.Text.UTF8Encoding $false
    # Ensure we use an absolute path for [IO.File]
    $absolutePath = if ([System.IO.Path]::IsPathRooted($Path)) { $Path } else { Join-Path (Get-Location) $Path }
    [IO.File]::WriteAllText($absolutePath, $Content, $utf8NoBOM)
}

function nimailt {
    Ensure-PackageJson
    npm install nodemailer
    npm install -D @types/nodemailer
}

function addNodemonScript {
    Ensure-PackageJson
    $packageJsonPath = (Resolve-Path "package.json").Path
    # Read package.json
    $jsonContent = Get-Content $packageJsonPath -Raw | ConvertFrom-Json

  # Add or update the "dev" script safely
    if (-not $jsonContent.scripts) {
        $jsonContent | Add-Member -MemberType NoteProperty -Name scripts -Value @{ dev = "nodemon src/index.ts" }
    } else {
        # Check if dev script exists and update or add it
        $scripts = $jsonContent.scripts
        if ($scripts.PSObject.Properties.Name -contains "dev") {
            $scripts.dev = "nodemon src/index.ts"
        } else {
            $scripts | Add-Member -MemberType NoteProperty -Name dev -Value "nodemon src/index.ts"
        }
    }

    # Convert back to JSON with 4-space indentation
    $jsonString = $jsonContent | ConvertTo-Json -Depth 10
    Write-NoBOM -Path $packageJsonPath -Content $jsonString


    Write-Output '"dev" script added to package.json successfully.'
}

function niscommon {
    Ensure-PackageJson
    # npm install nodemon
    npm install nodemon bcryptjs cors dotenv express jsonwebtoken mongoose morgan winston
    addNodemonScript
}

function niscommont {
    Ensure-PackageJson
    nist
    Initialize-NodeTemplate
    npm install nodemon bcryptjs cors dotenv express jsonwebtoken mongoose morgan winston
    npm install -D @types/bcryptjs @types/cors @types/dotenv @types/express @types/jsonwebtoken @types/mongoose @types/morgan @types/node
    addNodemonScript
}


