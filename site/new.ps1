# DoGoDev bootstrap -- https://dogodev.com/new.ps1
#
# What this does: checks the four tools (terminal you're in, Node, Git, Claude Code),
# GUIDES you through any that are missing, then creates your project folder under
# C:\dev, starts git history, and drops in the DoGoDev suite.
#
# What this does NOT do: host or bundle any software. Every install comes from its
# official source (winget's vendor-published manifests, nodejs.org, git-scm.com,
# Anthropic's own installer at claude.ai). Nothing installs without your explicit yes.
#
# Source-controlled at: https://github.com/mellowcity1/dogodev (site/new.ps1)
# Run: irm https://dogodev.com/new.ps1 | iex

Set-StrictMode -Off
$ErrorActionPreference = 'Continue'

function Write-Head($t) { Write-Host ""; Write-Host ("== " + $t + " ==") -ForegroundColor Cyan }
function Write-Ok($t)   { Write-Host ("  [OK]   " + $t) -ForegroundColor Green }
function Write-Miss($t) { Write-Host ("  [MISS] " + $t) -ForegroundColor Yellow }
function Write-Note($t) { Write-Host ("  " + $t) -ForegroundColor Gray }

function Update-SessionPath {
    $m = [Environment]::GetEnvironmentVariable('Path', 'Machine')
    $u = [Environment]::GetEnvironmentVariable('Path', 'User')
    $env:Path = $m + ';' + $u
}

function Test-HasCommand($name) {
    $c = Get-Command $name -ErrorAction SilentlyContinue
    if ($c) { return $true } else { return $false }
}

function Test-HasWinget { return (Test-HasCommand 'winget') }

# Returns $true when the tool is present (already, or after a guided install).
function Confirm-Tool($label, $checkScript, $wingetId, $downloadUrl, $officialNote) {
    $ok = & $checkScript
    if ($ok) { return $true }
    Write-Miss $label
    Write-Note $officialNote
    while ($true) {
        $opts = "[O]pen the official download page"
        if ((Test-HasWinget) -and $wingetId) { $opts = "[W]inget install (official source), " + $opts }
        $opts = $opts + ", [S]kip for now"
        $ans = Read-Host ("  Install " + $label + "? " + $opts)
        if ($ans -match '^[Ww]' -and $wingetId -and (Test-HasWinget)) {
            Write-Note ("Running: winget install --id " + $wingetId + " (you may see a Windows permission prompt)")
            winget install --id $wingetId --accept-source-agreements --accept-package-agreements
            Update-SessionPath
            $ok = & $checkScript
            if ($ok) { Write-Ok ($label + " installed") ; return $true }
            Write-Note "Not visible yet -- a NEW terminal window usually fixes that. Skipping for now."
            return $false
        }
        elseif ($ans -match '^[Oo]') {
            Start-Process $downloadUrl
            Read-Host ("  Browser opened to " + $downloadUrl + ". Press Enter here when the install finishes")
            Update-SessionPath
            $ok = & $checkScript
            if ($ok) { Write-Ok ($label + " installed") ; return $true }
            Write-Note "Not visible yet -- a NEW terminal window usually fixes that. Skipping for now."
            return $false
        }
        elseif ($ans -match '^[Ss]') { return $false }
    }
}

function Test-NodeOk {
    if (-not (Test-HasCommand 'node')) { return $false }
    $v = (& node --version) 2>$null
    if (-not $v) { return $false }
    $v = $v.TrimStart('v')
    try {
        $parts = $v.Split('.')
        $maj = [int]$parts[0]; $min = [int]$parts[1]
        if ($maj -gt 22) { return $true }
        if ($maj -eq 22 -and $min -ge 5) { return $true }
        return $false
    } catch { return $false }
}

function Confirm-GitIdentity {
    $name = (& git config user.name) 2>$null
    $mail = (& git config user.email) 2>$null
    if ($name -and $mail) { Write-Ok ("Git knows you: " + $name + " <" + $mail + ">"); return }
    Write-Miss "Git does not know your name/email yet -- your first save (commit) would fail confusingly."
    $ans = Read-Host "  Set it now? [Y/n]"
    if ($ans -match '^[Nn]') { Write-Note "Skipped. Claude can help set this later."; return }
    if (-not $name) {
        $name = Read-Host "  Your name (shows on your work history)"
        if ($name) { git config --global user.name "$name" }
    }
    if (-not $mail) {
        $mail = Read-Host "  Your email (use the same one as your GitHub account, if you have one)"
        if ($mail) { git config --global user.email "$mail" }
    }
    Write-Ok "Git identity set."
}

function New-DogodevProject($name) {
    $base = 'C:\dev'
    if (-not (Test-Path $base)) {
        New-Item -ItemType Directory -Path $base | Out-Null
        Write-Ok "Created C:\dev (your code home, out of OneDrive's reach)"
    }
    $proj = Join-Path $base $name
    if (-not (Test-Path $proj)) { New-Item -ItemType Directory -Path $proj | Out-Null }
    Set-Location $proj
    if (-not (Test-Path (Join-Path $proj '.git'))) {
        $initOut = (& git init -b main 2>&1)
        if ($LASTEXITCODE -ne 0) { git init | Out-Null }
        Write-Ok "Version history started (git)"
    } else { Write-Ok "Version history already present" }
    if (Test-Path (Join-Path $proj '.claude')) {
        Write-Ok "DoGoDev suite already present -- leaving it untouched"
    } else {
        $tmp = Join-Path $env:TEMP ("dogodev-src-" + $PID)
        try {
            git clone --depth 1 https://github.com/mellowcity1/dogodev.git $tmp 2>&1 | Out-Null
            Copy-Item (Join-Path $tmp '.claude') $proj -Recurse
            Copy-Item (Join-Path $tmp 'CLAUDE.md') $proj
            Write-Ok "DoGoDev suite installed (five agents, pipeline, /setup-check)"
        } finally {
            if (Test-Path $tmp) { Remove-Item $tmp -Recurse -Force }
        }
    }
    return $proj
}

function Invoke-DoGoDevBootstrap {
    Write-Host ""
    Write-Host "  DoGoDev -- from idea to running app, with Claude." -ForegroundColor White
    Write-Host "  This checks your tools, guides any installs (always from the official source," -ForegroundColor Gray
    Write-Host "  always asking first), then sets up your project." -ForegroundColor Gray

    Write-Head "Your tools"
    if (Test-NodeOk) { Write-Ok ("Node.js " + (& node --version)) }
    $nodeOk = Confirm-Tool 'Node.js (22.5 or newer)' ${function:Test-NodeOk} 'OpenJS.NodeJS.LTS' 'https://nodejs.org/en/download' 'Node runs your app''s code. Official source: nodejs.org'
    if ((Test-HasCommand 'git')) { Write-Ok ("Git " + ((& git --version) -replace 'git version ','')) }
    $gitOk = Confirm-Tool 'Git' { Test-HasCommand 'git' } 'Git.Git' 'https://git-scm.com/downloads' 'Git keeps your work history. Official source: git-scm.com'
    if ((Test-HasCommand 'claude')) { Write-Ok ("Claude Code " + (& claude --version)) }
    $claudeOk = $false
    if (Test-HasCommand 'claude') { $claudeOk = $true }
    if (-not $claudeOk) {
        Write-Miss "Claude Code (the builder -- needs a paid Claude plan, see claude.com/pricing)"
        Write-Note "Installs via Anthropic's own installer (claude.ai). The Claude DESKTOP APP is separate and does not provide this."
        $ans = Read-Host "  Run Anthropic's official installer now? [Y/n]"
        if (-not ($ans -match '^[Nn]')) {
            irm https://claude.ai/install.ps1 | iex
            Update-SessionPath
            if (Test-HasCommand 'claude') { $claudeOk = $true; Write-Ok "Claude Code installed" }
            else { Write-Note "Installed but not visible in THIS window -- open a new terminal after this finishes." }
        }
    }

    if (-not $gitOk) {
        Write-Head "Stopping here"
        Write-Note "Git is required to set up the project (it fetches the DoGoDev suite)."
        Write-Note "Install it, open a NEW terminal, and run this command again -- it is safe to re-run."
        return
    }

    Confirm-GitIdentity

    Write-Head "Your project"
    $name = $null
    while (-not $name) {
        $raw = Read-Host "  Project name (letters, numbers, hyphens -- e.g. my-first-app)"
        if ($raw -match '^[A-Za-z0-9][A-Za-z0-9_-]*$') { $name = $raw }
        else { Write-Note "Just letters, numbers, hyphens or underscores, starting with a letter or number." }
    }
    $proj = New-DogodevProject $name

    Write-Head "You're set. Three things left"
    Write-Note ("1. Open CLAUDE.md in " + $proj + " and fill in 'Your project's house rules'")
    Write-Note "   (what you're building, in what language -- a sentence or two is enough to start)."
    Write-Note ("2. In this terminal: cd " + $proj + "  then run: claude")
    if (-not $claudeOk) { Write-Note "   (claude was not found -- if you just installed it, use a NEW terminal window)" }
    Write-Note "3. Inside Claude Code, type /setup-check to confirm everything, then describe what you want built."
    Write-Host ""
    Write-Note "Full guide: https://dogodev.com"
}

if (-not (Get-Variable -Name DOGODEV_NO_RUN -ErrorAction SilentlyContinue)) {
    Invoke-DoGoDevBootstrap
}
