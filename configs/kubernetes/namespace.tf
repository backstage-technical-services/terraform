resource "kubernetes_namespace" "backstage" {
  metadata {
    name   = "backstage"
    labels = local.default_labels
  }
}

resource "kubernetes_namespace_v1" "backstage_tailscale" {
  metadata {
    name   = "backstage-tailscale"
    labels = local.default_labels
  }
}
