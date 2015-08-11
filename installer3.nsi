;Currell Berry

!include "MUI2.nsh"
!include nsDialogs.nsh
!include LogicLib.nsh

Name "Emacs_PowerPack"
Icon "ep_logo.ico"
OutFile "Emacs_PowerPack.exe"
!define VERSIONMAJOR 1
!define VERSIONMINOR 1
!define VERSIONBUILD 1
!define DESCRIPTION "Facilitates install of Emacs+MinGW+Utilities"
!define EMACSDIR 'emacs'
!define MINGWDIR 'mingw'

;default location where emacs powerpack itself will be installed
InstallDir "$PROGRAMFILES\Emacs_PowerPack"
;Get installation folder from registry if available
InstallDirRegKey HKCU "Software\Emacs PowerPack" ""

!define MINGWINSTALLDIR "C:\MinGW"
!define EMACSINSTALLDIR $PROGRAMFILES\emacs
!define EPINSTALLDIR $INSTDIR

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

;LangString welcome_str ${LANG_ENGLISH} "This wizard will guide you through the installation of Emacs Powerpack.$\r$\n$\r$\nEmacs Powerpack provides an accelerated install for emacs, mingw, and several add-ons for mingw.  Emacs Powerpack is intended to make it as easy as possible to set up a productive emacs-based development environment on a windows computer.$\r$\n$\r$\nIt is recommended that you close all other applications before starting Setup.  This will make it possible to update relevant system files without having to reboot your computer$\r$\n$\r$\nClick next to continue."
;!define MUI_WELCOMEPAGE_TEXT $(welcome_str)
!insertmacro MUI_PAGE_WELCOME 

!insertmacro MUI_PAGE_LICENSE "LICENSE.txt"
!insertmacro MUI_PAGE_COMPONENTS

Page custom myConfirmPage
!insertmacro MUI_PAGE_INSTFILES

!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES

!insertmacro MUI_LANGUAGE "English"
  
;--------------------------------
Var Dialog
Var Label
;Var Text

Function myConfirmPage
    nsDialogs::Create 1018
    Pop $Dialog

    ${If} $Dialog == error
	    Abort
    ${EndIf}

    !insertmacro MUI_HEADER_TEXT "Confirm Installation" "Review Changes"

    ${NSD_CreateLabel} 0 0 100% -2u "When you click 'Install', the following things will happen.$\r$\n1. Emacs Powerpack files and uninstaller will be installed in ${EPINSTALLDIR}.$\r$\n2. Emacs will be installed in ${EMACSINSTALLDIR}.$\r$\n3. MinGW will be installed in ${MINGWINSTALLDIR}.$\r$\n$\r$\nIf for any reason you are not satisfied you can always run the emacs powerpack uninstaller to revert all changes."
    Pop $Label

    ;${NSD_CreateText} 0 13u 100% -13u "Type something here..."
    ;Pop $Text

    nsDialogs::Show
FunctionEnd

InstType "Full (Installs Emacs+MinGW in standard locations)"
 
;------------ functions and macros --------------
function .onInit
	setShellVarContext all
functionEnd
;----------------------------------------------------------
 
;global section, installs emacs powerpack reg keys and such.
Section 
	SectionIn 1
	# Files for the install directory - to build the installer, these should be in the same directory as the install script (this file)
	setOutPath $INSTDIR

	# Files added here should be removed by the uninstaller (see section "uninstall")
	file "README.txt"
	file "ep_logo.ico"
 
	# Uninstaller - See function un.onInit and section "uninstall" for configuration
	writeUninstaller "$INSTDIR\uninstall.exe"
 
	# Start Menu
	createDirectory "$SMPROGRAMS\Emacs_PowerPack"

	# Registry information for add/remove programs
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Emacs_PowerPack" "DisplayName" "Emacs_PowerPack - Emacs - ${DESCRIPTION}"
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Emacs_PowerPack" "UninstallString" "$\"$INSTDIR\uninstall.exe$\""
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Emacs_PowerPack" "QuietUninstallString" "$\"$INSTDIR\uninstall.exe$\" /S"
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Emacs_PowerPack" "InstallLocation" "$\"$INSTDIR$\""
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Emacs_PowerPack" "DisplayIcon" "$\"$INSTDIR\ep_logo.ico$\""
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

SectionGroup "Emacs" EmacsGroup
  Section "Emacs 24.5" Emacs
	SectionIn 1
  	SetOutPath "${EMACSINSTALLDIR}"
	File /r "externals\${EMACSDIR}\*"
	createShortCut "$SMPROGRAMS\Emacs_PowerPack\Emacs.lnk" "${EMACSINSTALLDIR}\bin\runemacs.exe" "" "${EMACSINSTALLDIR}\share\icons\hicolor\32x32\apps\emacs.png"
SectionEnd
 
  Section "Basic Configuration"
     SectionIn 1
;    SetOutPath "$2"
;    CreateDirectory "$SMPROGRAMS\Harbinger"
;    CreateShortCut "$SMPROGRAMS\Harbinger\Harbinger 2003 Standard Edition.lnk" "$2\Harbinger.exe"
  SectionEnd
SectionGroupEnd

SectionGroup "MinGW" MinGWGroup
    Section "MinGW 1.x" MinGW
	SectionIn 1
	SetOutPath "${MINGWINSTALLDIR}"
	File /r "externals\${MINGWDIR}\*"
	createShortCut "$SMPROGRAMS\Emacs_PowerPack\MinGW.lnk" "${MINGWINSTALLDIR}\msys\1.0\msys.bat" "" "$INSTDIR\logo.ico"
    SectionEnd

    Section "MinGW Extras" MinGWExtras 
;	SectionIn 1
;	SetOutPath "$INSTDIR"
;  	SetShellVarContext all

;	File test3.txt
    SectionEnd

SectionGroupEnd

;--------------------------------
;Descriptions

;Language strings
LangString DESC_Emacs ${LANG_ENGLISH} "Install and configure GNU Emacs 24.5."
LangString DESC_MinGW ${LANG_ENGLISH} "Install MinGW"
LangString DESC_MinGWExtras ${LANG_ENGLISH} "man pages."

;Assign language strings to sections
!insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
	     !insertmacro MUI_DESCRIPTION_TEXT ${Emacs} $(DESC_Emacs)
	     !insertmacro MUI_DESCRIPTION_TEXT ${MinGW} $(DESC_MinGW)
	     !insertmacro MUI_DESCRIPTION_TEXT ${MinGWExtras} $(DESC_MinGWExtras)
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
	delete $INSTDIR\README.txt
	delete $INSTDIR\ep_logo.ico
	RMDir /r $EPINSTALLDIR
	
	# Remove Start Menu launcher
	# Try to remove the Start Menu folder - this will only happen if it is empty
	DetailPrint "attempt removal of  $SMPROGRAMS\Emacs_PowerPack"
	RMDir "$SMPROGRAMS\Emacs_PowerPack"
	
	Delete $INSTDIR\Uninstall.exe
	
	RMDir $INSTDIR
	
	DeleteRegKey /ifempty HKCU "Software\Emacs PowerPack"
	DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Emacs_PowerPack"
SectionEnd