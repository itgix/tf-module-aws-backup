locals {
  enabled           = var.enabled
  plan_enabled      = local.enabled && var.plan_enabled
  iam_role_enabled  = local.enabled && var.iam_role_enabled && !var.use_existing_iam_role
  iam_role_name     = local.enabled ? var.iam_role_name : null
  iam_role_arn      = join("", var.use_existing_iam_role ? data.aws_iam_role.existing[*].arn : aws_iam_role.default[*].arn)
  iam_role_policies = var.iam_role_policies
  vault_enabled     = local.enabled && var.vault_enabled && !var.use_existing_backup_vault
  vault_name        = local.enabled ? coalesce(var.vault_name, var.name_prefix) : null
  vault_id          = join("", var.use_existing_backup_vault ? data.aws_backup_vault.existing[*].id : aws_backup_vault.default[*].id)
  vault_arn         = join("", var.use_existing_backup_vault ? data.aws_backup_vault.existing[*].arn : aws_backup_vault.default[*].arn)
}

data "aws_partition" "current" {}

# IAM role for backup (conditional)
data "aws_iam_policy_document" "assume_role" {
  count = local.iam_role_enabled ? 1 : 0
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["backup.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "default" {
  count                = local.iam_role_enabled ? 1 : 0
  name                 = local.iam_role_name
  assume_role_policy   = join("", data.aws_iam_policy_document.assume_role[*].json)
  permissions_boundary = var.permissions_boundary
  tags                 = var.tags
}

data "aws_iam_role" "existing" {
  count = var.use_existing_iam_role ? 1 : 0
  name  = var.iam_role_name
}

resource "aws_iam_role_policy_attachment" "default" {
  for_each   = { for role in local.iam_role_policies : role => role if local.iam_role_enabled }
  policy_arn = each.value
  role       = join("", aws_iam_role.default[*].name)
}

# Backup vault
resource "aws_backup_vault" "default" {
  count       = local.vault_enabled ? 1 : 0
  name        = local.vault_name
  kms_key_arn = var.kms_key_arn
  tags        = var.tags
}

resource "aws_backup_vault_lock_configuration" "default" {
  count               = local.vault_enabled && var.backup_vault_lock_configuration != null ? 1 : 0
  backup_vault_name   = aws_backup_vault.default[0].id
  changeable_for_days = var.backup_vault_lock_configuration.changeable_for_days
  max_retention_days  = var.backup_vault_lock_configuration.max_retention_days
  min_retention_days  = var.backup_vault_lock_configuration.min_retention_days
}

data "aws_backup_vault" "existing" {
  count = var.use_existing_backup_vault ? 1 : 0
  name  = var.backup_vault_name
}

# Backup plan
resource "aws_backup_plan" "default" {
  count = local.plan_enabled ? 1 : 0
  name  = var.plan_name_suffix == null ? var.name_prefix : format("%s_%s", var.name_prefix, var.plan_name_suffix)

  dynamic "rule" {
    for_each = var.rules
    content {
      rule_name                = lookup(rule.value, "name", "${var.name_prefix}-${rule.key}")
      target_vault_name        = join("", local.vault_enabled ? aws_backup_vault.default[*].name : data.aws_backup_vault.existing[*].name)
      schedule                 = rule.value.schedule
      start_window             = rule.value.start_window
      completion_window        = rule.value.completion_window
      recovery_point_tags      = coalesce(var.recovery_point_tags, var.tags)
      enable_continuous_backup = rule.value.enable_continuous_backup

      dynamic "lifecycle" {
        for_each = lookup(rule.value, "lifecycle", null) != null ? [true] : []
        content {
          cold_storage_after = rule.value.lifecycle.cold_storage_after
          delete_after       = rule.value.lifecycle.delete_after
        }
      }

      dynamic "copy_action" {
        for_each = try(lookup(rule.value.copy_action, "destination_vault_arn", null), null) != null ? [true] : []
        content {
          destination_vault_arn = rule.value.copy_action.destination_vault_arn

          dynamic "lifecycle" {
            for_each = lookup(rule.value.copy_action, "lifecycle", null) != null ? [true] : []
            content {
              cold_storage_after = rule.value.copy_action.lifecycle.cold_storage_after
              delete_after       = rule.value.copy_action.lifecycle.delete_after
            }
          }
        }
      }
    }
  }

  dynamic "advanced_backup_setting" {
    for_each = var.advanced_backup_setting != null ? [true] : []
    content {
      backup_options = var.advanced_backup_setting.backup_options
      resource_type  = var.advanced_backup_setting.resource_type
    }
  }

  tags = var.tags
}

# Backup selection
resource "aws_backup_selection" "default" {
  count         = local.plan_enabled ? 1 : 0
  name          = var.name_prefix
  iam_role_arn  = local.iam_role_arn
  plan_id       = join("", aws_backup_plan.default[*].id)
  resources     = var.backup_resources
  not_resources = var.not_resources

  dynamic "selection_tag" {
    for_each = var.selection_tags
    content {
      type  = selection_tag.value["type"]
      key   = selection_tag.value["key"]
      value = selection_tag.value["value"]
    }
  }

  condition {
    dynamic "string_equals" {
      for_each = var.selection_conditions.string_equals
      content {
        key   = "aws:ResourceTag/${string_equals.value.key}"
        value = string_equals.value.value
      }
    }

    dynamic "string_like" {
      for_each = var.selection_conditions.string_like
      content {
        key   = "aws:ResourceTag/${string_like.value.key}"
        value = string_like.value.value
      }
    }

    dynamic "string_not_equals" {
      for_each = var.selection_conditions.string_not_equals
      content {
        key   = "aws:ResourceTag/${string_not_equals.value.key}"
        value = string_not_equals.value.value
      }
    }

    dynamic "string_not_like" {
      for_each = var.selection_conditions.string_not_like
      content {
        key   = "aws:ResourceTag/${string_not_like.value.key}"
        value = string_not_like.value.value
      }
    }
  }
}

# Backup settings (optional, mgmt only)
resource "aws_backup_global_settings" "this" {
  count           = var.configure_backup_settings ? 1 : 0
  global_settings = var.backup_global_settings
}

resource "aws_backup_region_settings" "this" {
  count                               = var.configure_backup_settings ? 1 : 0
  resource_type_opt_in_preference     = var.resource_type_opt_in_preference
  resource_type_management_preference = var.resource_type_management_preference
}

# Organization-level backup policy
resource "aws_organizations_policy" "org" {
  count       = var.create_policy ? 1 : 0
  name        = var.policy_name
  description = var.policy_description
  type        = var.policy_type
  content     = var.policy_document
}

resource "aws_organizations_policy_attachment" "assign" {
  for_each  = var.create_policy ? var.assignments : {}
  policy_id = aws_organizations_policy.org[0].id
  target_id = each.value.target_id
}