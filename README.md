The Terraform module is used by the ITGix AWS Landing Zone - https://itgix.com/itgix-landing-zone/

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 3.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_backup_global_settings.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/backup_global_settings) | resource |
| [aws_backup_plan.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/backup_plan) | resource |
| [aws_backup_region_settings.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/backup_region_settings) | resource |
| [aws_backup_selection.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/backup_selection) | resource |
| [aws_backup_vault.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/backup_vault) | resource |
| [aws_backup_vault_lock_configuration.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/backup_vault_lock_configuration) | resource |
| [aws_iam_role.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_organizations_policy.org](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/organizations_policy) | resource |
| [aws_organizations_policy_attachment.assign](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/organizations_policy_attachment) | resource |
| [aws_backup_vault.existing](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/backup_vault) | data source |
| [aws_iam_policy_document.assume_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_role.existing](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_role) | data source |
| [aws_partition.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/partition) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_advanced_backup_setting"></a> [advanced\_backup\_setting](#input\_advanced\_backup\_setting) | Advanced backup options for specific resource types | <pre>object({<br/>    backup_options = map(string)<br/>    resource_type  = string<br/>  })</pre> | `null` | no |
| <a name="input_assignments"></a> [assignments](#input\_assignments) | Map of targets (e.g. OU or account IDs) to attach the policy to | <pre>map(object({<br/>    target_id = string<br/>  }))</pre> | `{}` | no |
| <a name="input_backup_global_settings"></a> [backup\_global\_settings](#input\_backup\_global\_settings) | Global backup settings such as cross-account backup enablement | `map(string)` | <pre>{<br/>  "isCrossAccountBackupEnabled": "true"<br/>}</pre> | no |
| <a name="input_backup_resources"></a> [backup\_resources](#input\_backup\_resources) | List of resource ARNs to include in the backup plan | `list(string)` | `[]` | no |
| <a name="input_backup_vault_lock_configuration"></a> [backup\_vault\_lock\_configuration](#input\_backup\_vault\_lock\_configuration) | Configuration for Backup Vault Lock | <pre>object({<br/>    changeable_for_days = optional(number)<br/>    max_retention_days  = optional(number)<br/>    min_retention_days  = optional(number)<br/>  })</pre> | `null` | no |
| <a name="input_backup_vault_name"></a> [backup\_vault\_name](#input\_backup\_vault\_name) | Name of the existing or new backup vault. | `string` | `null` | no |
| <a name="input_configure_backup_settings"></a> [configure\_backup\_settings](#input\_configure\_backup\_settings) | Whether to configure AWS Backup global and region settings (should only be true in the management account) | `bool` | `false` | no |
| <a name="input_create_iam_role"></a> [create\_iam\_role](#input\_create\_iam\_role) | Whether to create an additional IAM role with custom policy attachments | `bool` | `false` | no |
| <a name="input_create_policy"></a> [create\_policy](#input\_create\_policy) | Whether to create an AWS Organizations backup policy | `bool` | `false` | no |
| <a name="input_enabled"></a> [enabled](#input\_enabled) | Whether to enable this module. If false, no resources are created. | `bool` | `true` | no |
| <a name="input_iam_role_boundary"></a> [iam\_role\_boundary](#input\_iam\_role\_boundary) | Permissions boundary for the additional IAM role | `string` | `null` | no |
| <a name="input_iam_role_enabled"></a> [iam\_role\_enabled](#input\_iam\_role\_enabled) | Whether to create a default IAM role for the backup selection | `bool` | `true` | no |
| <a name="input_iam_role_name"></a> [iam\_role\_name](#input\_iam\_role\_name) | Name of the IAM role to use or create | `string` | `null` | no |
| <a name="input_iam_role_policies"></a> [iam\_role\_policies](#input\_iam\_role\_policies) | List of managed policy ARNs to attach to the additional IAM role | `list(string)` | `[]` | no |
| <a name="input_kms_key_arn"></a> [kms\_key\_arn](#input\_kms\_key\_arn) | The server-side encryption key that is used to protect your backups | `string` | `null` | no |
| <a name="input_name_prefix"></a> [name\_prefix](#input\_name\_prefix) | Prefix used in resource naming (e.g. backup plan name, vault name, etc.) | `string` | n/a | yes |
| <a name="input_not_resources"></a> [not\_resources](#input\_not\_resources) | List of resource ARNs to exclude from the backup plan | `list(string)` | `[]` | no |
| <a name="input_permissions_boundary"></a> [permissions\_boundary](#input\_permissions\_boundary) | Permissions boundary to set on IAM roles | `string` | `null` | no |
| <a name="input_plan_enabled"></a> [plan\_enabled](#input\_plan\_enabled) | Whether to create a backup plan | `bool` | `true` | no |
| <a name="input_plan_name_suffix"></a> [plan\_name\_suffix](#input\_plan\_name\_suffix) | Optional suffix to append to the backup plan name | `string` | `null` | no |
| <a name="input_policy_description"></a> [policy\_description](#input\_policy\_description) | Description for the AWS Organizations backup policy | `string` | `"Organization-level AWS Backup policy"` | no |
| <a name="input_policy_document"></a> [policy\_document](#input\_policy\_document) | JSON document content for the backup policy | `string` | `null` | no |
| <a name="input_policy_name"></a> [policy\_name](#input\_policy\_name) | Name of the AWS Organizations backup policy | `string` | `null` | no |
| <a name="input_policy_type"></a> [policy\_type](#input\_policy\_type) | Type of the AWS Organizations policy (should be 'BACKUP\_POLICY') | `string` | `"BACKUP_POLICY"` | no |
| <a name="input_recovery_point_tags"></a> [recovery\_point\_tags](#input\_recovery\_point\_tags) | Override tags applied to recovery points (defaults to module tags) | `map(string)` | `null` | no |
| <a name="input_resource_type_management_preference"></a> [resource\_type\_management\_preference](#input\_resource\_type\_management\_preference) | Map of AWS resource types to enable backup management for | `map(bool)` | `{}` | no |
| <a name="input_resource_type_opt_in_preference"></a> [resource\_type\_opt\_in\_preference](#input\_resource\_type\_opt\_in\_preference) | Map of AWS resource types to opt into AWS Backup | `map(bool)` | `{}` | no |
| <a name="input_rules"></a> [rules](#input\_rules) | List of rule objects defining backup schedules | <pre>list(object({<br/>    name                     = string<br/>    schedule                 = optional(string)<br/>    enable_continuous_backup = optional(bool)<br/>    start_window             = optional(number)<br/>    completion_window        = optional(number)<br/>    lifecycle = optional(object({<br/>      cold_storage_after                        = optional(number)<br/>      delete_after                              = optional(number)<br/>      opt_in_to_archive_for_supported_resources = optional(bool)<br/>    }))<br/>    copy_action = optional(object({<br/>      destination_vault_arn = optional(string)<br/>      lifecycle = optional(object({<br/>        cold_storage_after                        = optional(number)<br/>        delete_after                              = optional(number)<br/>        opt_in_to_archive_for_supported_resources = optional(bool)<br/>      }))<br/>    }))<br/>  }))</pre> | `[]` | no |
| <a name="input_selection_conditions"></a> [selection\_conditions](#input\_selection\_conditions) | Conditions used to select resources for backup | <pre>object({<br/>    string_equals     = optional(list(object({ key = string, value = string })), [])<br/>    string_like       = optional(list(object({ key = string, value = string })), [])<br/>    string_not_equals = optional(list(object({ key = string, value = string })), [])<br/>    string_not_like   = optional(list(object({ key = string, value = string })), [])<br/>  })</pre> | `{}` | no |
| <a name="input_selection_tags"></a> [selection\_tags](#input\_selection\_tags) | List of tag condition objects used for selecting resources | <pre>list(object({<br/>    type  = string<br/>    key   = string<br/>    value = string<br/>  }))</pre> | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply to all taggable resources | `map(string)` | `{}` | no |
| <a name="input_use_existing_backup_vault"></a> [use\_existing\_backup\_vault](#input\_use\_existing\_backup\_vault) | Whether to use an existing AWS Backup vault instead of creating a new one. | `bool` | `false` | no |
| <a name="input_use_existing_iam_role"></a> [use\_existing\_iam\_role](#input\_use\_existing\_iam\_role) | Whether to use an existing IAM role instead of creating a new one. | `bool` | `false` | no |
| <a name="input_vault_enabled"></a> [vault\_enabled](#input\_vault\_enabled) | Whether to create a new backup vault | `bool` | `true` | no |
| <a name="input_vault_name"></a> [vault\_name](#input\_vault\_name) | Override name for the backup vault | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_backup_plan_arn"></a> [backup\_plan\_arn](#output\_backup\_plan\_arn) | Backup Plan ARN |
| <a name="output_backup_plan_version"></a> [backup\_plan\_version](#output\_backup\_plan\_version) | Unique, randomly generated, Unicode, UTF-8 encoded string that serves as the version ID of the backup plan |
| <a name="output_backup_selection_id"></a> [backup\_selection\_id](#output\_backup\_selection\_id) | Backup Selection ID |
| <a name="output_backup_vault_arn"></a> [backup\_vault\_arn](#output\_backup\_vault\_arn) | Backup Vault ARN |
| <a name="output_backup_vault_id"></a> [backup\_vault\_id](#output\_backup\_vault\_id) | Backup Vault ID |
| <a name="output_role_arn"></a> [role\_arn](#output\_role\_arn) | The Amazon Resource Name (ARN) specifying the role |
| <a name="output_role_name"></a> [role\_name](#output\_role\_name) | The name of the IAM role created |
<!-- END_TF_DOCS -->
