
### About Shoreline
The Shoreline platform provides real-time monitoring, alerting, and incident automation for cloud operations. Use Shoreline to detect, debug, and automate repairs across your entire fleet in seconds with just a few lines of code.

Shoreline Agents are efficient and non-intrusive processes running in the background of all your monitored hosts. Agents act as the secure link between Shoreline and your environment's Resources, providing real-time monitoring and metric collection across your fleet. Agents can execute actions on your behalf -- everything from simple Linux commands to full remediation playbooks -- running simultaneously across all the targeted Resources.

Since Agents are distributed throughout your fleet and monitor your Resources in real time, when an issue occurs Shoreline automatically alerts your team before your operators notice something is wrong. Plus, when you're ready for it, Shoreline can automatically resolve these issues using Alarms, Actions, Bots, and other Shoreline tools that you configure. These objects work in tandem to monitor your fleet and dispatch the appropriate response if something goes wrong -- you can even receive notifications via the fully-customizable Slack integration.

Shoreline Notebooks let you convert your static runbooks into interactive, annotated, sharable web-based documents. Through a combination of Markdown-based notes and Shoreline's expressive Op language, you have one-click access to real-time, per-second debug data and powerful, fleetwide repair commands.

### What are Shoreline Op Packs?
Shoreline Op Packs are open-source collections of Terraform configurations and supporting scripts that use the Shoreline Terraform Provider and the Shoreline Platform to create turnkey incident automations for common operational issues. Each Op Pack comes with smart defaults and works out of the box with minimal setup, while also providing you and your team with the flexibility to customize, automate, codify, and commit your own Op Pack configurations.

# Jenkins builds health score incident.
---

This incident type relates to issues with the health score of Jenkins builds. It could indicate that the builds are failing or not performing optimally. The incident could be triggered by failures in the health check process for a specific instance of Jenkins, and it may require investigation and remediation to restore normal operation.

### Parameters
```shell
export JENKINS_HOSTNAME="PLACEHOLDER"

export JENKINS_USERNAME="PLACEHOLDER"

export JENKINS_API_TOKEN="PLACEHOLDER"

export JOB_NAME="PLACEHOLDER"

export INSTANCE_NAME="PLACEHOLDER"

export METRICS_ENDPOINT="PLACEHOLDER"

export PROJECT_DIRECTORY="PLACEHOLDER"
```

## Debug

### Check if Jenkins is running
```shell
systemctl status jenkins
```

### Check if Jenkins is reachable from the affected instance
```shell
ping ${JENKINS_HOSTNAME}
```

### Check if the Jenkins plugin for the affected instance is installed and updated
```shell
java -jar jenkins-cli.jar -s https://${JENKINS_HOSTNAME}/ list-plugins
```

### Check if the Jenkins job is configured correctly
```shell
curl -X GET -u ${JENKINS_USERNAME}:${JENKINS_API_TOKEN} https://${JENKINS_HOSTNAME}/job/${JOB_NAME}/config.xml
```

### Check the Jenkins logs for errors
```shell
tail -f /var/log/jenkins/jenkins.log
```

### Check the health score metrics for the affected instance
```shell
curl -X GET https://${METRICS_ENDPOINT}/${INSTANCE_NAME}/health
```

### Changes made to the codebase that caused compatibility issues with the Jenkins build server.
```shell


#!/bin/bash



# Set variables

PROJECT_DIRECTORY=${PROJECT_DIRECTORY}

JENKINS_URL=${JENKINS_HOSTNAME}

JENKINS_USERNAME=${JENKINS_USERNAME}

JENKINS_PASSWORD=${JENKINS_API_TOKEN}



# Step 1: Verify code changes

cd $PROJECT_DIRECTORY

git pull origin master # or whichever branch is being used

if [ $? -ne 0 ]; then

  echo "Error: Failed to pull latest changes from git"

  exit 1

fi



# Step 2: Build code locally

./build.sh # or any other build script used

if [ $? -ne 0 ]; then

  echo "Error: Failed to build code locally"

  exit 1

fi



# Step 3: Verify Jenkins build server configuration

curl -sSL -u $JENKINS_USERNAME:$JENKINS_PASSWORD https://$JENKINS_URL/api/json | jq '.jobs[] | select(.name == "${JOB_NAME}") | .color' # replace ${JOB_NAME} with the name of the Jenkins job

if [ $? -ne 0 ]; then

  echo "Error: Failed to verify Jenkins build server configuration"

  exit 1

fi



# Step 4: Trigger Jenkins build

curl -sSL -u $JENKINS_USERNAME:$JENKINS_PASSWORD -X POST https://$JENKINS_URL/job/${JOB_NAME}/build # replace ${JOB_NAME} with the name of the Jenkins job

if [ $? -ne 0 ]; then

  echo "Error: Failed to trigger Jenkins build"

  exit 1

fi



# Step 5: Monitor Jenkins build logs

curl -sSL -u $JENKINS_USERNAME:$JENKINS_PASSWORD https://$JENKINS_URL/job/${JOB_NAME}/lastBuild/consoleText # replace ${JOB_NAME} with the name of the Jenkins job

if [ $? -ne 0 ]; then

  echo "Error: Failed to monitor Jenkins build logs"

  exit 1

fi



echo "Success: Diagnosis complete"

exit 0


```

## Repair

### Restart the Jenkins server to clear any cache or memory-related issues.
```shell


#!/bin/bash

sudo systemctl restart jenkins.service


```