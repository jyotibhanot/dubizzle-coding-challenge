#!/bin/bash -v
set -ex
sudo apt-get update -y 
sudo apt-get install python-minimal -y
sudo apt-get install ansible -y
git clone https://github.com/jyotibhanot30/clusterstorm.git coding-challenge
