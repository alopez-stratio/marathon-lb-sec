@rest
Feature: Adding marathon-lb Default

  Scenario: Add Default marathon-lb
    Given I authenticate to DCOS cluster '${DCOS_IP}' using email '${DCOS_USER}' with user '${REMOTE_USER}' and password '${REMOTE_PASSWORD}'
    And I securely send requests to '${DCOS_IP}:443'
    When I open a ssh connection to '${DCOS_IP}' with user '${REMOTE_USER}' and password '${REMOTE_PASSWORD}'
    And I run 'cat /tmp/vault_token | sed "s/\"//g"' in the ssh connection and save the value in environment variable 'token'
    When I send a 'POST' request to '/marathon/v2/apps' based on 'schemas/marathon-lb-Default.json' as 'json' with:
    | $.env.VAULT_HOST | UPDATE | ${VAULT_HOST} |
    | $.env.VAULT_PORT | UPDATE | ${VAULT_PORT} |
    | $.env.VAULT_TOKEN | UPDATE | !{token} |
    Then the service response status must be '201'.
    Given I open a ssh connection to '${DCOS_CLI_HOST}' with user '${DCOS_CLI_USER}' and password '${DCOS_CLI_PASSWORD}'
    When in less than '200' seconds, checking each '20' seconds, the command output 'dcos task | grep marathon-lb-sec | grep R | wc -l' contains '1'
    And I wait '200' seconds
    And I send a 'GET' request to '/mesos/frameworks'
    Then the service response status must be '200'.
    And I save element '$' in environment variable 'coordinator'
    And 'coordinator' matches the following cases:
      | $.frameworks[?(@.name == "marathon")].tasks[?(@.name == "marathon-lb-sec")].statuses[*].state           | contains   | TASK_RUNNING          |
