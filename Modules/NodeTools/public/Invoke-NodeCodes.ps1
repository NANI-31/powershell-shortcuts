function New-TSAppStructure {
    param (
        [string]$ProjectPath = (Get-Location)
    )

    # Base src path
    $srcPath = Join-Path $ProjectPath "src"

    # Folder structure
    $folders = @("config", "controller", "models", "routes", "middlewares", "utils")

    # Create src folder
    if (-not (Test-Path $srcPath)) {
        New-Item -Path $srcPath -ItemType Directory | Out-Null
        Write-Host "Created src folder."
    } else {
        Write-Host "src folder already exists."
    }

    # Create subfolders
    foreach ($folder in $folders) {
        $folderPath = Join-Path $srcPath $folder
        if (-not (Test-Path $folderPath)) {
            New-Item -Path $folderPath -ItemType Directory | Out-Null
            Write-Host "Created $folder folder."
        }
    }

    # Create empty app.ts and index.ts
    $files = @("app.ts", "index.ts")
    foreach ($file in $files) {
        $filePath = Join-Path $srcPath $file
        if (-not (Test-Path $filePath)) {
            New-Item -Path $filePath -ItemType File | Out-Null
            Write-Host "Created empty $file."
        }
    }
}

function New-CorsConfig {
    param (
        [string]$ProjectPath = (Get-Location)
    )

    # Path to config folder
    $configPath = Join-Path $ProjectPath "src\config"

    # Create config folder if it doesn't exist
    if (-not (Test-Path $configPath)) {
        New-Item -Path $configPath -ItemType Directory | Out-Null
        Write-Host "Created config folder."
    }

    # Path to cors.ts
    $corsFile = Join-Path $configPath "cors.ts"

    # CORS setup code
    $corsCode = @'
import { CorsOptions } from "cors";

export const corsOptions: CorsOptions = {
    origin: (origin, callback) => {
        // Allow server-to-server & tools like Postman
        if (!origin) return callback(null, true);

        const allowedOrigins = ["http://localhost:3000", "http://localhost:5173"];

        if (allowedOrigins.includes(origin)) {
        callback(null, true);
        } else {
        callback(new Error("❌ Not allowed by CORS"));
        }
    },

    credentials: true,
    methods: ["GET", "POST", "PUT", "PATCH", "DELETE", "OPTIONS"],
    allowedHeaders: ["Content-Type", "Authorization"],
};
'@

    # Write code to cors.ts
    Write-NoBOM -Path $corsFile -Content $corsCode
    Write-Host "Created cors.ts with CORS configuration."
}

function New-EnvConfig {
    param (
        [string]$ProjectPath = (Get-Location)
    )

    # Path to config folder
    $configPath = Join-Path $ProjectPath "src\config"

    # Create config folder if it doesn't exist
    if (-not (Test-Path $configPath)) {
        New-Item -Path $configPath -ItemType Directory | Out-Null
        Write-Host "Created config folder."
    }

    # Path to index.ts
    $indexFile = Join-Path $configPath "index.ts"

    # Index setup code
    $indexCode = @'
export * from "./env";
export * from "./db";
export * from "./cors";
'@

    # Write code to index.ts
    Write-NoBOM -Path $indexFile -Content $indexCode
    Write-Host "Created index.ts with environment configuration."
}
function New-DbConfig {
    param (
        [string]$ProjectPath = (Get-Location)
    )

    # Path to config folder
    $configPath = Join-Path $ProjectPath "src\config"

    # Create config folder if it doesn't exist
    if (-not (Test-Path $configPath)) {
        New-Item -Path $configPath -ItemType Directory | Out-Null
        Write-Host "Created config folder."
    }

    # Path to db.ts
    $dbFile = Join-Path $configPath "db.ts"

    # DB setup code
    $dbCode = @'
import mongoose from "mongoose";
import { env } from "./env";

export const connectDB = async (): Promise<void> => {
try {
        await mongoose.connect(env.MONGO_URI);

        console.log("✅ MongoDB connected");

        mongoose.connection.on("error", (err) => {
        console.error("❌ MongoDB error:", err);
        });

        mongoose.connection.on("disconnected", () => {
        console.warn("⚠️ MongoDB disconnected");
        });
    } catch (error) {
        console.error("❌ MongoDB connection failed:", error);
        process.exit(1);
    }
};
'@

    # Write code to db.ts
    Write-NoBOM -Path $dbFile -Content $dbCode
    Write-Host "Created db.ts with database configuration."
}


function New-IndexConfig {
    param (
        [string]$ProjectPath = (Get-Location)
    )

    # Path to config folder
    $configPath = Join-Path $ProjectPath "src\config"

    # Create config folder if it doesn't exist
    if (-not (Test-Path $configPath)) {
        New-Item -Path $configPath -ItemType Directory | Out-Null
        Write-Host "Created config folder."
    }

    # Path to env.ts
    $envFile = Join-Path $configPath "env.ts"

    # Index setup code
    $envCode = @'
import dotenv from "dotenv";
dotenv.config();

const requiredEnv = (key: string): string => {
const value = process.env[key];
if (!value) {
    throw new Error(`❌ Missing required env variable: ${key}`);
}
return value;
};

export const env = {
    NODE_ENV: process.env.NODE_ENV || "development",
    PORT: process.env.PORT ? Number(process.env.PORT) : 5000,

    // Database
    MONGO_URI: requiredEnv("MONGO_URI"),

    // JWT
    JWT_ACCESS_SECRET: requiredEnv("JWT_ACCESS_SECRET"),
    JWT_REFRESH_SECRET: requiredEnv("JWT_REFRESH_SECRET"),
    JWT_ACCESS_EXPIRES_IN: process.env.JWT_ACCESS_EXPIRES_IN || "15m",
    JWT_REFRESH_EXPIRES_IN: process.env.JWT_REFRESH_EXPIRES_IN || "7d",

    // Cloud storage
    CLOUDINARY_CLOUD_NAME: requiredEnv("CLOUDINARY_CLOUD_NAME"),
    CLOUDINARY_API_KEY: requiredEnv("CLOUDINARY_API_KEY"),
    CLOUDINARY_API_SECRET: requiredEnv("CLOUDINARY_API_SECRET"),

    // Google OAuth
    GOOGLE_CLIENT_ID: requiredEnv("GOOGLE_CLIENT_ID"),
    GOOGLE_CLIENT_SECRET: requiredEnv("GOOGLE_CLIENT_SECRET"),
    GOOGLE_REFRESH_TOKEN: requiredEnv("GOOGLE_REFRESH_TOKEN"),
    GOOGLE_REDIRECT_URI: requiredEnv("GOOGLE_REDIRECT_URI"),
};
'@

    # Write code to env.ts
    Write-NoBOM -Path $envFile -Content $envCode
    Write-Host "Created index.ts exporting all config modules."
}

function Write-TSAppCode {
    param (
        [string]$ProjectPath = (Get-Location)
    )

    $srcPath = Join-Path $ProjectPath "src"

    # app.ts code
    $appFile = Join-Path $srcPath "app.ts"
    $appCode = @'
import express, { Application } from 'express';
import cors from "cors";
import { corsOptions } from "./config";
import routes from './routes';

const app: Application = express();

// Enable CORS
app.use(cors(corsOptions));

// Middleware to parse JSON
app.use(express.json());

// Use routes
app.use('/', routes);

export default app;
'@
    Write-NoBOM -Path $appFile -Content $appCode
    Write-Host "Written code to app.ts."
}

function Write-TSIndexCode {
    param (
        [string]$ProjectPath = (Get-Location)
    )

    $srcPath = Join-Path $ProjectPath "src"
    $indexFile = Join-Path $srcPath "index.ts"

    $indexCode = @'
import { env, connectDB } from "./config";
import dotenv from "dotenv";
dotenv.config();
import app from './app';
// Connect to the database
connectDB();

const PORT = env.PORT || 5000;
app.listen(PORT, () => {
    console.log(`Server is running on http://localhost:${PORT}`);
});
'@
    Write-NoBOM -Path $indexFile -Content $indexCode
    Write-Host "Written code to index.ts."
}

function New-RouteConfig {
    param (
        [string]$ProjectPath = (Get-Location)
    )

    # Path to routes folder
    $routesPath = Join-Path $ProjectPath "src\routes"

    # Create routes folder if it doesn't exist
    if (-not (Test-Path $routesPath)) {
        New-Item -Path $routesPath -ItemType Directory | Out-Null
        Write-Host "Created routes folder."
    }

    # Path to index.ts
    $indexFile = Join-Path $routesPath "index.ts"

    # Base route setup code
    $routesCode = @'
import { Router } from "express";

const router = Router();

router.get("/", (req, res) => {
    res.json({ message: "Welcome to the API" });
});

export default router;
'@

    # Write code to index.ts
    Write-NoBOM -Path $indexFile -Content $routesCode
    Write-Host "Created src/routes/index.ts with base route."
}

function New-EnvFile {
    param (
        [string]$ProjectPath = (Get-Location),
        [string]$MongoURI = "db"
    )

    # Path to .env file
    $envFile = Join-Path $ProjectPath ".env"

    # Content for .env
    $envContent = @"
# Server port
PORT=5000
MONGODB_URI=mongodb+srv://nani:nani@cluster0.nkgeayy.mongodb.net/$MongoURI?retryWrites=true&w=majority

# JWT / Authentication
JWT_SECRET=your_jwt_secret_key
JWT_EXPIRES_IN=7d

# AWS S3
AWS_ACCESS_KEY_ID=your_aws_access_key_id
AWS_SECRET_ACCESS_KEY=your_aws_secret_access_key
AWS_REGION=us-east-1
AWS_S3_BUCKET_NAME=your_bucket_name

# Google OAuth (login)
GOOGLE_CLIENT_ID=your_google_client_id
GOOGLE_CLIENT_SECRET=your_google_client_secret
GOOGLE_REFRESH_TOKEN=your_refresh_token
GOOGLE_REDIRECT_URI=http://localhost:5000/api/auth/google/callback
EMAIL_USER=your_email@gmail.com

# Nodemailer (email)
EMAIL_HOST=smtp.gmail.com
EMAIL_PORT=587
EMAIL_USER=your_email@gmail.com
EMAIL_PASS=your_email_password_or_app_password
"@

    # Create or overwrite the .env file
    Write-NoBOM -Path $envFile -Content $envContent
    Write-Host ".env file created with MongoDB URI."
}

function Initialize-NodeTemplate {
    param (
        [string]$ProjectPath = (Get-Location),
        [string]$MongoURI = "db"
    )

    New-TSAppStructure -ProjectPath $ProjectPath
    New-CorsConfig -ProjectPath $ProjectPath
    New-EnvConfig -ProjectPath $ProjectPath
    New-DbConfig -ProjectPath $ProjectPath
    New-IndexConfig -ProjectPath $ProjectPath
    New-RouteConfig -ProjectPath $ProjectPath
    Write-TSAppCode -ProjectPath $ProjectPath
    Write-TSIndexCode -ProjectPath $ProjectPath
    New-EnvFile -ProjectPath $ProjectPath -MongoURI $MongoURI

}