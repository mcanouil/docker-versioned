#!/bin/bash
set -e

QUARTO_VERSION=${1:-${QUARTO_VERSION:-"latest"}}

# Only amd64 build can be installed now
ARCH=$(dpkg --print-architecture)

if [ "$ARCH" = "amd64" ]; then
  if [ ! -x "$(command -v wget)" ]; then
    apt-get update && apt-get -y install wget ca-certificates
  fi

  if [ "$QUARTO_VERSION" = "latest" ]; then
    QUARTO_DL_URL=$(wget -qO- https://api.github.com/repos/quarto-dev/quarto-cli/releases/latest | grep -oP "(?<=\"browser_download_url\":\s\")https.*${ARCH}\.deb")
  else
    QUARTO_DL_URL="https://github.com/quarto-dev/quarto-cli/releases/download/v${QUARTO_VERSION}/quarto-${QUARTO_VERSION}-linux-${ARCH}.deb"
  fi
  wget "$QUARTO_DL_URL" -O quarto.deb
  dpkg -i quarto.deb
  rm quarto.deb

  quarto check install
fi

# Clean up
apt-get autoremove -y
apt-get autoclean -y
rm -rf /var/lib/apt/lists/*
rm -rf /tmp/*

strip /usr/local/lib/R/site-library/*/libs/*.so
