function syncthing-n1-server-start() {
    # docker run -it -dp 8384:8384 \
    #     --name syncthing-n1 \
    #     --mount type=bind,source=/Users/Neruthes/Network/Syncthing/Neruthes-Syncthing-N1,target=/var/syncthing/Neruthes-Syncthing-N1,consistency=consistent \
    #     syncthing/syncthing
    docker start syncthing-n1
}

function syncthing-n1-server-halt() {
    docker stop syncthing-n1
}
