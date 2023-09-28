resource "shoreline_notebook" "jenkins_builds_health_score_incident" {
  name       = "jenkins_builds_health_score_incident"
  data       = file("${path.module}/data/jenkins_builds_health_score_incident.json")
  depends_on = [shoreline_action.invoke_jenkins_build_trigger,shoreline_action.invoke_restart_jenkins]
}

resource "shoreline_file" "jenkins_build_trigger" {
  name             = "jenkins_build_trigger"
  input_file       = "${path.module}/data/jenkins_build_trigger.sh"
  md5              = filemd5("${path.module}/data/jenkins_build_trigger.sh")
  description      = "Changes made to the codebase that caused compatibility issues with the Jenkins build server."
  destination_path = "/agent/scripts/jenkins_build_trigger.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "restart_jenkins" {
  name             = "restart_jenkins"
  input_file       = "${path.module}/data/restart_jenkins.sh"
  md5              = filemd5("${path.module}/data/restart_jenkins.sh")
  description      = "Restart the Jenkins server to clear any cache or memory-related issues."
  destination_path = "/agent/scripts/restart_jenkins.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_jenkins_build_trigger" {
  name        = "invoke_jenkins_build_trigger"
  description = "Changes made to the codebase that caused compatibility issues with the Jenkins build server."
  command     = "`chmod +x /agent/scripts/jenkins_build_trigger.sh && /agent/scripts/jenkins_build_trigger.sh`"
  params      = ["JOB_NAME","JENKINS_HOSTNAME","JENKINS_USERNAME","JENKINS_API_TOKEN","PROJECT_DIRECTORY"]
  file_deps   = ["jenkins_build_trigger"]
  enabled     = true
  depends_on  = [shoreline_file.jenkins_build_trigger]
}

resource "shoreline_action" "invoke_restart_jenkins" {
  name        = "invoke_restart_jenkins"
  description = "Restart the Jenkins server to clear any cache or memory-related issues."
  command     = "`chmod +x /agent/scripts/restart_jenkins.sh && /agent/scripts/restart_jenkins.sh`"
  params      = []
  file_deps   = ["restart_jenkins"]
  enabled     = true
  depends_on  = [shoreline_file.restart_jenkins]
}

