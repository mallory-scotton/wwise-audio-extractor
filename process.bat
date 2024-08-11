:: Turn off the command echoing, which means that only the final output will be displayed in the command prompt
@echo off
:: Change the current directory to the directory of the batch script
cd /d "%~dp0"
:: Enable the delayed environment variable expansion, which allows variables to be updated within a block of code
setlocal enabledelayedexpansion
:: Set the console mode to have 50 lines and 110 columns
mode con lines=50 cols=110
:: Set the title of the command prompt window
title Automater - BNK to OGG named by Mallow

:: Label the start of the script
:START
:::  _____ _____ _____ _____ _____ _____ _____ _____ _____ _____ _____ _____ _____ _____ _____ _____ _____ _____
:::  \____\\____\\____\\____\\____\\____\\____\\____\\____\\____\\____\\____\\____\\____\\____\\____\\____\\____\
:::
:::                                                                                ,----,
:::                 ,----..            ,--.                                      ,/   .`|
:::    ,----..     /   /   \         ,--.'|                ,---,.,-.----.      ,`   .'  :   ,---,.,-.----.
:::   /   /   \   /   .     :    ,--,:  : |       ,---.  ,'  .' |\    /  \   ;    ;     / ,'  .' |\    /  \
:::  |   :     : .   /   ;.  \,`--.'`|  ' :      /__./|,---.'   |;   :    \.'___,/    ,',---.'   |;   :    \
:::  .   |  ;. /.   ;   /  ` ;|   :  :  | | ,---.;  ; ||   |   .'|   | .\ :|    :     | |   |   .'|   | .\ :
:::  .   ; /--` ;   |  ; \ ; |:   |   \ | :/___/ \  | |:   :  |-,.   : |: |;    |.';  ; :   :  |-,.   : |: |
:::  ;   | ;    |   :  | ; | '|   : '  '; |\   ;  \ ' |:   |  ;/||   |  \ :`----'  |  | :   |  ;/||   |  \ :
:::  |   : |    .   |  ' ' ' :'   ' ;.    ; \   \  \: ||   :   .'|   : .  /    '   :  ; |   :   .'|   : .  /
:::  .   | '___ '   ;  \; /  ||   | | \   |  ;   \  ' .|   |  |-,;   | |  \    |   |  ' |   |  |-,;   | |  \
:::  '   ; : .'| \   \  ',  / '   : |  ; .'   \   \   ''   :  ;/||   | ;\  \   '   :  | '   :  ;/||   | ;\  \
:::  '   | '/  :  ;   :    /  |   | '`--'      \   `  ;|   |    \:   ' | \.'   ;   |.'  |   |    \:   ' | \.'
:::  |   :    /    \   \ .'   '   : |           :   \ ||   :   .':   : :-'     '---'    |   :   .':   : :-'
:::   \   \ .'      `---`     ;   |.'            '---" |   | ,'  |   |.'                |   | ,'  |   |.'
:::    `---`                  '---'                    `----'    `---'                  `----'    `---'
:::
:::                                           Developped by Mallow
:::  _____ _____ _____ _____ _____ _____ _____ _____ _____ _____ _____ _____ _____ _____ _____ _____ _____ _____
:::  \____\\____\\____\\____\\____\\____\\____\\____\\____\\____\\____\\____\\____\\____\\____\\____\\____\\____\
:::
:::
:::  _____ _____ _____ _____ _____ _____ _____ _____ _____ _____ _____ _____ _____ _____ _____ _____ _____ _____
:::  \____\\____\\____\\____\\____\\____\\____\\____\\____\\____\\____\\____\\____\\____\\____\\____\\____\\____\
:::                                              How do use ?
:::     \ Place all your WwiseAudio (.xml, .json, .bnk and .txt) into "banks\"
:::     \ Start the process.bat (this .bat, where you are reading this)
:::     \ Enter the name of your file (Example : I want to extract "Weapon_MP5.bnk", i write "Weapon_MP5")
:::     \ Wait untill the process are running
:::     \ Go in "progress\ended\..." And here we go, your sound bank extracted and renamed !
:::
:::     \ Now say thanks to the developper and smile !
:::  _____ _____ _____ _____ _____ _____ _____ _____ _____ _____ _____ _____ _____ _____ _____ _____ _____ _____
:::  \____\\____\\____\\____\\____\\____\\____\\____\\____\\____\\____\\____\\____\\____\\____\\____\\____\\____\
for /f "delims=: tokens=*" %%A in ('findstr /b ::: "%~f0"') do @echo(%%A
echo.
echo.
echo.
echo.

:: Check if a file name is provided as an argument
if "%~1" == "" (
	:: If not, prompt the user to enter a file name
	set /p "FileName=Wwise sound bank name >   "
) ELSE (
	:: If a file name is provided, set it to the variable FileName
	set "FileName=%~1"
)

:: Check if the .bnk file exists
if not exist "banks\!FileName!.bnk" (
	:: If the file does not exist, display an error message and exit
	echo Error: The system cannot find [!FileName!] file.
	echo.
	timeout /t 3 >nul
	cls
	goto START
)

:: Set the console mode and clear the screen
mode 130,9999
cls

:: Create the progress directory if it does not exist
mkdir "progress" -f

:: Move the .bnk and .txt files to the progress directory
move "banks\!FileName!.bnk" "progress"
move "banks\!FileName!.txt" "progress"

:: Delete the .json and .xml files
del "banks\!FileName!.json"
del "banks\!FileName!.xml"

:: Extract the .bnk file using bnkextr.exe
"bnkextr.exe" "progress\!FileName!.bnk"

:: Move the .wem files to the progress directory
move "*.wem" "progress"

:: Convert the .wem files to .ogg using ww2ogg.exe
pushd "ww2ogg"
for %%a in (..\progress\*.WEM) do ww2ogg.exe %%a --pcb packed_codebooks_aoTuV_603.bin
popd

:: Convert the .ogg files using revorb.exe
pushd "revorb"
for %%a in (..\progress\*.ogg) do revorb.exe %%a
popd

:: Delete the .wem files and the original .bnk file
del "progress\*.WEM"
del "progress\!FileName!.bnk"

:: Process the .txt file
for %%a in (!FileName!.txt) do call:PROCESS "%%a"

:: Delete the _new file and create the 'ended' directory
del "progress\!FileName!_new"
md "progress\ended\!FileName!"

:: Move the .ogg files to the 'ended directory
move "progress\*.ogg" "progress\ended\!FileName!\"

:: Delete the .bak and .txt files
del "progress\*.bak"
del "progress\*.txt"

:: Display a success message and exit
cls
echo.
echo.
echo Process finished.
exit


:: PROCESS subroutine
:PROCESS
set "filename=%~1"
pushd "progress"

:: Create a backup of the .txt file
..\batool.exe h 1
for %%a in (FileNameLines OldFileNameLines NewFileNameLines) do set %%a=0
for /f "tokens=1-4 delims=:.," %%a in ("!time: =0!") do set "FileNameBackup=!FileName!-%%ah-%%bm-%%ds.bak"
copy "!FileName!" "!FileNameBackup!" >nul || call:ERROR_EXIT "Could not create !FileNameBackup! backup. Security is important."

:: TXT_OP_1: Process the .txt file
echo.
set "FileNameTemp=!FileName!.temp"
findstr /ic:".wem" "!FileName!">>"!FileNameTemp!"
for %%a in ("!FileNameTemp!") do if %%~za leq 0 set "FileNameTemp=!FileName!"
for /f "tokens=* delims=" %%a in (!FileNameTemp!) do set /a OldFileNameLines+=1
if exist "!FileName!" (
	findstr /ic:"ID	Name" "!FileName!" >nul 2>&1 && del /f /q "!FileName!"
) else call:ERROR_EXIT "!FileName! doesn't exist."

:: TXT_OP_2: Process the .txt file further
for /f "tokens=2" %%a in (!FileNameTemp!) do echo.%%a>>"!FileName!"
if not exist "!FileName!" call:ERROR_EXIT "!FileName! contain an non-valid database and could not be operated. Please review the created !FileNameBackup! database backup."
if "!FileNameTemp!"=="!FileName!.temp" del /f /q "!FileNameTemp!"
for /f "tokens=* delims=" %%a in (!FileName!) do set /a NewFileNameLines+=1
if !NewFileNameLines! leq 0 (call:ERROR_EXIT "!FileName! is empty.") else (
	title Renaming [!OldFileNameLines!] on [!NewFileNameLines!] lines from [!FileName!] completed successfully.
	echo Renaming [!OldFileNameLines!] on [!NewFileNameLines!] lines from [!FileName!] completed successfully.
)

:: OGG_OP: Rename the .ogg files
echo.
for %%a in (*.ogg) do (
	for /f "tokens=* delims=0" %%b in ("%%a") do set num=%%b
	if exist "%%a" ren "%%a" "!num!"
)
for /f "tokens=* delims=" %%a in (!FileName!) do (
	set /a FileNameLines+=1
	title Renaming file [!FileNameLines!.ogg] to [%%a.ogg] from [!FileName!].
	call:RENAME "!FileNameLines!.ogg" "%%a.ogg"
)
if !FileNameLines! leq 0 (call:ERROR_EXIT "Something went wrong. Exiting...") else (
	title Renaming [!FileNameLines!] files from [!FileName!] completed successfully.
	echo Renaming [!FileNameLines!] files from [!FileName!] completed successfully.
)
echo.
echo press any key to exit . . .
popd
goto:eof


:: RENAME subroutine: Rename a file with a unique number if it already exists
:RENAME
if not exist %2 (
	ren %~1 %~2
	exit /b 0
)
..\batool.exe w 10
set i=0
:_RENAME
set /a i+=1
set "n=%~n2 (%i%).ogg"
if exist "%n%" goto _RENAME
ren %1 "%n%" >nul 2>&1 || echo File seem to be already renamed :^)
exit /b %i%


:: ERROR_EXIT subroutine: Display an error message and exit
:ERROR_EXIT
title Error: %~1
echo Error: %~1
echo.
exit
