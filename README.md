<img alt="Vagrant" src="https://img.shields.io/badge/vagrant%20-%231563FF.svg?&style=for-the-badge&logo=vagrant&logoColor=white"/>

# Arista vEOS-lab Vagrant box

A Packer template for creating an Arista vEOS-lab Vagrant box for the [libvirt](https://libvirt.org) provider.

## Prerequisites

  * [Arista](https://www.arista.com/en/user-registration) account
  * [Git](https://git-scm.com)
  * [Packer](https://packer.io) >= 1.70
  * [libvirt](https://libvirt.org)
  * [QEMU](https://www.qemu.org)
  * [Vagrant](https://www.vagrantup.com) <= 2.2.9
  * [vagrant-libvirt](https://github.com/vagrant-libvirt/vagrant-libvirt)

## Steps

0\. Verify the prerequisite tools are installed.

<pre>
$ <b>which git packer libvirtd qemu-img qemu-system-x86_64 vagrant</b>
$ <b>vagrant plugin list</b>
vagrant-libvirt (0.3.0, global)
</pre>

1\. Log in and download the vEOS-lab disk image (vmdk) file from [Arista](https://www.arista.com/support/software-download). Save the file to your `Downloads` directory.

2\. Convert the vEOS-lab disk image file from `vmdk` to `qcow2`.

<pre>
$ <b>qemu-img convert -pO qcow2 $HOME/Downloads/vEOS-lab-4.25.2F.vmdk $HOME/Downloads/vEOS.qcow2</b>
$ <b>qemu-img check $HOME/Downloads/vEOS.qcow2</b>
$ <b>qemu-img info $HOME/Downloads/vEOS.qcow2</b>
</pre>

3\. Copy the converted disk image file to the `/var/lib/libvirt/images` directory.

<pre>
$ <b>sudo cp $HOME/Downloads/vEOS.qcow2 /var/lib/libvirt/images</b>
</pre>

4\. Modify the file ownership and permissions. Note the owner may differ between Linux distributions.

> Ubuntu 18.04

<pre>
$ <b>sudo chown libvirt-qemu:kvm /var/lib/libvirt/images/vEOS.qcow2</b>
$ <b>sudo chmod u+x /var/lib/libvirt/images/vEOS.qcow2</b>
</pre>

> Arch Linux

<pre>
$ <b>sudo chown nobody:kvm /var/lib/libvirt/images/vEOS.qcow2</b>
$ <b>sudo chmod u+x /var/lib/libvirt/images/vEOS.qcow2</b>
</pre>

5\. Create the `boxes` directory.

<pre>
$ <b>mkdir -p $HOME/boxes</b>
</pre>

6\. Clone this GitHub repo and _cd_ into the directory.

<pre>
$ <b>git clone https://github.com/mweisel/veos-lab-vagrant-libvirt</b>
$ <b>cd veos-lab-vagrant-libvirt</b>
</pre>

7\. Packer _build_ to create the Vagrant box artifact. Supply the EOS version number for the `version` variable value.

<pre>
$ <b>packer build -var 'version=4.25.2F' arista-veos.pkr.hcl</b>
</pre>

8\. Copy the Vagrant box artifact to the `boxes` directory.

<pre>
$ <b>cp ./builds/arista-veos-4.25.2F.box $HOME/boxes/</b>
</pre>

9\. Copy the box metadata file to the `boxes` directory.

<pre>
$ <b>cp ./src/arista-veos.json $HOME/boxes/</b>
</pre>

10\. Change the current working directory to `boxes`.

<pre>
$ <b>cd $HOME/boxes</b>
</pre>

11\. Substitute the `HOME` placeholder string in the box metadata file.

<pre>
$ <b>awk '/url/{gsub(/^ */,"");print}' arista-veos.json</b>
"url": "file://<b>HOME</b>/boxes/arista-veos-VER.box"

$ <b>sed -i "s|HOME|${HOME}|" arista-veos.json</b>

$ <b>awk '/url/{gsub(/^ */,"");print}' arista-veos.json</b>
"url": "file://<b>/home/marc</b>/boxes/arista-veos-VER.box"
</pre>

12\. Also, substitute the `VER` placeholder string with the EOS version you're using.

<pre>
$ <b>awk '/VER/{gsub(/^ */,"");print}' arista-veos.json</b>
"version": "<b>VER</b>",
"url": "file:///home/marc/boxes/arista-veos-<b>VER</b>.box"

$ <b>sed -i 's/VER/4.25.2F/g' arista-veos.json</b>

$ <b>awk '/\&lt;version\&gt;|url/{gsub(/^ */,"");print}' arista-veos.json</b>
"version": "<b>4.25.2F</b>",
"url": "file:///home/marc/boxes/arista-veos-<b>4.25.2F</b>.box"
</pre>

13\. Add the Vagrant box to the local inventory.

<pre>
$ <b>vagrant box add arista-veos.json</b>
</pre>

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details
