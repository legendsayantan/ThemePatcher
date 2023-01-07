@ECHO OFF
SETLOCAL enableDelayedExpansion
echo.
echo ---------------------------------------------------------------------
echo --------------- Welcome to Oppo-Realme Theme patcher! ----------------
echo ----------------------------------------------------by legendsayantan
echo.
echo Take a free trial from theme store, then run this script to make them permanent :)
echo.
set ADB=adb.exe
FOR /F %%x IN ('tasklist /NH /FI "IMAGENAME eq %ADB%"') DO IF %%x == %ADB% (
  adb kill-server
)
adb start-server
IF %ERRORLEVEL% NEQ 0 (
    ECHO ERROR - adb.exe not found. Try to redownload ThemePatcher from https://github.com/legendsayantan/ThemePatcher
    color c
    PAUSE
    exit
)
echo.
adb reconnect >tempfile.tmp
set /p device=<tempfile.tmp
set nodevice=no devices/emulators found
set multidevice=more than one device/emulator
IF "%device%" EQU "%multidevice%" (
ECHO ERROR - More than one android devices are connected. Disconnect them or turn off usb debugging.
echo 0 >tempfile.tmp
del tempfile.tmp
color c
)
IF "%device%" EQU "%nodevice%" (
ECHO ERROR - No android devices are connected. Make sure you have usb debugging turned on.
echo 0 >tempfile.tmp
del tempfile.tmp
color c
) ELSE (
color e
)
echo.
echo Looking for android devices on USB...
adb wait-for-device shell settings get secure oppo_device_name >tempfile.tmp
echo.
set /p deviceName=<tempfile.tmp
IF "%deviceName%" NEQ "%nullT%" (
    echo Successfully connected to %deviceName%.
color b
) ELSE (
echo Warning - This device may be incompatible. Still trying to patch...
color 3
)
adb shell am force-stop com.heytap.themestore
adb shell am force-stop com.nearme.themestore
echo.
adb shell settings get system persist.sys.trial.theme >tempfile.tmp
set /p theme=<tempfile.tmp
adb shell settings get system persist.sys.trial.font >tempfile.tmp
set /p font=<tempfile.tmp
adb shell settings get system persist.sys.trial.live_wp >tempfile.tmp
set /p livewp=<tempfile.tmp
adb shell settings get system current_wallpaper_name >tempfile.tmp
set /p themeName=<tempfile.tmp
for /f "tokens=1 delims=;" %%G in ("%themeName%") DO echo %%G>tempfile.tmp
set /p themeName=<tempfile.tmp
echo %themeName:InnerTheme:= %>tempfile.tmp
set /p themeName=<tempfile.tmp
echo %themeName:  = %>tempfile.tmp
set /p themeName=<tempfile.tmp
adb shell settings get system current_typeface_name >tempfile.tmp
set /p fontName=<tempfile.tmp
echo 0 >tempfile.tmp
del tempfile.tmp
echo Installed Theme :%themeName%
IF %theme% NEQ 0 (
echo Theme Status : Trial
adb shell settings put system persist.sys.oppo.theme_uuid -1 ; echo $? >tempfile.tmp
set /p val=<tempfile.tmp
IF !val! NEQ 0 (
    echo 0 >tempfile.tmp
    del tempfile.tmp
    echo.
    ECHO ERROR - Make sure to Disable Permission Monitoring in Developer Options.
    color c
    echo.
    adb kill-server
    PAUSE
    exit
) ELSE (
adb shell settings put system persist.sys.oplus.theme_uuid -1
adb shell settings put system persist.sys.trial.theme 0
adb shell settings put secure persist.sys.oppo.theme_uuid -1
adb shell settings put secure persist.sys.oplus.theme_uuid -1
adb shell settings put secure persist.sys.trial.theme 0
color a
ECHO Successfully converted to permanent.
)
) ELSE (echo Theme Status : Permanent)
echo.
echo Installed Font : %fontName% 
IF %font% NEQ 0 (
echo Font Status : Trial
adb shell settings put system persist.sys.trial.font 0 ; echo $? >tempfile.tmp
set /p val=<tempfile.tmp
IF !val! NEQ 0 (
    echo 0 >tempfile.tmp
    del tempfile.tmp
    echo.
    ECHO ERROR - Make sure to Disable Permission Monitoring in Developer Options.
    color c
    echo.
    adb kill-server
    PAUSE
    exit
) ELSE (
adb shell settings put secure persist.sys.trial.font 0
color a
ECHO Successfully converted to permanent.
)
) ELSE (echo Font Status : Permanent )
echo.
IF %livewp% NEQ 0 (
echo Live Wallpaper Status : Trial
adb shell settings put system persist.sys.oplus.live_wp_uuid default_live_wp_package_name ; echo $? >tempfile.tmp
set /p val=<tempfile.tmp
IF !val! NEQ 0 (
    echo 0 >tempfile.tmp
    del tempfile.tmp
    echo.
    ECHO ERROR - Make sure to Disable Permission Monitoring in Developer Options.
    color c
    echo.
    adb kill-server
    PAUSE
    exit
) ELSE (
adb shell settings put system persist.sys.oppo.live_wp_uuid -1
adb shell settings put system persist.sys.trial.live_wp 0
adb shell settings put secure persist.sys.oplus.live_wp_uuid default_live_wp_package_name
adb shell settings put secure persist.sys.oppo.live_wp_uuid -1
adb shell settings put secure persist.sys.trial.live_wp 0
color a
ECHO Successfully converted to permanent.
)
) ELSE (echo Live Wallpaper Status : Permanent)
echo 0 >tempfile.tmp
del tempfile.tmp
adb kill-server
echo.
PAUSE