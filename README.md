Runs mullvad vpn in a podman container and provides a socks proxy too.

Download the mullvad deb:
`curl -L -o src/mullvad.deb https://mullvad.net/download/app/deb/latest`

Put a env file named .mullvad_id here like:
`MULLVAD_ID=<your mullvad id>`

Connect to the socks proxy at `socks5://127.0.0.1:42691`
