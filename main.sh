#!/bin/bash

# ~~~ EaglercraftX 1.12 Server

unset DISPLAY

echo "set -g mouse on" > ~/.tmux.conf

tmux kill-session -t server
tmux kill-session -t placeholder

BASEDIR="$PWD"

FORCE1="nah"

JAVA11="$(command -v javac)"
JAVA11="${JAVA11%?}"

export GIT_TERMINAL_PROMPT=0

if [ ! -d "eaglercraftx" ]; then
  rm client_version
  rm gateway_version
  FORCE1="bruh"
fi


# reset stuff
if [ -f "base.repl" ] && ! { [ "$REPL_OWNER" == "catfoolyou" ] && [ "$REPL_SLUG" == "eaglercraftx" ]; }; then
  rm base.repl
  rm -rf server/world
  rm -rf server/world_nether
  rm -rf server/world_the_end
  rm -rf server/logs
  rm -rf server/plugins/PluginMetrics
  rm -f server/usercache.json
  rm -rf cuberite
  rm -rf bungee/logs
  rm -f bungee/eaglercraft_skins_cache.db
  rm -f bungee/eaglercraft_auths.db
  sed -i '/^stats: /d' bungee/config.yml
  sed -i "s/^server_uuid: .*\$/server_uuid: $(cat /proc/sys/kernel/random/uuid)/" bungee/plugins/EaglercraftXBungee/settings.yml
  rm -f /tmp/mcp918.zip
  rm -f /tmp/1.8.8.jar
  rm -f /tmp/1.8.json
  chmod +x selsrv.sh
  ./selsrv.sh
fi

rm -rf /tmp/##EAGLER.TEMP##
rm -rf /tmp/teavm
rm -rf /tmp/output

mkdir -p bungee/plugins

# update waterfall!!
cd ../bungee
rm bungee-new.jar
WF_VERSION="`curl -s \"https://papermc.io/api/v2/projects/waterfall\" | jq -r \".version_groups[-1]\"`"
WF_BUILDS="`curl -s \"https://papermc.io/api/v2/projects/waterfall/versions/1.12/builds\"`"
WF_SHA256="`echo $WF_BUILDS | jq -r \".builds[-1].downloads.application.sha256\"`"
echo "$WF_SHA256 bungee.jar" | sha256sum --check
retVal=$?
if [ $retVal -ne 0 ]; then
  wget -O bungee-new.jar "`echo $WF_BUILDS | jq -r \".builds[-1]|\\\"https://papermc.io/api/v2/projects/waterfall/versions/1.12/builds/\\\"+(.build|tostring)+\\\"/downloads/\\\"+.downloads.application.name\"`"
  if [ -f "bungee-new.jar" ]; then
    rm bungee.jar
    mv bungee-new.jar bungee.jar
  fi
fi
cd ..

# run it!!
cd bungee
tmux new -d -s server "java -Xmx128M -jar bungee.jar; tmux kill-session -t server"
cd ../server
tmux splitw -t server -v "java -Djline.terminal=jline.UnsupportedTerminal -Xmx512M -jar server.jar nogui; tmux kill-session -t server"
cd ..
while tmux has-session -t server
do
  tmux a -t server
done
