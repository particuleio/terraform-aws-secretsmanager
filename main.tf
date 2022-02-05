# Main module resources
resource "aws_secretsmanager_secret" "this" {
  for_each                       = var.secrets
  name                           = lookup(each.value, "use_name_prefix", true) ? lookup(each.value, "name", each.key) : null
  name_prefix                    = lookup(each.value, "use_name_prefix", false) ? lookup(each.value, "name", each.key) : null
  kms_key_id                     = lookup(each.value, "kms_key_id", null)
  recovery_window_in_days        = lookup(each.value, "recovery_window_in_days", null)
  force_overwrite_replica_secret = lookup(each.value, "force_overwrite_replica_secret", null)
  tags                           = var.tags

  dynamic "replica" {
    for_each = lookup(each.value, "replicas", [])
    iterator = replica
    content {
      region     = lookup(replica.value, "region", null)
      kms_key_id = lookup(replica.value, "kms_key_id", null)
    }
  }
}

resource "aws_secretsmanager_secret_version" "this" {
  for_each      = var.secrets
  secret_id     = aws_secretsmanager_secret.this[each.key].id
  secret_string = each.value.content
}
