resource "alicloud_vpc" "vpc" {
  cidr_block = "172.16.0.0/12"
  vpc_name   = "k8s_vpc"
}

resource "alicloud_vswitch" "vsw" {
  cidr_block = "172.16.0.0/16"
  vpc_id     = alicloud_vpc.vpc.id
  zone_id    = "cn-zhangjiakou-a"
}