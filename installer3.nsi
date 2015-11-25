;Currell Berry
;TODO
;3. test on a couple different platforms. MEH
;8. go through and make sure bundled msys has all advertised features. HARDISH.

!include "MUI2.nsh"
!include nsDialogs.nsh
!include LogicLib.nsh

Name "Emacs_PowerPack"
Icon "icons\ep_logo.ico"
!define MUI_ICON "icons\ep_logo.ico"

OutFile "Emacs_PowerPack.exe"
!define VERSIONMAJOR 1
!define VERSIONMINOR 1
!define VERSIONBUILD 1
!define DESCRIPTION "Facilitates install of Emacs+MinGW+Utilities"
!define EMACSFILE 'emacs-24.5.zip'
!define MINGWFILE 'MinGW.zip'
;!define EMACSFILE 'emacs2.zip'
;!define MINGWFILE 'MinGW2.zip'

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

# This is the approximate size (in kB) of all the files copied into "Program Files"
!define INSTALLSIZE 230000

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

!define MUI_PAGE_CUSTOMFUNCTION_LEAVE BroadcastPathChanges
!insertmacro MUI_PAGE_INSTFILES

!insertmacro MUI_UNPAGE_CONFIRM

!define MUI_PAGE_CUSTOMFUNCTION_LEAVE un.BroadcastPathChanges
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
	file /r "icons"
 
	# Uninstaller - See function un.onInit and section "uninstall" for configuration
	writeUninstaller "$INSTDIR\uninstall.exe"
 
	# Start Menu
	createDirectory "$SMPROGRAMS\Emacs_PowerPack"
	createShortCut "$SMPROGRAMS\Emacs_PowerPack\ep_uninstall.lnk" "$INSTDIR\uninstall.exe" "" "$INSTDIR\icons\ep_logo_uninstall.ico"

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
	InitPluginsDir
	File /r "externals\${EMACSFILE}"
  	nsisunz::UnzipToLog "${EMACSINSTALLDIR}\${EMACSFILE}" "${EMACSINSTALLDIR}"
	;Always check result on stack
	Pop $0
	StrCmp $0 "success" ok
	   DetailPrint "$0" ;print error message to log
	ok:

	delete "${EMACSINSTALLDIR}\${EMACSFILE}"

	createShortCut "$SMPROGRAMS\Emacs_PowerPack\Emacs.lnk" "${EMACSINSTALLDIR}\bin\runemacs.exe" "" "$INSTDIR\icons\emacs.ico"
SectionEnd
 
Section "Basic Configuration"
    SectionIn 1
    SetOutPath "$PROFILE"

    ;1. set HOME env variable
    !define env_hklm 'HKLM "SYSTEM\CurrentControlSet\Control\Session Manager\Environment"'
    !define env_hkcu 'HKCU "Environment"'
    WriteRegExpandStr ${env_hkcu} "HOME" $PROFILE 

    ;2. if .emacs exists, then write .emacs.sample.  otherwise, write .emacs
    IfFileExists "$PROFILE\\.emacs" eexists enoexists
    eexists: ;then we just write a sample file and leave .emacs alone
    file  .emacs.sample
    goto after_dot_emacs
    enoexists:
    file /oname=.emacs .emacs.sample
    after_dot_emacs:
    
SectionEnd

Section "Add emacs to PATH" EMACS_PATH_SECTION
  	  SectionIn 1

  	  Push "${EMACSINSTALLDIR}\bin"
  	  Call AddToPath
SectionEnd

Section "Add 'open with emacs' option to context menu" EMACS_CTX_SECTION
  	  SectionIn 1

	 WriteRegStr HKCR "*\shell\Open With Emacs\command" "" '${EMACSINSTALLDIR}\bin\emacsclientw.exe  -n --alternate-editor="${EMACSINSTALLDIR}\bin\runemacs.exe"  "%1"' 

  	  Push "${EMACSINSTALLDIR}\bin"
  	  Call AddToPath
SectionEnd


SectionGroupEnd

SectionGroup "MinGW" MinGWGroup
    Section "MinGW 1.x" MinGW
	SectionIn 1
	SetOutPath "${MINGWINSTALLDIR}"

	File /r "externals\${MINGWFILE}"
  	nsisunz::UnzipToLog "${MINGWINSTALLDIR}\${MINGWFILE}" "${MINGWINSTALLDIR}"
	;Always check result on stack
	Pop $0
	StrCmp $0 "success" ok
	   DetailPrint "$0" ;print error message to log
	ok:

	delete "${MINGWINSTALLDIR}\${MINGWFILE}"

	createShortCut "$SMPROGRAMS\Emacs_PowerPack\msys.lnk" "${MINGWINSTALLDIR}\msys\1.0\msys.bat" "" "$INSTDIR\icons\msys.ico"
    SectionEnd

;    Section "MinGW Extras" MinGWExtras 
;	SectionIn 1
;	SetOutPath "$INSTDIR"
;  	SetShellVarContext all

;	File test3.txt
;    SectionEnd

Section "Add MinGW utilities (gcc, gdb, etc...) to PATH" MINGW_PATH_SECTION
  	  SectionIn 1

  	  Push "${MINGWINSTALLDIR}\bin"
  	  Call AddToPath
SectionEnd

Section "Add msys (mingw shell) to PATH" MSYS_PATH_SECTION
  	  SectionIn 1

  	  Push "${MINGWINSTALLDIR}\msys\1.0"
  	  Call AddToPath
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
	delete "$SMPROGRAMS\Emacs_PowerPack\msys.lnk"
	delete "$SMPROGRAMS\Emacs_PowerPack\ep_uninstall.lnk"
	
	# Remove files
	delete $INSTDIR\README.txt
	RMDir /r $INSTDIR\icons
	RMDir /r "${EPINSTALLDIR}"

	# Remove Start Menu launcher
	# Try to remove the Start Menu folder - this will only happen if it is empty
	DetailPrint "attempt removal of  $SMPROGRAMS\Emacs_PowerPack"
	RMDir "$SMPROGRAMS\Emacs_PowerPack"

  	; Remove emacs install dir from PATH
  	Push "${EMACSINSTALLDIR}\bin"
  	Call un.RemoveFromPath

	RMDir /r "${EMACSINSTALLDIR}"

  	; Remove mingw bin from PATH
  	Push "${MINGWINSTALLDIR}\bin"
  	Call un.RemoveFromPath

  	; Remove msys bin from PATH
  	Push "${MINGWINSTALLDIR}\msys\1.0"
  	Call un.RemoveFromPath
	RMDir /r "${MINGWINSTALLDIR}"
	
	Delete $INSTDIR\Uninstall.exe
	
	RMDir $INSTDIR

	DeleteRegKey HKCR "*\shell\Open With Emacs" 
	
	DeleteRegKey /ifempty HKCU "Software\Emacs PowerPack"
	DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Emacs_PowerPack"
SectionEnd

;--------------------------------------------------------------------
; Path functions
;
; Based on example from:
; http://nsis.sourceforge.net/Path_Manipulation
; taken from smartmontools installer
; http://www.smartmontools.org/browser/trunk/smartmontools/os_win32/installer.nsi?rev=4110&order=name
;

!include "WinMessages.nsh"

; Registry Entry for environment (NT4,2000,XP)
; All users:
!define Environ 'HKLM "SYSTEM\CurrentControlSet\Control\Session Manager\Environment"'
; Current user only:
;!define Environ 'HKCU "Environment"'

; AddToPath - Appends dir to PATH
;   (does not work on Win9x/ME)
;
; Usage:
;   Push "dir"
;   Call AddToPath

Function AddToPath
  Exch $0
  Push $1
  Push $2
  Push $3
  Push $4

  ; NSIS ReadRegStr returns empty string on string overflow
  ; Native calls are used here to check actual length of PATH

  ; $4 = RegOpenKey(HKEY_LOCAL_MACHINE,   "SYSTEM\CurrentControlSet\Control\Session Manager\Environment", &$3)
  System::Call "advapi32::RegOpenKey(i 0x80000002, t'SYSTEM\CurrentControlSet\Control\Session Manager\Environment', *i.r3) i.r4"
  IntCmp $4 0 0 done done
  ; $4 = RegQueryValueEx($3, "PATH", (DWORD*)0, (DWORD*)0, &$1, ($2=NSIS_MAX_STRLEN, &$2))
  ; RegCloseKey($3)
  System::Call "advapi32::RegQueryValueEx(i $3, t'PATH', i 0, i 0, t.r1, *i ${NSIS_MAX_STRLEN} r2) i.r4"
  System::Call "advapi32::RegCloseKey(i $3)"

  IntCmp $4 234 0 +4 +4 ; $4 == ERROR_MORE_DATA
    DetailPrint "AddToPath: original length $2 > ${NSIS_MAX_STRLEN}"
    MessageBox MB_OK "PATH not updated, original length $2 > ${NSIS_MAX_STRLEN}"
    Goto done

  IntCmp $4 0 +5 ; $4 != NO_ERROR
    IntCmp $4 2 +3 ; $4 != ERROR_FILE_NOT_FOUND
      DetailPrint "AddToPath: unexpected error code $4"
      Goto done
    StrCpy $1 ""


  ; Check if already in PATH
  Push "$1;"
  Push "$0;"
  Call StrStr
  Pop $2
  StrCmp $2 "" 0 done
  Push "$1;"
  Push "$0\;"
  Call StrStr
  Pop $2
  StrCmp $2 "" 0 done

  ; Prevent NSIS string overflow
  StrLen $2 $0
  StrLen $3 $1
  IntOp $2 $2 + $3
  IntOp $2 $2 + 2 ; $2 = strlen(dir) + strlen(PATH) + sizeof(";")
  IntCmp $2 ${NSIS_MAX_STRLEN} +4 +4 0
    DetailPrint "AddToPath: new length $2 > ${NSIS_MAX_STRLEN}"
    MessageBox MB_OK "PATH not updated, new length $2 > ${NSIS_MAX_STRLEN}."
    Goto done


  ; Append dir to PATH
  DetailPrint "Add to PATH: $0"
  StrCpy $2 $1 1 -1
  StrCmp $2 ";" 0 +2
    StrCpy $1 $1 -1 ; remove trailing ';'
  StrCmp $1 "" +2   ; no leading ';'
    StrCpy $0 "$1;$0"
  WriteRegExpandStr ${Environ} "PATH" $0

done:
  Pop $4
  Pop $3
  Pop $2
  Pop $1
  Pop $0

  DetailPrint "finishing addToPath"
FunctionEnd


; RemoveFromPath - Removes dir from PATH
;
; Usage:
;   Push "dir"
;   Call RemoveFromPath

Function un.RemoveFromPath
  Exch $0
  Push $1
  Push $2
  Push $3
  Push $4
  Push $5
  Push $6

  ReadRegStr $1 ${Environ} "PATH"
  StrCpy $5 $1 1 -1
  StrCmp $5 ";" +2
    StrCpy $1 "$1;" ; ensure trailing ';'
  Push $1
  Push "$0;"
  Call un.StrStr
  Pop $2 ; pos of our dir
  StrCmp $2 "" done

  DetailPrint "Remove from PATH: $0"
  StrLen $3 "$0;"
  StrLen $4 $2
  StrCpy $5 $1 -$4 ; $5 is now the part before the path to remove
  StrCpy $6 $2 "" $3 ; $6 is now the part after the path to remove
  StrCpy $3 "$5$6"
  StrCpy $5 $3 1 -1
  StrCmp $5 ";" 0 +2
    StrCpy $3 $3 -1 ; remove trailing ';'
  WriteRegExpandStr ${Environ} "PATH" $3

done:
  Pop $6
  Pop $5
  Pop $4
  Pop $3
  Pop $2
  Pop $1
  Pop $0
FunctionEnd
 
var timer

; StrStr - find substring in a string
;
; Usage:
;   Push "this is some string"
;   Push "some"
;   Call StrStr
;   Pop $0 ; "some string"

!macro StrStr un
Function ${un}StrStr
  Exch $R1 ; $R1=substring, stack=[old$R1,string,...]
  Exch     ;                stack=[string,old$R1,...]
  Exch $R2 ; $R2=string,    stack=[old$R2,old$R1,...]
  Push $R3
  Push $R4
  Push $R5
  StrLen $R3 $R1
  StrCpy $R4 0
  ; $R1=substring, $R2=string, $R3=strlen(substring)
  ; $R4=count, $R5=tmp
  loop:
    StrCpy $R5 $R2 $R3 $R4
    StrCmp $R5 $R1 done
    StrCmp $R5 "" done
    IntOp $R4 $R4 + 1
    Goto loop
done:
  StrCpy $R1 $R2 "" $R4
  Pop $R5
  Pop $R4
  Pop $R3
  Pop $R2
  Exch $R1 ; $R1=old$R1, stack=[result,...]
FunctionEnd
!macroend
!insertmacro StrStr ""
!insertmacro StrStr "un."

;CB it appears that this is necessary for new cmd windows etc... to see the changed
;path items.  otherwise you have to completely reboot.
Function BroadcastPathChanges
  DetailPrint "broadcasting registry updates."
  SendMessage ${HWND_BROADCAST} ${WM_WININICHANGE} 0 "STR:Environment" /TIMEOUT=1500
  DetailPrint "Completed."
FunctionEnd

Function un.BroadcastPathChanges
  DetailPrint "broadcasting registry updates."
  SendMessage ${HWND_BROADCAST} ${WM_WININICHANGE} 0 "STR:Environment" /TIMEOUT=1500
  DetailPrint "Completed."
FunctionEnd
