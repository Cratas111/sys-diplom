# ===========================================
# Yandex Cloud VPC Network
# ===========================================
resource "yandex_vpc_network" "net" {
  name = "site-network"
}

# ===========================================
# Subnet A (zone ru-central1-a)
# ===========================================
resource "yandex_vpc_subnet" "subnet_a" {
  name           = "subnet-a"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.net.id
  v4_cidr_blocks = ["10.10.1.0/24"]
  route_table_id = yandex_vpc_route_table.nat_rt.id
}

# ===========================================
# Subnet B (zone ru-central1-b)
# ===========================================
resource "yandex_vpc_subnet" "subnet_b" {
  name           = "subnet-b"
  zone           = "ru-central1-b"
  network_id     = yandex_vpc_network.net.id
  v4_cidr_blocks = ["10.10.2.0/24"]
  route_table_id = yandex_vpc_route_table.nat_rt.id
}

# ===========================================
# NAT Gateway (для выхода в интернет из приватных подсетей)
# ===========================================
resource "yandex_vpc_gateway" "nat_gateway" {
  name = "nat-gateway"
  shared_egress_gateway {}
}

# ===========================================
# Route Table для NAT Gateway
# ===========================================
resource "yandex_vpc_route_table" "nat_rt" {
  name       = "nat-route-table"
  network_id = yandex_vpc_network.net.id

  static_route {
    destination_prefix = "0.0.0.0/0"
    gateway_id         = yandex_vpc_gateway.nat_gateway.id
  }
}

