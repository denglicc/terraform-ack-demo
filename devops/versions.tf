terraform {
  required_providers {
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "2.12.1"
    }

        alicloud = {
      //源地址
      source = "hashicorp/alicloud"
      //版本
      version = "1.177.0"
    }
  }
  
}

