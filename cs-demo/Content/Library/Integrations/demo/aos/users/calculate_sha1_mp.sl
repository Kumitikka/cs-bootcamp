namespace: Integrations.demo.aos.users
flow:
  name: calculate_sha1_mp
  inputs:
    - host
    - user
    - password:
        sensitive: true
    - text
  workflow:
    - ssh_command:
        do:
          io.cloudslang.base.ssh.ssh_command:
            - host: '${host}'
            - command: "${\"echo -n '\"+ text + \"' | sha1sum | awk '{print $1}'\"}"
            - username: '${user}'
            - password:
                value: '${password}'
                sensitive: true
        publish:
          - sha1: '${return_result.strip()}'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - sha1: '${sha1}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      ssh_command:
        x: 257
        'y': 161
        navigate:
          2c2c0ca6-2443-80e8-5609-412c97b8f3fa:
            targetId: 5bb38323-a29a-6607-ce84-79a66115b407
            port: SUCCESS
    results:
      SUCCESS:
        5bb38323-a29a-6607-ce84-79a66115b407:
          x: 542
          'y': 160
