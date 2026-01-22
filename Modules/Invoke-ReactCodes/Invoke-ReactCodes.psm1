function Add-TailwindVite {
    $viteConfigPath = "vite.config.ts"

    if (-not (Test-Path $viteConfigPath)) {
        Write-Output "vite.config.ts not found."
        return
    }

    $content = Get-Content $viteConfigPath -Raw

    # -------------------------
    # 1️⃣ Add imports safely
    # -------------------------
    $importsToAdd = @(
        "import tailwindcss from '@tailwindcss/vite'",
        "import path from 'path'"
    )

    foreach ($imp in $importsToAdd) {
        if ($content -notmatch [regex]::Escape($imp)) {
            $content = $imp + "`r`n" + $content
        }
    }

    # -------------------------
    # 2️⃣ Add tailwindcss() to plugins array
    # -------------------------
    if ($content -match "plugins\s*:\s*\[([^\]]*)\]") {
        $existingPlugins = $matches[1].Trim()
        if ($existingPlugins -notmatch "tailwindcss\(\)") {
            $newPlugins = $existingPlugins
            if ($existingPlugins.Length -gt 0) { $newPlugins += "," }
            $newPlugins += "`r`n    tailwindcss()"
            $content = $content -replace "plugins\s*:\s*\[([^\]]*)\]", "plugins: [`r`n$newPlugins`r`n]"
        }
    }

    # -------------------------
    # 3️⃣ Add resolve.alias and server.host before closing })
    # -------------------------
# Only add if resolve: is missing
if ($content -notmatch "resolve\s*:") {
    $extraConfig = @"
resolve: {
    alias: {
        '@': path.resolve(__dirname, 'src'),
    },
},
server: {
    host: true,
},
"@

    # Build replacement string for -replace
    $replacement = $extraConfig + "`r`n`$1"

    # Insert before the closing '});' of defineConfig
    $content = $content -replace "(\}\s*\)\s*;)", $replacement
}


    # -------------------------
    # 4️⃣ Write file UTF-8 without BOM
    # -------------------------
    [System.IO.File]::WriteAllText($viteConfigPath, $content, [System.Text.Encoding]::UTF8)

    Write-Output "vite.config.ts updated: imports, tailwind, resolve.alias, server.host."
}

function  Add-TailwindCssImport {
    $srcFolder = "src"

    # Find index.css
    $cssFile = Get-ChildItem -Path $srcFolder -Filter "*.css" -Recurse |
               Where-Object { $_.Name -eq "index.css" } |
               Select-Object -First 1

    if (-not $cssFile) {
        Write-Output "index.css not found in src folder. Please create it first."
        return
    }

    $cssPath = $cssFile.FullName

    # Tailwind directives to write
    $tailwindDirectives = @"
@import "tailwindcss";
@tailwind utilities;
"@

    # Overwrite file
    [System.IO.File]::WriteAllText($cssPath, $tailwindDirectives, [System.Text.Encoding]::UTF8)

    Write-Output "index.css has been cleared and Tailwind directives added."
}

function Initialize-ReduxAppStructure {
    $srcFolder = "src"
    $appFolder = Join-Path $srcFolder "app"
    $featuresFolder = Join-Path $srcFolder "features"
    $mainFile = Join-Path $srcFolder "main.tsx"
    $storeFile = Join-Path $appFolder "store.ts"
    $hooksFile = Join-Path $appFolder "hooks.ts"

    # -------------------------
    # 1️⃣ Create folders
    # -------------------------
    if (-not (Test-Path $appFolder)) {
        New-Item -Path $appFolder -ItemType Directory | Out-Null
        Write-Output "Created folder: src\app"
    } else {
        Write-Output "Folder already exists: src\app"
    }

    if (-not (Test-Path $featuresFolder)) {
        New-Item -Path $featuresFolder -ItemType Directory | Out-Null
        Write-Output "Created folder: src\features"
    } else {
        Write-Output "Folder already exists: src\features"
    }

    # -------------------------
    # 2️⃣ Create store.ts
    # -------------------------
    if (-not (Test-Path $storeFile)) {
        $storeCode = @"
import { configureStore } from '@reduxjs/toolkit'

// Add your reducers here
export const store = configureStore({
    reducer: {},
})

export type RootState = ReturnType<typeof store.getState>
export type AppDispatch = typeof store.dispatch
"@
        [System.IO.File]::WriteAllText($storeFile, $storeCode, [System.Text.Encoding]::UTF8)
        Write-Output "Created store.ts in src\app"
    } else {
        Write-Output "store.ts already exists in src\app"
    }

    # -------------------------
    # 3️⃣ Create hooks.ts
    # -------------------------
    if (-not (Test-Path $hooksFile)) {
        $hooksCode = @"
import { type TypedUseSelectorHook, useDispatch, useSelector } from 'react-redux'
import type { RootState, AppDispatch } from './store'

// Use throughout your app instead of plain `useDispatch` and `useSelector`
export const useAppDispatch: () => AppDispatch = useDispatch
export const useAppSelector: TypedUseSelectorHook<RootState> = useSelector
"@
        [System.IO.File]::WriteAllText($hooksFile, $hooksCode, [System.Text.Encoding]::UTF8)
        Write-Output "Created hooks.ts in src\app"
    } else {
        Write-Output "hooks.ts already exists in src\app"
    }

    # -------------------------
    # 4️⃣ Update main.tsx to wrap <App /> with Provider
    # -------------------------
    if (Test-Path $mainFile) {
        $mainContent = Get-Content $mainFile -Raw

        # Check if Provider is already added
        if ($mainContent -match "Provider") {
            Write-Output "<Provider> already exists in main.tsx"
        } else {
            # Insert imports at the top
            $importsToAdd = @(
                "import { Provider } from 'react-redux'",
                "import { store } from './app/store'"
            )

            foreach ($imp in $importsToAdd) {
                if ($mainContent -notmatch [regex]::Escape($imp)) {
                    $mainContent = $imp + "`r`n" + $mainContent
                }
            }

            # Wrap <App /> with <Provider store={store}>
            $mainContent = $mainContent -replace "<App\s*/>", "<Provider store={store}>`r`n         <App />`r`n     </Provider>"

            # Write back
            [System.IO.File]::WriteAllText($mainFile, $mainContent, [System.Text.Encoding]::UTF8)
            Write-Output "<App /> wrapped with <Provider> in main.tsx"
        }
    } else {
        Write-Output "main.tsx not found in src folder. Please ensure it exists."
    }
}

function Clear-ReactApp {
    param (
        [string]$ProjectPath = (Get-Location)
    )

    # Paths
    $assetsFolder = Join-Path $ProjectPath "src\assets"
    $appCssFile = Join-Path $ProjectPath "src\app.css"
    $appTsxFile = Join-Path $ProjectPath "src\App.tsx"

    # Delete assets folder
    if (Test-Path $assetsFolder) {
        Remove-Item -Path $assetsFolder -Recurse -Force
        Write-Host "Deleted assets folder."
    } else {
        Write-Host "Assets folder not found."
    }

    # Delete app.css file
    if (Test-Path $appCssFile) {
        Remove-Item -Path $appCssFile -Force
        Write-Host "Deleted app.css."
    } else {
        Write-Host "app.css file not found."
    }

    # Modify App.tsx to simple text display
    if (Test-Path $appTsxFile) {
        $simpleContent = @"
import React from 'react';

function App() {
    return (
        <div>
            Hello, this is a simple React App!
        </div>
    );
}

export default App;
"@
        $simpleContent | Set-Content -Path $appTsxFile -Encoding UTF8
        Write-Host "App.tsx updated with simple text display."
    } else {
        Write-Host "App.tsx file not found."
    }
}

function Initialize-ReactTemplate {
    param (
        [string]$ProjectPath = (Get-Location)
    )

    Add-TailwindVite -ProjectPath $ProjectPath
    Add-TailwindCssImport -ProjectPath $ProjectPath
    Initialize-ReduxAppStructure -ProjectPath $ProjectPath
    Clear-ReactApp -ProjectPath $ProjectPath
}