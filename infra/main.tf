provider "alicloud" {
  access_key = var.alicloud_access_key
  secret_key = var.alicloud_secret_key
  region     = "cn-zhangjiakou"

}


locals {
  cluster_version = "1.28.9-aliyun.1"
  service_cidr    = "192.168.0.0/16"
  pod_cidr        = "10.81.0.0/16"
  proxy_mode      = "ipvs"

}
resource "alicloud_cs_managed_kubernetes" "k8s" {
  name              = var.cluster_name
  cluster_spec      = "ack.standard"
  version           = local.cluster_version
  availability_zone = "cn-zhangjiakou-a"
  service_cidr      = local.service_cidr
  pod_cidr          = local.pod_cidr
  new_nat_gateway   = true

  load_balancer_spec   = "slb.s1.small"
  slb_internet_enabled = true
  password             = "Password1234"
  node_port_range      = "30000-32767"
  os_type              = "Linux"
  platform             = "CentOS"


  worker_number                 = 1
  worker_instance_types         = ["ecs.gn6i-c4g1.xlarge"]
  worker_instance_charge_type   = "PostPaid"
  worker_vswitch_ids            = [alicloud_vswitch.vsw.id]
  # worker_disk_category          = "slb.s1.small"
  worker_disk_category          = "cloud_essd"
  worker_disk_size              = 40
  # worker_disk_performance_level = "PL0"


  proxy_mode     = local.proxy_mode

  dynamic "addons" {
    for_each = var.cluster_addons
    content {
      name   = lookup(addons.value, "name", var.cluster_addons)
      config = lookup(addons.value, "config", var.cluster_addons)
    }
  }

runtime = {
  name = "containerd"
}




}