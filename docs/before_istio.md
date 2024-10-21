# Things to know

## Keys differences between istio on Kubernetes vs istio on redhat Openshift

### Difference #1: istio installation

To run istio service mesh on :

- Openshift you must use the redhat istio service mesh operator among other operators. (see mesh installation page for more details).
- kubernetes (see mesh installation page for more details).

Red Hat OpenShift Service Mesh does not support Istio installation profiles.

Red Hat OpenShift Service Mesh does not support canary upgrades of the service mesh.

### Difference #2: Enabling sideCar autoInjection

Red Hat OpenShift Service Mesh does not automatically inject the sidecar into any pods, but you must opt in to injection using an annotation without labeling projects.

The upstream Istio community installation automatically injects the sidecar into pods within the projects you have labeled.

### Difference #3: Redhat operator specific objects

The Redhat operator adds a bundle of objects : SMCP, SMMR.

- SMCP is the service mesh control plane.
- SMMR is the service mesh member role, the way to include a project in the service mesh.

### Difference #4 : Command line tool

The command line tool for Red Hat OpenShift Service Mesh is `oc`
Red Hat OpenShift Service Mesh does not support `istioctl`

## Redhat support

### Istio service mesh operator support

The Red Hat OpenShift Service Mesh Operator supports multiple versions of the ServiceMeshControlPlane resource.

Version 2.2 Service Mesh control planes are supported on the following platform versions:

- Red Hat OpenShift Container Platform version 4.9 or later.
- Red Hat OpenShift Dedicated version 4.
- Azure Red Hat OpenShift (ARO) version 4.
- Red Hat OpenShift Service on AWS (ROSA).

### Supported configurations for Kiali

The Kiali console is only supported on the two most recent releases of the Chrome, Edge, Firefox, or Safari browsers.

### Supported configurations for Distributed Tracing

Jaeger agent as a sidecar is the only supported configuration for Jaeger. Jaeger as a daemonset is not supported for multitenant installations or OpenShift Dedicated.

### About the operator

To check the operator official github repo, please click [here](https://github.com/Maistra/istio-operator)

### RedHat Istio Operator Known issues

When you uninstall the operators, custom resources hang out, and persist:

- Original issue [here](https://issues.redhat.com/browse/OSSM-1692)
- Similar issue 1 with solution [here](https://access.redhat.com/solutions/4364051)
- Similar issue 2 with solution [here](https://access.redhat.com/solutions/6452551)

This issue costs me countless hours of debugging, please read it carefully before uninstalling your servicemesh operators on Openshift.
Basically you should look for the CRD finalizer and delete it, in order to get rid of the CRD.

## General Pre-requisites

- Before getting your hands dirty, you should be aware of the Redhat servicemesh architecture and design patterns. (Network communicaion level, Data and control plan work, Istio components, Istio ingress, network policies created, ...)
Please read carefully the istio service mesh introduction + design patterns considerations.

- Access right management: Managing users and profiles (access to service mesh by a group of users [teams, department, ...], ...)

- Security decisions/strategy:
    - Define a TLS version (if required by the organization policy for example).
    - TLS mode upgrade stategy: Use permissive mode while you migrate your workloads to Service Mesh. Then, you can enable strict mTLS across your mesh, namespace, or application.

### Certificate management with Istio mTLS

The Citadel component in Istio manages the lifecycle of keys and certificates issued for services. When Istio establishes mutual TLS authentication, it uses these keys and certificates to exchange the identities of services.

To establish a mutual TLS connection between two services, the envoy proxy on the client side establishes a mutual TLS handshake with the envoy proxy on the server side during which the client side envoy proxy verifies the identity of the server side and whether it is authorized to run the target service.

When the identities of the services are verified, the mutual TLS connection is established and the client service sends communication through the client side proxy to the server side proxy and finally to the target service.

The authentication policies and secure naming information is distributed to the Envoy proxies by the Pilot component. The Mixer component handles the authorization and auditing part of Istio security.

### Setting the correct network policy

Service Mesh creates network policies in the Service Mesh control plane and member namespaces to allow traffic between them. Before you deploy, consider the following conditions to ensure the services in your service mesh that were previously exposed through an OpenShift Container Platform route:

- Traffic into the service mesh must always go through the ingress-gateway for Istio to work properly.

- Deploy services external to the service mesh in separate namespaces that are not in any service mesh.

- Non-mesh services that need to be deployed within a service mesh enlisted namespace should label their deployments maistra.io/expose-route: "true", which ensures OpenShift Container Platform routes to these services still work.

## References

[Service Mesh documentation](https://docs.openshift.com/container-platform/4.10/service_mesh/v2x/ossm-vs-community.html)