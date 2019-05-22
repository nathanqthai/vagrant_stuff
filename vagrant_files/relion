# vi: set ft=ruby :

$apt_update = <<-SCRIPT
apt-get update
apt-get -y upgrade
apt-get -y install xauth libx11-6 libxrender1 libxtst6 libxi6 libfontconfig1
SCRIPT

Vagrant.configure("2") do |config|
    config.vm.box = "ubuntu/bionic64"

    config.vm.provider "virtualbox" do |v|
        v.memory = 4096
        v.cpus = 2
        v.name = "relion_vm"
    end

    # configure hostname
    config.vm.hostname = "relion-vm"

    # enable xforwarding
    config.ssh.forward_agent = true
    config.ssh.forward_x11 = true

    config.vm.provision "initial", type: "shell" do |init|
        init.inline = $apt_update
    end

    config.vm.provision "relion", type: "shell" do |relion|
        relion.path = "provision/relion.sh"
        relion.args = ["/vagrant", "/tmp"]
    end
end
