variable "project_id" {
  type = string
}

variable "application" {
  type = list(object({
    id                  = number
    location_id         = string
    auth_domain         = optional(string)
    database_type       = optional(string)
    serving_status      = optional(string)
    split_health_checks = optional(bool)
    iap = optional(list(object({
      oauth2_client_id     = string
      oauth2_client_secret = string
    })), [])
  }))
  default     = []
  description = <<EOF
  EOF

  validation {
    condition = length([
      for a in var.application : true if contains(["CLOUD_FIRESTORE", "CLOUD_DATASTORE_COMPATIBILITY"], a.database_type)
    ]) == length(var.application)
    error_message = "Valid values are CLOUD_FIRESTORE or CLOUD_DATABASE_COMPATIBILITY."
  }
}

variable "application_url_dispatch_rules" {
  type = list(object({
    id = number
    dispatch_rules = optional(list(object({
      path       = string
      service_id = number
      domain     = optional(string)
    })), [])
  }))
  default     = []
  description = <<EOF
  EOF
}

variable "domain_mapping" {
  type = list(object({
    id                = number
    domain_name       = string
    override_strategy = optional(string)
    ssl_settings = optional(list(object({
      ssl_management_type = string
      certificate_id      = optional(string)
    })), [])
  }))
  default     = []
  description = <<EOF
  EOF

  validation {
    condition = length([
      for a in var.domain_mapping : true if contains(["STRICT", "OVERRIDE"], a.override_strategy)
    ]) == length(var.domain_mapping)
    error_message = "Valid values are STRICT or OVERRIDE."
  }

  validation {
    condition = length([
      for b in var.domain_mapping : true if contains(["AUTOMATIC", "MANUAL"], b.ssl_settings.ssl_management_type)
    ]) == length(var.domain_mapping)
    error_message = "Valid values are AUTOMATIC or MANUAL."
  }
}

variable "firewall_rule" {
  type = list(object({
    id           = number
    action       = string
    source_range = string
    description  = optional(string)
    priority     = optional(number)
  }))
  default     = []
  description = <<EOF
  EOF

  validation {
    condition = length([
      for a in var.firewall_rule : true if contains(["UNSPECIFIED_ACTION", "ALLOW", "DENY"], a.action)
    ]) == length(var.firewall_rule)
    error_message = "Possible values are: UNSPECIFIED_ACTION, ALLOW, DENY."
  }
}

variable "flexible_app_version" {
  type = list(object({
    id                           = number
    runtime                      = string
    service                      = string
    version_id                   = optional(string)
    inbound_services             = optional(list(string))
    instance_class               = optional(string)
    runtime_api_version          = optional(string)
    runtime_channel              = optional(string)
    runtime_main_executable_path = optional(string)
    serving_status               = optional(string)
    env_variables                = optional(map(string))
    default_expiration           = optional(string)
    nobuild_files_regex          = optional(string)
    noop_on_destroy              = optional(bool)
    shell                        = optional(string)
    manual_scaling_instances     = optional(number)
    vpc_access_connector_name    = optional(string)
    liveness_check = list(object({
      path              = string
      host              = string
      failure_threshold = optional(number)
      success_threshold = optional(number)
      check_interval    = optional(string)
      timeout           = optional(string)
      initial_delay     = optional(string)
    }))
    readiness_check = list(object({
      path              = string
      host              = string
      failure_threshold = optional(number)
      success_threshold = optional(number)
      check_interval    = optional(string)
      timeout           = optional(string)
      app_start_timeout = optional(string)
    }))
    deployment = optional(list(object({
      zip = optional(list(object({
        source_url  = string
        files_count = optional(number)
      })), [])
      files = optional(list(object({
        name       = string
        source_url = string
        sha1_sum   = optional(string)
      })), [])
      container = optional(list(object({
        image = string
      })), [])
      cloud_build_options = optional(list(object({
        app_yaml_path       = string
        cloud_build_timeout = optional(string)
      })), [])
    })), [])
    api_config = optional(list(object({
      script           = string
      auth_fail_action = optional(string)
      login            = optional(string)
      security_level   = optional(string)
      url              = optional(string)
    })), [])
    automatic_scaling = optional(list(object({
      cool_down_period        = optional(string)
      max_concurrent_requests = optional(number)
      max_idle_instances      = optional(number)
      max_pending_latency     = optional(string)
      max_total_instances     = optional(number)
      min_idle_instances      = optional(number)
      min_pending_latency     = optional(string)
      min_total_instances     = optional(number)
      network_utilization = optional(list(object({
        target_received_bytes_per_second   = optional(number)
        target_received_packets_per_second = optional(number)
        target_sent_bytes_per_second       = optional(number)
        target_sent_packets_per_second     = optional(number)
      })), [])
      disk_utilization = optional(list(object({
        target_read_bytes_per_second  = optional(number)
        target_read_ops_per_second    = optional(number)
        target_write_bytes_per_second = optional(number)
        target_write_ops_per_second   = optional(number)
      })), [])
      request_utilization = optional(list(object({
        target_concurrent_requests      = optional(number)
        target_request_count_per_second = optional(string)
      })), [])
      cpu_utilization = optional(list(object({
        target_utilization        = optional(number)
        aggregation_window_length = optional(string)
      })), [])
    })), [])
    endpoints_api_service = optional(list(object({
      name                   = string
      config_id              = optional(string)
      rollout_strategy       = optional(string)
      disable_trace_sampling = optional(bool)
    })), [])
    handlers = optional(list(object({
      url_regex                   = optional(string)
      security_level              = optional(string)
      login                       = optional(string)
      auth_fail_action            = optional(string)
      redirect_http_response_code = optional(string)
      script_path                 = optional(string)
      static_files = optional(list(object({
        path                  = optional(string)
        upload_path_regex     = optional(string)
        http_headers          = optional(map(string))
        mime_type             = optional(string)
        expiration            = optional(string)
        require_matching_file = optional(bool)
        application_readable  = optional(bool)
      })), [])
    })), [])
    network = optional(list(object({
      name             = string
      forwarded_ports  = optional(list(string))
      instance_tag     = optional(string)
      session_affinity = optional(bool)
      subnetwork       = optional(string)
    })), [])
    resources = optional(list(object({
      cpu       = optional(number)
      disk_gb   = optional(number)
      memory_gb = optional(number)
      volumes = optional(list(object({
        name        = string
        size_gb     = number
        volume_type = string
      })), [])
    })), [])
  }))
  default     = []
  description = <<EOF
  EOF

  validation {
    condition = length([
      for a in var.flexible_app_version : true if contains(["INBOUND_SERVICE_MAIL", "INBOUND_SERVICE_MAIL_BOUNCE", "INBOUND_SERVICE_XMPP_ERROR", "INBOUND_SERVICE_XMPP_MESSAGE", "INBOUND_SERVICE_XMPP_SUBSCRIBE", "INBOUND_SERVICE_XMPP_PRESENCE", "INBOUND_SERVICE_CHANNEL_PRESENCE", "INBOUND_SERVICE_WARMUP"], a.inbound_services)
    ]) == length(var.flexible_app_version)
    error_message = "Each value may be one of: INBOUND_SERVICE_MAIL, INBOUND_SERVICE_MAIL_BOUNCE, INBOUND_SERVICE_XMPP_ERROR, INBOUND_SERVICE_XMPP_MESSAGE, INBOUND_SERVICE_XMPP_SUBSCRIBE, INBOUND_SERVICE_XMPP_PRESENCE, INBOUND_SERVICE_CHANNEL_PRESENCE, INBOUND_SERVICE_WARMUP."
  }

  validation {
    condition = length([
      for b in var.flexible_app_version : true if contains(["F1", "F2", "F4", "F4_1G", "B1", "B2", " B4", "B8", "B4_1G"], b.instance_class)
    ]) == length(var.flexible_app_version)
    error_message = "Valid values are AutomaticScaling: F1, F2, F4, F4_1G ManualScaling: B1, B2, B4, B8, B4_1G."
  }

  validation {
    condition = length([
      for c in var.flexible_app_version : true if contains(["SERVING", "STOPPED"], c.serving_status)
    ]) == length(var.flexible_app_version)
    error_message = " Possible values are: SERVING, STOPPED."
  }

  validation {
    condition = length([
      for d in var.flexible_app_version : true if contains(["python", "java", "php", "ruby", "go", "nodejs"], d.runtime_api_version)
    ]) == length(var.flexible_app_version)
    error_message = "Please see the app.yaml reference for valid values at https://cloud.google.com/appengine/docs/standard/<language>/config/appref Substitute <language> with python, java, php, ruby, go or nodejs."
  }

  validation {
    condition = length([
      for e in var.flexible_app_version : true if contains(["SECURE_DEFAULT", "SECURE_NEVER", "SECURE_OPTIONAL", "SECURE_ALWAYS"], e.handlers.security_level)
    ]) == length(var.flexible_app_version)
    error_message = "Possible values are: SECURE_DEFAULT, SECURE_NEVER, SECURE_OPTIONAL, SECURE_ALWAYS."
  }

  validation {
    condition = length([
      for f in var.flexible_app_version : true if contains(["LOGIN_OPTIONAL", "LOGIN_ADMIN", "LOGIN_REQUIRED"], f.handlers.login)
    ]) == length(var.flexible_app_version)
    error_message = "Possible values are: LOGIN_OPTIONAL, LOGIN_ADMIN, LOGIN_REQUIRED."
  }

  validation {
    condition = length([
      for g in var.flexible_app_version : true if contains(["AUTH_FAIL_ACTION_REDIRECT", "AUTH_FAIL_ACTION_UNAUTHORIZED"], g.handlers.auth_fail_action)
    ]) == length(var.flexible_app_version)
    error_message = "Possible values are: AUTH_FAIL_ACTION_REDIRECT, AUTH_FAIL_ACTION_UNAUTHORIZED."
  }

  validation {
    condition = length([
      for h in var.flexible_app_version : true if contains(["REDIRECT_HTTP_RESPONSE_CODE_301", "REDIRECT_HTTP_RESPONSE_CODE_302", "REDIRECT_HTTP_RESPONSE_CODE_303", "REDIRECT_HTTP_RESPONSE_CODE_307"], h.handlers.redirect_http_response_code)
    ])
    error_message = "Possible values are: REDIRECT_HTTP_RESPONSE_CODE_301, REDIRECT_HTTP_RESPONSE_CODE_302, REDIRECT_HTTP_RESPONSE_CODE_303, REDIRECT_HTTP_RESPONSE_CODE_307."
  }

  validation {
    condition = length([
      for i in var.flexible_app_version : true if contains(["LOGIN_OPTIONAL", "LOGIN_ADMIN", "LOGIN_REQUIRED"], i.api_config.login)
    ]) == length(var.flexible_app_version)
    error_message = "Possible values are: LOGIN_OPTIONAL, LOGIN_ADMIN, LOGIN_REQUIRED."
  }

  validation {
    condition = length([
      for j in var.flexible_app_version : true if contains(["AUTH_FAIL_ACTION_REDIRECT", "AUTH_FAIL_ACTION_UNAUTHORIZED"], j.api_config.auth_fail_action)
    ]) == length(var.flexible_app_version)
    error_message = "Possible values are: AUTH_FAIL_ACTION_REDIRECT, AUTH_FAIL_ACTION_UNAUTHORIZED."
  }

  validation {
    condition = length([
      for k in var.flexible_app_version : true if contains(["SECURE_DEFAULT", "SECURE_NEVER", "SECURE_OPTIONAL", "SECURE_ALWAYS"], k.api_config.security_level)
    ]) == length(var.flexible_app_version)
    error_message = "Possible values are: SECURE_DEFAULT, SECURE_NEVER, SECURE_OPTIONAL, SECURE_ALWAYS."
  }

  validation {
    condition = length([
      for l in var.flexible_app_version : true if contains(["FIXED", "MANAGED"], l.endpoints_api_service.rollout_strategy)
    ]) == length(var.flexible_app_version)
    error_message = "Possible values are: FIXED, MANAGED."
  }
}

variable "service_network_settings" {
  type = list(object({
    id                      = number
    service_id              = any
    ingress_traffic_allowed = optional(string)
  }))
  default     = []
  description = <<EOF
  EOF

  validation {
    condition = length([
      for a in var.service_network_settings : true if contains(["INGRESS_TRAFFIC_ALLOWED_UNSPECIFIED", "INGRESS_TRAFFIC_ALLOWED_ALL", "INGRESS_TRAFFIC_ALLOWED_INTERNAL_ONLY", "INGRESS_TRAFFIC_ALLOWED_INTERNAL_AND_LB"], a.ingress_traffic_allowed)
    ]) == length(var.flexible_app_version)
    error_message = "Possible values are: INGRESS_TRAFFIC_ALLOWED_UNSPECIFIED, INGRESS_TRAFFIC_ALLOWED_ALL, INGRESS_TRAFFIC_ALLOWED_INTERNAL_ONLY, INGRESS_TRAFFIC_ALLOWED_INTERNAL_AND_LB."
  }
}

variable "service_split_traffic" {
  type = list(object({
    id              = number
    service_id      = number
    migrate_traffic = optional(bool)
    split = list(object({
      allocations   = any
      app_engine_id = any
      shard_by      = optional(string)
    }))
  }))
  default     = []
  description = <<EOF
  EOF

  validation {
    condition = length([
      for a in var.service_split_traffic : true if contains(["UNSPECIFIED", "COOKIE", "IP", "RANDOM"], a.split.shard_by)
    ]) == length(var.service_split_traffic)
    error_message = "Possible values are: UNSPECIFIED, COOKIE, IP, RANDOM."
  }
}

variable "standard_app_version" {
  type = list(object({
    id                        = number
    runtime                   = string
    service                   = string
    version_id                = optional(string)
    threadsafe                = optional(bool)
    runtime_api_version       = optional(string)
    env_variables             = optional(map(string))
    inbound_services          = optional(list(string))
    instance_class            = optional(string)
    noop_on_destroy           = optional(bool)
    delete_service_on_destroy = optional(bool)
    entrypoint_shell          = string
    vpc_access_connector_name = optional(string)
    manual_scaling_instances  = optional(number)
    deployment = optional(list(object({
      zip = optional(list(object({
        source_url  = string
        files_count = optional(number)
      })), [])
      files = optional(list(object({
        name       = string
        source_url = string
        sha1_sum   = optional(string)
      })), [])
    })), [])
    handlers = optional(list(object({
      url_regex                   = optional(string)
      security_level              = optional(string)
      login                       = optional(string)
      auth_fail_action            = optional(string)
      redirect_http_response_code = optional(string)
      script_path                 = optional(string)
      static_files = optional(list(object({
        path                  = optional(string)
        upload_path_regex     = optional(string)
        http_headers          = optional(map(string))
        mime_type             = optional(string)
        expiration            = optional(string)
        require_matching_file = optional(bool)
        application_readable  = optional(bool)
      })), [])
    })), [])
    libraries = optional(list(object({
      name    = optional(string)
      version = optional(string)
    })), [])
    automatic_scaling = optional(list(object({
      max_concurrent_requests = optional(number)
      max_idle_instances      = optional(number)
      max_pending_latency     = optional(string)
      min_idle_instances      = optional(number)
      min_pending_latency     = optional(string)
      standard_scheduler_settings = optional(list(object({
        target_cpu_utilization        = optional(number)
        target_throughput_utilization = optional(number)
        max_instances                 = optional(number)
        min_instances                 = optional(number)
      })), [])
    })), [])
    basic_scaling = optional(list(object({
      max_instances = number
      idle_timeout  = optional(string)
    })), [])
  }))
  default     = []
  description = <<EOF
  EOF
}