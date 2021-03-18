variable "version" {
  type    = string
  default = "unknown"
}

variable "gui_disabled" {
  type    = bool
  default = true
}

variable "boot_time" {
  type    = string
  default = "3m"
}

variable "boot_key_interval" {
  type    = string
  default = "50ms"
}

variable "out_dir" {
  type    = string
  default = "tmp_out"
}

source "qemu" "veos" {
  accelerator       = "kvm"
  cpus              = 1
  memory            = 2048
  skip_resize_disk  = true
  skip_compaction   = true
  disk_image        = true
  use_backing_file  = false
  disk_interface    = "ide"
  disk_cache        = "unsafe"
  format            = "qcow2"
  net_device        = "virtio-net"
  iso_checksum      = "none"
  iso_url           = "/var/lib/libvirt/images/vEOS.qcow2"
  boot_wait         = "${var.boot_time}"
  boot_key_interval = "${var.boot_key_interval}"
  boot_command = [
    "admin<enter><wait>",
    "zerotouch disable<enter><wait>",
    "<wait${var.boot_time}>",
    "admin<enter><wait>",
    "enable<enter><wait>",
    "configure<enter><wait>",
    "aaa authorization exec default local<enter><wait>",
    "aaa root secret 0 vagrant<enter><wait>",
    "username admin privilege 15 role network-admin secret 0 admin<enter><wait>",
    "username vagrant privilege 15 role network-admin secret 0 vagrant<enter><wait>",
    "username vagrant ssh-key ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEA6NF8iallvQVp22WDkTkyrtvp9eWW6A8YVr+kz4TjGYe7gHzIw+niNltGEFHzD8+v1I2YJ6oXevct1YeS0o9HZyN1Q9qgCgzUFtdOKLv6IedplqoPkcmF0aYet2PkEDo3MlTBckFXPITAMzF8dJSIFo9D8HfdOV0IAdx4O7PtixWKn5y2hMNG0zQPyUecp4pzC6kivAIhyfHilFR61RGL+GPXQ2MWZWFYbAGjyiYJnAmCP3NOTd0jMZEnDkbUvxhMmBYSdETk1rRgm+R4LOzFUGaHqHDLKLX+FIPKcF96hrucXzcWyLbIbEgE98OHlnVYCzRdK8jlqm8tehUc9c9WhQ== vagrant insecure public key<enter><wait>",
    "interface Management 1<enter><wait>",
    "no lldp transmit<enter><wait>",
    "no lldp receive<enter><wait>",
    "ip address dhcp<enter><wait>",
    "exit<enter><wait>",
    "security pki key generate rsa 2048 default<enter><wait5>",
    "security pki certificate generate self-signed default key default parameters common-name Arista<enter><wait>",
    "management api http-commands<enter><wait>",
    "no shutdown<enter><wait>",
    "exit<enter><wait>",
    "management api netconf<enter><wait>",
    "transport ssh default<enter><wait>",
    "exit<enter><wait>",
    "exit<enter><wait>",
    "management api restconf<enter><wait>",
    "transport https default<enter><wait>",
    "ssl profile default<enter><wait>",
    "port 6040<enter><wait>",
    "exit<enter><wait>",
    "exit<enter><wait>",
    "management api gnmi<enter><wait>",
    "transport grpc default<enter><wait>",
    "no shutdown<enter><wait>",
    "exit<enter><wait>",
    "exit<enter><wait>",
    "management security<enter><wait>",
    "ssl profile default<enter><wait>",
    "certificate default key default<enter><wait>",
    "exit<enter><wait>",
    "exit<enter><wait>",
    "end<enter><wait>",
    "copy running-config startup-config<enter><wait>",
    "bash sudo poweroff<enter><wait>",
    "<exit>"
  ]
  headless         = "${var.gui_disabled}"
  communicator     = "none"
  vm_name          = "veos-${var.version}"
  output_directory = "${var.out_dir}"
}

build {
  sources = ["source.qemu.veos"]

  post-processor "vagrant" {
    vagrantfile_template = "src/Vagrantfile"
    output               = "builds/arista-veos-${var.version}.box"
  }
}
