provider "kubernetes" {
  # Configuration options
  config_path    = "../config/clustera.config"
  config_context = "kubernetes-admin-cb4f60661082d4bc5b196a01cced07bf3"
  alias          = "clustera"
  insecure = true
}

provider "alicloud" {
  access_key = var.alicloud_access_key
  secret_key = var.alicloud_secret_key
  region     = "cn-zhangjiakou"
}




# provider "kubernetes" {
#   # Configuration options
#   config_path    = "~/config/clusterb.config"
#   config_context = "kind-test-cluster"
#   alias          = "clusterb"
# }


resource "kubernetes_namespace" "jenkins" {
    provider = kubernetes.clustera
  metadata {
    name = "devops"
  }
}