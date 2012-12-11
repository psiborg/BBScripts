#!/bin/sh

# Usage: pb.sh [. | path] [dirname] [ipaddr | usb] [password] [build | install] [debug | signed]

sdkpath="/Developer/SDKs/Research In Motion/BlackBerry WebWorks SDK for TabletOS 2.2.0.5"
keystorepassword="YOUR_KEYSTORE_PASSWORD"

apppath="$1"
appname="$2"
deviceip="169.254.0.1"
devicepassword="$4"
action="$5"
buildtype="$6"

if [ "$3" != "usb" ]
then
	deviceip="$3"
fi

# Generate zip file
echo
echo "---[ Generating zip file... ]-------------------------------------------------"
echo

cd ~/Sites/webworks/"$apppath"/"$appname"
zip -r ~/Sites/webworks/bin/"$appname".zip * -x ".DS_Store"

# Generate bar file
echo
echo "---[ Generating bar file... ]-------------------------------------------------"
echo

cd "$sdkpath"/bbwp
if [ "$buildtype" == "signed" ]
then
	./bbwp ~/Sites/webworks/bin/"$appname".zip -g "$keystorepassword" -buildId 1 -d -o ~/Sites/webworks/bin/pb
else
	./bbwp ~/Sites/webworks/bin/"$appname".zip -d -o ~/Sites/webworks/bin/pb
fi

# Install bar file
echo
echo "---[ Installing bar file... ]-------------------------------------------------"
echo

cd "$sdkpath"/bbwp/blackberry-tablet-sdk/bin
./blackberry-deploy -installApp -password "$devicepassword" -device "$deviceip" -package ~/Sites/webworks/bin/pb/"$appname".bar

echo
echo "*** DONE ***"
echo
