function setGitUser {
    param (
        [string]$name,
        [string]$email
    )
    git config --global user.name $name
    git config --global user.email $email
}

function getGitUser {
    $name = git config --global user.name
    $email = git config --global user.email
    return @{ Name = $name; Email = $email }
}

function setGitEmail {
    param (
        [string]$email
    )
    git config --global user.email $email
}
function getGitEmail {
    return git config --global user.email
}

function setGitName {
    param (
        [string]$name
    )
    git config --global user.name $name
}
function getGitName {
    return git config --global user.name
}