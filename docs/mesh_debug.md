Generate traffic:

watch -n 1 curl -o /dev/null -s -w %{http_code} http://$GATEWAY_URL

Getting Envoy Proxy config:

oc exec <pod name> -c istio-proxy -- curl -kv localhost:15000/config_dump> <podname>_Envoy_config.json

Increase the logging level of the Envoy proxy:

For a specific component:

oc exec -it <pod name> -c istio-proxy -- sh -c 'curl -k -X POST localhost:15000/logging?rbac=debug'

Example:
oc exec -it keycloak-v1-app-0 -c istio-proxy -- sh -c 'curl -k -X POST localhost:15000/logging?rbac=debug?admin=debug?config=debug?router=debug?runtime=debug'


Control plane:
oc exec -it dispatch-wip-6d6975b7cb-rzxhw -c istio-proxy -- sh -c 'curl -k -X POST localhost:15000/logging?rbac=debug?admin=debug?'

Ingress gateway:

oc exec -it istio-ingressgateway-77479549b4-kc22p -c istio-proxy -- sh -c 'curl -k -X POST localhost:15000/logging?rbac=debug?admin=debug?config=warning?router=debug?runtime=warning'


For all Components:

BEWARE! the logs will come too heavy!

oc exec -it keycloak-v1-app-0 -c istio-proxy -- sh -c 'curl -k -X POST localhost:15000/logging?level=warning'

oc exec -it keycloak-v1-db-postgresql-0 -c istio-proxy -- sh -c 'curl -k -X POST localhost:15000/logging?level=warning'

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

Port-forwarding:

oc port-forward keycloak-v1-db-postgresql-0 15432:5432
psql -h localhost -p 15432 -U admin -d aidc_v1
(sudo apt-install postgresql-client)

Sniff postgresql traffic:
sudo tcpdump -A -i any port 15432

Connecting to Istio Pilot GUI:
oc port-forward istio-pilot-775d8bfc6b-zb25d 9876
If we open this website http://localhost:9876/scopez/ in our browser, we see the following GUI:

You can do this also for : Mixer, Pilot, Citadel, and Galley
oc port-forward <istio pod name> 9876

Istio version:
oc rsh -n openshift-operators istio-operator-85787fd5f5-kvjfz env | grep ISTIO_VERSION
ISTIO_VERSION=1.12.9