namespace: Integrations.demo.aos.users
operation:
  name: parse_credentials
  inputs:
    - credentials
    - delimeter:
        required: false
        default: =
  python_action:
    script: |-
      array=credentials.split(delimeter);
      name=array[0];
      password=array[1];
  outputs:
    - name
    - password
  results:
    - SUCCESS
