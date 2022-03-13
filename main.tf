resource "aws_secretsmanager_secret" "this" {
  for_each                       = var.secrets
  name                           = try(each.value.name, null)
  name_prefix                    = try(each.value.name_prefix, null)
  kms_key_id                     = try(each.value.kms_key_id, null)
  recovery_window_in_days        = try(each.value.recovery_window_in_days, null)
  force_overwrite_replica_secret = try(each.value.force_overwrite_replica_secret, null)
  tags                           = var.tags

  dynamic "replica" {
    for_each = try(each.value.replicas, [])
    iterator = replica
    content {
      region     = try(replica.value.region, null)
      kms_key_id = try(replica.value.kms_key_id, null)
    }
  }
}

resource "aws_secretsmanager_secret_version" "this" {
  for_each      = var.secrets
  secret_id     = aws_secretsmanager_secret.this[each.key].id
  secret_string = each.value.content
}
