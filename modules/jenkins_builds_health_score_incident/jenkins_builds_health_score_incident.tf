resource "shoreline_notebook" "jenkins_builds_health_score_incident" {
  name       = "jenkins_builds_health_score_incident"
  data       = file("${path.module}/data/jenkins_builds_health_score_incident.json")
  depends_on = [shoreline_action.invoke_jenkins_ci_script,shoreline_action.invoke_restart_jenkins_service]
}

resource "shoreline_file" "jenkins_ci_script" {
  name             = "jenkins_ci_script"
  input_file       = "${path.module}/data/jenkins_ci_script.sh"
  md5              = filemd5("${path.module}/data/jenkins_ci_script.sh")
  description      = "Changes made to the codebase that caused compatibility issues with the Jenkins build server."
  destination_path = "/agent/scripts/jenkins_ci_script.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "restart_jenkins_service" {
  name             = "restart_jenkins_service"
  input_file       = "${path.module}/data/restart_jenkins_service.sh"
  md5              = filemd5("${path.module}/data/restart_jenkins_service.sh")
  description      = "Restart the Jenkins server to clear any cache or memory-related issues."
  destination_path = "/agent/scripts/restart_jenkins_service.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_jenkins_ci_script" {
  name        = "invoke_jenkins_ci_script"
  description = "Changes made to the codebase that caused compatibility issues with the Jenkins build server."
  command     = "`chmod +x /agent/scripts/jenkins_ci_script.sh && /agent/scripts/jenkins_ci_script.sh`"
  params      = ["JENKINS_USERNAME","JENKINS_API_TOKEN","JOB_NAME","PROJECT_DIRECTORY","JENKINS_HOSTNAME"]
  file_deps   = ["jenkins_ci_script"]
  enabled     = true
  depends_on  = [shoreline_file.jenkins_ci_script]
}

resource "shoreline_action" "invoke_restart_jenkins_service" {
  name        = "invoke_restart_jenkins_service"
  description = "Restart the Jenkins server to clear any cache or memory-related issues."
  command     = "`chmod +x /agent/scripts/restart_jenkins_service.sh && /agent/scripts/restart_jenkins_service.sh`"
  params      = []
  file_deps   = ["restart_jenkins_service"]
  enabled     = true
  depends_on  = [shoreline_file.restart_jenkins_service]
}

