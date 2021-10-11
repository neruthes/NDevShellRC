#!/bin/bash

if [[ "$HOSTNAME" != "NDLT6" ]]; then
    echo "Not NDLT6!"
    exit 1
fi

# source $DEV_HOME_DIR/NDevShellRC/dev-spec/cat-desktop.sh

### ----------------------------------------------------------------------------
### Data backup operations
function NDLT6--Docker--Gentoo() {
    # Networking documentation: https://docs.docker.com/network/bridge/

    # NDLT6-Gentoo-003
    docker create -v /usr/portage --name myportagesnapshot gentoo/portage:latest /bin/true
    docker run --interactive --tty --volumes-from myportagesnapshot gentoo/stage3-amd64:latest /bin/bash
    docker exec -it NDLT6-Gentoo-003 /bin/bash
}
