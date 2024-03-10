cd F:\
dism /Get-WimInfo /WimFile:F:\install.esd
dism /Export-Image /SourceImageFile:F:\install.esd /SourceIndex:1 /DestinationImageFile:F:\install.wim /Compress:Max /CheckIntegrity
pause