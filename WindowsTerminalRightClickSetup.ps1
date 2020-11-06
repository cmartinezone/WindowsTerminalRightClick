
#Author: Carlos Martinez Github @cmartinezone  
#Version: 1.0
$host.ui.RawUI.WindowTitle = "WindowsTerminal RightClickMenu setup v.1.0 - GitHub: @cmartinezone"

#Find windows terminal
$getWindowsTerminal = Get-ChildItem -Path $env:LOCALAPPDATA\Packages -Filter *Microsoft.WindowsTerminal*

#Detect Lenguage
$getLeng = Get-WinSystemLocale

#Set user lenguage leyout
$leng = @{} # Hash table for user lenguage 
if ($getLeng.DisplayName -match 'Español' -or $getLeng.DisplayName -match 'Spanish') {
    $leng = @{} 
    $leng.PrintUser00 = 'No se ha detectado WindowsTerminal instalado!'
    $leng.PrintUser01 = 'Porfavor actualice WindowsTerminal settings.json'
    $leng.PrintUser02 = 'En "profiels" configure:'
    $leng.PrintUser03 = '!Cierre el bloc de notas cuando haya terminado de editar!'
    $leng.PrintUser04 = 'Configuración de el registro...'
    $leng.PrintUser05 = 'Configuración Completada!'
    $leng.PrintUser06 = 'Disfruta Windows Terminal!'

    $leng.SetRegProperty00 = 'Abrir Windows Terminal aquí'
    $leng.SetRegProperty01 = 'Abrir Windows Terminal aquí (Administrador)'

}else{
    $leng.PrintUser00 = 'No detected WindowsTerminal installation'
    $leng.PrintUser01 = 'Please Update WindowsTerminal settings.json'
    $leng.PrintUser02 = 'Please update in "profiles":'
    $leng.PrintUser03 = '!Close notepad when you are done editing!'
    $leng.PrintUser04 = 'Setting Registry...'
    $leng.PrintUser05 = 'Done!'
    $leng.PrintUser06 = 'Enjoy Windows Terminal!'
    
    $leng.SetRegProperty00 = 'Open Windows Terminal here'
    $leng.SetRegProperty01 = 'Open Windows Terminal here (Admin)'
}

#If Windows Terminal is installed
if(-not($getWindowsTerminal)){ 
   
    Write-Host $leng.PrintUser00

}else {

    ##EDIT WINDOWS TERMINAL PROPERTIES##
    $getWindowsTerminalPath = $getWindowsTerminal | Select-Object -First 1
    $getWindowsTerminalPath.fullName
    $windowsTerminalProperties = ($getWindowsTerminalPath.FullName+"\LocalState\settings.json")
     
    $getRequireSetting = Get-Content -Path $windowsTerminalProperties

    do {
    Clear-Host
    Write-Host $leng.PrintUser01 -BackgroundColor Yellow -ForegroundColor Blue
    Write-Host $leng.PrintUser02 -BackgroundColor Yellow -ForegroundColor Blue
    Write-Host @"
    "defaults":
    {
        "startingDirectory": "."
    }
"@ -ForegroundColor Yellow

    Write-Host $leng.PrintUser03 -ForegroundColor Green
    Start-Sleep 2
    Start-Process notepad.exe $windowsTerminalProperties  -Wait
    $getRequireSetting = Get-Content -Path $windowsTerminalProperties
    } until ($getRequireSetting -match '"startingDirectory": "."')
     
     ##GET WINDOWS TERMINAL INSTALLATION PACKAGE PATH##
     $getWinTernInstallationPath =  Get-AppxPackage -Name Microsoft.WindowsTerminal 

     ## PRESET REGISTRY VALUES ##
     $windowsTerminalIcon = ($getWinTernInstallationPath.InstallLocation +"\WindowsTerminal.exe")
     $windowsTerminalCommand = 'wt.exe'
     $windowsTerminalAdminCommand = "PowerShell -WindowStyle Hidden  -Command Start-Process wt.exe -ArgumentList '-d','.' -Verb runAs "
     
     Write-Host $leng.PrintUser04 -ForegroundColor Yellow
     ## SET REGISTRY VALUES ##
     New-Item -Path 'Registry::HKCR\Directory\Background\shell\WinTerm' -Force | Out-Null
     New-ItemProperty -Path 'Registry::HKCR\Directory\Background\shell\WinTerm' -Name '(Default)' -PropertyType String -Value  $leng.SetRegProperty00 -Force | Out-Null
     New-ItemProperty -Path 'Registry::HKCR\Directory\Background\shell\WinTerm' -Name 'Icon' -PropertyType String -Value $windowsTerminalIcon -Force | Out-Null
     New-Item -Path 'Registry::HKCR\Directory\Background\shell\WinTerm\command' -Force | Out-Null
     New-ItemProperty -Path 'Registry::HKCR\Directory\Background\shell\WinTerm\command' -Name "(Default)" -PropertyType String -Value $windowsTerminalCommand -Force | Out-Null

     New-Item -Path 'Registry::HKCR\Directory\Background\shell\WinTermAdmin' -Force | Out-Null
     New-ItemProperty -Path 'Registry::HKCR\Directory\Background\shell\WinTermAdmin' -Name '(Default)' -PropertyType String -Value  $leng.SetRegProperty01 -Force | Out-Null
     New-ItemProperty -Path 'Registry::HKCR\Directory\Background\shell\WinTermAdmin' -Name 'Icon' -PropertyType String -Value $windowsTerminalIcon -Force | Out-Null
     New-Item -Path 'Registry::HKCR\Directory\Background\shell\WinTermAdmin\command' -Force | Out-Null
     New-ItemProperty -Path 'Registry::HKCR\Directory\Background\shell\WinTermAdmin\command' -Name "(Default)" -PropertyType String -Value $windowsTerminalAdminCommand -Force | Out-Null
     Write-Host $leng.PrintUser05 -ForegroundColor Green
     Write-Host $leng.PrintUser06 -ForegroundColor Green
}