---
title: Security — Learning Roadmap
date: 2024-01-21 11:02:00
categories:
- System Design
tags:
- Security
- Authentication
- Best Practices
---

# Security — Learning Roadmap

This is the starting point for the enterprise security curriculum. It connects concise concept articles, the evolving [reference enterprise system](reference-enterprise-system.md), interactive learning sessions, and evidence gates into one path.

For each unit:

1. **Learn** the underlying concepts in the linked security articles.
2. **Apply** them to the same enterprise system in the linked curriculum sequence.
3. **Demonstrate** the skill through the learning session and required artifact.
4. **Revisit** weak areas using the [adaptive learning system](adaptive-learning-system.md).

Do not advance because an article was read. Advance when the evidence gate can be completed without relying on an answer key.

## Unit 1 — Security Thinking and Trust

Build the mental model used throughout the course: assets, threats, trust boundaries, attack paths, controls, evidence, and residual risk.

| Order | Learn | Apply and demonstrate |
|---|---|---|
| 1 | [Security Fundamentals](../01-security-thinking-trust/security-fundamentals.md) | [Phase 1: Security Mental Model](../01-security-thinking-trust/applied-security-thinking-threats-identity.md#phase-1-security-mental-model) |
| 2 | [Core Concepts](../01-security-thinking-trust/core-concepts.md) and [Key Principles](../01-security-thinking-trust/key-principles.md) | Learning Session 1: build an asset-to-recovery risk chain |
| 3 | Threat-model the reference system | [Phase 2: Practical Threat Modeling](../01-security-thinking-trust/applied-security-thinking-threats-identity.md#phase-2-practical-threat-modeling) |

**Exit evidence:** risk register, trust-boundary diagram, prioritized threat records, negative tests, and residual-risk owners.

## Unit 2 — Identity, Credentials, and Authorization

Follow identity from initial proof through sessions, federation, workload identity, authorization, revocation, and audit.

| Order | Learn | Apply and demonstrate |
|---|---|---|
| 1 | [Password Storage](../02-identity-access/password-storage.md) and [Authentication Mechanisms](../02-identity-access/authentication-mechanisms.md) | Compare password, MFA, passkey, certificate, and workload authentication threats |
| 2 | [Sessions, Tokens & JWT](../02-identity-access/sessions-tokens-jwt.md) | Test expiry, replay, audience, storage, refresh, and revocation behavior |
| 3 | [OAuth 2.0 and OIDC](../02-identity-access/oauth2-oidc.md) and [Enterprise SSO](../02-identity-access/enterprise-sso.md) | Trace browser, partner, workforce, and machine identity flows |
| 4 | [Authorization Models](../02-identity-access/authorization-models.md) | [Phase 3: Identity and Access](../01-security-thinking-trust/applied-security-thinking-threats-identity.md#phase-3-identity-and-access) |

**Exit evidence:** identity-flow diagram, principal-to-resource matrix, least-privilege design, lifecycle tests, and privilege-change audit event.

## Unit 3 — API, Application, and Data Protection

Turn identity and threat decisions into secure request handling, business invariants, and data-lifecycle controls.

| Order | Learn | Apply and demonstrate |
|---|---|---|
| 1 | [API Security](../03-application-data/api-security.md) | [Phase 4: API Security](../03-application-data/applied-api-application-data.md#phase-4-api-security) |
| 2 | [Web Attacks & OWASP Top 10](../03-application-data/web-attacks-owasp.md) | [Phase 5: Application Security Patterns](../03-application-data/applied-api-application-data.md#phase-5-application-security-patterns) |
| 3 | [Spring Boot API Security Flow](../03-application-data/spring-boot-api-security-flow.md) | Trace source, validation, authorization, sink, response, and telemetry |
| 4 | Data classification and lifecycle decisions | [Phase 6: Data Security](../03-application-data/applied-api-application-data.md#phase-6-data-security) |

**Exit evidence:** API inventory, deny-path regression pack, secure code-review trace, data-flow classification, access matrix, and export detection.

## Unit 4 — Transport, Network, Cloud, and Runtime

Constrain reachability and blast radius across TLS, GCP, Kubernetes, networks, secrets, and cryptographic operations.

| Order | Learn | Apply and demonstrate |
|---|---|---|
| 1 | [Cryptography Basics](../04-platform-runtime/cryptography-basics.md) and [HTTPS and TLS](../04-platform-runtime/https-tls.md) | Explain the property each primitive provides and validate TLS identity |
| 2 | [Network Protection](../04-platform-runtime/network-protection.md) | Design ingress, egress, segmentation, DDoS, WAF, and zero-trust controls |
| 3 | [Secrets Management](../04-platform-runtime/secrets-management.md) | Replace static credentials where possible and exercise rotation and revocation |
| 4 | GCP, GKE, network, and cryptographic controls | [Applied Platform Sessions](../04-platform-runtime/applied-cloud-platform-network-crypto.md) |

**Exit evidence:** cloud identity map, compromised-pod attack graph, connectivity matrix, TLS validation, secret inventory, and rotation drill.

## Unit 5 — Secure Delivery and Security Operations

Carry trust from source to runtime, then detect, investigate, prioritize, recover, and produce governance evidence.

| Order | Learn | Apply and demonstrate |
|---|---|---|
| 1 | Supply-chain and CI/CD trust | [Software Supply Chain and Secure Delivery](../05-secure-delivery-operations/software-supply-chain-cicd.md) |
| 2 | Incident response and observability | [Security Operations, Phases 13–14](../05-secure-delivery-operations/security-operations-governance.md#phase-13-incident-response) |
| 3 | Vulnerability management and governance | [Security Operations, Phases 15–16](../05-secure-delivery-operations/security-operations-governance.md#phase-15-vulnerability-management) |
| 4 | Production hardening | [Production Security and Operational Readiness](../05-secure-delivery-operations/production-considerations.md) |

**Exit evidence:** commit-to-runtime trust map, gate policy, tested detection, incident timeline, risk-ranked backlog, control mapping, and time-bound exception.

## Unit 6 — Architecture, AI, and FDE Leadership

Synthesize the preceding units into defensible architecture and customer decisions under ambiguity, delivery pressure, and operational constraints.

| Order | Learn | Apply and demonstrate |
|---|---|---|
| 1 | Architecture patterns and policy as code | [Advanced Security Patterns](../06-architecture-leadership/advanced-security-patterns.md) |
| 2 | Enterprise architecture method | [Phase 17](../06-architecture-leadership/security-architecture-ai-fde.md#phase-17-security-architecture-method) |
| 3 | AI, RAG, and agent security | [Phase 18](../06-architecture-leadership/security-architecture-ai-fde.md#phase-18-ai-llm-rag-and-agent-security) |
| 4 | Customer leadership and capstone | [FDE Customer Leadership](../06-architecture-leadership/security-architecture-ai-fde.md#fde-customer-leadership) |

**Exit evidence:** architecture decision record, complete threat model, control/evidence matrix, AI tool-authorization design, incident path, residual-risk decision, and customer recommendation.

## Recommended progression

- Complete Units 1–2 in order; every later unit depends on their threat and identity models.
- Complete Units 3–4 before designing delivery gates or operational detections.
- Complete Unit 5 before the architecture capstone so designs include evidence and recovery, not only preventive controls.
- Use the [capability map](capability-map.md) to identify domain gaps and the [quick reference](../07-reference/01-quick-reference.md) during exercises.
- Return to this roadmap after each evidence gate and record the next gap rather than marking a topic permanently complete.
