resource "snowflake_resource_monitor" "this" {
  for_each = var.resource_monitors

  name         = "${local.name_prefix}_${upper(each.key)}_MONITOR"
  credit_quota = each.value.credit_quota

  frequency       = "MONTHLY"
  start_timestamp = "IMMEDIATELY"

  notify_triggers = [75, 90]
  suspend_trigger = 100
}