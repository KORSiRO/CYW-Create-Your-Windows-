cd E:\
dism /Get-WimInfo /WimFile:E:\install.wim
dism /Export-Image /SourceImageFile:E:\install.wim /SourceIndex:1 /DestinationImageFile:E:\install.esd /Compress:recovery /CheckIntegrity
pause