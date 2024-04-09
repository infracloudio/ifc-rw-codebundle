## ServiceLevelX(SLX)

Read more about [ServiceLevelX(SLX)](https://docs.runwhen.com/public/runwhen-platform/terms-and-concepts#servicelevelx-slx)

## Service Level Indicator(SLI)

Read more about [Service Level Indicator(SLI)](https://docs.runwhen.com/public/runwhen-platform/terms-and-concepts#service-level-indicator-sli) 

In this SLI, we measure the reliability level of RDS MYSQL using the `aws_rds_database_connections_average{dimension_DBInstanceIdentifier="robotshopmysql"}` metric. If the connections average exceeds 30, we're likely to experience disruptions in services connected to RDS MYSQL.

### Runtime configuration details, such as:

`displayUnitsLong` and `displayUnitsShort` Display Units (Long and short): these display on the map and should be meaningful to map viewers

`intervalSeconds`: How much time will elapse between each execution of the SLI code

[`intervalStrategy`](https://docs.runwhen.com/public/runwhen-platform/feature-overview/points-on-the-map-slxs/service-level-indicators-slis/interval-strategies): Intermezzo (simply means that we run the code on an interval)

`locations`: Which RunWhen location to execute the SLI code within. RunWhen will operate many locations that exist across different computing regions. Currently, `location-01-us-west1` is available.

`codeBundle`:
- `repoUrl`: This specifies the URL of the Git repository where the code bundle is located.
- `ref`: This indicates the Git reference (such as branch or tag) to use from the repository specified in repoUrl. In this case, it's set to main, implying that the code from the main branch of the repository will be used.
- `pathToRobot`: This specifies the path within the repository where the specific Robot Framework file (sli.robot) is located.

`secretsProvided`: This parameter includes the secrets passed through the platform, allowing us to avoid committing the secrets in our SLX codes.

`servicesProvided`: Select the RunWhen Service to use for accessing services within a network. For instance, if we want to access the Prometheus endpoint, we can utilize `curl-service.shared`.

    Available service binaries:
        
        # Curl cli
        - name: curl
        locationServiceName: curl-service.shared

        # kubectl cli
        - name: kubectl
        locationServiceName: kubectl-service.shared

        # Google cloud cli
        - name: gcloud
        locationServiceName: gcloud-service.shared


### `configProvided` schema: 

`PROMETHEUS_HOSTNAME`: The prometheus endpoint to perform requests against. Currently, this endpoint must be publicly exposed because RunWhen lacks a method to access internal endpoints through its runwhen-local(agent).

`QUERY`: The PromQL statement used to query metrics. In this case it's `aws_rds_database_connections_average`

`TRANSFORM`: What transform method to apply to the column data. Available options are `RAW`, `MAX`, `Average`, `Minimum`, `Sum`, `First` and `Last`. `First` and `Last` are position relative, so Last is the most recent value. Use Raw to skip transform.

`STEP`: The step interval in seconds requested from the Prometheus API.

`DATA_COLUMN`: Which column of the result data to perform aggregation on. Typically 0 is the timestamp, whereas 1 is the metric value.

`NO_RESULT_OVERWRITE`: Determine how to handle queries with no result data. Set to Yes to write a metric (specified below) or No to accept the null result.

`NO_RESULT_VALUE`: Set the metric value that should be stored when no data result is available.


## Service Level Objective(SLO)

Read more about  [Service Level Objective(SLO)](https://docs.runwhen.com/public/runwhen-platform/terms-and-concepts#service-level-objective-slo)

## Automated Tasks (Runbook)

Learn more about [Task](https://docs.runwhen.com/public/runwhen-platform/terms-and-concepts#task)

Here, we're adding the `codebundles/rds-mysql-conn-count/runbook.robot` runbook to terminate the sleeping MySQL process. We're passing `MYSQL_USER`, `MYSQL_HOST`, and `PROCESS_USER` (the username of the sleeping process), while the password will be retrieved from the runwhen platform.

This runbook utilizes the `RW.Core.Import Secret` function, which instructs the platform to prompt for the `MYSQL_PASSWORD` as secret input. This approach eliminates the need to explicitly include it in our YAML file in an unsafe manner.

The `secretsProvided` parameter specifies the secrets that will be automatically added to the YAML configuration. In this case:

```
secretsProvided:
  - name: MYSQL_PASSWORD
    workspaceKey: MYSQL_PASSWORD
```

- `name`: Specifies the name of the secret.
- `workspaceKey`:  Indicates the workspace key associated with the secret.