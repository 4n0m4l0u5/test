#!/bin/bash
#
# This file shall be executed on a clean Ubuntu 16.04 machine with Internet access
# This file will download and install puppet and its dependancies

sudo apt update && sudo apt upgrade -y
wget https://apt.puppetlabs.com/puppet5-release-xenial.deb
sudo dpkg -i puppet5-release-xenial.deb

sudo apt update && sudo apt install puppetserver -y && sudo apt autoclean -y

sudo systemctl enable puppetserver
sudo systemctl start puppetserver

sudo apt-get install ruby-full -y

sudo /opt/puppetlabs/puppet/bin/gem install aws-sdk retries

echo export PATH=/opt/puppetlabs/bin:$PATH >> ~/.bashrc
source .bashrc

#change install directory here?????
puppet module install puppetlabs-aws

mkdir ~/.aws
echo [default] >> ~/.aws/credentials
echo aws_access_key_id = your_access_key_id >> ~/.aws/credentials
echo aws_secret_access_key = your_secret_access_key >> ~/.aws/credentials

#setup environment variables
echo export AWS_REGION=us-east-1 >> ~/.bashrc
#if proxy is used setup with line below before execution of this script:
#echo export PUPPET_AWS_PROXY=http://localhost:8888 >> ~/.bashrc
source .bashrc

puppet apply deploy-infra/deploy.pp
