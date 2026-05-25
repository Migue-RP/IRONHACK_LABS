#############################################
# Warehouse Grants
#############################################

resource "snowflake_grant_privileges_to_account_role" "loader_wh" {
  privileges        = ["USAGE"]
  account_role_name = snowflake_account_role.this["loader"].name

  on_account_object {
    object_type = "WAREHOUSE"
    object_name = snowflake_warehouse.this["loading"].name
  }
}

resource "snowflake_grant_privileges_to_account_role" "transform_wh" {
  privileges        = ["USAGE"]
  account_role_name = snowflake_account_role.this["transformer"].name

  on_account_object {
    object_type = "WAREHOUSE"
    object_name = snowflake_warehouse.this["transform"].name
  }
}

resource "snowflake_grant_privileges_to_account_role" "analytics_wh" {
  privileges        = ["USAGE"]
  account_role_name = snowflake_account_role.this["analyst"].name

  on_account_object {
    object_type = "WAREHOUSE"
    object_name = snowflake_warehouse.this["analytics"].name
  }
}

resource "snowflake_grant_privileges_to_account_role" "reporting_wh" {
  privileges        = ["USAGE"]
  account_role_name = snowflake_account_role.this["reporter"].name

  on_account_object {
    object_type = "WAREHOUSE"
    object_name = snowflake_warehouse.this["reporting"].name
  }
}

resource "snowflake_grant_privileges_to_account_role" "dev_wh" {
  privileges        = ["USAGE"]
  account_role_name = snowflake_account_role.this["developer"].name

  on_account_object {
    object_type = "WAREHOUSE"
    object_name = snowflake_warehouse.this["dev"].name
  }
}

#############################################
# Schema Grants
#############################################

resource "snowflake_grant_privileges_to_account_role" "loader_raw" {
  for_each = {
    for k, v in snowflake_schema.this :
    k => v if v.name == "RAW"
  }

  privileges        = ["USAGE", "CREATE TABLE"]
  account_role_name = snowflake_account_role.this["loader"].name

  on_schema {
    schema_name = "${each.value.database}.${each.value.name}"
  }
}

resource "snowflake_grant_privileges_to_account_role" "transformer_schema" {
  for_each = {
    for k, v in snowflake_schema.this :
    k => v if contains(["STAGING", "ANALYTICS"], v.name)
  }

  privileges        = ["USAGE"]
  account_role_name = snowflake_account_role.this["transformer"].name

  on_schema {
    schema_name = "${each.value.database}.${each.value.name}"
  }
}

resource "snowflake_grant_privileges_to_account_role" "analyst_schema" {
  for_each = {
    for k, v in snowflake_schema.this :
    k => v if contains(["ANALYTICS", "MARTS"], v.name)
  }

  privileges        = ["USAGE"]
  account_role_name = snowflake_account_role.this["analyst"].name

  on_schema {
    schema_name = "${each.value.database}.${each.value.name}"
  }
}

resource "snowflake_grant_privileges_to_account_role" "data_admin_all" {
  for_each = snowflake_schema.this

  privileges        = ["ALL PRIVILEGES"]
  account_role_name = snowflake_account_role.this["data_admin"].name

  on_schema {
    schema_name = "${each.value.database}.${each.value.name}"
  }
}