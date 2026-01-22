function glm {
    param (
        [string]$branch = "main"
    )
    git log $branch --oneline --graph --decorate --all
}

function glr {
    param (
        [string]$branch = "main"
    )
    git log origin/$branch --oneline --graph --decorate --all
}

function glo {
    param (
        [string]$branch = "main"
    )
    git log origin/$branch..$branch --oneline --graph --decorate --all
}

function glmm {
    param (
        [string]$branch = "main"
    )
    git log $branch..main --oneline --graph --decorate --all
}

function gl { git log --oneline --graph --decorate --all }