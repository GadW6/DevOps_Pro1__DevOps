#!/bin/sh

set -e

echo "Installing Plugins ..." 
packer init pkr/common.pkr.hcl
echo "Plugins Installed !"

echo "Validating ..." 
packer validate pkr/
echo "Templates are valid !"

echo "Building ..." 
packer build -timestamp-ui -machine-readable pkr/
echo "Build completed !"
