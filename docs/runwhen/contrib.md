# Contributing to CodeCollections/CodeBundles

## Creating a New CodeCollection
### Forking the template repository

## Writing a Non-trivial CodeBundle
### Directory structure / Scaffolding



#########
Repository Setup
Introduction to Robot Framework Scripts (how it interacts with RunWhen)
Calling bash with relative paths
Secret handling
Suite Initialization
Library usage
Explain the call chain
Library Setup
How to get an exhaustive list of available libraries
CLI repo
Public repo
Explain what libraries would be auto-fetched by devcontainer tooling
Core
CLI
What needs to be added for specific libraries that are used in a robot script
Paths
Running a test with local docker
Adding additional binaries to devcontainer as needed
Mysql-client
Postgres-client
Redis-client
Configuring Env / secrets
Expose endpoints
Local docker network
Expose from test cluster
Test by using docker run on localhost
Test in your live environment
Deploy as a k8s job
Give an example
Testing on Runwhen Platform
Connecting test env/cluster to runwhen
Runwhen-local upload
If Robot script needs to use additional dependencies, like CLI tools the devs need to be informed and for now they will handle the update on platform side
Mysql-client
Postgres-client
Redis-client
Registering your first codecollection to Runwhen-platform
Mention that this may be in private as per developer discretion
How to configure the YAML to test
Branch name length limitations
Expose metric endpoints so that they are accessible to runwhen-platform codebundles
Configuring Env / secrets
Running the test
Checking logs
Checking for errors
