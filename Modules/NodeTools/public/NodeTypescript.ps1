function nist {
    Ensure-PackageJson
    # Install TypeScript and related packages as dev dependencies
    npm install -D typescript ts-node @types/node

    # Check if tsconfig.json already exists
    if (Test-Path "tsconfig.json") {
        Write-Output "tsconfig.json already exists. Skipping creation."
    } else {
        Write-Output "Creating tsconfig.json..."
        # Create a basic tsconfig.json file
        $tsconfig = @'
{
"compilerOptions": {
    "target": "es2021",
    "module": "commonjs",
    "outDir": "dist",
    "rootDir": "src",
    "strict": true,
    "esModuleInterop": true,
    "forceConsistentCasingInFileNames": true
},
"include": ["src"],
"exclude": ["node_modules"]
}
'@

        # Save it to tsconfig.json
        Write-NoBOM -Path "tsconfig.json" -Content $tsconfig
        Write-Output "tsconfig.json created successfully."
    }
}
