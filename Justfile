alias r := run
alias b := build

default:
  @just --list

run country="us" city="" ip="10.88.0.42" *args="":
  # Run as privileged. Expose the socks proxy 10.64.0.1:1080 at 42691.
  sudo podman run --env MULLVAD_COUNTRY={{country}} --env MULLVAD_CITY={{city}} \
    --env-file .mullvad_id --privileged -p 42691:1080 -v mullvad_config:/config \
    --ip {{ip}} --replace --name mullvad-container-instance -ti mullvad-container
  sleep 2
  # Make sure connection works.
  sudo podman exec -it mullvad-container-instance mullvad connect

build:
  sudo podman build -t mullvad-container src

shell:
  sudo podman exec -it mullvad-container-instance /bin/bash

remove-all-podman:
  sudo podman rm -a
  sudo podman rmi -a

update-mullvad:
  rm src/mullvad.deb
  curl -L -o src/mullvad.deb https://mullvad.net/download/app/deb/latest
