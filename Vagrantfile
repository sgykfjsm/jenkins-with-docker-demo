# -*- mode: ruby -*-
# vi: set ft=ruby :

$script = <<SCRIPT
set -x

# Change JP Repositoy
sed -i".bk" -e \
        "s|http://security.ubuntu.com/ubuntu|http://ftp.jaist.ac.jp/pub/Linux/ubuntu/|g" \
        /etc/apt/sources.list

bash -c 'echo LC_ALL="en_US.UTF-8" >> /etc/default/locale'

wget -q -O - http://pkg.jenkins-ci.org/debian/jenkins-ci.org.key | apt-key add -
sh -c 'echo deb http://pkg.jenkins-ci.org/debian binary/ > /etc/apt/sources.list.d/jenkins.list'
apt-get -q update
apt-get -y upgrade

# Install Jenkins
useradd -u 45678 -g 65534 -m -d /var/lib/jenkins -s /bin/bash jenkins
apt-get -y install \
         jenkins \
         build-essential wget curl git-core jq

# Install Docker
wget -qO- https://get.docker.com/ | sh

adduser vagrant docker
adduser jenkins docker
service docker restart

# Install jenkins plugins
cat <<EOL | su jenkins -c "xargs -P 5 -n 1 wget -nv -T 60 -t 3 -P /var/lib/jenkins/plugins"
https://updates.jenkins-ci.org/download/plugins/git-client/1.4.6/git-client.hpi
https://updates.jenkins-ci.org/download/plugins/git/2.0/git.hpi
https://updates.jenkins-ci.org/download/plugins/scm-api/0.2/scm-api.hpi
https://updates.jenkins-ci.org/download/plugins/ansicolor/0.3.1/ansicolor.hpi
EOL

# Setup jenkins jobs
su jenkins -c "cp -R /vagrant/jobs/* /var/lib/jenkins/jobs/"

# Restart jenkins service
service jenkins restart

# Build Docker image
docker build -t jenkins-with-docker/nodejs /vagrant
SCRIPT

Vagrant.configure('2') do |config|
  # $ vagrant plugin install --plugin-source https://rubygems.org/ --plugin-prerelease vagrant-vbguest
  config.vbguest.auto_update = false

  config.vm.box = 'trusty64'
  config.vm.box_url = '/Users/sgyk/local/vagrant/box/trusty-server-cloudimg-amd64-vagrant-disk1.box'

  config.vm.network :forwarded_port, guest: 8080, host:8888

  config.vm.provider :virtualbox do |vb|
    vb.customize ['modifyvm', :id, '--memory', '2048', '--natdnsproxy1', 'on']
  end

  config.vm.provision :shell, inline: $script
end
