Set-PSReadLineOption -EditMode Vi
Set-PSReadLineKeyHandler -Key Tab -Function Complete

function prompt {
    $(if (test-path variable:/PSDebugContext) { '[DBG]: ' }
    else { '' }) + $(if (test-path env:VIRTUAL_ENV) { "$($env:VIRTUAL_ENV.Split("\")[-1]): " } else { '' }) + 'PS ' + $(if ($(Get-Location).Path.Length -gt 80) { $(Get-Location | Split-Path -Qualifier) + '\...\' + $(Get-Location | Split-Path -Leaf) } else { Get-Location }) `
    + $(if ($nestedpromptlevel -ge 1) { '>>' }) + '> '
}

function touch ($Name) {
    if (!(Test-Path $Name)) {
        New-Item -Type File $Name
    }
}

Function Export-Toggl
(
    [Parameter(Mandatory=$True)]
    [ValidateNotNullOrEmpty()]
    [int] $Week
)

{
    $togglWorkspaceId = "3046214"
    $togglUserId = "4432985"
    $togglApiToken = "896165f98f99a04a2f70cd063d189c3a"

    dcli toggl-weekly-export `
        --week $Week `
        --workspace-id $togglWorkspaceId `
        --user-id $togglUserId `
        --api-token $togglApiToken `
        2> $NULL
}

$Env:ASPNETCORE_ENVIRONMENT = "Development"
$Env:NETCORE_ENVIRONMENT = "Development"
$Env:DOTNET_ENVIRONMENT = "Development"

Set-Alias qemu 'C:\Program Files\qemu\qemu-system-i386.exe'
Set-Alias nasm 'C:\Program Files\NASM\nasm.exe'

Function Run-Asm
(
    [Parameter(Mandatory=$True)]
    [ValidateNotNullOrEmpty()]
    [string] $file
)
{
    if ($file.Substring($file.Length - 4, 4) -ne '.asm')
    {
        Write-Error 'File is not .asm'
        return
    }
    nasm $file
    if ($?)
    {
        qemu $file.Substring(0, $file.Length - 4)
    }
}
