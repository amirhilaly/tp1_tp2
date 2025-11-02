#!/bin/bash

az login --identity --allow-no-subscriptions 1>/dev/null

DB_PASSWORD=$(az keyvault secret show   --vault-name SuperKeyV   --name DBPASSWORD --query "value" | sed 's/"//g')

FLASK_SECRET=$(az keyvault secret show   --vault-name SuperKeyV   --name FLASKSECRET --query "value" | sed 's/"//g')


sed -i "s/DB_PASSWORD=.*/DB_PASSWORD=$DB_PASSWORD/g" /opt/meow/app/.env
sed -i "s/FLASK_SECRET_KEY=.*/FLASK_SECRET_KEY=$FLASK_SECRET/g" /opt/meow/app/.env
