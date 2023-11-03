

#!/bin/bash



# Set the App Service Plan name

APP_SERVICE_PLAN_NAME=${APP_SERVICE_PLAN_NAME}



# Set the Azure resource group name

RESOURCE_GROUP=${RESOURCE_GROUP_NAME}



# Set the new instance size for the web app

NEW_INSTANCE_SKU=${NEW_INSTANCE_SKU}



# Scale the web app vertically

az appservice plan update --name $APP_SERVICE_PLAN_NAME --resource-group $RESOURCE_GROUP --sku $NEW_INSTANCE_SKU