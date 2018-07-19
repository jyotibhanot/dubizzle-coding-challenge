#!/bin/bash -v
set -ex
sudo apt-get update -y
sudo apt-get install python-minimal -y
git clone https://github.com/jyotibhanot30/clusterstorm.git coding-challenge
