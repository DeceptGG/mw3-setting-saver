@echo off
title MW3 Settings Saver

set "playersDir=%USERPROFILE%\Documents\Call of Duty\players"

set "apiUrl=https://deception.gg/steam-api-resolver.php"

set "filesToCopy=keybinds.cod23.cbd settingspresets.cdb colorpreset.cdb favoritesettings.cdb"

echo Please enter the Steam ID of the main account:
set /p "mainSteamId=Steam ID: "

if not exist "%playersDir%\%mainSteamId%" (
    echo !Error! Main account directory not found: %playersDir%\%mainSteamId%
    pause
    exit /b
)

for /f "delims=" %%u in ('powershell -command "(Invoke-WebRequest -Uri '%apiUrl%?steamuser=%mainSteamId%').Content"') do (
    set "mainUsername=%%u"
)
echo Main account username: %mainUsername%

echo Copying files from %mainSteamId% to smurf accounts...
for /d %%D in ("%playersDir%\*") do (
    set "smurfSteamId=%%~nD"
    
    if /i not "!smurfSteamId!"=="%mainSteamId%" (
        echo Checking smurf account: !smurfSteamId!

        for /f "delims=" %%u in ('powershell -command "(Invoke-WebRequest -Uri '%apiUrl%?steamuser=!smurfSteamId!').Content"') do (
            set "smurfUsername=%%u"
        )
        
        echo Smurf account username: !smurfUsername!
        
        echo Copying files to smurf account: !smurfSteamId!
        for %%F in (%filesToCopy%) do (
            if exist "%playersDir%\%mainSteamId%\%%F" (
                copy /Y "%playersDir%\%mainSteamId%\%%F" "%%D\%%F"
                echo Copied %%F to %%D
            ) else (
                echo File not found: %playersDir%\%mainSteamId%\%%F
            )
        )
    )
)

echo All files copied successfully!
pause
