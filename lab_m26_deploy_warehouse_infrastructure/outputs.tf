output "warehouse_names" {
  description = "Warehouse names"

  value = {
    for k, v in snowflake_warehouse.this :
    k => v.name
  }
}

output "database_names" {
  value = {
    for k, v in snowflake_database.this :
    k => v.name
  }
}

output "schema_names" {
  value = {
    for k, v in snowflake_schema.this :
    k => v.name
  }
}

output "role_names" {
  value = {
    for k, v in snowflake_account_role.this :
    k => v.name
  }
}

output "resource_monitor_names" {
  value = {
    for k, v in snowflake_resource_monitor.this :
    k => v.name
  }
}