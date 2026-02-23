resource "yandex_compute_instance" "zabbix" {
  name     = "zabbix"
  hostname = "zabbix"
  zone     = "ru-central1-a"
  
  allow_stopping_for_update = true
  
  resources {
    cores         = 2
    memory        = 2
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = "fd86fe1acea2ng8lf4l1"
      size     = 10
      type     = "network-hdd"
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
  
  network_interface {
  subnet_id = yandex_vpc_subnet.subnet_a.id
  nat       = true
  }
}




