Get-ChildItem "$PSScriptRoot\Public\*.ps1" | ForEach-Object {
    . $_.FullName
}
function pythonInstall {
    <#
    .SYNOPSIS
        Installs Python on the system.

    .DESCRIPTION
        This function downloads and installs the latest version of Python.
        It supports both Windows and Unix-based systems.

    .EXAMPLE
        pythonInstall

        Installs the latest version of Python.

    .NOTES
        Author: Firstname Lastname
    #>
    param(
        [switch]$Force
    )

    # Check if Python is already installed
    if (Get-Command python -ErrorAction SilentlyContinue) {
        Write-Host "Python is already installed." -ForegroundColor Green
        return
    }

    # Check if the user wants to force the installation
    if (-not $Force) {
        $confirm = Read-Host "Are you sure you want to install Python? (y/n)"
        if ($confirm -ne 'y') {
            Write-Host "Aborted!" -ForegroundColor Yellow
            return
        }
    }

    # Download and install Python
    if ($IsWindows) {
        $url = "https://www.python.org/ftp/python/3.11.1/python-3.11.1-amd64.exe"
        $output = "python-3.11.1-amd64.exe"
    } else {
        $url = "https://www.python.org/ftp/python/3.11.1/python-3.11.1.tar.xz"
        $output = "python-3.11.1.tar.xz"
    }

    Write-Host "Downloading Python..." -ForegroundColor Cyan
    Invoke-WebRequest -Uri $url -OutFile $output

    Write-Host "Installing Python..." -ForegroundColor Cyan
    if ($IsWindows) {
        Start-Process -FilePath $output -ArgumentList "/quiet InstallAllUsers=1 PrependPath=1" -Wait
    } else {
        tar -xf $output
        cd python-3.11.1
        ./configure --enable-optimizations
        make
        sudo make altinstall
        cd ..
        rm -rf python-3.11.1
    }
    Remove-Item $output

    Write-Host "Python installed successfully!" -ForegroundColor Green
}

# check python version as py -v
function py {
    param(
        [switch]$v
    )

    if (Get-Command python -ErrorAction SilentlyContinue) {
        python --version
    } else {
        Write-Host "Python is not installed." -ForegroundColor Red
    }
}

# run python file as pr filename. we add the .py in funcion
function pr {
    param(
        [string]$filename
    )
    Clear-Host
    python "$filename.py"   
}

# install python packages
function pipi {
    pip install @args
}

# uninstall python packages
function pipu {
    pip uninstall @args
}

# list installed python packages
function pipl {
    pip list
}

# show python package details
function pipd {
    param(
        [string]$packageName
    )
    pip show $packageName
}

# upgrade python packages
function pipup {
    pip install --upgrade @args
}

# upgrade pip itself
function pipupself {
    pip install --upgrade pip
}

# create a virtual environment
function pyvenv {
    param(
        [string]$envName
    )
    python -m venv $envName
}

# activate a virtual environment
function pyvenvActivate {
    param(
        [string]$envName
    )
    if ($IsWindows) {
        & "$envName\Scripts\Activate.ps1"
    } else {
        & "source $envName/bin/activate"
    }
}

# deactivate a virtual environment
function pyvenvDeactivate {
    if ($IsWindows) {
        & "deactivate"
    } else {
        & "deactivate"
    }
}