
variable "enabled" {
  type        = bool
  default     = true
  description = "Whether to enable this module. If false, no resources are created."
}

variable "name_prefix" {
  type        = string
  description = "Prefix used in resource naming (e.g. backup plan name, vault name, etc.)"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Tags to apply to all taggable resources"
}

variable "kms_key_arn" {
  type        = string
  default     = null
  description = "The server-side encryption key that is used to protect your backups"
}

variable "vault_name" {
  type        = string
  default     = null
  description = "Override name for the backup vault"
}

variable "vault_enabled" {
  type        = bool
  default     = true
  description = "Whether to create a new backup vault"
}

variable "backup_vault_lock_configuration" {
  type = object({
    changeable_for_days = optional(number)
    max_retention_days  = optional(number)
    min_retention_days  = optional(number)
  })
  default     = null
  description = "Configuration for Backup Vault Lock"
}

variable "plan_enabled" {
  type        = bool
  default     = true
  description = "Whether to create a backup plan"
}

variable "plan_name_suffix" {
  type        = string
  default     = null
  description = "Optional suffix to append to the backup plan name"
}

variable "rules" {
  type = list(object({
    name                     = string
    schedule                 = optional(string)
    enable_continuous_backup = optional(bool)
    start_window             = optional(number)
    completion_window        = optional(number)
    lifecycle = optional(object({
      cold_storage_after                        = optional(number)
      delete_after                              = optional(number)
      opt_in_to_archive_for_supported_resources = optional(bool)
    }))
    copy_action = optional(object({
      destination_vault_arn = optional(string)
      lifecycle = optional(object({
        cold_storage_after                        = optional(number)
        delete_after                              = optional(number)
        opt_in_to_archive_for_supported_resources = optional(bool)
      }))
    }))
  }))
  default     = []
  description = "List of rule objects defining backup schedules"
}

variable "advanced_backup_setting" {
  type = object({
    backup_options = map(string)
    resource_type  = string
  })
  default     = null
  description = "Advanced backup options for specific resource types"
}

variable "backup_resources" {
  type        = list(string)
  default     = []
  description = "List of resource ARNs to include in the backup plan"
}

variable "not_resources" {
  type        = list(string)
  default     = []
  description = "List of resource ARNs to exclude from the backup plan"
}

variable "selection_tags" {
  type = list(object({
    type  = string
    key   = string
    value = string
  }))
  default     = []
  description = "List of tag condition objects used for selecting resources"
}

variable "selection_conditions" {
  type = object({
    string_equals     = optional(list(object({ key = string, value = string })), [])
    string_like       = optional(list(object({ key = string, value = string })), [])
    string_not_equals = optional(list(object({ key = string, value = string })), [])
    string_not_like   = optional(list(object({ key = string, value = string })), [])
  })
  default     = {}
  description = "Conditions used to select resources for backup"
}

variable "iam_role_enabled" {
  type        = bool
  default     = true
  description = "Whether to create a default IAM role for the backup selection"
}

variable "iam_role_name" {
  type        = string
  default     = null
  description = "Name of the IAM role to use or create"
}

variable "permissions_boundary" {
  type        = string
  default     = null
  description = "Permissions boundary to set on IAM roles"
}

variable "create_iam_role" {
  type        = bool
  default     = false
  description = "Whether to create an additional IAM role with custom policy attachments"
}

variable "iam_role_boundary" {
  type        = string
  default     = null
  description = "Permissions boundary for the additional IAM role"
}

variable "iam_role_policies" {
  type        = list(string)
  default     = []
  description = "List of managed policy ARNs to attach to the additional IAM role"
}

variable "create_policy" {
  type        = bool
  default     = false
  description = "Whether to create an AWS Organizations backup policy"
}

variable "policy_name" {
  type        = string
  default     = null
  description = "Name of the AWS Organizations backup policy"
}

variable "policy_description" {
  type        = string
  default     = "Organization-level AWS Backup policy"
  description = "Description for the AWS Organizations backup policy"
}

variable "policy_type" {
  type        = string
  default     = "BACKUP_POLICY"
  description = "Type of the AWS Organizations policy (should be 'BACKUP_POLICY')"
}

variable "policy_document" {
  type        = string
  default     = null
  description = "JSON document content for the backup policy"
}

variable "assignments" {
  type = map(object({
    target_id = string
  }))
  default     = {}
  description = "Map of targets (e.g. OU or account IDs) to attach the policy to"
}

variable "configure_backup_settings" {
  type        = bool
  default     = false
  description = "Whether to configure AWS Backup global and region settings (should only be true in the management account)"
}

variable "backup_global_settings" {
  type = map(string)
  default = {
    "isCrossAccountBackupEnabled" = "true"
  }
  description = "Global backup settings such as cross-account backup enablement"
}

variable "resource_type_opt_in_preference" {
  type        = map(bool)
  default     = {}
  description = "Map of AWS resource types to opt into AWS Backup"
}

variable "resource_type_management_preference" {
  type        = map(bool)
  default     = {}
  description = "Map of AWS resource types to enable backup management for"
}

variable "recovery_point_tags" {
  type        = map(string)
  default     = null
  description = "Override tags applied to recovery points (defaults to module tags)"
}

variable "use_existing_backup_vault" {
  description = "Whether to use an existing AWS Backup vault instead of creating a new one."
  type        = bool
  default     = false
}

variable "use_existing_iam_role" {
  description = "Whether to use an existing IAM role instead of creating a new one."
  type        = bool
  default     = false
}

variable "backup_vault_name" {
  description = "Name of the existing or new backup vault."
  type        = string
  default     = null
}