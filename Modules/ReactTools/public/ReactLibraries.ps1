function nicommon {
    Initialize-ReactTemplate
    npm install axios react-redux react-router-dom @reduxjs/toolkit react-icons
    npm i -D tailwindcss @tailwindcss/vite
}

function nicommont {
    Initialize-ReactTemplate
    npm install axios react-redux react-router-dom @reduxjs/toolkit react-icons
    npm install -D tailwindcss @tailwindcss/vite @types/react-redux @types/react-router-dom @types/tailwindcss
}

function niredux {
    npm install react-redux @reduxjs/toolkit 
}

function nireduxt {
    npm install react-redux @reduxjs/toolkit @types/react-redux
    npm install -D @types/react-redux
}

function niraxios {
    npm install axios
}

function nirouter {
    npm install react-router-dom 
}

function niroutert {
    npm install react-router-dom
    npm install -D @types/react-router-dom
}

function nithree {
    npm install three @react-three/fiber @react-three/drei @react-three/postprocessing
}

function nithreet {
    npm install three @react-three/fiber @react-three/drei @react-three/postprocessing
    npm install -D @types/three
}

function nirtwo {
    npm install react-two-fiber twod @react-two/fiber @react-two/drei
}

function nimaterial {
    npm install @mui/icons-material @mui/material @emotion/styled @emotion/react
}

function nimaterialt {
    npm install @mui/icons-material @mui/material @emotion/styled @emotion/react
}

function nicss {
    npm install -D tailwindcss @tailwindcss/vite @types/tailwindcss
    addTailwindVite
    addTailwindCssImport
}

function nifm {
    npm install framer-motion
}

function nitailwindui {
    npm install @headlessui/react @heroicons/react
}

function nitailwinduip {
    npm install @headlessui/react @heroicons/react @types/headlessui__react
}

function nicsocketio {
    npm install socket.io-client
}

function nicsocketiot {
    npm install socket.io-client
    npm install -D @types/socket.io-client
}


function addTailwindViteEnhanced {
    $viteConfigPath = "vite.config.ts"
    # Read the existing config
    $content = Get-Content $viteConfigPath -Raw

    # Check if tailwindcss() is already added
    if ($content -match "tailwindcss\(\)") {
        Write-Output "Tailwind plugin already exists in vite.config.ts."
        return
    }

    # Insert the import for tailwindcss and path if missing
    if ($content -notmatch "import tailwindcss from '@tailwindcss/vite'") {
        $content = $content -replace "(import react from '@vitejs/plugin-react')", '$1' + "`nimport tailwindcss from '@tailwindcss/vite'" 
    }
    if ($content -notmatch "import path from 'path'") {
        $content = $content -replace "(import tailwindcss from '@tailwindcss/vite')", '$1' + "`nimport path from 'path'" 
    }

    # Add tailwindcss() to plugins array
    $content = $content -replace "plugins\s*:\s*\[([^\]]*)\]", {
        param($matches)
        $existingPlugins = $matches.Groups[1].Value.Trim()
        "plugins: [`r`n$existingPlugins,`r`n    tailwindcss(),`r`n]"
    }

    # Add resolve.alias and server.host if missing
    if ($content -notmatch "resolve\s*:") {
        $insertAfter = "export default defineConfig\(\{"
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
        $content = $content -replace [regex]::Escape($insertAfter), $insertAfter + "`r`n" + $extraConfig
    }

    # Write back to the file
    $content | Set-Content -Encoding UTF8 $viteConfigPath
    Write-Output "vite.config.ts updated with Tailwind, aliases, and server.host."
}

