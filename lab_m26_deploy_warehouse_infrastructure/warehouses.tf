resource "snowflake_warehouse" "this" {
  for_each = var.warehouses

  name = "${local.name_prefix}_${upper(each.key)}_WH"

  warehouse_size = each.value.size

  auto_suspend = each.value.auto_suspend
  auto_resume  = true

  resource_monitor = snowflake_resource_monitor.this[
    each.value.monitor
  ].name

  comment = "Managed by Terraform - ${var.environment}"
}