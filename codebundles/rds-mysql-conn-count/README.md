# CodeBundle - RDS MySQL Connection Count

This codebundle targets to detect and resolve an incident caused by too many sleeping connections in MySQL.

- Target Service - MySQL
- Cloud Platform - AWS/RDS

## SLX
```YAML
statement: RDS MySql connections should be within 80% of total max connection.
alias: RDS MySql Connections Count
metricType: gauge
asMeasuredBy: Score based on promethues query
icon: Cloud
owners:
  - saurabh.yadav@infracloud.io
imageURL: >-
  https://storage.googleapis.com/runwhen-nonprod-shared-images/icons/kubernetes/resources/labeled/ns.svg

```
## SLO / Service Level Objective
Example:
```YAML
codeBundle:
  repoUrl: https://github.com/infracloudio/ifc-rw-codecollection
  pathToYaml: codebundles/slo-default/queries.yaml
  ref: main
sloSpecType: simple-mwmb
objective: 95
threshold: 48
operand: lt
```

## SLI / Service Level Indicator
```YAML
displayUnitsLong: OK
displayUnitsShort: ok
locations:
  - location-01-us-west1
description: >-
  Watch RDS MySql connection count
codeBundle:
  repoUrl: https://github.com/infracloudio/ifc-rw-codecollection
  ref: main
  pathToRobot: codebundles/rds-mysql-conn-count/sli.robot
# read more about intervalStrategy here: https://docs.runwhen.com/public/runwhen-platform/feature-overview/points-on-the-map-slxs/service-level-indicators-slis/interval-strategies
intervalStrategy: intermezzo
intervalSeconds: 30
configProvided:
  # Change PROMETHEUS_HOSTNAME to your endpoint and currently endpoint needs to be publicly exposed.
  - name: PROMETHEUS_HOSTNAME
    value: >-
      http://aeccfb7ff9bfb4705b6218294a7346c3-2081802229.us-west-2.elb.amazonaws.com/prometheus/api/v1
  - name: QUERY
    value: >-
      aws_rds_database_connections_average{dimension_DBInstanceIdentifier="robotshopmysql"} > 1
  - name: TRANSFORM
    value: RAW
  - name: STEP
    value: '30'
  - name: DATA_COLUMN
    value: '1'
  - name: NO_RESULT_OVERWRITE
    value: 'Yes'
  - name: NO_RESULT_VALUE
    value: '0'
servicesProvided:
  - name: curl
    locationServiceName: curl-service.shared
```

## RunBook / Mitigation

```YAML
location: location-01-us-west1
codeBundle:
  repoUrl: https://github.com/infracloudio/ifc-rw-codecollection
  ref: main
  pathToRobot: codebundles/rds-mysql-conn-count/runbook.robot
servicesProvided:
  - name: curl
    locationServiceName: curl-service.shared
configProvided:
  - name: MYSQL_USER
    value: admin
  - name: MYSQL_HOST
    value: robotshopmysql.example.us-west-2.rds.amazonaws.com
  - name: PROCESS_USER
    value: shipping
```

### Assumptions & Pitfalls

These configs are placeholder YAML. one needs to modify them according to need and then paste them to the platform side.