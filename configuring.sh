# Cloned the VROOM repo to my computer
git clone https://github.com/VROOM-Project/vroom.git
cd vroom/src
git submodule init
git submodule update

# installed some dependencies
brew install llvm pkg-config

# installing docker
brew install --cask docker

# opening and checking Docker
open /Applications/Docker.app
docker version

# running Vroom in Docker
cd ~/Desktop/DSAN_5550/Final\ Project/vroom
docker pull ghcr.io/vroom-project/vroom-docker:latest
docker run -it -v "$(pwd)":/vroom arm64v8/ubuntu:22.04 bash
apt update
apt install -y build-essential cmake git libasio-dev libssl-dev libglpk-dev pkg-config
cd /vroom/src
exit
cd ~/Desktop/DSAN_5550/Final\ Project
docker run -it -v "$(pwd)/vroom":/vroom arm64v8/ubuntu:22.04 bash
cd /vroom/
exit
cd ~/Desktop/DSAN_5550/Final\ Project
docker run -it -v "$(pwd)":/workspace arm64v8/ubuntu:22.04 bash
cd /workspace/vroom
apt update && apt install -y build-essential cmake git libasio-dev libssl-dev libglpk-dev pkg-config
git submodule update --init --recursive
cd src
apt update
apt install -y g++-13
