resource "aws_route53_zone" "default" {
  name = var.domain_name
}

resource "aws_route53_record" "default" {
  for_each = { for record in var.records : "${record.type}/${replace(join("_", compact([record.name, var.domain_name])), "/[.-]/", "_")}" => record }

  zone_id = aws_route53_zone.default.id
  name    = each.value.name
  type    = each.value.type
  records = each.value.records
  ttl     = each.value.ttl
}
