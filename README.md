
### About Shoreline
The Shoreline platform provides real-time monitoring, alerting, and incident automation for cloud operations. Use Shoreline to detect, debug, and automate repairs across your entire fleet in seconds with just a few lines of code.

Shoreline Agents are efficient and non-intrusive processes running in the background of all your monitored hosts. Agents act as the secure link between Shoreline and your environment's Resources, providing real-time monitoring and metric collection across your fleet. Agents can execute actions on your behalf -- everything from simple Linux commands to full remediation playbooks -- running simultaneously across all the targeted Resources.

Since Agents are distributed throughout your fleet and monitor your Resources in real time, when an issue occurs Shoreline automatically alerts your team before your operators notice something is wrong. Plus, when you're ready for it, Shoreline can automatically resolve these issues using Alarms, Actions, Bots, and other Shoreline tools that you configure. These objects work in tandem to monitor your fleet and dispatch the appropriate response if something goes wrong -- you can even receive notifications via the fully-customizable Slack integration.

Shoreline Notebooks let you convert your static runbooks into interactive, annotated, sharable web-based documents. Through a combination of Markdown-based notes and Shoreline's expressive Op language, you have one-click access to real-time, per-second debug data and powerful, fleetwide repair commands.

### What are Shoreline Op Packs?
Shoreline Op Packs are open-source collections of Terraform configurations and supporting scripts that use the Shoreline Terraform Provider and the Shoreline Platform to create turnkey incident automations for common operational issues. Each Op Pack comes with smart defaults and works out of the box with minimal setup, while also providing you and your team with the flexibility to customize, automate, codify, and commit your own Op Pack configurations.

# Azure Web App Performance Downtime or Slowness due to High Traffic
---

This incident type refers to situations where an Azure web app experiences slow performance or downtime due to increased traffic. When the traffic to a web app increases, it can overload the server, causing it to respond slowly or even crash. This can lead to downtime, which can affect the user experience and impact the business. To resolve this issue, the web app can be scaled vertically (scale up/down) or horizontally (scale out/in) based on traffic patterns. Auto-scaling rules can also be configured to handle traffic fluctuations automatically.

### Parameters
```shell
export WEB_APP_NAME="PLACEHOLDER"

export RESOURCE_GROUP_NAME="PLACEHOLDER"

export APP_SERVICE_PLAN_ID="PLACEHOLDER"

export APP_SERVICE_PLAN_NAME="PLACEHOLDER"

export AUTOSCALE_SETTING_NAME="PLACEHOLDER"

export NEW_INSTANCE_SKU="PLACEHOLDER"

export MAX_INSTANCES="PLACEHOLDER"

export MIN_INSTANCES="PLACEHOLDER"
```

## Debug

### Check the current status of the web app:
```shell
az webapp show --name ${WEB_APP_NAME} --resource-group ${RESOURCE_GROUP_NAME} --query "state"
```

### Check the logs of the web app to identify any errors or performance issues:
```shell
az webapp log tail --name ${WEB_APP_NAME} --resource-group ${RESOURCE_GROUP_NAME}
```

### Check the current resource usage of the web app:
```shell
az monitor metrics list --resource ${APP_SERVICE_PLAN_ID} --metric "CpuPercentage" "MemoryPercentage" --interval PT1H
```

### Check the current number of instances of the web app:
```shell
az appservice plan show --name ${APP_SERVICE_PLAN_NAME} --resource-group ${RESOURCE_GROUP_NAME} --query "sku.capacity"
```

### Check the current auto-scaling rules of the web app:
```shell
az monitor autoscale show --name ${AUTOSCALE_SETTING_NAME} --resource-group ${RESOURCE_GROUP_NAME}
```

## Repair

### Scale the web app vertically (scale up/down) to increase its capacity. This involves adding more resources such as RAM, CPU, and storage to the server.
```shell


#!/bin/bash



# Set the App Service Plan name

APP_SERVICE_PLAN_NAME=${APP_SERVICE_PLAN_NAME}



# Set the Azure resource group name

RESOURCE_GROUP=${RESOURCE_GROUP_NAME}



# Set the new instance size for the web app

NEW_INSTANCE_SKU=${NEW_INSTANCE_SKU}



# Scale the web app vertically

az appservice plan update --name $APP_SERVICE_PLAN_NAME --resource-group $RESOURCE_GROUP --sku $NEW_INSTANCE_SKU


```

### Scale the web app horizontally
```shell


#!/bin/bash



# Define variables

RESOURCE_GROUP=${RESOURCE_GROUP_NAME}

PLAN=${APP_SERVICE_PLAN_NAME}

COUNT=${MAX_INSTANCES}



# Scale the web app horizontally

az appservice plan update --number-of-workers $COUNT --name $APP_SERVICE_PLAN_NAME --resource-group $RESOURCE_GROUP
```

### Configure auto-scaling rules to handle traffic fluctuations automatically. This ensures that the web app can handle increased traffic without manually scaling up or down.
```shell


# Define variables

RESOURCE_GROUP=${RESOURCE_GROUP}

APP_SERVICE_PLAN_ID=${APP_SERVICE_PLAN_ID}

AUTOSCALE_SETTING_NAME=${AUTOSCALE_SETTING_NAME}

MIN_INSTANCES=${MIN_INSTANCES}

MAX_INSTANCES=${MAX_INSTANCES}



# Configure auto-scaling settings

az monitor autoscale create \

  --resource-group $RESOURCE_GROUP \

  --resource-id $APP_SERVICE_PLAN_ID \

  --name $AUTOSCALE_SETTING_NAME \

  --min-count $MIN_INSTANCES \

  --max-count $MAX_INSTANCES \

  --count 1 



# Create auto-scaling scale out rule

az monitor autoscale rule create \

  --resource-group $RESOURCE_GROUP \

  --autoscale-name $AUTOSCALE_SETTING_NAME \

  --scale out 1 \

  --condition "Percentage CPU > 75 avg 5m"



# Create auto-scaling scale in rule

az monitor autoscale rule create \

  --resource-group $RESOURCE_GROUP \

  --autoscale-name $AUTOSCALE_SETTING_NAME \

  --scale in 1 \

  --condition "Percentage CPU < 25 avg 5m"
```