locals {
  common_tags = {
    environment = var.environment
    managed_by  = "terraform"
    project     = "streampulse"
  }

  name_prefix = upper(var.environment)

  role_hierarchy = {
    data_admin = ["transformer", "analyst"]
    transformer = ["loader"]
    analyst = ["reporter"]
  }

  database_schemas = {
    for pair in setproduct(var.database_names, var.schema_names) :
    "${pair[0]}_${pair[1]}" => {
      database = pair[0]
      schema   = pair[1]
    }
  }
}