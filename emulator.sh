#!/usr/bin/env bash

set -eu

# start android emulator
START=`date +%s` > /dev/null

echo no | ./avdmanager create avd --force -n test -k "system-images;android-22;google_apis;armeabi-v7a" 
cd $ANDROID_HOME/emulator  
./emulator -list-avds
./emulator @test -no-window -no-audio -partition-size 800 -verbose &
wait-for-emulator

DURATION=$(( `date +%s` - START )) > /dev/null
echo "Android Emulator started after $DURATION seconds."

# emulator isn't ready yet, wait 1 min more
# prevents APK installation error
sleep 60

