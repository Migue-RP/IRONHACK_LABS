resource "snowflake_account_role" "this" {
  for_each = toset(var.role_names)

  name    = "${local.name_prefix}_${upper(each.key)}"
  comment = "Terraform managed role"
}

########################################
# Role hierarchy
########################################

resource "snowflake_grant_account_role" "transformer_to_loader" {
  role_name        = snowflake_account_role.this["loader"].name
  parent_role_name = snowflake_account_role.this["transformer"].name
}

resource "snowflake_grant_account_role" "analyst_to_reporter" {
  role_name        = snowflake_account_role.this["reporter"].name
  parent_role_name = snowflake_account_role.this["analyst"].name
}

resource "snowflake_grant_account_role" "data_admin_to_transformer" {
  role_name        = snowflake_account_role.this["transformer"].name
  parent_role_name = snowflake_account_role.this["data_admin"].name
}

resource "snowflake_grant_account_role" "data_admin_to_analyst" {
  role_name        = snowflake_account_role.this["analyst"].name
  parent_role_name = snowflake_account_role.this["data_admin"].name
}

resource "snowflake_grant_account_role" "accountadmin_to_data_admin" {
  role_name        = snowflake_account_role.this["data_admin"].name
  parent_role_name = "ACCOUNTADMIN"
}