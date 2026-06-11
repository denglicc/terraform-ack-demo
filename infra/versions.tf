terraform {

  required_version = "1.4.6"
  required_providers {
    alicloud = {
      //源地址
      source = "hashicorp/alicloud"
      //版本
      version = "1.177.0"
    }
  }
}