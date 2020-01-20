function prompt {
    Write-Host ("")
    Write-Host ("PS " + $(Get-Location) +">") -NoNewLine `
     -ForegroundColor Green
    return " "
}
