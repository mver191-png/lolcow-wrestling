#requires -Version 5.1
[CmdletBinding()]
param(
    [ValidateSet('gl_compatibility','forward_plus')][string]$Renderer='gl_compatibility',
    [ValidateNotNullOrEmpty()][string]$ProjectRoot='D:\lolcow-wrestling',
    [switch]$ValidateOnly
)
Set-StrictMode -Version Latest
$ErrorActionPreference='Stop'
$RuntimeRoot=Join-Path $ProjectRoot '.runtime'
$RuntimeDir=Join-Path $RuntimeRoot 'godot-4.7.2'
$LogDir=Join-Path $ProjectRoot '.launch-logs'
$ArchiveName='Godot_v4.7.2-stable_win64.exe.zip'
$DownloadUrl='https://github.com/godotengine/godot-builds/releases/download/4.7.2-stable/'+$ArchiveName
$ExpectedSha256='731980f9608d61333e5baf54a2ef17210acc7a538446c0cb9969f002aca1e953'

function Invoke-Engine {
    param([string]$Executable,[string[]]$EngineArguments,[string]$LogName)
    # Controlled switches and filesystem paths; none ends in a backslash.
    $quoted=($EngineArguments | ForEach-Object { '"'+$_+'"' }) -join ' '
    $stdout=Join-Path $LogDir ($LogName+'-stdout.log')
    $stderr=Join-Path $LogDir ($LogName+'-stderr.log')
    $p=Start-Process -FilePath $Executable -ArgumentList $quoted -WorkingDirectory $ProjectRoot -Wait -PassThru -RedirectStandardOutput $stdout -RedirectStandardError $stderr
    if ($p.ExitCode -ne 0) {
        if (Test-Path -LiteralPath $stderr) { Get-Content -LiteralPath $stderr -Tail 15 | Out-Host }
        throw ('Godot exited with code {0}. Logs: {1}' -f $p.ExitCode,$LogDir)
    }
}

function Find-Engine {
    $candidates=@()
    if ($env:GODOT_BIN) {
        if (Test-Path -LiteralPath $env:GODOT_BIN -PathType Leaf) { $candidates+= (Resolve-Path -LiteralPath $env:GODOT_BIN).Path }
        else {
            $command=Get-Command $env:GODOT_BIN -CommandType Application -ErrorAction SilentlyContinue | Select-Object -First 1
            if (-not $command) { throw 'GODOT_BIN is invalid. Correct or remove it.' }
            $candidates+=$command.Source
        }
    } else {
        foreach ($folder in @($RuntimeDir,$ProjectRoot)) {
            foreach ($name in @('Godot_v4.7.2-stable_win64_console.exe','Godot_v4.7.2-stable_win64.exe','godot.exe')) {
                $candidate=Join-Path $folder $name
                if (Test-Path -LiteralPath $candidate -PathType Leaf) { $candidates+=$candidate }
            }
        }
        foreach ($name in @('godot','godot4')) {
            $command=Get-Command $name -CommandType Application -ErrorAction SilentlyContinue | Select-Object -First 1
            if ($command) { $candidates+=$command.Source }
        }
    }
    foreach ($candidate in ($candidates | Select-Object -Unique)) {
        Invoke-Engine $candidate @('--version') 'engine-version'
        $version=(Get-Content -LiteralPath (Join-Path $LogDir 'engine-version-stdout.log') -Raw).Trim()
        if ($version -match '^4\.7\.2\.stable(?:\.|$)') { return $candidate }
        if ($env:GODOT_BIN) { throw ('GODOT_BIN selects '+$version+'; this package needs Godot 4.7.2 stable.') }
        Write-Host ('Skipping incompatible engine: '+$version)
    }
    return $null
}

function Install-Engine {
    if (-not [Environment]::Is64BitOperatingSystem) { throw 'Automatic setup requires 64-bit Windows.' }
    Write-Host 'The pinned Godot 4.7.2 engine was not found.'
    Write-Host ('Official Windows x64 download (86 MB): '+$DownloadUrl)
    if ((Read-Host 'Download and verify it now? [y/N]') -notmatch '^(y|yes)$') { throw 'Download cancelled. See START_HERE.txt for manual setup.' }
    New-Item -ItemType Directory -Path $RuntimeRoot -Force | Out-Null
    Set-Content -LiteralPath (Join-Path $RuntimeRoot '.gdignore') -Value '' -Encoding ASCII
    $partial=Join-Path $RuntimeRoot ($ArchiveName+'.partial')
    $archive=Join-Path $RuntimeRoot $ArchiveName
    try {
        [Net.ServicePointManager]::SecurityProtocol=[Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12
        $old=$ProgressPreference
        try { $ProgressPreference='SilentlyContinue'; Invoke-WebRequest -UseBasicParsing -Uri $DownloadUrl -OutFile $partial -TimeoutSec 180 -MaximumRedirection 10 }
        finally { $ProgressPreference=$old }
        if ((Get-FileHash -LiteralPath $partial -Algorithm SHA256).Hash.ToLowerInvariant() -ne $ExpectedSha256) { throw 'Archive checksum failed. Nothing from it has been executed.' }
        Move-Item -LiteralPath $partial -Destination $archive -Force
        New-Item -ItemType Directory -Path $RuntimeDir -Force | Out-Null
        Expand-Archive -LiteralPath $archive -DestinationPath $RuntimeDir -Force
    } finally { if (Test-Path -LiteralPath $partial) { Remove-Item -LiteralPath $partial -Force } }
    $engine=Find-Engine
    if (-not $engine) { throw 'The verified archive did not yield the expected engine.' }
    return $engine
}

try {
    if (-not (Test-Path -LiteralPath (Join-Path $ProjectRoot 'project.godot') -PathType Leaf)) { throw ('Missing project.godot in '+$ProjectRoot+'. Extract the complete ZIP into D:\, not into an extra nested folder.') }
    foreach ($id in @('tophiachu','novaonline','cyraxx','candy_rooks','andy_ditch','jupiter_the_hybrid','anacondasin','daniel_larson','referee_cobra','ring_arena')) {
        if (-not (Test-Path -LiteralPath (Join-Path $ProjectRoot ('assets\models\'+$id+'.glb')) -PathType Leaf)) { throw ('Missing model: '+$id+'. Extract the complete ZIP again.') }
    }
    New-Item -ItemType Directory -Path $LogDir -Force | Out-Null
    Set-Content -LiteralPath (Join-Path $LogDir '.gdignore') -Value '' -Encoding ASCII
    $godot=Find-Engine
    if (-not $godot) { $godot=Install-Engine }
    Write-Host ('Project: '+$ProjectRoot)
    Write-Host ('Engine: '+$godot)
    Write-Host 'Checking assets. First-time import can take a little longer.'
    $importLog=Join-Path $LogDir 'import-engine.log'
    if (Test-Path -LiteralPath $importLog) { Remove-Item -LiteralPath $importLog -Force }
    Invoke-Engine $godot @('--headless','--editor','--path',$ProjectRoot,'--rendering-method',$Renderer,'--import','--log-file',$importLog) 'import'
    $errors=@(@($importLog,(Join-Path $LogDir 'import-stdout.log'),(Join-Path $LogDir 'import-stderr.log')) | Where-Object { Test-Path -LiteralPath $_ } | Select-String -Pattern 'SCRIPT ERROR:|Parse Error:|^ERROR:')
    if ($errors.Count -gt 0) { $errors | Select-Object -First 15 | ForEach-Object { Write-Host $_.Line }; throw ('Import failed. The game was not started. Logs: '+$LogDir) }
    if ($ValidateOnly) { Write-Host 'Validation completed; gameplay was not started.'; exit 0 }
    Write-Host 'Starting OFFLINE MAYHEM. Escape pauses; F1 shows controls.'
    Invoke-Engine $godot @('--path',$ProjectRoot,'--rendering-method',$Renderer,'--log-file',(Join-Path $LogDir 'game-engine.log')) 'game'
    exit 0
} catch {
    Write-Host ('ERROR: '+$_.Exception.Message)
    Write-Host 'See START_HERE.txt and .launch-logs. No administrator privileges are required.'
    exit 1
}
