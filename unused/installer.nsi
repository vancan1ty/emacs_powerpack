#name the installer
Outfile "Emacs_PowerPack.exe"

InstallDir "$PROGRAMFILES\Emacs PowerPack"

# For removing Start Menu shortcut in Windows 7
RequestExecutionLevel admin

# default section start; every NSIS script has at least one section.
Section

    SetOutPath $INSTDIR

    File test.txt

    WriteUninstaller $INSTDIR\uninstall.exe

    # create a shortcut named "new shortcut" in the start menu programs directory
    # point the new shortcut at the program uninstaller
    CreateShortCut "$SMPROGRAMS\uninstallEmacsPowerpack.lnk" "$INSTDIR\uninstall.exe"

# default section end
SectionEnd

Section "Uninstall"

    Delete $INSTDIR\uninstall.exe
    Delete $INSTDIR\test.txt
    RMDir $INSTDIR

    Delete "$SMPROGRAMS\uninstallEmacsPowerpack.lnk"

SectionEnd