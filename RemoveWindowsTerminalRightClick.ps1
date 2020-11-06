
#Remove Windows Terminal Right Click menu items.
Remove-Item -Path 'Registry::HKCR\Directory\Background\shell\WinTerm' -Recurse -Force | Out-Null
Remove-Item -Path 'Registry::HKCR\Directory\Background\shell\WinTermAdmin' -Recurse -Force | Out-Null