#!/bin/bash

set -xe

echo "Running daemon"
export MULLVAD_SETTINGS_DIR=/config
/usr/bin/mullvad-daemon -v &

# Sleep for a bit to let the daemon start up
sleep 5
mullvad relay set tunnel-protocol wireguard
mullvad lockdown-mode set on
mullvad lan set allow
mullvad auto-connect set on

echo "Using ID: $MULLVAD_ID, country: $MULLVAD_COUNTRY, city: $MULLVAD_CITY"
mullvad account login $MULLVAD_ID  && \
mullvad relay set location $MULLVAD_COUNTRY $MULLVAD_CITY && \
mullvad connect

# Redirect traffic incoming on 1080 to the mullvad socks proxy.
socat TCP-LISTEN:1080,fork TCP:10.64.0.1:1080 &

wait
