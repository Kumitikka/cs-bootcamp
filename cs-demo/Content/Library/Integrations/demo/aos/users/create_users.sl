namespace: Integrations.demo.aos.users
flow:
  name: create_users
  inputs:
    - file_host: itom1.hcm.demo.local
    - file_user: root
    - file_password:
        default: S0lutions2016
        sensitive: true
    - file_path: /tmp/users.txt
    - db_host: 10.0.46.80
    - db_user: postgres
    - db_password:
        default: admin
        sensitive: true
    - mm_url: 'https://mattermost.hcm.demo.local'
    - mm_user: admin
    - mm_password:
        default: Cloud_123
        sensitive: true
    - mm_chanel_id: eeujbpz9ufbc8rxcyj9qhcgq3a
  workflow:
    - read_users:
        do:
          io.cloudslang.base.ssh.ssh_command:
            - host: '${file_host}'
            - command: '${"cat " + file_path}'
            - username: '${file_user}'
            - password:
                value: '${file_password}'
                sensitive: true
        publish:
          - file_content: '${return_result}'
        navigate:
          - SUCCESS: create_user
          - FAILURE: on_failure
    - create_user:
        loop:
          for: credentials in file_content.split()
          do:
            Integrations.demo.aos.users.create_user:
              - credentials: '${credentials}'
          break:
            - FAILURE
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      read_users:
        x: 226
        'y': 148
      create_user:
        x: 419
        'y': 149
        navigate:
          9ffb7c8b-17e8-4796-089a-aa4072968ae6:
            targetId: 60f11c47-fd65-6102-d9c8-1ce6e7cec8c7
            port: SUCCESS
    results:
      SUCCESS:
        560e69a5-85ed-5e4e-5d6c-9b34ae7dd824:
          x: 1006
          'y': 145
        60f11c47-fd65-6102-d9c8-1ce6e7cec8c7:
          x: 660
          'y': 162
