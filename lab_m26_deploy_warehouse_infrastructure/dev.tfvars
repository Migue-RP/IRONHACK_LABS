snowflake_account  = "VYTWKTY-TC76598"
snowflake_username = "MIGUERP89"
snowflake_password = "Ciaoitalia.07!"

environment = "dev"

time_travel_retention_days = 1

warehouses = {
  loading = {
    size           = "SMALL"
    auto_suspend   = 60
    monitor        = "loading"
  }

  transform = {
    size           = "MEDIUM"
    auto_suspend   = 60
    monitor        = "analytics"
  }

  analytics = {
    size           = "MEDIUM"
    auto_suspend   = 60
    monitor        = "analytics"
  }

  reporting = {
    size           = "XSMALL"
    auto_suspend   = 60
    monitor        = "analytics"
  }

  dev = {
    size           = "XSMALL"
    auto_suspend   = 60
    monitor        = "dev"
  }
}

resource_monitors = {
  loading = {
    credit_quota = 100
  }

  analytics = {
    credit_quota = 300
  }

  dev = {
    credit_quota = 50
  }
}