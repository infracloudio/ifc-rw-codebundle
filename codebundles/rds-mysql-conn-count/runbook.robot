*** Settings ***
Documentation       This taskset Kills the numbers of sleep process created in MySQL
Metadata            Author    IFC

Library             BuiltIn
Library             RW.Core
Library             RW.platform
Library             RW.CLI

Suite Setup         Suite Initialization

*** Variables ***
${MYSQL_PASSWORD_ENV}      %{MYSQL_PASSWORD_ENV}

*** Tasks ***
Run Bash File
    [Documentation]    Runs a bash file to kill sleep processes created in MySQL
    [Tags]    file    script
    ${rsp}=    RW.CLI.Run Bash File
    ...    bash_file=kill-mysql-sleep-processes.sh
    ...    cmd_override=./kill-mysql-sleep-processes.sh
    ...    env=${env}
    ...    include_in_history=False
    RW.Core.Add Pre To Report    Command Stdout:\n${rsp.stdout}
    RW.Core.Add Pre To Report    Command Stderr:\n${rsp.stderr}


*** Keywords ***
Suite Initialization
   ${MYSQL_PASSWORD}=    RW.Core.Import User Variable    MYSQL_PASSWORD
    ...    type=string
    ...    description=MySQL password
    ...    pattern=\w*
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
    ...    example=robotshopmysql.example.us-west-2.rds.amazonaws.com
    ${PROCESS_USER}=    RW.Core.Import User Variable    PROCESS_USER
    ...    type=string
    ...    description=mysql user which created numbers of sleep connections
    ...    pattern=\w*
    ...    example=shipping

    Set Suite Variable
    ...    ${env}    {"MYSQL_USER":"${MYSQL_USER}", "MYSQL_PASSWORD":"${MYSQL_PASSWORD}", "MYSQL_HOST":"${MYSQL_HOST}", "PROCESS_USER":"${PROCESS_USER}"}