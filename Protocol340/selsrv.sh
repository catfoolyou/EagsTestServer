#!/bin/bash
SRV=$(dialog --menu "Choose a server software:\n(or cancel for no change)\nUse arrow keys and enter to select:" 12 40 3 1 "Paper 1.12 (recommended)" --output-fd 1)

clear

case $SRV in
  1)
    echo "Switching to Paper 1.12..."
    rm /tmp/server.jar
    cp misc/paper-1.12-1169.jar /tmp/server.jar
    rm server/plugins/Carbon.jar
    rm server/plugins/Carbon-ProtocolLib.jar
    ;;


  *)
    echo "Not changing server software..."
    exit
    ;;
esac

if [ -f "/tmp/server.jar" ]; then
  rm server/server.jar
  mv /tmp/server.jar server/server.jar
fi
