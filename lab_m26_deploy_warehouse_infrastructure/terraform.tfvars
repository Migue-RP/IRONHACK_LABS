snowflake_account  = "VYTWKTY-TC76598"
snowflake_username = "MIGUERP89"
snowflake_password = "xxxxxxx"

environment = "prod"

time_travel_retention_days = 1

warehouses = {
  loading = {
    size           = "MEDIUM"
    auto_suspend   = 300
    monitor        = "loading"
  }

  transform = {
    size           = "LARGE"
    auto_suspend   = 300
    monitor        = "analytics"
  }

  analytics = {
    size           = "LARGE"
    auto_suspend   = 300
    monitor        = "analytics"
  }

  reporting = {
    size           = "SMALL"
    auto_suspend   = 300
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
    credit_quota = 500
  }

  analytics = {
    credit_quota = 1000
  }

  dev = {
    credit_quota = 200
  }
}