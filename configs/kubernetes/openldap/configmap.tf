resource "kubernetes_config_map_v1" "ldifs_bootstrap" {
  metadata {
    namespace = var.namespace
    name      = "openldap-ldifs-bootstrap"
    labels    = local.labels
  }

  data = {
    "01-base-tree.ldif"   = <<EOT
dn: ${local.root_dn}
objectClass: dcObject
objectClass: organization
dc: ldap
o: example

dn: ou=users,${local.root_dn}
objectClass: organizationalUnit
ou: users

dn: ou=groups,${local.root_dn}
objectClass: organizationalUnit
ou: groups
EOT
    "02-su2bc-user.ldif"  = <<EOT
dn: uid=su2bc,ou=users,${local.root_dn}
objectClass: inetOrgPerson
uid: su2bc
sn: su2bc
cn: su2bc
EOT
    "03-admin-group.ldif" = <<EOT
dn: cn=admin,ou=groups,${local.root_dn}
objectClass: posixGroup
cn: admin
gidNumber: 1001
memberUid: su2bc
EOT
  }
}

resource "kubernetes_config_map_v1" "ldifs_misc" {
  metadata {
    namespace = var.namespace
    name      = "openldap-ldifs-misc"
    labels    = local.labels
  }

  data = {
    "01-acls.ldif" = <<EOT
dn: olcDatabase={2}mdb,cn=config
changetype: modify
add: olcAccess
olcAccess: to dn.children="${local.root_dn}"
  by self write
  by group.exact="cn=admin,ou=groups,${local.root_dn}" manage
  by * auth
EOT
  }
}

#
