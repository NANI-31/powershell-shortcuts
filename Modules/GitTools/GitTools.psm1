# gi is already an alias for Get-Item
# Remove-Item Alias:gc -ErrorAction SilentlyContinue
# Import-Module OtherModule
# . "$env:USERPROFILE\Documents\PowerShell\Modules\OtherModule\Public\OtherModule1.psm1"
# $requiredModules = @('OtherModule')

foreach ($mod in $requiredModules) {
    if (-not (Get-Module -Name $mod)) {
        Write-Host "Importing module: $mod"
        Import-Module $mod
    }
}
Get-ChildItem "$PSScriptRoot\Public\*.ps1" -File | ForEach-Object {
    . $_.FullName
}
function ginit { git init }

function gait {
    param (
        [string]$repoUrl
    )
    git init
    git remote add origin $repoUrl
}

function gs { git status }

function ga {
    param([string[]]$files)
    if ($files) { git add $files }
    else { git add . }
}

function cm {
    param(
        [Parameter(Mandatory=$true, ValueFromRemainingArguments=$true)]
        [string]$message
    )
    git commit -m ($message -join " ")
}

function gca {
    param(
        [Parameter(Mandatory)]
        [string]$message
    )
    git commit -am $message
}

function gpu {
    $branch = git branch --show-current 2>$null

    if (-not $branch) {
        Write-Error "Not a git repository or detached HEAD."
        return
    }

    git rev-parse --abbrev-ref --symbolic-full-name '@{u}' 2>$null | Out-Null

    if ($LASTEXITCODE -ne 0) {
        Write-Host "First push for branch '$branch' - setting upstream..."
        git push -u origin $branch
    }
    else {
        git push
    }
}

# function gpu {
#     git rev-parse --abbrev-ref --symbolic-full-name "@{u}" 2>$null `
#         ? (git push) `
#         : (git push -u origin (git branch --show-current))
# }


function gpl { git pull }

function gf { git fetch}

# function gpl {
#     param (
#         [string]$branch = "main"
#     )
#     git pull origin $branch
# }

function glp {
    param (
        [string]$branch = "main"
    )
    git log origin/$branch --oneline --graph --decorate --all
}

function gd {
    param([string]$path)
    if ($path) { git diff $path }
    else { git diff }
}

function gds { git diff --staged }

# See which files changed between your branch and upstream/main
function gdb {
    param (
        [string]$branch
    )
    git diff --name-only "$branch..upstream/main"
}


function gr {
    param([string]$branch)
    if ($branch) { git rebase $branch }
    else { git rebase }
}

function gst { git stash }

function gstp { git stash pop }

function gcf {
    # param (
    #     [string]$filePath
    # )
    git config --global core.fileMode false
}

function gcl {
    param (
        [string]$repoUrl
    )
    git clone $repoUrl
}

function gclean {
    git clean -fd
}

function gundo {
    git reset --soft HEAD~1
}



Export-ModuleMember -Function *