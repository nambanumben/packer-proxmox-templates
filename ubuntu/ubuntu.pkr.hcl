build {
  source "proxmox-iso.image" {
    name         = "ubuntu20"
    boot_command = var.boot_cmd_ubuntu20
    boot_wait    = var.boot_wait
    http_content = {
      "/meta-data" = file("configs/meta-data")
      "/user-data" = templatefile("configs/user-data",
        {
          var            = var,
          ssh_public_key = chomp(file(var.ssh_public_key_file))
      })
    }

    boot_iso {
      iso_file = "${var.iso_storage_pool}:iso/${var.iso_image["ubuntu20"]}"
      unmount = var.unmount_iso
    }

    template_name = "ubuntu20"
    vm_id         = var.vm_id["ubuntu20"]
  }

  source "proxmox-iso.image" {
    name         = "ubuntu22"
    boot_command = var.boot_cmd_ubuntu22
    boot_wait    = var.boot_wait
    http_content = {
      "/meta-data" = file("configs/meta-data")
      "/user-data" = templatefile("configs/user-data",
        {
          var            = var,
          ssh_public_key = chomp(file(var.ssh_public_key_file))
      })
    }

    boot_iso {
      iso_file = "${var.iso_storage_pool}:iso/${var.iso_image["ubuntu22"]}"
      unmount = var.unmount_iso
    }

    template_name = "ubuntu22"
    vm_id         = var.vm_id["ubuntu22"]
  }

  source "proxmox-iso.image" {
    name         = "ubuntu24"
    boot_command = var.boot_cmd_ubuntu22
    boot_wait    = var.boot_wait
    http_content = {
      "/meta-data" = file("configs/meta-data")
      "/user-data" = templatefile("configs/user-data",
        {
          var            = var,
          ssh_public_key = chomp(file(var.ssh_public_key_file))
      })
    }

    boot_iso {
      iso_file = "${var.iso_storage_pool}:iso/${var.iso_image["ubuntu24"]}"
      unmount = var.unmount_iso
    }

    template_name = "ubuntu24"
    vm_id         = var.vm_id["ubuntu24"]
  }

  provisioner "shell" {
    inline = [
      "while [ ! -f /var/lib/cloud/instance/boot-finished ]; do echo 'Waiting for cloud-init...'; sleep 1; done",
      // clean image identifiers
      "cloud-init clean --machine-id --seed",
      "rm /etc/hostname /etc/ssh/ssh_host_* /var/lib/systemd/random-seed",
      "truncate -s 0 /root/.ssh/authorized_keys",
      "sed -i 's/^#PasswordAuthentication\\ yes/PasswordAuthentication\\ no/' /etc/ssh/sshd_config",
      "sed -i 's/^#PermitRootLogin\\ prohibit-password/PermitRootLogin\\ no/' /etc/ssh/sshd_config"
    ]
  }
}
