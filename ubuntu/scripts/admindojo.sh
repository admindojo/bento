#!/bin/sh -ux

# allow password login
sed -i 's/ChallengeResponseAuthentication no/ChallengeResponseAuthentication yes/g' /etc/ssh/sshd_config
sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
service ssh restart

REQUIREMENTS="git"
apt-get install -y -q --no-install-recommends $REQUIREMENTS

# install inspec dependencies
apt-get install -y ruby
apt-get install -y ruby-dev

#compile inspec locally
#still not licence compliant >v.4 - don't use it until resolved.
#cd /tmp
#git clone https://github.com/inspec/inspec.git
#cd inspec
#
#
#gem build inspec.gemspec
#gem install inspec-*.gem --no-document
#
#cd inspec-bin
#gem build inspec-bin.gemspec
#gem install inspec-bin-*.gem --no-document

wget -O /tmp/install.sh https://omnitruck.chef.io/install.sh
# fix inspec version <4 due to license change!
bash /tmp/install.sh -P inspec -v 3.9.3

# install tuptime for detailed uptime
cd /tmp
git clone https://github.com/rfrail3/tuptime.git
cd tuptime
bash tuptime-install.sh


# remove banner
rm --interactive=never -rf /etc/update-motd.d/50-motd-news
rm --interactive=never -rf /etc/update-motd.d/80-livepatch
rm --interactive=never -rf /etc/update-motd.d/51-cloudguest
rm --interactive=never -rf /etc/update-motd.d/80-esm
rm --interactive=never -rf /etc/update-motd.d/95-hwe-eol
rm --interactive=never -rf /etc/update-motd.d/91-release-upgrade
rm --interactive=never -rf /etc/update-motd.d/10-help-text


# install admindojo
apt-get install -y python3-pip
python3 -m pip install --upgrade pip
python3 -m pip install --upgrade admindojo

## add admindojo to PATH
echo 'PATH=$PATH:/home/vagrant/.local/bin/'>>/home/vagrant/.bashrc

