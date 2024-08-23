locals {
  certificates = { for filePath in fileset("${path.module}/certificates", "*.csr") : trimsuffix(filePath, ".csr") => file("${path.module}/certificates/${filePath}") }
}

resource "kubernetes_certificate_signing_request_v1" "default" {
  for_each = local.certificates

  metadata {
    name = each.key
  }

  spec {
    request            = trimspace(each.value)
    signer_name        = "kubernetes.io/kube-apiserver-client"
    expiration_seconds = 365 * 24 * 60 * 60 # 1 year
    usages             = ["client auth"]
  }
}

resource "kubernetes_secret_v1" "auth_certificate" {
  for_each = local.certificates

  metadata {
    namespace   = "backstage"
    name        = "cluster-auth-${each.key}"
    annotations = local.default_annotations
  }

  type = "kubernetes.io/tls"
  data = {
    "tls.key" = ""
    "tls.crt" = kubernetes_certificate_signing_request_v1.default[each.key].certificate
  }
}
