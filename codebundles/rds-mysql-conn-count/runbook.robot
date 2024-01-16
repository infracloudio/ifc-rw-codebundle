*** Settings ***
Documentation       This taskset Kills the numbers of sleep process created in MySQL
Metadata            Author    IFC

Library             BuiltIn
Library             RW.Core
Library             RW.platform
Library             RW.CLI

Suite Setup         Suite Initialization

*** Variables ***
${MYSQL_USER_ENV}      %{MYSQL_USER_ENV}
${MYSQL_PASSWORD_ENV}      %{MYSQL_PASSWORD_ENV}
${MYSQL_HOST_ENV}      %{MYSQL_HOST_ENV}
${PROCESS_USER_ENV}      %{PROCESS_USER_ENV}

*** Tasks ***
Run Bash File
    [Documentation]    Runs a bash file to verify script passthrough works
    [Tags]    file    script
    ${rsp}=    RW.CLI.Run Bash File
    ...    bash_file=kill-mysql-sleep-processes.sh
    ...    cmd_overide=./kill-mysql-sleep-processes.sh livenessProbe
    ...    env=${env}
    ...    include_in_history=False
    RW.Core.Add Pre To Report    Command Stdout:\n${rsp.stdout}
    RW.Core.Add Pre To Report    Command Stderr:\n${rsp.stderr}


*** Keywords ***
Suite Initialization
   ${MYSQL_PASSWORD}=    RW.Core.Import Secret    MYSQL_PASSWORD
    ...    type=string
    ...    description=MySQL password
    ...    pattern=\w*
    ...    default="dwfsfeefe"
    ...    example='9jZGIzNDIxego'
    ${MYSQL_USER}=    RW.Core.Import User Variable    MYSQL_USER
    ...    type=string
    ...    description=MySQL Username
    ...    pattern=\w*
    ...    example=admin
    ${MYSQL_HOST}=    RW.Core.Import User Variable    MYSQL_HOST
    ...    type=string
    ...    description=MySQL host endpoint
    ...    pattern=\w*
    ...    example=robotshopmysql.cn9m6m4s8zo0.us-west-2.rds.amazonaws.com
    ${PROCESS_USER}=    RW.Core.Import User Variable    PROCESS_USER
    ...    type=string
    ...    description=mysql user which created numbers of sleep connections
    ...    pattern=\w*
    ...    example=shipping

    Set Suite Variable
    ...    ${env}    {"MYSQL_USER_ENV":"${MYSQL_USER_ENV}", "MYSQL_PASSWORD_ENV":"${MYSQL_PASSWORD_ENV}"}