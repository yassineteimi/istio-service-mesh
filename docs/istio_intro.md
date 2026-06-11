# 1. Intro

## What is Service Mesh
Ref: https://istio.io/docs/concepts/what-is-istio/#what-is-a-service-mesh


__Istio Service Mesh__ is a network connectivity (i.e. __mesh__) within Kubernetes cluster created by __Envoy proxy__ containers, be it a standalone or a sidecar proxy:
```mermaid
graph TD
    subgraph K8S["K8s Ingress (nginx)"]
        direction TB
        A1["nginx-ingress-controller<br/>(LoadBalancer)"] --> A2["Ingress &quot;/&quot;"]
        A2 --> A3["guestbook Service<br/>(NodePort)"]
        A3 --> A4["guestbook pods"]
        A4 --> A5["Redis master<br/>(ClusterIP)"]
        A4 --> A6["Redis slave<br/>(ClusterIP)"]
    end
    subgraph ISTIO["Istio VirtualService"]
        direction TB
        B1["istio-ingressgateway<br/>(LoadBalancer)"] --> B2["VirtualService &quot;/&quot;"]
        B2 --> B3["guestbook Service<br/>(NodePort)"]
        B3 --> B4["guestbook pod<br/>+ Envoy sidecar"]
        B4 --> B5["Redis master<br/>(ClusterIP)"]
        B4 --> B6["Redis slave<br/>(ClusterIP)"]
    end
```


Another huge benefit of Istio is the default in-cluster __mutual TLS__.

Without istio, say if using __Ingress controller__, you can configure __TLS termnation__ at ingress controller pod, like this:
```mermaid
graph LR
    U["Client<br/>https://bookinfo.com"] -->|TLS| CLB["Cloud LoadBalancer"]
    CLB -->|TLS| GW["istio-ingressgateway<br/>(TLS termination<br/>credentialName: bookinfo-certs)"]
    GW -->|in-cluster| PP["productpage"]
    GW -->|in-cluster| RV["reviews"]
```

With __istio__, __connections among pods__ in the cluster behind the what-used-to-be ingress controller (i.e. Istio Gateway) can be __mutual TLS__, without changing app code:
```mermaid
graph LR
    GW["istio-ingressgateway"] -->|mTLS| PP["productpage<br/>+ Envoy"]
    PP -->|mTLS| RV["reviews<br/>+ Envoy"]
    PP -->|mTLS| RT["ratings<br/>+ Envoy"]
```