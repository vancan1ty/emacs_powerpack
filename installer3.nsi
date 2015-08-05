;Currell Berry
# This installs two files, app.exe and logo.ico, creates a start menu shortcut, builds an uninstaller, and
# adds uninstall information to the registry for Add/Remove Programs

!include "MUI2.nsh"
!include LogicLib.nsh

Name "Emacs_PowerPack"
Icon "logo.ico"
OutFile "Emacs_PowerPack.exe"
!define VERSIONMAJOR 1
!define VERSIONMINOR 1
!define VERSIONBUILD 1
!define DESCRIPTION "Facilitates install of Emacs+MinGW+Utilities"

;Default install dir
InstallDir "$PROGRAMFILES\Emacs_PowerPack"
;Get installation folder from registry if available
InstallDirRegKey HKCU "Software\Emacs PowerPack" ""

RequestExecutionLevel admin ;Require admin rights on NT6+ 
 
# These will be displayed by the "Click here for support information" link in "Add/Remove Programs"
# It is possible to use "mailto:" links in here to open the email client
!define HELPURL "http://cvberry.com/software/emacs_powerpack" # "Support Information" link
!define UPDATEURL "http://cvberry.com/software/emacs_powerpack" # "Product Updates" link
!define ABOUTURL "http://cvberry.com/software/emacs_powerpack" # "Publisher" link

# This is the size (in kB) of all the files copied into "Program Files"
!define INSTALLSIZE 7233

!define MUI_ABORTWARNING
 
# rtf or txt file - remember if it is txt, it must be in the DOS text format (\r\n)
LicenseData "LICENSE.txt"
 
;--------------------------------
;Pages

LangString welcome_str ${LANG_ENGLISH} "This wizard will guide you through the installation of Emacs Powerpack.$\r$\n$\r$\nEmacs Powerpack provides an accelerated install for emacs, mingw, and several add-ons for mingw.  Emacs Powerpack is intended to make it as easy as possible to set up a productive emacs-based development environment on a windows computer.$\r$\n$\r$\nIt is recommended that you close all other applications before starting Setup.  This will make it possible to update relevant system files without having to reboot your computer$\r$\n$\r$\nClick next to continue."

!define MUI_WELCOMEPAGE_TEXT $(welcome_str)
!insertmacro MUI_PAGE_WELCOME 
!insertmacro MUI_PAGE_LICENSE "LICENSE.txt"
!insertmacro MUI_PAGE_COMPONENTS
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES

!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES

!insertmacro MUI_LANGUAGE "English"
  
;--------------------------------
 
;------------ functions and macros --------------
;CB TODO look into why/if this is needed.
!macro VerifyUserIsAdmin
UserInfo::GetAccountType
pop $0
${If} $0 != "admin" ;Require admin rights on NT4+
        messageBox mb_iconstop "Administrator rights required!"
        setErrorLevel 740 ;ERROR_ELEVATION_REQUIRED
        quit
${EndIf}
!macroend
 
function .onInit
	setShellVarContext all
	!insertmacro VerifyUserIsAdmin
functionEnd
;----------------------------------------------------------
 
;global section
Section 
	# Files for the install directory - to build the installer, these should be in the same directory as the install script (this file)
	setOutPath $INSTDIR
  	SetShellVarContext all

	# Files added here should be removed by the uninstaller (see section "uninstall")
	file "app.exe"
	file "logo.ico"
	# Add any other files for the install directory (license files, app data, etc) here
 
	# Uninstaller - See function un.onInit and section "uninstall" for configuration
	writeUninstaller "$INSTDIR\uninstall.exe"
 
	# Start Menu
	createDirectory "$SMPROGRAMS\Emacs_PowerPack"

	# Registry information for add/remove programs
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Emacs_PowerPack" "DisplayName" "Emacs_PowerPack - Emacs - ${DESCRIPTION}"
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Emacs_PowerPack" "UninstallString" "$\"$INSTDIR\uninstall.exe$\""
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Emacs_PowerPack" "QuietUninstallString" "$\"$INSTDIR\uninstall.exe$\" /S"
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Emacs_PowerPack" "InstallLocation" "$\"$INSTDIR$\""
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Emacs_PowerPack" "DisplayIcon" "$\"$INSTDIR\logo.ico$\""
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Emacs_PowerPack" "Publisher" "$\"Emacs_PowerPack$\""
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Emacs_PowerPack" "HelpLink" "$\"${HELPURL}$\""
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Emacs_PowerPack" "URLUpdateInfo" "$\"${UPDATEURL}$\""
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Emacs_PowerPack" "URLInfoAbout" "$\"${ABOUTURL}$\""
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Emacs_PowerPack" "DisplayVersion" "$\"${VERSIONMAJOR}.${VERSIONMINOR}.${VERSIONBUILD}$\""
	WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Emacs_PowerPack" "VersionMajor" ${VERSIONMAJOR}
	WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Emacs_PowerPack" "VersionMinor" ${VERSIONMINOR}
	# There is no option for modifying or repairing the install
	WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Emacs_PowerPack" "NoModify" 1
	WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Emacs_PowerPack" "NoRepair" 1
	# Set the INSTALLSIZE constant (!defined at the top of this script) so Add/Remove Programs can accurately report the size
	WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Emacs_PowerPack" "EstimatedSize" ${INSTALLSIZE}

SectionEnd

Section "Emacs 24.5" Emacs
  	SetOutPath "$INSTDIR"
  	SetShellVarContext all

	File /r externals\emacs 
	createShortCut "$SMPROGRAMS\Emacs_PowerPack\Emacs.lnk" "$INSTDIR\emacs\bin\runemacs.exe" "" "$INSTDIR\logo.ico"
sectionEnd

Section "MinGW" MinGW
	SetOutPath "$INSTDIR"
  	SetShellVarContext all

	File test2.txt
	createShortCut "$SMPROGRAMS\Emacs_PowerPack\MinGW.lnk" "$INSTDIR\app.exe" "" "$INSTDIR\logo.ico"
SectionEnd

Section "Helper Utilities" HelperUtils
	SetOutPath "$INSTDIR"
  	SetShellVarContext all

	File test3.txt
SectionEnd

;--------------------------------
;Descriptions

;Language strings
LangString DESC_Emacs ${LANG_ENGLISH} "Install and configure GNU Emacs 24.5."
LangString DESC_MinGW ${LANG_ENGLISH} "Install MinGW"
LangString DESC_HelperUtils ${LANG_ENGLISH} "Install man pages and other helpful utilities."

;Assign language strings to sections
!insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
	     !insertmacro MUI_DESCRIPTION_TEXT ${Emacs} $(DESC_Emacs)
	     !insertmacro MUI_DESCRIPTION_TEXT ${MinGW} $(DESC_MinGW)
	     !insertmacro MUI_DESCRIPTION_TEXT ${HelperUtils} $(DESC_HelperUtils)
!insertmacro MUI_FUNCTION_DESCRIPTION_END

;--------------------------------

# Uninstaller
 
;function un.onInit
;	!insertmacro VerifyUserIsAdmin
;functionEnd

Section "Uninstall"
  	SetShellVarContext all
	delete "$SMPROGRAMS\Emacs_PowerPack\Emacs.lnk"
	delete "$SMPROGRAMS\Emacs_PowerPack\MinGW.lnk"
	
	# Remove files
	delete $INSTDIR\app.exe
	delete $INSTDIR\logo.ico
	Delete $INSTDIR\test.txt
	Delete $INSTDIR\test2.txt
	RMDir /r $INSTDIR\emacs
	Delete $INSTDIR\test3.txt
	
	# Remove Start Menu launcher
	# Try to remove the Start Menu folder - this will only happen if it is empty
	DetailPrint "attempt removal of  $SMPROGRAMS\Emacs_PowerPack"
	RMDir "$SMPROGRAMS\Emacs_PowerPack"
	
	Delete $INSTDIR\Uninstall.exe
	
	RMDir $INSTDIR
	
	DeleteRegKey /ifempty HKCU "Software\Emacs PowerPack"
	DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Emacs_PowerPack"
SectionEnd