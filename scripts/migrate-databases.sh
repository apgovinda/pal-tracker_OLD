#!/usr/bin/env bash
set -e


app_guid=`cf app $1 --guid`
echo " appguid : $app_guid "

credentials=`cf curl /v2/apps/$app_guid/env | jq '.system_env_json.VCAP_SERVICES | if .["p-mysql"] != null then .["p-mysql"] else .["cleardb"] end | .[0].credentials'`

echo "printing credentials... "
echo "credentials : $credentials "

ip_address=`echo $credentials | jq -r '.hostname'`
db_name=`echo $credentials | jq -r '.name'`
db_username=`echo $credentials | jq -r '.username'`
db_password=`echo $credentials | jq -r '.password'`

echo "Opening ssh tunnel to $ip_address"
cf ssh -N -L 63306:$ip_address:3306 $1 &
cf_ssh_pid=$!

echo "Waiting for tunnel"
sleep 5

# Passing this in as a param is a bit strage. Maybe put flyway on the path?
$3/flyway-*/flyway -url="jdbc:mysql://127.0.0.1:63306/$db_name" -locations=filesystem:$2/databases/tracker -user=$db_username -password=$db_password repair migrate 


kill -STOP $cf_ssh_pid
