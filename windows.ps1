''
'Kairos - Fast Dev Setup'
''

$param1=$args[0]

$NoPrompts = 0

if($param1 -eq '-a'){
    'All programs and options will be installed.'
    'Kinto remapper will be installed.'
    'Virtualbox w/ extension pack will be installed.'
    'Git projects Kinto & Kairos will be added to ~\Documents\git-projects.'
    'These programs will be installed.'
    'git sublimetext3 vscode googlechrome firefox opera microsoft-windows-terminal'
    $NoPrompts = 1
}
else{
    'You will be prompted before every install option.'
    ''
}

$SystemTheme = Get-ItemPropertyValue 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize' 'SystemUsesLightTheme'
$AppsTheme = Get-ItemPropertyValue 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize' 'AppsUseLightTheme'

If($SystemTheme  -eq '0'  -AND $AppsTheme  -eq '0'){
    'Dark Theme is applied.'
    $ThemeColor='Light'
    $ThemeValue='1'
} 
ElseIf($SystemTheme  -eq '1'  -AND $AppsTheme  -eq '1'){
    'Light Theme is applied'
    $ThemeColor='Dark'
    $ThemeValue='0'
}
Else{
    'Light and Dark themes are applied.'
    $ThemeColor='Either'
    $ThemeValue='2'
}

If($ThemeColor  -eq 'Light' -OR $ThemeColor  -eq 'Dark'){
    $SetTheme = "Do you want to apply a $ThemeColor Theme? [Y/N]"
    do {
        $response = Read-Host -Prompt $SetTheme
        if ($response -eq 'y') {
            Set-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize -Name SystemUsesLightTheme -Value $ThemeValue
            Set-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize -Name AppsUseLightTheme -Value $ThemeValue
        }
    } until ($response -eq 'n' -OR $response -eq 'y')
}
Else{
    $SetTheme = 'You have both Light and Dark themes enabled. Do you want to change that (N for no)? [L/D/N]'
    do {
        $response = Read-Host -Prompt $SetTheme
        if ($response -eq 'l') {
            Set-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize -Name SystemUsesLightTheme -Value 1
            Set-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize -Name AppsUseLightTheme -Value 1
        }
        if ($response -eq 'd') {
            Set-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize -Name SystemUsesLightTheme -Value 0
            Set-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize -Name AppsUseLightTheme -Value 0
        }
    } until ($response -eq 'n' -OR $response -eq 'l' -OR $response -eq 'd')
}

If(-not(Get-Command 'choco' -errorAction SilentlyContinue)){
    'Seems Chocolatey is not installed, installing now'
    Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
    refreshenv
}
Else{
    'Chocolatey is already installed. Continuing...'
}


If($NoPrompts -eq '0'){
    choco feature enable -n=allowGlobalConfirmation
    choco install virtualbox --params "/NoDesktopShortcut /ExtensionPack"
    choco install git googlechrome firefox opera sublimetext3 vscode wsl wsl-ubuntu-2004
    choco install microsoft-windows-terminal --pre
    choco feature disable -n=allowGlobalConfirmation
}
else{

    # Prompts

    # Virtualbox
    do {
        $InstallVirtualbox = Read-Host -Prompt 'Do you want to install Virtualbox? [Y/N]'
    } until ($InstallVirtualbox -eq 'n' -OR $InstallVirtualbox -eq 'y')
    # Browsers
    do {
        $InstallBrowsers = Read-Host -Prompt 'Do you want to install Chrome, Firefox and Opera? [C/F/O/[A]ll/[N]one]'
    } until ($InstallBrowsers -eq 'c' -OR $InstallBrowsers -eq 'f' -OR $InstallBrowsers -eq 'o' -OR $InstallBrowsers -eq 'a' -OR $InstallBrowsers -eq 'n')
    # Code Editors
    do {
        $InstallEditors = Read-Host -Prompt 'Do you want to install SublimeText3 and VSCode? [S/V/[A]ll]'
    } until ($InstallEditors -eq 's' -OR $InstallEditors -eq 'v' -OR $InstallEditors -eq 'a')
    do {
        $InstallVSExt = Read-Host -Prompt 'Do you want to install VSCode Extensions & set Kairos defaults? [Y/N]'
    } until ($InstallVSExt -eq 'y' -OR $InstallVSExt -eq 'n')
    # WSL
    do {
        'Do you want to install WSL1 or WSL2? [1/2]'
        $InstallWSL = Read-Host -Prompt 'Note: WSL2 uses hyper-V & may cause other VM solutions such as VirtualBox to be unstable.'
    } until ($InstallWSL -eq '1' -OR $InstallWSL -eq '2')
    # Distro
    do {
        $InstallDistro = Read-Host -Prompt 'Do you want to install Ubuntu 20.04? [Y/N]'
    } until ($InstallDistro -eq 'y' -OR $InstallDistro -eq 'n')
    # Windows Terminal Preview
    do {
        $InstallTerminal = Read-Host -Prompt 'Do you want to install Windows Terminal Preview & set WSL as default? [Y/N]'
    } until ($InstallTerminal -eq 'y' -OR $InstallTerminal -eq 'n')
    # WSL git, zsh, oh-my-zsh, ssh share
    do {
        $InstallTermApps = Read-Host -Prompt 'Under WSL do you want to install git, zsh, oh-my-zsh, & ssh share? [Y/N]'
    } until ($InstallTermApps -eq 'y' -OR $InstallTermApps -eq 'n')

    # Prompts End

    # Choco installs
    choco feature enable -n=allowGlobalConfirmation
    If($InstallVirtualbox -eq 'y'){
        choco install virtualbox --params "/NoDesktopShortcut /ExtensionPack"
    }
    If($InstallBrowsers -eq 'a'){
        choco install googlechrome firefox opera
    }
    ElseIf($InstallBrowsers -eq 'c'){
        choco install googlechrome
    }
    ElseIf($InstallBrowsers -eq 'f'){
        choco install firefox
    }
    ElseIf($InstallBrowsers -eq 'o'){
        choco install opera
    }
    If($InstallEditors -eq 'a'){
        choco install sublimetext3 vscode
    }
    ElseIf($InstallEditors -eq 's'){
        choco install sublimetext3
    }
    ElseIf($InstallEditors -eq 'v'){
        choco install vscode
    }
    If($InstallVSExt -eq 'y'){
        'Install VSCode Extensions and default json settings'
    }
    If($InstallWSL -eq '1'){
        choco install wsl
    }
    ElseIf($InstallWSL -eq '2'){
        choco install wsl2
    }
    If($InstallDistro -eq 'y'){
        choco install wsl-ubuntu-2004
    }
    If($InstallTerminal -eq 'y'){
        choco install microsoft-windows-terminal --pre
    }
    If($InstallTermApps -eq 'y'){
        'Install WSL git, zsh, oh-my-zsh, ssh share'
    }
    If($InstallPulseAudio -eq 'y'){
        'Install WSL PulseAudio'
    }
    choco feature disable -n=allowGlobalConfirmation
}