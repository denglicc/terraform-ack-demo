variable "alicloud_access_key" {
  type = string
}
variable "alicloud_secret_key" {
  type = string
}

variable "region" {
  type        = string
  description = "region name"
  default     = "cn-zhangjiakou"
  sensitive   = true
}

variable "cluster_name" {
  default = "k8s_cluster_01"
}

variable "cluster_addons" {
  type = list(object({
    name   = string
    config = string
  }))

  default = [
    {
      "name"   = "flannel",
      "config" = "",
    },
    {
      "name"   = "flexvolume",
      "config" = "",
    },
    {
      "name"   = "alicloud-disk-controller",
      "config" = "",
    },
    # {
    #   "name"   = "logtail-ds",
    #   "config" = "{\"IngressDashboardEnabled\":\"true\"}",
    # },
    {
      "name"   = "nginx-ingress-controller",
      "config" = "{\"IngressSlbNetworkType\":\"internet\"}",
    }
  ]
}