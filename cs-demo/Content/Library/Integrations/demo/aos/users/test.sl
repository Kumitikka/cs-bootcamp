namespace: Integrations.demo.aos.users
flow:
  name: test
  workflow:
    - parse_credentials:
        do:
          Integrations.demo.aos.users.parse_credentials:
            - credentials: petr=cloud
        navigate:
          - SUCCESS: SUCCESS
  results:
    - SUCCESS
extensions:
  graph:
    steps:
      parse_credentials:
        x: 340
        'y': 246
        navigate:
          85640c4e-2518-2257-2a40-c9af1eb05700:
            targetId: a9e40b78-2c77-38df-75f4-bb32d1b8c7e7
            port: SUCCESS
    results:
      SUCCESS:
        a9e40b78-2c77-38df-75f4-bb32d1b8c7e7:
          x: 530
          'y': 261
