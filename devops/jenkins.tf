
resource "kubernetes_deployment_v1" "jenkins" {
    provider = kubernetes.clustera
  metadata {
    name = "jenkins"
    labels = {
      app = "jenkins"
    }
    namespace = kubernetes_namespace.jenkins.id
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "jenkins"
      }
    }

    template {
      metadata {
        labels = {
          app = "jenkins"
        }
      }

      spec {
        container {
          image = "jenkins/jenkins:2.421"
          name  = "jenkins"
          image_pull_policy = "IfNotPresent"

          port {
            container_port = 8080
          }
          resources {
            limits = {
              cpu    = "1000m"
              memory = "4096Mi"
            }
            requests = {
              cpu    = "500m"
              memory = "1024Mi"
            }
          }

          liveness_probe {
            http_get {
              path = "/login"
              port = 8080

            }

            initial_delay_seconds = 60
            period_seconds        = 3
          }
        }
      #   init_container {
      #     image = "harbor.56hswl.com/course/busybox:1.28"
      #     name  = "fix-permissions"
      #     image_pull_policy = "IfNotPresent"
      #     command = ["sh", "-c", "chown -R 1000:1000 /var/jenkins_home"]


      # }
    }
  }
  
}
}

resource "kubernetes_service_v1" "jenkins" {
    provider = kubernetes.clustera
  metadata {
    name = "jenkins-service"
    namespace = kubernetes_namespace.jenkins.id
  }
  spec {
    selector = {
      app = kubernetes_deployment_v1.jenkins.metadata[0].labels.app
    }

    port {
      port        = 8080
      target_port = 8080
    }

    type = "ClusterIP"
  }
}

resource "kubernetes_ingress_v1" "jenkins_ingress" {
  provider = kubernetes.clustera
  metadata {
    name = "jenkins-ingress"
    namespace = kubernetes_namespace.jenkins.id
  }

  spec {
    

    rule {
      host = "jenkins.dengli.site"
      http {
        path {
          backend {
            service {
              name = kubernetes_service_v1.jenkins.metadata[0].name
              port {
                number = 8080
              }
            }
          }
          path_type = "Prefix"
          path = "/"
        }

      }
    }

  }
}