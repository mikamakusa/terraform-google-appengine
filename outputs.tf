output "applications" {
  value = {
    for a in google_app_engine_application.this : a => {
      id                = a.id
      name              = a.name
      app_id            = a.app_id
      auth_domain       = a.auth_domain
      code_bucket       = a.code_bucket
      database_type     = a.database_type
      default_bucket    = a.default_bucket
      default_hostname  = a.default_hostname
      feature_settings  = a.feature_settings
      serving_status    = a.serving_status
      url_dispatch_rule = a.url_dispatch_rule
    }
  }
}

output "app_versions" {
  value = {
    for a in google_app_engine_standard_app_version.this : a => {
      version_id                = a.version_id
      name                      = a.name
      id                        = a.id
      deployment                = a.deployment
      app_engine_apis           = a.app_engine_apis
      automatic_scaling         = a.automatic_scaling
      basic_scaling             = a.basic_scaling
      delete_service_on_destroy = a.delete_service_on_destroy
      entrypoint                = a.entrypoint
      env_variables             = a.env_variables
      inbound_services          = a.inbound_services
      instance_class            = a.instance_class
      manual_scaling            = a.manual_scaling
      runtime                   = a.runtime
      runtime_api_version       = a.runtime_api_version
    }
  }
}

output "split_traffic" {
  value = {
    for a in google_app_engine_service_split_traffic.this : a => {
      id              = a.id
      migrate_traffic = a.migrate_traffic
      service         = a.service
      split           = a.split
    }
  }
}

output "network_settings" {
  value = {
    for a in google_app_engine_service_network_settings.this : a => {
      id               = a.id
      network_settings = a.network_settings
    }
  }
}

output "flexible_app" {
  value = {
    for a in google_app_engine_flexible_app_version.this : a => {
      id                        = a.id
      version_id                = a.version_id
      deployment                = a.deployment
      automatic_scaling         = a.automatic_scaling
      delete_service_on_destroy = a.delete_service_on_destroy
      entrypoint                = a.entrypoint
      env_variables             = a.env_variables
      inbound_services          = a.inbound_services
      instance_class            = a.instance_class
      manual_scaling            = a.manual_scaling
      runtime                   = a.runtime
      runtime_api_version       = a.runtime_api_version
    }
  }
}

output "firewall_rule" {
  value = {
    for a in google_app_engine_firewall_rule.this : a => {
      id           = a.id
      source_range = a.source_range
      action       = a.action
      priority     = a.priority
    }
  }
}

output "domain_mappings" {
  value = {
    for a in google_app_engine_domain_mapping.this : a => {
      id                = a.id
      name              = a.name
      domain_name       = a.domain_name
      override_strategy = a.override_strategy
      resource_records  = a.resource_records
      ssl_settings      = a.ssl_settings
    }
  }
}

output "url_dispatch_rules" {
  value = {
    for a in google_app_engine_application_url_dispatch_rules.this : a => {
      id             = a.id
      dispatch_rules = a.dispatch_rules
    }
  }
}