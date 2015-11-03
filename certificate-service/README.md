an API server which hands out everything you need to run new flocker agents
based on a shared secret, which must match one specified in an environment
variable `BOOTSTRAP_TOKEN`.

* POST /v1/control

  * request data:  `{"bootstrap_token": "a quick brown fox"}`
  * response data: `{"cluster.crt": "DATA",
                     "control-service.crt": "DATA",
                     "control-service.key": "DATA"}`

  * there will be precisely one control service certificate generated; it can
    be fetched multiple times

* POST /v1/agent

  * request data:  `{"bootstrap_token": "a quick brown fox",
                     "host_uuid": "abc" (optional)}`
  * response data: `{"agent.yml": "data",
                     "cluster.crt": "data",
                     "node.crt": "data",
                     "node.key": "data",
                     "plugin.crt": "data",
                     "plugin.key": "data"}`

  * there will be precisely one agent certificate set generated per host uuid,
    if specified

* as an agent, it is then your job to write these into files which, from
  container agent's pov, are in `/etc/flocker`.  attempt to write these files
  atomically.

TODO: use https://pypi.python.org/pypi/streql/3.0.2 for string comparison

XXX TODO: refuse to serve responses over plaintext HTTP
