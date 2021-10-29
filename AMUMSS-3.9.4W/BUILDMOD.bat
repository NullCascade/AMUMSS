@echo off
SETLOCAL EnableDelayedExpansion ENABLEEXTENSIONS

set _mOK=Y

rem https://stackoverflow.com/questions/3973824/windows-bat-file-optional-argument-parsing/8162578#8162578
rem let us set default options value here
rem the order of definition is irrelevant

rem these defaults can be overridden by calling like: BUILDMOD.bat -CombineModPak N -CopyToGamefolder NONE
rem     USE BUILDMOD_AUTO.bat for easy control of the OPTIONS (OR BETTER YET: USE AMUMSS GUI interface)

rem     SEE 'README - OPTIONS DEFINITIONS.txt' for OPTION definitions

rem  >>>>>>>>>>>>>>  DO NOT EVER MODIFY THIS LINE BELOW, modify BUILDMOD_AUTO.bat instead  <<<<<<<<<<<<<<<<<<
set "options=-AutoUpdateMBinCompiler:"Y" -CheckForModConflicts:"Y" -CombinedModType:"ASK" -CombineModPak:"ASK" -CopyToGamefolder:"ASK" -IncludeLuaScriptInPak:"Y" -IndividualModPakType:"P" -MAPFILETREE:"LUA" -MAPFILETREEFORCE:"N" -ReCreateMapFileTree:"N" -RecreatePAKList:"N" -SerializeScript:"N" -SHOWEXTRASECTIONS:"N" -SHOWOPTIONS:"N" -SHOWSECTIONS:"Y" -UseColors:"Y" -UseExtraFilesInPAK:"ASK" -UseLuaScriptInPak:"ASK""
rem  >>>>>>>>>>>>>>  DO NOT EVER MODIFY THIS LINE ABOVE, modify BUILDMOD_AUTO.bat instead  <<<<<<<<<<<<<<<<<<

for %%O in (%options%) do (for /f "tokens=1,* delims=:" %%A in ("%%O") do (set "%%A=%%~B"))
:loop
if not "%~1"=="" (
  set "test=!options:*%~1:=! "
  if "!test!"=="!options! " (
      echo. Error: Invalid option %~1
  ) else if "!test:~0,1!"==" " (
      set "%~1=1"
  ) else (
      setlocal disableDelayedExpansion
      set "val=%~2"
      call :escapeVal
      setlocal enableDelayedExpansion
	  CALL :UCase val val
      for /f delims^=^ eol^= %%A in ("!val!") do endlocal&endlocal&set "%~1=%%A" !
      shift /1
  )
  shift /1
  goto :loop
)
goto :endArgs

:escapeVal
set "val=%val:^=^^%"
set "val=%val:!=^!%"
exit /b

:endArgs

if [%-SHOWOPTIONS%]==[Y] (
	set -
	echo.
)

rem To get the value of a single parameter, just remember to include the `-`
REM echo The value of -CopyToGamefolder is: !-CopyToGamefolder!
REM pause

if [%-UseColors%]==[N] goto :SKIP_COLORS

REM enable color output
rem NOT USED, won't work on win 7, use ansicon.exe
rem reg add HKEY_CURRENT_USER\Console /v VirtualTerminalLevel /t REG_DWORD /d 0x00000001 /f 1>NUL 2>NUL

.\MODBUILDER\ansicon_x64\ansicon.exe -p 1>NUL 2>NUL

set _zRED=[1;31m[1m
set _zGREEN=[1;32m[1m
set _zYELLOW=[1;33m[1m
set _zDARKGRAY=[1;90m[1m

set _zWHITEonYELLOW=[93;43m[1m
set _zBLACKonYELLOW=[7;93m

set _zINVERSE=[7m
set _zDEFAULT=[0m

set _zUpOneLineErase=[F[K
rem end For win 7 to use colors also

:SKIP_COLORS
Del /f /q /s "log.txt" 1>NUL 2>NUL

REM for testing
REM Test_Basic.bat 2>&1 | MODBUILDER\wtee.exe log.txt

REM echo. ^>^>^> Running bzrun.bat
bzrun.bat 2>&1 | MODBUILDER\wtee.exe log.txt

goto :eof
rem *****************************************************************************************
rem               --------------------- WE ARE DONE ---------------------
rem *****************************************************************************************

rem --------------------------------------------
rem subroutine section starts below

rem --------------------------------------------
rem https://www.robvanderwoude.com/battech_convertcase.php
:LCase
:UCase
	:: Converts to upper/lower case variable contents
	:: Syntax: CALL :UCase _VAR1 _VAR2
	:: Syntax: CALL :LCase _VAR1 _VAR2
	:: _VAR1 = Variable NAME whose VALUE is to be converted to upper/lower case
	:: _VAR2 = NAME of variable to hold the converted value
	:: Note: Use variable NAMES in the CALL, not values (pass "by reference")

	SET _UCase=A B C D E F G H I J K L M N O P Q R S T U V W X Y Z
	REM SET _LCase=a b c d e f g h i j k l m n o p q r s t u v w x y z
	SET _Lib_UCase_Tmp=!%1!
	IF /I "%0"==":UCase" SET _Abet=%_UCase%
	REM IF /I "%0"==":LCase" SET _Abet=%_LCase%
	FOR %%Z IN (%_Abet%) DO SET _Lib_UCase_Tmp=!_Lib_UCase_Tmp:%%Z=%%Z!
	SET %2=%_Lib_UCase_Tmp%
	exit /b
