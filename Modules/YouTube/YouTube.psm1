# Get all public functions
Get-ChildItem "$PSScriptRoot\Public\*.ps1" -ErrorAction SilentlyContinue | ForEach-Object {
    . $_.FullName
}

# List formats for a video using yt-dlp
function yt {
    <#
    .SYNOPSIS
        Lists available formats for a YouTube video using yt-dlp.

    .DESCRIPTION
        Downloads and displays all available video formats and resolutions for a given URL.
        This is useful for selecting the best quality format before downloading.

    .PARAMETER Url
        The YouTube (or other supported site) URL to query.

    .EXAMPLE
        yt "https://www.youtube.com/watch?v=dQw4w9WgXcQ"

        Lists all available formats for the video.

    .NOTES
        Requires yt-dlp to be installed.
        Install with: pip install yt-dlp
    #>
    param(
        [Parameter(Mandatory = $true, Position = 0)]
        [string]$Url
    )

    if (-not (Get-Command yt-dlp -ErrorAction SilentlyContinue)) {
        Write-Host "yt-dlp is not installed." -ForegroundColor Red
        Write-Host "Install it using: pip install yt-dlp" -ForegroundColor Yellow
        return
    }

    Write-Host "Fetching available formats for: $Url" -ForegroundColor Cyan
    yt-dlp -F $Url
}

# Download best quality video
function ytdl {
    <#
    .SYNOPSIS
        Downloads a video using yt-dlp with the best quality.

    .DESCRIPTION
        Downloads the best available video format from the provided URL.

    .PARAMETER Url
        The YouTube (or other supported site) URL to download.

    .PARAMETER Output
        Optional output file pattern. Default is '%(title)s.%(ext)s'

    .EXAMPLE
        ytdl "https://www.youtube.com/watch?v=dQw4w9WgXcQ"

        Downloads the video with the best quality.

    .NOTES
        Requires yt-dlp to be installed.
    #>
    param(
        [Parameter(Mandatory = $true, Position = 0)]
        [string]$Url,
        [Parameter(Mandatory = $false)]
        [string]$Output = '%(title)s.%(ext)s'
    )

    if (-not (Get-Command yt-dlp -ErrorAction SilentlyContinue)) {
        Write-Host "yt-dlp is not installed." -ForegroundColor Red
        Write-Host "Install it using: pip install yt-dlp" -ForegroundColor Yellow
        return
    }

    Write-Host "Downloading: $Url" -ForegroundColor Cyan
    yt-dlp -f "bestvideo+bestaudio/best" -o $Output $Url
}
