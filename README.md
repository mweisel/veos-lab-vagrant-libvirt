A Packer template for creating an Arista vEOS-lab Vagrant box for the [libvirt](https://libvirt.org) provider.

## Prerequisites

  * [Arista account](https://www.arista.com/en/user-registration)
  * [Git](https://git-scm.com)
  * [Packer](https://packer.io)
  * [qemu-img](https://www.qemu.org)
  * [vagrant-libvirt](https://github.com/vagrant-libvirt/vagrant-libvirt)

## Steps

1. Clone this GitHub repo and _cd_ into the directory.

```
git clone https://github.com/mweisel/veos-lab-vagrant-libvirt
cd veos-lab-vagrant-libvirt
```

2. Log in and download the vEOS-lab disk image from [Arista](https://www.arista.com/support/software-download).

<img src="https://res.cloudinary.com/binarynature/image/upload/v1573883854/veos-download-from-arista-site_vdzstv.png" width="410" height="369">

3. Convert the vEOS-lab disk image from `vmdk` to `qcow2`.

```
qemu-img convert -pO qcow2 $HOME/Downloads/vEOS-lab-4.23.0.1F.vmdk $HOME/Downloads/vEOS.qcow2
qemu-img check $HOME/Downloads/vEOS.qcow2
qemu-img info $HOME/Downloads/vEOS.qcow2
```

4. Copy the converted vEOS-lab disk image to the `/var/lib/libvirt/images` directory.

```
sudo cp $HOME/Downloads/vEOS.qcow2 /var/lib/libvirt/images
```

5. Modify the file ownership and permissions.

```
sudo chown nobody:kvm /var/lib/libvirt/images/vEOS.qcow2
sudo chmod u+x /var/lib/libvirt/images/vEOS.qcow2
```

6. Packer _build_ with the vEOS version as a variable to create the Vagrant box artifact.

```
packer build -var 'version=4.23.0.1F' arista-veos-lab.json
```

7. Add the Vagrant box. 

```
vagrant box add --provider libvirt --name arista-veos-4.23.0.1F ./builds/veos-lab-4.23.0.1F-libvirt.box
```

7. Vagrant Up!

[![asciicast](https://asciinema.org/a/283821.svg)](https://asciinema.org/a/283821?speed=4)

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details
