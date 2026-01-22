function aas {
    # git add --all ; git commit -m "Auto commit on $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')" ; git push
    Write-Host "Auto committing all changes..."
}

# Create a new branch
    # git branch branch-name
# Switch to a branch
    # git checkout branch-name
# Create and switch in one command
    # git checkout -b new-branch
# View all branches
    # git branch

# 🌿 List & Inspect Branches
# Shows all local branches and highlights the current one.
function gb { git branch}
# Lists local branches (same as git branch, but explicit).
function gbl { git branch --list}
# Lists all branches: local and remote.
function gba { git branch -a }
# Lists remote branches only.
function gbr { git branch -r}
# Lists local branches and shows the latest commit on each branch.
function gbv { git branch -v}
# Lists local branches with latest commit and shows which remote branch they track (and ahead/behind status).
function gbvv { git branch -vv}
# Displays branches and their commit history relationship (useful for comparing branches).
# function gbg { git branch --graph --all --decorate }
function gbg { git show-branch }

# 🌿 Switch / Checkout Branch
function gcrb {
    param (
        [string]$branch
    )
    git checkout -b $branch
    # -B to force create/reset
    # git switch -c branch_name
    # -C to force create/reset
}

function gchb {
    param (
        [string]$branch
    )

    git checkout $branch
    # git switch branch_name
}

# Switch to previous branch
function gpb {
    # git switch -c $(git symbolic-ref --short HEAD)_$(date +%Y%m%d%H%M%S)
    # git switch -c "$(git symbolic-ref --short HEAD)_$(Get-Date -Format 'yyyyMMddHHmmss')"
    # $newBranch = "$(git symbolic-ref --short HEAD)_$(Get-Date -Format 'yyyyMMddHHmmss')"
    # git checkout -b $newBranch
    git switch -
}

# Delete a local branch (safe)
function gdelb {
    param (
        [string]$branch
    )
    git branch -d $branch
}
# Force delete a local branch
function gdelbr {
    param (
        [string]$branch
    )
    git branch -D $branch
}
# git branch -r -d <remote>/<branch-name>

# Delete a remote branch
function gdelrb {
    param (
        [string]$branch
    )
    git push origin --delete $branch
}

# 🌿 Rename Branch
function grb {
    param (
        [string]$oldName,
        [string]$newName
    )
    git branch -m $oldName $newName
    # -M to force rename
}


