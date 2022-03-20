@ECHO OFF
echo -----------------------------------------------
echo -----Welcome to Oppo-Realme Theme patcher!-----
echo -----------------------------------------------
echo Take a free trial from theme store, then run this batch file to make them permanent :)
echo.
echo using && WHERE adb
IF %ERRORLEVEL% NEQ 0 (
ECHO ERROR ENCOUNTERED- Please put this bat file in ADB directory of your system.
PAUSE
exit
)
echo.
adb reconnect >tempfile.tmp
set /p device=<tempfile.tmp
set nodevice=no devices/emulators found
set multidevice=more than one device/emulator
IF "%device%" EQU "%multidevice%" (
ECHO ERROR ENCOUNTERED- More than one android devices are connected through adb.
PAUSE
exit
)
IF "%device%" EQU "%nodevice%" (
ECHO ERROR ENCOUNTERED- No android devices are connected through adb.
PAUSE
exit
) ELSE (echo Please wait , connecting to android device...)
timeout /t 10 /nobreak
adb shell am force-stop com.heytap.themestore
adb shell am force-stop com.nearme.themestore
echo.
adb shell settings get system persist.sys.trial.theme >tempfile.tmp
set /p theme=<tempfile.tmp
adb shell settings get system persist.sys.trial.font >tempfile.tmp
set /p font=<tempfile.tmp
adb shell settings get system persist.sys.trial.live_wp >tempfile.tmp
set /p livewp=<tempfile.tmp
del tempfile.tmp
IF %theme% NEQ 0 (
echo Trial theme detected , converting to permanent...
adb shell settings put system persist.sys.oppo.theme_uuid -1
adb shell settings put system persist.sys.oplus.theme_uuid -1
adb shell settings put system persist.sys.trial.theme 0
adb shell settings put secure persist.sys.oppo.theme_uuid -1
adb shell settings put secure persist.sys.oplus.theme_uuid -1
adb shell settings put secure persist.sys.trial.theme 0
) ELSE (echo No Theme trials activated to patch.)
IF %font% NEQ 0 (
echo Trial font detected , converting to permanent...
adb shell settings put system persist.sys.trial.font 0
adb shell settings put secure persist.sys.trial.font 0
) ELSE (echo No Font trials activated to patch.)
IF %livewp% NEQ 0 (
echo Trial live wallpaper detected , converting to permanent...
adb shell settings put system persist.sys.oplus.live_wp_uuid default_live_wp_package_name
adb shell settings put system persist.sys.oppo.live_wp_uuid -1
adb shell settings put system persist.sys.trial.live_wp 0
adb shell settings put secure persist.sys.oplus.live_wp_uuid default_live_wp_package_name
adb shell settings put secure persist.sys.oppo.live_wp_uuid -1
adb shell settings put secure persist.sys.trial.live_wp 0
) ELSE (echo No Live wallpaper trials activated to patch.)
echo.
echo authored by LegendSayantan.
echo.
PAUSE