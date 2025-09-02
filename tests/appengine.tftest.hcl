run "setup_tests" {
  module {
    source = "./tests/setup"
  }
}

run "appengine" {

    variables {
      project_id = "appengine-project-test"
      application = [{
        id          = "0"
        location_id = "us-central"
      }]
      application_url_dispatch_rules = [{
        id = "0"
        dispatch_rules = [
          {
            domain  = "*"
            path    = "/*"
            service = "default"
          }
        ]
      }]
      domain_mapping = [{
        id          = "0"
        domain_name = "verified-domain.com"
        ssl_settings = [
          {
            ssl_management_type = "AUTOMATIC"
          }
        ]
      }]
      firewall_rule = [{
        id            = "0"
        priority      = 1000
        action        = "ALLOW"
        source_range  = "*"
      }]
      flexible_app_version = [{
        id                = "0"
        version_id        = "v1"
        service           = "default"
        runtime           = "nodejs"
        entrypoint_shell  = "node ./app.js"
        deployment = [{
          zip = [{
            source_url = "https://storage.googleapis.com/${google_storage_bucket.bucket.name}/${google_storage_bucket_object.object.name}"
          }]
        }]
        liveness_check = [
          {
            path = "/"
          }
        ]
        readiness_check = [
          {
            path = "/"
          }
        ]
        handlers = [{
          url_regex        = ".*\\/my-path\\/*"
          security_level   = "SECURE_ALWAYS"
          login            = "LOGIN_REQUIRED"
          auth_fail_action = "AUTH_FAIL_ACTION_REDIRECT"
          static_files = [
            {
              path              = "my-other-path"
              upload_path_regex = ".*\\/my-path\\/*"
            }
          ]
        }]
        automatic_scaling = [{
          cool_down_period = "120s"
          cpu_utilization = [
            {
              target_utilization = 0.5
            }]
        }]
      }]
      service_network_settings = [{
        id          = "0"
        service_id  = "0"
        network_settings = [
          {
            ingress_traffic_allowed = "INGRESS_TRAFFIC_ALLOWED_INTERNAL_ONLY"
          }
        ]
      }]
    }
}