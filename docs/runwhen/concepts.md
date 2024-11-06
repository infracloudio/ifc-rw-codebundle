# RunWhen Concepts
- [RunWhen Concepts](#runwhen-concepts)
- [Runwhen Local](#runwhen-local)
  - [CheatSheet Generator](#cheatsheet-generator)
  - [Uploading Cluster Topology to the Platform](#uploading-cluster-topology-to-the-platform)
- [CodeCollections](#codecollections)
- [CodeBundles](#codebundles)

# Runwhen Local
- [source-code](https://github.com/runwhen-contrib/runwhen-local)
- [Helm Chart](https://github.com/runwhen-contrib/helm-charts/tree/main/charts/runwhen-local)
- [Upstream docs](https://docs.runwhen.com/public/v/runwhen-local/)
  
RunWhen Local has two core functions:
- Generate remediation scripts / CheatSheets from included templates for your local cluster
- Upload Cluster Topology to the RunWhen Platform

## CheatSheet Generator
At the moment RunWhen Local **does not posses the ability to discover issues** in
your cluster and suggest mitigation runbooks / codebundles. 

**However, it discovers your kubernetes resources and object names.**
Using which, it generates a wide set of runbooks for you, if you already know the
root cause. These runbooks contain documentation and pastable shell script
snippets for the searched issue. These scripts / cheatsheet are already pre-templated
with your namespaces and kubernetes resource names.

This collection of cheatsheets / runbooks, although not exhaustive, covers a significant portion
of recurring issues and healthcheck failures and can be useful to SREs for quick
resolution of incidents.

[Upstream Examples](https://docs.runwhen.com/public/v/runwhen-local/user-guide/features/user_guide-feature_overview)

## Uploading Cluster Topology to the Platform
The second core function of runwhen-local is to upload cluster topology to the
runwhen platform so you can visualize the cluster workload map from a configured
runwhen workspace.

- First, follow documentation at [Upload to RunWhen Platform](https://docs.runwhen.com/public/v/runwhen-local/user-guide/features/upload-to-runwhen-platform#upload-from-the-cli)
  - To generate the `uploadInfo.yaml` file
- Next, take the yaml object and copy over it's contents to `uploadInfo:[]` section
of the helm [`values.yaml` file](https://github.com/runwhen-contrib/helm-charts/blob/main/charts/runwhen-local/values.yaml#L121)
- Once configured it should look like this:
  ```YAML
  uploadInfo:
    workspaceName: <your-workspace-name>
    token: <your token> # Do NOT add token and commit to git
    workspaceOwnerEmail: tester@my-company.com
    papiURL: https://papi.beta.runwhen.com
    defaultLocation: location-01-us-west1 # available runwhen locations
  ```
- You should pass the token from helm cli, to ensure you are not leaking the token via git
  ```bash
  helm upgrade --install  ${HELM_RELEASE_NAME} runwhen-contrib/runwhen-local \
    --set uploadInfo.token=${RUNWHEN_PLATFORM_TOKEN} \
     -f ${VALUES_FILE} -n ${NAMESPACE}
  ```

# CodeCollections
CodeCollections are a group of CodeBundles that can be referenced and used in RunWhen Platform.

*N.B. It's important to note here that currently codecollections cannot be imported explicitly and run against your local cluster using RunWhen Local*

Currently RunWhen has published two codecollections:
- [runwhen-public-codecollection](https://github.com/runwhen-contrib/rw-public-codecollection)
  - These contain codebundles that are usually run against services and doesn't involved a Shell / CLI component
- [runwhen-cli-codecollection](https://github.com/runwhen-contrib/rw-cli-codecollection)
  - These are generally targeted towards SRE workloads and wraps various shell-scripts and CLI tooling.

# CodeBundles
CodeBundles are specific detectors/mitigators of known SLI/SLO violations in a live software stack.

It comprises of:
- Robot files
  - Scripts / Playbooks / tasksets written using [Robot Framework](), that either
    - Create and enforce RunWhen SLIs - `sli.robot`
    - Create miitigation runbooks in response to an SLO/SLI violation - `runbook.robot`
- Platform definitions of `{SLX, SLO, SLI, Runbook}` as `YAML` configurations
  - These do not need to be located in your repo, however it's a good practice to have them committed in git.
  - These configurations wrap standard behaviors for interacting with RunWhen Platform API, `papi`
    - Endpoint: `https://papi.beta.runwhen.com`
  - The RunWhen `YAML` configurations are only pertinent when your codebundle is live on RunWhen Platform, these do not play any role as of now for either local testing or RunWhen Local.
- Test resources / scripts

In a local testing environment you only need to execute the `*.robot` files inside the provided container configurations,
- [Dockerfile](../../Dockerfile)
- [vscode/devcontainer](../../.devcontainer.json)


The usual call chain is as follows:
- Robot Scripts
  - User variable and secret injection
  - Runwhen Libraries
    - RunWhen Services 
      -  Wrapped shell CLI command / Platform SDK code execution
      -  or, direct shims to your shell scripts / python code when services are unavailable
      -  These tasks fetch the current value of a metric / state
         -  This metric value is then compared against the defined thresholds at `sli/slo.yaml` in the platform.
      - If the Robot script just runs a set of tasks as a mitigation step, it returns either success or failure.

More concepts and non-trivial FAQs around writing CodeBundles are explained at [Contributing to CodeCollections/CodeBundles](contrib.md)