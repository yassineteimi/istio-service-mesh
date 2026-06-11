# Istio Service Mesh on OpenShift — Production Pilot Asset

**📖 Documentation site: [yassineteimi.github.io/istio-service-mesh](https://yassineteimi.github.io/istio-service-mesh/)**

This repository documents a real engagement: as a Cloud & Platform Architect with IBM Client Engineering, I designed the target architecture and automated the OpenShift deployment of an AI decision platform (IBM AI Decision Coordination) for **one of the largest banking groups in France** — in six weeks, ahead of the product's GA release.

> **Confidentiality:** the client is under NDA. Their name and all identifying details have been removed; everything else reflects the real project.

## What's inside

- **The production pilot** — project overview, target architecture (system context down to the physical operational model), and the full installation guide I authored for the product's GA release.
- **An Istio implementation guide** — field notes distilled from the engagement: design considerations at the mesh edge, installation, traffic management, mTLS and OIDC security patterns, observability, and debugging.
- **Working manifests** — the Istio resources used in the pilot (gateways, virtual services, destination rules, peer authentication, request authentication, authorization policies) in [`Istio/`](Istio/).

## Highlights

- Strict **mTLS everywhere** inside the mesh without touching application code, via the Red Hat OpenShift Service Mesh operator.
- **OIDC authentication at the edge** with Keycloak as identity provider (JWT validation with `RequestAuthentication` + `AuthorizationPolicy`).
- **Semi-automated installation** of the platform and its middlewares (Keycloak, PostgreSQL, MongoDB) with Ansible and Helm, including air-gapped scenarios.
- Delivered on time and **passed IBM internal penetration and performance testing**, unblocking the client contract signature.
