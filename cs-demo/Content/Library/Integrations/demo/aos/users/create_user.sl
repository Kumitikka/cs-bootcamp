namespace: Integrations.demo.aos.users
flow:
  name: create_user
  inputs:
    - file_host: itom1.hcm.demo.local
    - file_user: root
    - file_password:
        default: S0lutions2016
        sensitive: true
    - credentials:
        required: true
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
    - parse_credentials:
        do:
          Integrations.demo.aos.users.parse_credentials:
            - credentials: '${credentials}'
        publish:
          - created_name: '${name}'
          - created_password: '${password}'
        navigate:
          - SUCCESS: calculate_sha1
    - calculate_sha1:
        do:
          Integrations.demo.aos.users.calculate_sha1:
            - host: '${file_host}'
            - user: '${file_user}'
            - password:
                value: '${file_password}'
                sensitive: true
            - text: '${created_password}'
        publish:
          - password_sha1: '${sha1}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: calculate_sha1_1
    - calculate_sha1_1:
        do:
          Integrations.demo.aos.users.calculate_sha1:
            - host: '${file_host}'
            - user: '${file_user}'
            - password:
                value: '${file_password}'
                sensitive: true
            - text: '${created_name[::-1]+password_sha1}'
        publish:
          - username_password_sha1: '${sha1}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: random_number_generator
    - random_number_generator:
        do:
          io.cloudslang.base.math.random_number_generator:
            - min: '100000000'
            - max: '1000000000'
        publish:
          - user_id: '${random_number}'
        navigate:
          - SUCCESS: sql_command
          - FAILURE: on_failure
    - sql_command:
        do:
          io.cloudslang.base.database.sql_command:
            - db_server_name: '${db_host}'
            - db_type: PostgreSQL
            - username: '${db_user}'
            - password:
                value: '${db_password}'
                sensitive: true
            - database_name: adv_account
            - command: "${\"INSERT INTO account (user_id, user_type, active, agree_to_receive_offers, defaultpaymentmethodid, email, internallastsuccesssullogin, internalunsuccessfulloginattempts, internaluserblockedfromloginuntil, login_name, password, country_id) VALUES (\"+user_id+\", 20, 'Y', true, 0, 'someone@microfocus.com', 0, 0, 0, '\"+created_name+\"', '\"+username_password_sha1+\"', 210)\"}"
            - trust_all_roots: 'true'
        navigate:
          - SUCCESS: Send_Message
          - FAILURE: on_failure
    - Send_Message:
        do_external:
          3dff4bb9-c9fa-4040-98bf-cb139fb9160f:
            - url: '${mm_url}'
            - username: '${mm_user}'
            - password:
                value: '${mm_password}'
                sensitive: true
            - message: '${"User " + created_name + " added to AOS"}'
        navigate:
          - success: SUCCESS
          - failure: on_failure
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      parse_credentials:
        x: 189
        'y': 161
      calculate_sha1:
        x: 182
        'y': 337
      calculate_sha1_1:
        x: 385
        'y': 353
      random_number_generator:
        x: 374
        'y': 141
      sql_command:
        x: 554
        'y': 139
      Send_Message:
        x: 705
        'y': 153
        navigate:
          89cf2477-c9ce-f853-f7f8-e065ab7d8baf:
            targetId: 560e69a5-85ed-5e4e-5d6c-9b34ae7dd824
            port: success
    results:
      SUCCESS:
        560e69a5-85ed-5e4e-5d6c-9b34ae7dd824:
          x: 563
          'y': 355
