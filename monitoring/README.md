# Basic Monitoring Infrastructure for Apicurio Registry

This Monitoring Stack is meant to be deployed together with Apicurio Registry in the same cluster.

One of the most important configuration files is `01-infra/01-service-monitors.yaml` . This enables the monitoring of the Apicurio Registry deployment in the namespace `apicurio-registry-sql`

*Note. You may need to change that namespace if your Apicurio Registry is deployed into a different namespace*

# Steps

First deploy the operators required to provision the monitoring infra.
```
oc apply -f 00-operators
```

```
$ oc get pod -n registry-monitoring
NAME                                   READY   STATUS    RESTARTS   AGE
grafana-operator-558968c88f-q69dw      1/1     Running   0          23s
prometheus-operator-66fcc75b4d-vcwvd   1/1     Running   0          48s
```


Then, after the operators are installed we can run
```
oc apply -f 01-infra
```

You can get the prometheus and grafana URLs with
```
$ oc get route -n registry-monitoring
```

There is a grafana dashboard `dash.json` that can be manually imported to grafana.