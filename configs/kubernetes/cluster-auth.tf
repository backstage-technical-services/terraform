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

resource "aws_ssm_parameter" "certificate" {
  for_each = local.certificates

  name  = "/backstage/kubernetes/cluster-auth/${each.key}"
  type  = "SecureString"
  value = kubernetes_certificate_signing_request_v1.default[each.key].certificate
}
