resource "kubernetes_namespace" "backstage" {
  metadata {
    name   = "backstage"
    labels = local.default_labels
  }
}
