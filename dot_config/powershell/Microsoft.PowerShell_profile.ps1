# Set GPG_TTY, please keep this line on top
$env:GPG_TTY = $(tty)

# Import modules
Import-Module posh-git

# Check command exists and return bool
function CommandExists($command) {
    $oldPreference = $ErrorActionPreference
    $ErrorActionPreference = 'Stop'
    try {
        Get-Command $command -ErrorAction Stop | Out-Null
        $ErrorActionPreference = $oldPreference
        return $true
    }
    catch {
        $ErrorActionPreference = $oldPreference
        return $false
    }
}

# Command initialization
if (CommandExists '/opt/homebrew/bin/brew') { Invoke-Expression (&/opt/homebrew/bin/brew shellenv | Out-String) }

if (CommandExists 'starship') { Invoke-Expression (&starship init powershell | Out-String) }

if (CommandExists 'zoxide') {
    Invoke-Expression (& { $hook = if ($PSVersionTable.PSVersion.Major -ge 6) { 'pwd' } else { 'prompt' } (zoxide init powershell --hook $hook | Out-String) })
}

if (CommandExists 'fnm') { Invoke-Expression (&fnm env --use-on-cd | Out-String) }

# Shell completions
if (CommandExists 'rustup') { Invoke-Expression (&rustup completions powershell | Out-String) }

if (CommandExists 'uv') { Invoke-Expression (&uv generate-shell-completion powershell | Out-String) }
if (CommandExists 'uvx') { Invoke-Expression (&uvx --generate-shell-completion powershell  | Out-String) }


# VSCode shell integration
# if ($env:TERM_PROGRAM -eq "vscode") { . "$(code --locate-shell-integration-path pwsh)" }
