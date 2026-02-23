resource "yandex_alb_target_group" "tg" {
  name = "web-target-group"

  target {
    subnet_id  = yandex_vpc_subnet.subnet_a.id
    ip_address = yandex_compute_instance.web_a.network_interface[0].ip_address
  }

  target {
    subnet_id  = yandex_vpc_subnet.subnet_b.id
    ip_address = yandex_compute_instance.web_b.network_interface[0].ip_address
  }
}

resource "yandex_alb_backend_group" "bg" {
  name = "web-backend-group"

  http_backend {
    name             = "http-backend"
    port             = 80
    target_group_ids = [yandex_alb_target_group.tg.id]

    healthcheck {
      timeout  = "5s"
      interval = "10s"
      http_healthcheck {
        path = "/"
      }
    }
  }
}

resource "yandex_alb_http_router" "router" {
  name = "http-router"
}

resource "yandex_alb_virtual_host" "vh" {
  name           = "site-vhost"
  http_router_id = yandex_alb_http_router.router.id

  route {
    name = "root-route"

    http_route {
      http_route_action {
        backend_group_id = yandex_alb_backend_group.bg.id
      }
    }
  }
}

resource "yandex_alb_load_balancer" "alb" {
  name       = "site-alb"
  network_id = yandex_vpc_network.net.id

  allocation_policy {
    location {
      zone_id   = "ru-central1-a"
      subnet_id = yandex_vpc_subnet.subnet_a.id
    }
  }

  listener {
    name = "http"
    endpoint {
      address {
        external_ipv4_address {}
      }
      ports = [80]
    }

    http {
      handler {
        http_router_id = yandex_alb_http_router.router.id
      }
    }
  }
}

