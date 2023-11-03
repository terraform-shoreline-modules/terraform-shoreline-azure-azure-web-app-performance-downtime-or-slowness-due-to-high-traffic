resource "shoreline_notebook" "azure_web_app_performance_downtime_or_slowness_due_to_high_traffic" {
  name       = "azure_web_app_performance_downtime_or_slowness_due_to_high_traffic"
  data       = file("${path.module}/data/azure_web_app_performance_downtime_or_slowness_due_to_high_traffic.json")
  depends_on = [shoreline_action.invoke_update_appservice_plan,shoreline_action.invoke_scale_webapp,shoreline_action.invoke_autoscale_config_script]
}

resource "shoreline_file" "update_appservice_plan" {
  name             = "update_appservice_plan"
  input_file       = "${path.module}/data/update_appservice_plan.sh"
  md5              = filemd5("${path.module}/data/update_appservice_plan.sh")
  description      = "Scale the web app vertically (scale up/down) to increase its capacity. This involves adding more resources such as RAM, CPU, and storage to the server."
  destination_path = "/tmp/update_appservice_plan.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "scale_webapp" {
  name             = "scale_webapp"
  input_file       = "${path.module}/data/scale_webapp.sh"
  md5              = filemd5("${path.module}/data/scale_webapp.sh")
  description      = "Scale the web app horizontally"
  destination_path = "/tmp/scale_webapp.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "autoscale_config_script" {
  name             = "autoscale_config_script"
  input_file       = "${path.module}/data/autoscale_config_script.sh"
  md5              = filemd5("${path.module}/data/autoscale_config_script.sh")
  description      = "Configure auto-scaling rules to handle traffic fluctuations automatically. This ensures that the web app can handle increased traffic without manually scaling up or down."
  destination_path = "/tmp/autoscale_config_script.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_update_appservice_plan" {
  name        = "invoke_update_appservice_plan"
  description = "Scale the web app vertically (scale up/down) to increase its capacity. This involves adding more resources such as RAM, CPU, and storage to the server."
  command     = "`chmod +x /tmp/update_appservice_plan.sh && /tmp/update_appservice_plan.sh`"
  params      = ["NEW_INSTANCE_SKU","APP_SERVICE_PLAN_NAME","RESOURCE_GROUP_NAME"]
  file_deps   = ["update_appservice_plan"]
  enabled     = true
  depends_on  = [shoreline_file.update_appservice_plan]
}

resource "shoreline_action" "invoke_scale_webapp" {
  name        = "invoke_scale_webapp"
  description = "Scale the web app horizontally"
  command     = "`chmod +x /tmp/scale_webapp.sh && /tmp/scale_webapp.sh`"
  params      = ["APP_SERVICE_PLAN_NAME","RESOURCE_GROUP_NAME","MAX_INSTANCES"]
  file_deps   = ["scale_webapp"]
  enabled     = true
  depends_on  = [shoreline_file.scale_webapp]
}

resource "shoreline_action" "invoke_autoscale_config_script" {
  name        = "invoke_autoscale_config_script"
  description = "Configure auto-scaling rules to handle traffic fluctuations automatically. This ensures that the web app can handle increased traffic without manually scaling up or down."
  command     = "`chmod +x /tmp/autoscale_config_script.sh && /tmp/autoscale_config_script.sh`"
  params      = ["MIN_INSTANCES","AUTOSCALE_SETTING_NAME","APP_SERVICE_PLAN_ID","MAX_INSTANCES"]
  file_deps   = ["autoscale_config_script"]
  enabled     = true
  depends_on  = [shoreline_file.autoscale_config_script]
}

