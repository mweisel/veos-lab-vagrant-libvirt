![Vagrant](https://img.shields.io/badge/vagrant%20-%231563FF.svg?&style=for-the-badge&logo=vagrant&logoColor=white) ![netlab](https://img.shields.io/badge/netlab-d26400?style=for-the-badge)

# Arista vEOS-lab Vagrant box

A Packer template for creating an Arista vEOS-lab Vagrant box for the [libvirt](https://libvirt.org) provider.

## Prerequisites

  * [Arista](https://www.arista.com/en/user-registration) account
  * [Git](https://git-scm.com)
  * [Packer](https://developer.hashicorp.com/packer)
  * [libvirt](https://libvirt.org)
  * [QEMU](https://www.qemu.org)
  * [Vagrant](https://developer.hashicorp.com/vagrant) >= 2.4.0
  * [vagrant-libvirt](https://github.com/vagrant-libvirt/vagrant-libvirt)

## Steps

0\. Verify the prerequisite tools are installed.

```
which git packer libvirtd qemu-system-x86_64 vagrant
```

```
vagrant plugin list
```

1\. Log in and download the **vEOS Lab** disk image (qcow2) file from [Arista](https://www.arista.com/support/software-download).

2\. Save the file to your `Downloads` directory.

3\. Copy (and rename) the disk image file to the `/var/lib/libvirt/images` directory.

```
sudo cp ~/Downloads/vEOS64-lab-4.35.3F.qcow2 /var/lib/libvirt/images/arista-veos.qcow2
```

4\. Create the `boxes` directory.

```
mkdir -p ~/boxes
```

5\. Clone this GitHub repo and _cd_ into the directory.

```
git clone https://github.com/mweisel/veos-lab-vagrant-libvirt && cd veos-lab-vagrant-libvirt
```

6\. Install the plugins required for the Packer configuration.

```
packer init -upgrade arista-veos.pkr.hcl
```

7\. Packer _build_ to create the Vagrant box artifact, including the EOS version number for the `version` variable value.

```
packer build -var 'version=4.35.3F' arista-veos.pkr.hcl
```

8\. Copy the Vagrant box artifact to the `boxes` directory.

```
cp ./builds/arista-veos-4.35.3F.box ~/boxes/
```

9\. Copy the box metadata file to the `boxes` directory.

```
cp ./src/arista-veos.json ~/boxes/
```

10\. Change the current working directory to `boxes`.

```
cd ~/boxes
```

11\. Substitute the `HOME` placeholder string in the box metadata file.

<pre>
$ <b>awk '/url/{gsub(/^ */,"");print}' arista-veos.json</b>
"url": "file://<b>HOME</b>/boxes/arista-veos-VER.box"

$ <b>sed -i "s|HOME|${HOME}|" arista-veos.json</b>

$ <b>awk '/url/{gsub(/^ */,"");print}' arista-veos.json</b>
"url": "file://<b>/home/marc</b>/boxes/arista-veos-VER.box"
</pre>

12\. Also, substitute the `VER` placeholder string with the EOS version.

<pre>
$ <b>awk '/VER/{gsub(/^ */,"");print}' arista-veos.json</b>
"version": "<b>VER</b>",
"url": "file:///home/marc/boxes/arista-veos-<b>VER</b>.box"

$ <b>sed -i 's/VER/4.35.3F/g' arista-veos.json</b>

$ <b>awk '/\&lt;version\&gt;|url/{gsub(/^ */,"");print}' arista-veos.json</b>
"version": "<b>4.35.3F</b>",
"url": "file:///home/marc/boxes/arista-veos-<b>4.35.3F</b>.box"
</pre>

13\. Add the Vagrant box to the local inventory.

```
vagrant box add arista-veos.json
```

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details
