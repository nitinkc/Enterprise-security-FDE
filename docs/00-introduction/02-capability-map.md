# Enterprise Security Capability Map

Use this map as the curriculum backbone. The sequence follows the security decision loop rather than treating security as a list of products.

> **Asset → threat → attack surface → vulnerability → exploit → impact → control → detection → response → recovery**

## Learning Contract

For every topic, be able to explain the asset at risk, attacker objective, trust boundary, preventive control, detective signal, response action, residual risk, and evidence that the control works. A topic is not complete when you can define it; it is complete when you can make and defend a design decision.

## Capability Domains

| Stage | Domain | Decisions You Must Be Able to Make | Required Evidence |
|---|---|---|---|
| 1 | Security mental model | Rank risks by likelihood, impact, exposure, and blast radius | Risk statement and control hypothesis |
| 2 | Threat modeling | Find assets, actors, entry points, trust boundaries, and STRIDE threats | Data-flow diagram and threat register |
| 3 | Identity | Choose authentication, authorization, federation, and lifecycle controls | Identity flow and deny-path tests |
| 4 | API security | Prevent broken object/function authorization, injection, SSRF, and abuse | Negative tests and API inventory |
| 5 | Application security | Remove vulnerability patterns at design and implementation layers | Secure code review and regression tests |
| 6 | Data security | Classify, minimize, encrypt, retain, and delete sensitive data | Data-flow map and access evidence |
| 7 | GCP security | Design hierarchy, IAM, network, compute, data, and logging controls | Policy export and drift checks |
| 8 | Kubernetes security | Limit pod compromise, lateral movement, and privilege escalation | Admission, RBAC, and network-policy tests |
| 9 | Network security | Control ingress, egress, segmentation, TLS, DNS, and service trust | Connectivity matrix and flow evidence |
| 10 | Secrets and cryptography | Select managed primitives and rotation patterns | Key ownership and rotation proof |
| 11 | Software supply chain | Establish dependency, artifact, image, SBOM, signing, and provenance trust | Verified build and scan artifacts |
| 12 | Secure CI/CD | Decide which findings block, warn, expire, or require exception | Pipeline policy and exception record |
| 13 | Incident response | Triage, contain, eradicate, recover, and learn under pressure | Timeline, decisions, and after-action review |
| 14 | Security observability | Turn telemetry into actionable detections and investigations | Detection logic and response linkage |
| 15 | Vulnerability management | Prioritize beyond CVSS using exposure and business context | Owner, SLA, re-test, and closure evidence |
| 16 | Governance | Translate frameworks into enforceable engineering behavior | Control-to-evidence mapping |
| 17 | Security architecture | Explain controls, trade-offs, residual risk, and operating cost | Architecture decision record |
| 18 | AI and agent security | Bound model data, tool authority, egress, and untrusted content | AI threat model and tool authorization tests |

## Depth Levels

| Level | Expected Behavior |
|---|---|
| Recognize | Identify the asset, trust boundary, and likely failure mode. |
| Apply | Implement or test a control in the reference system. |
| Analyze | Trace an attack path and estimate business impact and blast radius. |
| Decide | Compare options and document residual risk and operational trade-offs. |
| Lead | Defend the decision with customer, security, engineering, and audit stakeholders. |

## Reusable Lesson Pattern

1. Present the current architecture and business constraint.
2. Ask the learner to identify assets, threats, and trust boundaries before revealing answers.
3. Introduce one realistic failure or attacker action.
4. Compare preventive, detective, and responsive controls.
5. Implement the smallest effective control and a negative regression test.
6. Capture evidence, residual risk, owner, and review date.
7. Revisit the same system later with a harder constraint or new threat.

## Enterprise Readiness Gate

A capability is production-ready only when the learner can:

- explain who calls whom and why that identity is trusted;
- show that authorization applies to the exact action and resource;
- describe what an attacker gains if the control fails;
- prove deny behavior without exposing sensitive data;
- identify logs, alerts, containment actions, and recovery ownership;
- communicate a practical recommendation without overstating certainty.

Continue with the [reference enterprise system](02-reference-enterprise-system.md), then study the complete curriculum in order:

1. [Security thinking, threats, and identity](../04-curriculum/01-security-thinking-threats-identity.md)
2. [API, application, and data security](../04-curriculum/02-api-application-data.md)
3. [GCP, Kubernetes, network, and cryptography](../04-curriculum/03-cloud-platform-network-crypto.md)
4. [Software supply chain and secure delivery](../04-curriculum/04-supply-chain-cicd.md)
5. [Security operations, vulnerabilities, and governance](../04-curriculum/05-security-operations-governance.md)
6. [Security architecture, AI, and FDE leadership](../04-curriculum/06-architecture-ai-fde.md)

Use the [adaptive learning system](03-adaptive-learning-system.md) after each sequence to revisit gaps before advancing.
