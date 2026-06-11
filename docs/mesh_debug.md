# Debug your mesh

A grab-bag of practical commands for debugging traffic, Envoy proxies, and the Istio control plane.

## Generate traffic

```sh
# poll the gateway once per second and print only the HTTP status code
watch -n 1 curl -o /dev/null -s -w %{http_code} http://$GATEWAY_URL
```

## Inspect Envoy proxy config

Dump the full Envoy configuration of a pod's `istio-proxy` sidecar to a file:

```sh
oc exec <pod-name> -c istio-proxy -- curl -kv localhost:15000/config_dump > <pod-name>_Envoy_config.json
```

## Adjust Envoy proxy log level

Envoy exposes a `/logging` admin endpoint on port `15000`. You can raise the log level per component or globally.

### For a specific component

```sh
oc exec -it <pod-name> -c istio-proxy -- sh -c 'curl -k -X POST localhost:15000/logging?rbac=debug'
```

Example — several components at once:

```sh
oc exec -it keycloak-v1-app-0 -c istio-proxy -- \
  sh -c 'curl -k -X POST localhost:15000/logging?rbac=debug?admin=debug?config=debug?router=debug?runtime=debug'
```

### Control plane

```sh
oc exec -it dispatch-wip-6d6975b7cb-rzxhw -c istio-proxy -- \
  sh -c 'curl -k -X POST localhost:15000/logging?rbac=debug?admin=debug?'
```

### Ingress gateway

```sh
oc exec -it istio-ingressgateway-77479549b4-kc22p -c istio-proxy -- \
  sh -c 'curl -k -X POST localhost:15000/logging?rbac=debug?admin=debug?config=warning?router=debug?runtime=warning'
```

### For all components

!!! warning "Heads up"
    Setting every logger at once produces a **very** large volume of logs. Prefer scoping to a single component whenever possible.

```sh
oc exec -it keycloak-v1-app-0 -c istio-proxy -- sh -c 'curl -k -X POST localhost:15000/logging?level=warning'

oc exec -it keycloak-v1-db-postgresql-0 -c istio-proxy -- sh -c 'curl -k -X POST localhost:15000/logging?level=warning'
```

The response lists the active loggers and their current level:

```text
active loggers:
  admin: debug
  aws: debug
  assert: debug
  backtrace: debug
  client: debug
  config: debug
  ...
  pool: debug
  rbac: debug
  redis: debug
  router: debug
  runtime: debug
  stats: debug
  secret: debug
  tap: debug
  testing: debug
  thrift: debug
  tracing: debug
  upstream: debug
  udp: debug
  wasm: debug
```

## Port-forwarding

Forward a local port to a pod — handy for reaching a database or admin UI directly:

```sh
oc port-forward keycloak-v1-db-postgresql-0 15432:5432

# connect with the postgres client (apt-get install postgresql-client)
psql -h localhost -p 15432 -U admin -d aidc_v1
```

### Sniff PostgreSQL traffic

```sh
sudo tcpdump -A -i any port 15432
```

## Connect to the Istio Pilot GUI

```sh
oc port-forward istio-pilot-775d8bfc6b-zb25d 9876
```

Then open <http://localhost:9876/scopez/> in your browser to view the GUI.

!!! tip
    The same approach works for the other control-plane components — **Mixer, Pilot, Citadel, and Galley**:

    ```sh
    oc port-forward <istio-pod-name> 9876
    ```

## Check the Istio version

```sh
oc rsh -n openshift-operators istio-operator-85787fd5f5-kvjfz env | grep ISTIO_VERSION

# output
ISTIO_VERSION=1.12.9
```
