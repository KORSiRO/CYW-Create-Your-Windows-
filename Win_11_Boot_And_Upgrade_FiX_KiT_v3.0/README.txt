Win 11 Boot And Upgrade FiX KiT v3.0 By @Enthousiast at MDL

This tool provides these fixes:

================================================================================
Select the desired FiX...
================================================================================

[ 1 ] This option mainly utilizes UFWS v1.4 (recommended option).

- It circumvents all Win 11 minimum requirements (CPU-RAM-Disksize-TPM-Secureboot).
- This works for clean installs and upgrade scenarios using standard setup.
- Integrates the Diskpart & Apply Image script (v1.3.1).
- A generic EI.CFG file will be copied to the sources folder.

================================================================================

[ 2 ] - This option modifies boot.wim registry to skip the SB, RAM, DiskSize and
 TPM 2.0 check and replaces "appraiserres.dll" with one from Win 10
 (You can insert your own in the Files folder, by default it's one from a 15063 ISO).
- Integrates the Diskpart & Apply Image script (v1.3.1).
- A generic EI.CFG file will be copied to the sources folder.

This method enables you to:

- Use the standard Win 11 setup for clean installs on devices without:
Secure Boot, TPM 2.0, DiskSize <52GB & RAM <8GB.
- Use the alternative Diskpart & Apply Image installation script for clean installs.
- Circumvent "TPM 2.0 is required" error when (inplace) upgrading.
- Enables to install on LegacyBIOS/MBR only systems.
- Circumvents the 64GB (52GB) minimum disk size check.

================================================================================

[ 3 ] - This option combines option 1 and option 2.

================================================================================

This only applies to Option 1, 2 and 3!!!

- For when public release (all Win 7/8/10) to DEV channel release ISO upgrades fails,
i've put in a cmd called "Upgrade_Fail_Fix.cmd", run this as admin,
after rebooting you can simply run standard setup.

================================================================================

[ 4 ] - Puts the Win 11 install.wim/esd in a Win 10 ISO.
(Provide a Win 10 ISO in the "Source_ISO\W10\" Folder).

- This method is useful for clean installs from boot, using the standard W10 setup.
- A generic EI.CFG file will be copied to the sources folder.

================================================================================

Diskpart and Apply Image usage instructions:

After selecting the desired keyboard language press "SHIFT+F10" to open commandprompt and type "menu", press "Y" and next "F" and "Y" again.

The options for recovery options are removed from the script by @murphy78 (no longer supported on 10/11).

Video: https://i.imgur.com/1uDnjKr.gif

Official (support) thread: https://forums.mydigitallife.net/threads/win-11-boot-and-upgrade-fix-kit-v1-5.83724/

====================================================================

Changelog:

v3.0

- Unified the old boot.wim registry modification\appraiserres.dll replacement method with the UFWS (WINDOWS/INSTALLATIONTYPE=Server) method.
- Updated the wimlib-imagex and 7zip files to the latest available
- Updated the code to be able to handle spacings in the folder path/name (code suggestion by @rpo)
- You can insert your own desired win 10 appraiserres.dll file in the "Files" folder, the script will show what version it is (by default the one from a 15063 ISO is provided).
- Made the integration of the Diskpart & Apply Image script (v1.3.1) by @murphy78 optional by editing the script settings:

SET "DPaA=1" < This sets the script to integrate the Diskpart & Apply Image script (v1.3.1), when set to "0" it won't integrate it.

v2.2

Replaced the UFWS cmd by UFWS v1.4, now modifying the index info on install.wim/esd to circumvent the win 11 minimum system requirements when clean installing or upgrading.
UFWS enables you to do ISO upgrades without the need for disconnecting from internet.
The tool now uses only one folder for the used files, thanks to @W_fantasma at MDL.
Added an "Upgrade_Fail_Fix.cmd to the root of the ISO, meant for when upgrading has failed.
Also put in direct CMD settings for adding ei.cfg and boot.wim optimization.
Replaced the date assessment for ISO fix date by code suggestion by @RPO at MDL
Added 2 new settings on the cmd file directly:

SET "EI_CFG_ADD=1" <--- This sets the script to add the generic ei.cfg (if already exists, the existing one will be renamed to "EI.CFG.Ori"), when set to "0" the generic ei.cfg will not be copied, existing ones will remain on the ISO.
SET "Boot_WIM_Opt=1" <--- This sets the script to run the optimize (rebuild) command for boot.wim, when set to "0" it won't.

v2.1

Fixed the wimic stuff by @abbodi1406 at MDL
Added UFWS v1.3 (https://github.com/uwuowouwu420/ufws)

v2.0

Added the 64GB minimum disksize check bypass
Changed the code to use the original filename with "FiXED_date" addition (requested by @antonio8909 and used code offered by @rpo )
Added the ei.cfg copy function to option 2 too
Added some more info about what the fixes enable to do (suggested by @ch100 )

v1.9

Removed the need for mounting boot.wim, speeding up the progress

v1.8

Added the latest Diskpart & Apply Image v1.3.1 (@murphy78 removed the options for recovery, they are no longer supported by MSFT)

v1.7

Fixed the problems with running the tool from a file path containing spacings (help from @murphy78)

v1.6

Updated wimlib files
Added Bypassramcheck to option 2