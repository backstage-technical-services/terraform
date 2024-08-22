resource "kubernetes_namespace" "backstage" {
  metadata {
    name        = "backstage"
    annotations = local.default_annotations
  }
}
