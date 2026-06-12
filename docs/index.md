# AI Decision Platform — Production Pilot at a Major French Bank

!!! note "Confidentiality"
    This engagement was delivered under NDA for one of the largest banking groups in France. The client's name and any identifying details have been removed from this documentation — everything else reflects the real project.

## The project at a glance

| | |
| -- | -- |
| **Client** | A major French bank (top-tier European banking group) |
| **My role** | Cloud & Platform Architect — IBM Client Engineering |
| **Mission** | Design the target architecture and automate the OpenShift deployment of IBM AI Decision Coordination (AIDC) ahead of its GA release |
| **Stack** | OpenShift, Istio service mesh, Keycloak (OIDC), MongoDB, PostgreSQL, Helm, Ansible |
| **Duration** | 6 weeks |
| **Outcome** | Deployment package delivered on time, passed IBM internal penetration and performance testing, and unblocked the contract signature and product go-live |

## Background

During the Covid crisis, the bank faced a surge of loan requests that overwhelmed its back-office teams. To absorb the workload, it moved several AI models into production: repetitive, manual tasks were offloaded to AI, letting human agents focus on business value and complex decisions.

**IBM AI Decision Coordination (AIDC)** is the product born from that experience. It defines *when* and *how* AI should be involved in a business process, and how AI can be governed at enterprise scale. AIDC supports the Trustworthy AI framework by providing new sources of decisions and performance metrics, so AI can be deployed safely in decision processes — avoiding cognitive bias and staying compliant with regulations.

## The challenge

Ahead of a major contract signature, the bank expected to see a **stable, installable version of AIDC running on OpenShift**. The product development team did not have the platform and packaging skills in-house, and the GA release deadline left a **six-week window** to deliver a complete deployment package.

IBM Client Engineering — my team — worked side by side with the AIDC development team to cover every aspect of the solution packaging, while transferring the skills and knowledge to them at the same time.

## How the six weeks were spent

- **Framing & understanding (1 week)** — defined the MVP success factors, confirmed the scope, built the project plan, and assigned the workstreams.
- **Design & build (4 weeks)** — defined the target architecture, provisioned and configured the environment and required services, and automated the deployment process.
- **Delivery & evaluation (1 week)** — delivered the project documentation, evaluated the success factors, passed the IBM internal security checks (penetration and performance tests), and validated the project goals.

## What I delivered

- A **target architecture** compatible with the bank's security constraints and technical stack — see [Architecture](architecture.md).
- **Zero-trust networking with Istio**: strict mutual TLS between all services without touching application code, TLS at the cluster edge, and rate limiting on the exposed APIs.
- **Authentication and authorization** through the OIDC workflow, with Keycloak as identity provider.
- A **semi-automated installation** of the whole platform (core applications and middlewares) built with Ansible and Helm.
- **Knowledge transfer** to the product development team, so they could own the deployment package after the engagement.

## Results

- The product reached its **go-live on time**, allowing the contract to be signed.
- The deployment package **passed IBM's internal security gates** (penetration and performance testing).
- The architecture and automation were handed over as the **reference installation method** for the product's GA release.

## Explore this documentation

- [Architecture](architecture.md) — system context, operational models, requirements, and the architectural decisions behind the design.
- The **Istio sections** of this site are a field-tested implementation guide distilled from this engagement: design considerations, mesh installation, traffic management, security, and observability.
