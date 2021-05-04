
set -e

echo "Getting aggregator route/host."
AGGREGATOR_HOST=`oc get route -o json | jq -r .items[0].spec.host`

# Aggregate results
#########################################
echo "Aggregating results..."
curl -X PUT http://$AGGREGATOR_HOST/api/aggregator/commands/aggregate

echo "Done!"

echo "View the report: http://$AGGREGATOR_HOST/w/report"