

#!/bin/bash



# Define variables

RESOURCE_GROUP=${RESOURCE_GROUP_NAME}

PLAN=${APP_SERVICE_PLAN_NAME}

COUNT=${MAX_INSTANCES}



# Scale the web app horizontally

az appservice plan update --number-of-workers $COUNT --name $APP_SERVICE_PLAN_NAME --resource-group $RESOURCE_GROUP