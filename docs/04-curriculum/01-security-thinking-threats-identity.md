# Sequence 1: Security Thinking, Threats, and Identity

**Phases 1–3 · Prerequisite:** senior engineering experience · **Outcome:** reason from assets and trust instead of controls and products.

Use the [reference enterprise system](../00-introduction/02-reference-enterprise-system.md). Complete each phase in order because identity decisions depend on the threat model, and the threat model depends on a sound risk vocabulary.

## Phase 1 — Security Mental Model

Security preserves **confidentiality, integrity, and availability** while producing enough accounting and audit evidence to explain important actions. Authentication establishes an identity claim; authorization decides whether that principal may perform a specific action; auditing records decision-relevant facts.

| Concept | Security Engineer’s Question | Common Failure |
|---|---|---|
| Asset and threat | What has value, and which actor wants to harm or misuse it? | Starting with a scanner rather than business impact |
| Trust boundary | Where does identity, ownership, or validation change? | Trusting “internal” network location |
| Attack surface | Which interfaces, identities, dependencies, and operators can affect the asset? | Inventorying only public HTTP routes |
| Vulnerability and exploit | Which weakness makes an attack path feasible? | Treating every weakness as equally exploitable |
| Risk | What are likelihood, impact, exposure, and uncertainty? | Equating CVSS with business risk |
| Control | Does it prevent, detect, respond, or recover? | Assuming a configured control is effective |
| Posture | What is true now, including drift and exceptions? | Treating certification as current security |

Apply defense in depth, least privilege, secure defaults, fail-secure behavior, separation of duties, and bounded blast radius. Zero trust means continuously evaluating identity, device/workload context, resource, and action; it does not mean “trust nobody” or buying one product.

**Exercise:** Identify five assets in the reference system. For each, write one threat, one preventive control, one signal, and one containment action. Explain how the system fails if each control is unavailable.

### Learning Session 1 — See the System as a Security Engineer

**Objective:** Convert an architecture inventory into an asset-to-recovery risk chain.

**Scenario:** The reference platform is about to accept its first sensitive referral. The diagram is accurate, but no security decisions or evidence exist yet.

**Facilitator flow:** Ask only the first unanswered question, wait for the learner’s response, and challenge assumptions before continuing.

1. Which single asset would create the greatest business impact if its confidentiality, integrity, or availability failed?
2. Which actor has the motivation and practical access needed to affect it?
3. Trace one path from attack surface through vulnerability, exploit, and impact.
4. Classify one control as preventive, detective, responsive, or recovery-oriented. What does it not prevent?
5. What signal proves the control operated, and what happens if it fails open?
6. How would least privilege, separation of duties, or a smaller blast radius change the outcome?

**Artifact:** A five-row risk register using `asset → threat → attack surface → vulnerability → exploit → impact → control → detection → response → recovery`.

**Evidence gate:** Each row names an owner, a negative test, a detection signal, residual risk, and a recovery action. Advance only when the learner distinguishes current posture from intended configuration.

**Adaptive branch:** If the learner starts with products or scanners, return to asset and impact. If the reasoning is complete, add an unavailable identity provider or compromised administrator.

## Phase 2 — Practical Threat Modeling

1. Define business objective and scope.
2. Inventory data, credentials, services, artifacts, and availability dependencies.
3. Identify users, administrators, workloads, partners, insiders, and external attackers.
4. Draw data flows, entry points, stores, processing steps, and trust boundaries.
5. Apply STRIDE to each element and trace complete attack paths.
6. Rank threats, choose mitigations, assign owners, and record residual risk.
7. Validate the model with negative tests, telemetry, and incident scenarios.

| STRIDE | Question | Reference-System Example |
|---|---|---|
| Spoofing | Can an actor impersonate a principal or workload? | Stolen partner credential |
| Tampering | Can data, configuration, or artifacts be modified? | Unsigned image replacement |
| Repudiation | Can an actor plausibly deny a sensitive action? | Shared administrator identity |
| Information disclosure | Can data reach an unauthorized party? | PHI in logs or analytics export |
| Denial of service | Can capacity or a dependency be exhausted? | Unbounded API or database query |
| Elevation of privilege | Can a principal gain stronger authority? | Runtime SA can impersonate deployer |

**Exercise:** Before reading a solution, mark every trust boundary on the reference diagram and produce ten threats. Include precondition, attack step, impact, existing control, proposed control, detection, owner, and residual risk.

### Learning Session 2 — Build the First Threat Model

**Objective:** Produce a usable threat model rather than a diagram decorated with threat labels.

**Scenario:** Users, partner systems, administrators, CI workers, and runtime workloads all interact with the referral platform. Trust currently changes at undocumented boundaries.

**Facilitator flow:** Reveal no threat list. Ask the learner to draw the flow first, then examine one element at a time with STRIDE.

1. What business operation is in scope, and what must remain explicitly out of scope?
2. Where do identity, ownership, privilege, data classification, or administrative control change?
3. Choose one boundary. Which actor can cross it, under what precondition, and through which entry point?
4. Apply STRIDE to that element and trace one complete attack path to business impact.
5. Which mitigation breaks the path most reliably, and which independent signal detects failure?
6. Who owns the residual risk and what evidence should trigger model review?

**Artifact:** A data-flow diagram plus ten threat records containing precondition, attack step, impact, mitigation, detection, owner, and residual risk.

**Evidence gate:** At least one threat from every STRIDE category is tied to a real element or flow, prioritized by attack feasibility and business impact, and validated by a proposed negative test.

**Adaptive branch:** If boundaries are missed, introduce a partner identity and a CI deployment path. If the model is strong, add asynchronous messaging and partial telemetry.

## Phase 3 — Identity and Access

Always ask: **Who is calling whom, how is identity proven, why is this action allowed, and how is access removed?**

| Identity Area | Decisions to Make |
|---|---|
| Authentication | Password policy, phishing-resistant MFA, session lifetime, re-authentication, revocation |
| Tokens | JWT signature, issuer, audience, expiry, algorithm, key rotation, replay resistance |
| Federation | OAuth 2.0 authorization, OIDC identity, SSO trust, IdP availability and compromise |
| Authorization | RBAC baseline, ABAC context, scopes, claims, server-side resource and tenant checks |
| Workforce identity | Joiner/mover/leaver lifecycle, privileged access, access reviews, break-glass handling |
| Workload identity | Unique service accounts, short-lived credentials, service-to-service authentication |
| GCP IAM | Resource hierarchy, principals, roles, permissions, conditions, impersonation, org policies |

Do not use ID-token claims as permanent application permissions without lifecycle design. Authentication at a gateway does not replace authorization in the service. Network reachability does not establish a business right to access a resource.

**Evidence gate:** Produce an identity-flow diagram, principal-to-resource authorization matrix, least-privilege rationale, disabled-user test, expired/replayed-token test, cross-tenant test, and audit event for privilege changes.

**FDE scenario:** A customer requests one project-owner service account for CI and runtime. Propose separated federated identities, minimum roles, operational fallback, and a time-bound exception path without dismissing the delivery deadline.

### Learning Session 3 — Design the Identity Control Plane

**Objective:** Separate authentication, authorization, lifecycle, and audit decisions for workforce and workload identities.

**Scenario:** One project-owner service account is shared by CI and runtime, gateway authentication is treated as authorization, and tenant membership is copied into long-lived tokens.

**Facilitator flow:** Keep the running question visible: who is calling whom, how is identity proven, why is this action allowed, and how is access removed?

1. Enumerate every workforce, partner, CI, runtime, and administrative principal in one referral flow.
2. Which trust authority authenticates each principal, and what failure or compromise must be assumed?
3. Where must function-, resource-, and tenant-level authorization occur?
4. Which claims are trustworthy only at issuance, and which permissions require current server-side state?
5. How should GCP roles, conditions, impersonation, and federation separate CI from runtime?
6. How are disablement, revocation, emergency access, and privilege changes tested and audited?

**Artifact:** Identity-flow diagram, principal-to-resource matrix, and a replacement design for the shared service account.

**Evidence gate:** Wrong-audience, expired, replayed, disabled-user, cross-tenant, role-negative, and CI/runtime privilege-separation tests pass; privilege changes generate useful audit events.

**Adaptive branch:** If network location is used as trust, expose the service through a compromised internal workload. If the design is strong, require break-glass access during an IdP outage.

**Next:** [Sequence 2 — API, application, and data security](02-api-application-data.md).
