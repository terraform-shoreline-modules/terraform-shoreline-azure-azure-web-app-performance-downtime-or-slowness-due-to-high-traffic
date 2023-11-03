

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