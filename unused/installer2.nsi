;Emacs Powerpack install script 
;Currell Berry
;based on MUI example by Joost Verburg

;--------------------------------
;Include Modern UI

  !include "MUI2.nsh"

;--------------------------------
;General

;Name and file
Name "Emacs PowerPack"
OutFile "EmacsPowerPack.exe"

;Default installation folder
InstallDir "$PROGRAMFILES\Emacs PowerPack"

;Get installation folder from registry if available
InstallDirRegKey HKCU "Software\Emacs PowerPack" ""

;Request application privileges for Windows Vista
RequestExecutionLevel admin

;--------------------------------
;Interface Settings

!define MUI_ABORTWARNING

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
  
;--------------------------------
;Languages
 
  !insertmacro MUI_LANGUAGE "English"

;--------------------------------
;Installer Sections

;global section
Section
  SetOutPath "$INSTDIR"

  ;Store installation folder
  WriteRegStr HKCU "Software\Emacs PowerPack" "" $INSTDIR
  
  ;Create uninstaller
  WriteUninstaller "$INSTDIR\Uninstall.exe"
SectionEnd

Section "Emacs 24.5" Emacs 
  SetOutPath "$INSTDIR"

   File test.txt
SectionEnd

Section "MinGW" MinGW
  SetOutPath "$INSTDIR"

   File test2.txt
SectionEnd

Section "Helper Utilities" HelperUtils
  SetOutPath "$INSTDIR"

   File test3.txt
SectionEnd


;--------------------------------
;Descriptions

;Language strings
LangString DESC_Emacs ${LANG_ENGLISH} "Install GNU Emacs 24.5."
LangString DESC_MinGW ${LANG_ENGLISH} "Install MinGW"
LangString DESC_MinGW ${LANG_ENGLISH} "Install MinGW"

;Assign language strings to sections
!insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
	     !insertmacro MUI_DESCRIPTION_TEXT ${Emacs} $(DESC_Emacs)
!insertmacro MUI_FUNCTION_DESCRIPTION_END

;--------------------------------
;Uninstaller Section

Section "Uninstall"

Delete $INSTDIR\Uninstall.exe

Delete $INSTDIR\test.txt
Delete $INSTDIR\test2.txt

  RMDir $INSTDIR

  DeleteRegKey /ifempty HKCU "Software\Emacs PowerPack"

SectionEnd