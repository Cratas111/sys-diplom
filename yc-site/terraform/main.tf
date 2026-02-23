terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "~> 0.110"
    }
  }
}

provider "yandex" {
  service_account_key_file = "/home/user7213/authorized_key.json"
  cloud_id                 = "b1g2i4th586htcuo8b25"
  folder_id                = "b1gopk3po7dltoo59prl"
}

resource "yandex_compute_instance" "bastion" {
  name     = "bastion"
  hostname = "bastion"
  zone     = "ru-central1-a"

  resources {
    cores         = 2
    memory        = 2
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = var.image_id
      size     = 10
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet_a.id
    nat       = true
  }

  scheduling_policy {
    preemptible = true
  }

  metadata = {
    ssh-keys = "ubuntu:${file("/home/user7213/.ssh/id_rsa_yc.pub")}"
  }
}

resource "yandex_compute_instance" "web_a" {
  name     = "web-a"
  hostname = "web-a"
  zone     = "ru-central1-a"

  resources {
    cores         = 2
    memory        = 2
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = var.image_id
      size     = 10
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet_a.id
    nat       = false
  }

  scheduling_policy {
    preemptible = true
  }

  metadata = {
    ssh-keys = "ubuntu:${file("/home/user7213/.ssh/id_rsa_yc.pub")}"
  }
}

resource "yandex_compute_instance" "web_b" {
  name     = "web-b"
  hostname = "web-b"
  zone     = "ru-central1-b"

  resources {
    cores         = 2
    memory        = 2
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = var.image_id
      size     = 10
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet_b.id
    nat       = false
  }

  scheduling_policy {
    preemptible = true
  }

  metadata = {
    ssh-keys = "ubuntu:${file("/home/user7213/.ssh/id_rsa_yc.pub")}"
  }
}

resource "yandex_compute_instance" "elasticsearch" {
  name = "elasticsearch"
  hostname = "elasticsearch"
  zone     = "ru-central1-a"
  resources {
    cores  = 4
    memory = 8
  }

  boot_disk {
    initialize_params {
      image_id = var.image_id
      size     = 50
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet_a.id
    nat       = true
  }

  metadata = {
    ssh-keys = "ubuntu:${file("/home/user7213/.ssh/id_rsa_yc.pub")}"
  }
}

resource "yandex_compute_instance" "kibana" {
  name = "kibana"
  hostname = "kibana"
  zone     = "ru-central1-a"
  resources {
    cores  = 2
    memory = 4
  }

  boot_disk {
    initialize_params {
      image_id = var.image_id
      size     = 20
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet_a.id
    nat       = true
  }

  metadata = {
    ssh-keys = "ubuntu:${file("/home/user7213/.ssh/id_rsa_yc.pub")}"
  }
}



