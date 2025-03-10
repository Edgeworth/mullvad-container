alias r := run
alias b := build

default:
  @just --list

run country="us" city="" ip="10.88.0.42" *args="":
  sh -c "sleep 10; sudo podman exec -it mullvad-container-instance mullvad reconnect" &
  sudo podman run -ti --env MULLVAD_COUNTRY={{country}} --env MULLVAD_CITY={{city}} \
    --env-file .mullvad_id --privileged -p 42691:1080 -v mullvad_config:/config \
    --ip {{ip}} --replace --name mullvad-container-instance mullvad-container

connect:
  # Make sure connection works.
  sudo podman exec -it mullvad-container-instance mullvad connect

reconnect:
  sudo podman exec -it mullvad-container-instance mullvad reconnect

build:
  sudo podman build -t mullvad-container src

shell:
  sudo podman exec -it mullvad-container-instance /bin/bash

remove-all-podman:
  sudo podman rm -a
  sudo podman rmi -a

update:
  rm -f src/mullvad.deb
  curl -L -o src/mullvad.deb https://mullvad.net/download/app/deb/latest
