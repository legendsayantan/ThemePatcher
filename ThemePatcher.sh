#!/bin/sh
echo
echo "----------------------------------------------------------------------"
echo "--------------- Welcome to Oppo-Realme Theme patcher! ----------------"
echo "-----------------------------------------------------by legendsayantan"
echo
echo "Take a free trial from theme store, then run this script to make them permanent :)"
echo

ADB="adb"
for x in $(pgrep adb); do
  adb kill-server
done
adb start-server
if [ $? -ne 0 ]; then
  echo "ERROR - adb not found. Check if adb is in path. Try to redownload ThemePatcher from https://github.com/legendsayantan/ThemePatcher"
fi
echo
adb reconnect >tempfile.tmp
device=`cat tempfile.tmp`
nodevice="no devices/emulators found"
multidevice="more than one device/emulator"
if [ "$device" = "$multidevice" ]; then
  echo "ERROR - More than one android devices are connected. Disconnect them or turn off usb debugging."
  echo 0 >tempfile.tmp
  rm -f tempfile.tmp
  exit 1
fi
if [ "$device" = "$nodevice" ]; then
  echo "ERROR - No android devices are connected. Make sure you have usb debugging turned on."
  echo 0 >tempfile.tmp
  rm -f tempfile.tmp
fi
echo
echo "Looking for android devices on USB..."
adb wait-for-device shell settings get secure oppo_device_name >tempfile.tmp
echo
deviceName=`cat tempfile.tmp`
if [ $deviceName != "null" ]; then
  echo "Successfully connected to $deviceName"
else
  echo "Warning - This device may be incompatible. Still trying to patch..."
fi
adb shell am force-stop com.heytap.themestore
adb shell am force-stop com.nearme.themestore
echo
adb shell settings get system persist.sys.trial.theme >tempfile.tmp
theme=`cat tempfile.tmp`
adb shell settings get system persist.sys.trial.font >tempfile.tmp
font=`cat tempfile.tmp`
adb shell settings get system persist.sys.trial.live_wp >tempfile.tmp
livewp=`cat tempfile.tmp`
adb shell settings get system current_wallpaper_name >tempfile.tmp
themeName=`cat tempfile.tmp | cut -f1 -d ";" | cut -f2 -d ":" | xargs`
adb shell settings get system current_typeface_name >tempfile.tmp
fontName=`cat tempfile.tmp`
echo 0 >tempfile.tmp
rm -f tempfile.tmp
echo "Installed Theme: $themeName"
if [ $theme -ne 0 ]; then
  echo "Theme Status : Trial"
  adb shell settings put system persist.sys.oppo.theme_uuid -1
  if [ $? -ne 0 ]; then
    rm -f tempfile.tmp
    echo
    echo "ERROR - Make sure to Disable Permission Monitoring in Developer Options."
    echo
    exit 1
  else
    adb shell settings put system persist.sys.oplus.theme_uuid -1
    adb shell settings put system persist.sys.trial.theme 0
    adb shell settings put secure persist.sys.oppo.theme_uuid -1
    adb shell settings put secure persist.sys.oplus.theme_uuid -1
    adb shell settings put secure persist.sys.trial.theme 0
    echo "Successfully converted to permanent."
  fi
else
  echo "Theme Status : Permanent"
fi
echo
echo "Installed Font : $fontName"
if [ $font -ne 0 ]; then
  echo "Font Status : Trial"
  adb shell settings put system persist.sys.trial.font 0
  if [ $? -ne 0 ]; then
    rm -f tempfile.tmp
    echo
    echo "ERROR - Make sure to Disable Permission Monitoring in Developer Options."
    echo
    exit 1
  else
    adb shell settings put secure persist.sys.trial.font 0
    echo "Successfully converted to permanent."
  fi
else
  echo "Font Status : Permanent"
fi
echo
if [ $livewp -ne 0 ]; then
  echo "Live Wallpaper Status : Trial"
  adb shell settings put system persist.sys.oplus.live_wp_uuid default_live_wp_package_name
  if [ $? -ne 0 ]; then
    rm -f tempfile.tmp
    echo
    echo "ERROR - Make sure to Disable Permission Monitoring in Developer Options."
    echo
    exit 1
  else
    adb shell settings put system persist.sys.oppo.live_wp_uuid -1
    adb shell settings put system persist.sys.trial.live_wp 0
    adb shell settings put secure persist.sys.oplus.live_wp_uuid default_live_wp_package_name
    adb shell settings put secure persist.sys.oppo.live_wp_uuid -1
    adb shell settings put secure persist.sys.trial.live_wp 0
    echo "Successfully converted to permanent."
  fi
else
  echo "Live Wallpaper Status : Permanent"
fi
rm -f tempfile.tmp
adb kill-server
echo