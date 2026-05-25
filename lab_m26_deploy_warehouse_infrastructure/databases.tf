resource "snowflake_database" "this" {
  for_each = toset(var.database_names)

  name = "${local.name_prefix}_${upper(each.key)}"

  data_retention_time_in_days = var.time_travel_retention_days

  comment = "Terraform managed database"
}

resource "snowflake_schema" "this" {
  for_each = local.database_schemas

  database = snowflake_database.this[each.value.database].name

  name = upper(each.value.schema)

  comment = "Terraform managed schema"

  depends_on = [
    snowflake_database.this
  ]
}