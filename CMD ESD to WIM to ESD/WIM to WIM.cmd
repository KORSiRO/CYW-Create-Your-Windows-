cd E:\
dism /Get-WimInfo /WimFile:E:\install.wim
dism /Export-Image /SourceImageFile:E:\install.wim /SourceIndex:6 /DestinationImageFile:E:\W1\install.wim /Compress:Max /CheckIntegrity
pause