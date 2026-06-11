# 1. Why Istio

Ref: https://istio.io/blog/2020/tradewinds-2020/

Service mesh requirements can be thought of as a typical __API gateway__ functionality, but instead of having just one API gateway, consider each sidecar Envoy proxies acting as API gateway:

## Benefits:

### [Traffic Management](https://istio.io/docs/concepts/traffic-management/)
- Control Ingress Traffic using Gateway, VirtualService, DestinationRules
```mermaid
graph LR
    GW["istio-ingressgateway"] --> G["Gateway<br/>(port · protocol · hosts)"]
    G --> VS["VirtualService<br/>(L7 routing rules)"]
    VS --> DR["DestinationRule<br/>(subsets + policy)"]
    DR --> SVC["backend Service"]
``` 
### Load balancing 
```mermaid
graph LR
    VS["VirtualService"] --> DR["DestinationRule<br/>loadBalancer policy"]
    DR -->|"ROUND_ROBIN / RANDOM / LEAST_CONN"| V1["reviews v1"]
    DR --> V2["reviews v2"]
    DR --> V3["reviews v3"]
```
### Service Entry
Provides the ability to manually define endpoints that cannot be auto-discovered and may represent destinations outside of the mesh (location: MESH_EXTERNAL).
### Request Routing
Fine-grained control of traffic behavior with rich routing rules, retries, failovers, and __fault injection__
- TLS termination
```mermaid
graph LR
    U["Client<br/>https://bookinfo.com"] -->|TLS| CLB["Cloud LoadBalancer"]
    CLB -->|TLS| GW["istio-ingressgateway<br/>(TLS termination<br/>credentialName: bookinfo-certs)"]
    GW -->|in-cluster| PP["productpage"]
    GW -->|in-cluster| RV["reviews"]
```
### Canary rollouts
```mermaid
graph LR
    GW["istio-ingressgateway"] --> VS["VirtualService<br/>weighted route"]
    VS -->|10%| V1["reviews v1"]
    VS -->|10%| V2["reviews v2"]
    VS -->|80%| V3["reviews v3"]
```
### Identity/header based routing
```mermaid
graph LR
    U["Request<br/>(end-user header)"] --> VS["VirtualService: reviews<br/>match: headers.end-user"]
    VS -->|"end-user = tester"| V1["reviews v1"]
    VS -->|"default (weighted)"| VW["reviews v1 / v2 / v3"]
```
### Failure recovery (delay, abort, retries, timeout)
```mermaid
graph LR
    U["Request (tester)"] --> VS["VirtualService: ratings<br/>fault.delay 100% · fixedDelay 10s"]
    VS -->|"+10s delay"| R["ratings v1"]
```
```mermaid
graph LR
    U["Request (tester)"] --> VS["VirtualService: ratings<br/>fault.abort 100% · HTTP 400"]
    VS -.->|"aborted — never reaches"| R["ratings v1"]
```
```mermaid
graph LR
    A["caller (Envoy)"] --> VS["VirtualService<br/>timeout: 3s (default 15s)"]
    VS -->|"reply &lt; 3s → OK"| R["upstream service"]
    VS -.->|"reply &gt; 3s → fail"| R
```
```mermaid
graph LR
    A["caller (Envoy)"] --> VS["VirtualService<br/>retries: attempts 3 · perTryTimeout 3s"]
    VS -->|"retry on failure (up to 3×)"| R["upstream service"]
```
### Mirror live traffic
```mermaid
graph LR
    GW["istio-ingressgateway"] --> VS["VirtualService: reviews<br/>mirror v1 (100%)"]
    VS -->|"live traffic 100%"| V3["reviews v3"]
    VS -.->|"mirror copy (Host: -shadow)"| V1["reviews v1"]
```
### Rate limiting
Cap how many requests a client may send; Envoy returns `HTTP 429` once the limit is exceeded. Local limits are enforced per-proxy, while global limits share a counter via an external rate-limit service (commonly Redis-backed).
```mermaid
graph LR
    C["Clients"] --> GW["istio-ingressgateway<br/>+ Envoy rate-limit filter"]
    GW -->|"within limit"| SVC["productpage"]
    GW -.->|"over limit → HTTP 429"| C
    GW <-->|"check / increment counter"| RLS["Rate-limit service<br/>(global · Redis-backed)"]
```
### Circuit breaker
A `DestinationRule` `connectionPool` caps concurrent connections/requests, and `outlierDetection` ejects hosts that return too many errors — so failures stay isolated instead of cascading.
```mermaid
graph LR
    VS["VirtualService"] --> DR["DestinationRule<br/>connectionPool + outlierDetection"]
    DR -->|healthy| H1["reviews v1 ✓"]
    DR -->|healthy| H2["reviews v2 ✓"]
    DR -.->|"5xx threshold exceeded →<br/>ejected from pool"| H3["reviews v3 ✗"]
```
### Control egress traffic
By default the mesh allows any outbound call (`ALLOW_ANY`). Switching to `REGISTRY_ONLY` and declaring external hosts as `ServiceEntry` routes outbound traffic through the egress gateway, so only approved destinations are reachable and can be monitored.
```mermaid
graph LR
    POD["mesh pod<br/>+ Envoy sidecar"] --> EG["istio-egressgateway"]
    EG -->|"ServiceEntry declared ✓"| EXT1["external API (allowed)"]
    EG -.->|"REGISTRY_ONLY: undeclared host ✗"| EXT2["blocked"]
```
### [Security](https://istio.io/docs/concepts/security/)
- transparently secure traffic behind the firewall ([Auto mutual TLS among backend services](https://istio.io/docs/tasks/security/authentication/authn-policy/#auto-mutual-tls), [which doubles the latency at max or max 10ms](https://github.com/istio/tools/tree/3ac7ab40db8a0d595b71f47b8ba246763ecd6213/perf/benchmark#run-performance-tests), [also explained in Istio best practice blog](https://istio.io/blog/2019/performance-best-practices/#3-measure-with-and-without-proxies))
```mermaid
graph LR
    GW["istio-ingressgateway"] -->|mTLS| PP["productpage<br/>+ Envoy"]
    PP -->|mTLS| RV["reviews<br/>+ Envoy"]
    PP -->|mTLS| RT["ratings<br/>+ Envoy"]
```
![alt text](imgs/istio_tls.svg "Istio TLS")
### End-to-end authentication and authorization using JWT
```mermaid
graph LR
    U1["Unauthorized<br/>(no JWT)"] -.->|401| GW["istio-ingressgateway"]
    U2["Authorized<br/>(Bearer JWT)"] --> GW
    GW --> RA["RequestAuthentication<br/>(validate JWT issuer/jwks)"]
    RA --> AP["AuthorizationPolicy<br/>(allow rules)"]
    AP --> APP["productpage"]
```
### Observability
- Debug the latency in the overall architecture
![alt text](imgs/istio_performance_latency.png "Istio Latency")
- Automatic metrics, logs, and traces for all traffic within a cluster, including cluster ingress and egress
    ![alt text](imgs/kiali_virtualservice_ratings_timeout_10s_graph.png "")
- Raw telemetry data are sent from envoy proxy to Mixer, which Mixer processes into metrics, traces, and other telemetry
- New in istio 1.5 and 1.6
    - Reduced installation and configuration complexity by moving control plane components into a single component: __Istiod__. This binary includes the features of Pilot, Citadel, Galley, and the sidecar injector
    - High performant ([Istio Performance Benchmarking and script](https://github.com/istio/tools/tree/3ac7ab40db8a0d595b71f47b8ba246763ecd6213/perf/benchmark#run-performance-tests), [egress gateway performance testing](https://istio.io/blog/2019/egress-performance/))
         ![alt text](imgs/istio_egress_performance_throughput.png "Istio Latency")
         ![alt text](imgs/istio_egress_performance_cpu.png "Istio Latency")

- Refs:
    - [Istio with Kubernetes on AWS](https://github.com/aws-samples/istio-on-amazon-eks)
    - [Kiali: Istio dashboard](https://kiali.io/)
    - [Istio sidecar injection failing with error - MountVolume.SetUp failed for volume "istiod-ca-cert" : configmap "istio-ca-root-cert" not found #22463](https://github.com/istio/istio/issues/22463)
    - [Failed to get secret "istio-ca-secret" thus istiod pod's readiness probe fails on EKS #24009](https://github.com/istio/istio/issues/24009)