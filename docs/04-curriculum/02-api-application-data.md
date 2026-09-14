# Sequence 2: API, Application, and Data Security

**Phases 4–6 · Prerequisite:** Sequence 1 · **Outcome:** convert identity and threat decisions into secure Spring Boot behavior and data controls.

## Phase 4 — API Security

Inventory every route, method, caller, authentication mechanism, authorization rule, request source, response classification, rate limit, and outbound dependency. Map findings to the current OWASP API Security Top 10, but fix the underlying design rather than the label.

| Failure | Attack | Control and Proof |
|---|---|---|
| Broken authentication | Forged, replayed, expired, or mis-audienced token | Full token validation and negative token tests |
| BOLA/IDOR | Valid user reads another tenant’s object | Server-side tenant/resource check and cross-tenant test |
| Broken function authorization | User invokes administrative route | Policy at service boundary and role-negative test |
| Mass assignment | Client sets owner, role, or status fields | Explicit request DTO and immutable server-owned fields |
| Excessive data exposure | API returns full entity | Purpose-specific response DTO and schema assertion |
| Injection | Input becomes SQL, shell, template, LDAP, or NoSQL syntax | Parameterization and adversarial input tests |
| SSRF | User-controlled URL reaches metadata or internal service | Destination allowlist, safe client, egress control |
| Resource abuse | Unbounded requests exhaust API or dependencies | Quotas, pagination, size/time limits, backpressure |
| Unsafe errors | Stack traces, identifiers, or PHI leak | Stable error contract and log-redaction tests |

For every vulnerability: show the vulnerable design, trace the attack, state impact, fix the root cause, add a regression test, and automate detection where reliable. Distinguish `401` unauthenticated from `403` authenticated but forbidden; return neither resource existence nor sensitive payload on deny.

**Exercise:** Harden `POST /referrals`, `GET /referrals/{id}`, `DELETE /referrals/{id}`, and `GET /admin/users`. Test anonymous, wrong audience, expired token, missing scope, wrong tenant, wrong owner, wrong role, duplicate request, oversized payload, and rate-limit behavior.

### Learning Session 4 — Break and Harden the Referral API

**Objective:** Derive API controls from caller, resource, tenant, and abuse-path decisions.

**Scenario:** The Spring Boot referral API trusts gateway authentication, returns persistence entities, accepts client-owned status fields, and can fetch a partner callback URL.

**Facilitator flow:** Present one endpoint and one weakness at a time. Require the learner to explain the attack before discussing a fix.

1. For `GET /referrals/{id}`, which identity and resource relationship must the service prove?
2. How can a valid user turn an identifier into a cross-tenant attack?
3. Which invariant belongs in the controller, service, repository, and database boundary?
4. What changes for forged, expired, replayed, or wrong-audience tokens?
5. How could mass assignment, excessive output, SSRF, or unbounded requests affect this endpoint family?
6. Which regression tests and telemetry prove denials without leaking resource existence?

**Artifact:** Endpoint inventory and an implemented hardening plan for all four routes.

**Evidence gate:** Automated negative tests cover authentication, function and object authorization, tenant isolation, request/response fields, outbound destinations, limits, and safe errors.

**Adaptive branch:** If the learner proposes gateway-only enforcement, test a direct service call. If all controls hold, add a trusted partner token with the wrong tenant context.

## Phase 5 — Application Security Patterns

Learn vulnerability families through data/control-flow patterns:

```text
Untrusted input + powerful interpreter + missing separation = injection
Attacker-controlled destination + server network authority = SSRF
User-controlled identifier + missing object authorization = IDOR
Sensitive state change + ambient browser authority = CSRF
Untrusted object graph + unsafe reconstruction = insecure deserialization
```

| Class | Design Rule |
|---|---|
| SQL/NoSQL/LDAP/command/template injection | Use structured APIs and parameterization; never concatenate syntax |
| XSS | Context-aware output encoding, safe templating, CSP, no unsafe DOM sinks |
| CSRF | SameSite cookies and anti-CSRF protection for cookie-authenticated state changes |
| Path traversal and file upload | Canonicalize, confine storage, sniff MIME, limit size, strip EXIF, scan content |
| XXE/deserialization | Disable external entities and unsafe polymorphic/native deserialization |
| Race condition | Enforce invariant atomically; use idempotency and concurrency tests |
| Cryptography and secrets | Use approved libraries and managed keys; never invent protocols |
| Business logic | Model abuse of valid workflows, limits, ordering, refunds, and approval paths |
| Dependencies | Pin, lock, inventory, verify provenance, scan, prioritize, and update safely |

Secure code review follows source → validation → transformation → authorization → sink → response → telemetry. Review failure paths and background jobs, not only controllers. Never log request bodies, tokens, clinical details, or sensitive identifiers by default.

**Exercise:** Trace one referral request through Spring Security filters, controller, service, repository, event publication, and logs. Identify where each invariant is enforced and write tests proving bypasses fail.

### Learning Session 5 — Trace Vulnerability Patterns Through Code

**Objective:** Recognize exploitable data and control flows across the full Spring Boot request lifecycle.

**Scenario:** A referral request reaches validation, persistence, event publication, a notification template, and structured logs. Several layers assume another layer made the security decision.

**Facilitator flow:** Provide one vulnerable flow. The learner must identify source, trust change, interpreter or privileged sink, impact, and bypass before remediation.

1. Where does attacker influence enter, and where is its meaning transformed?
2. Which security invariant must remain true across filters, controller, service, repository, events, and background consumers?
3. Which sink creates SQL, command, template, file, network, browser, or deserialization risk?
4. Can concurrency, retries, or valid workflow abuse violate the same invariant without malformed input?
5. What root-cause design change removes the dangerous interpretation or missing authorization?
6. Which regression test and automated signal detect the original class rather than one payload?

**Artifact:** An annotated source-to-sink trace and a secure-code-review finding with root cause, exploit path, fix, test, and telemetry.

**Evidence gate:** The learner demonstrates one injection family, one authorization or business-logic failure, and one non-request path such as an event consumer or scheduled job.

**Adaptive branch:** If the learner searches for payload strings, switch interpreters while retaining the pattern. If successful, add a race between duplicate referral submissions.

## Phase 6 — Data Security

Classify data by sensitivity and permitted use before choosing storage. For PHI/PII, verify minimum necessary use, approved location, retention, disclosure, and third-party BAA requirements with authoritative owners.

| Lifecycle | Required Decision |
|---|---|
| Collect | Is each field necessary, consented/authorized, and validated? |
| Process | Which identity, purpose, tenant, and operation are allowed? |
| Store | PostgreSQL/BigQuery boundary, encryption, row/column access, backups |
| Share | Recipient, approved purpose, minimization, contract/BAA, secure transfer |
| Observe | Audit useful access without placing sensitive data in logs or URLs |
| Retain/delete | Enforce schedule, legal hold, deletion propagation, backup expiry |

Encryption at rest and TLS protect different attack paths; neither fixes excessive authorization. KMS design includes key ownership, separation of duties, rotation, disable/destroy safeguards, availability, and auditability. Use tokenization or masking when workflows do not require original values. BigQuery datasets need purpose-specific access and monitored exports; PostgreSQL needs private connectivity, least-privilege roles, parameterized queries, and tested backup restoration.

**Evidence gate:** Data-flow diagram, field-level classification, access matrix, retention schedule, key ownership, backup/restore test, denied query test, BigQuery export detection, and proof that errors/URLs/logs exclude PHI.

### Learning Session 6 — Constrain Sensitive Data Blast Radius

**Objective:** Design controls across the complete data lifecycle rather than treating encryption as the data-security solution.

**Scenario:** Referral data is duplicated from PostgreSQL into BigQuery, appears in support logs, uses broadly administered keys, and has no tested deletion or restoration path.

**Facilitator flow:** Begin with one field and one permitted business use. Expand only after the learner identifies who needs the original value and why.

1. How should each referral field be classified, minimized, and tied to a permitted purpose?
2. Which principals can collect, process, query, export, support, and delete the data?
3. What attack paths are reduced by TLS, storage encryption, CMEK, tokenization, masking, and row-level controls?
4. What remains exposed if an authorized database or analytics principal is compromised?
5. How do retention, legal hold, deletion propagation, backups, and key lifecycle interact?
6. Which denied query, export alert, restore drill, and log-redaction test prove the design?

**Artifact:** Field-level classification and data-flow diagram with access, retention, key ownership, and deletion decisions.

**Evidence gate:** The learner proves minimum necessary access in PostgreSQL and BigQuery, monitored exports, recoverable backups, deletion behavior, and absence of sensitive data in errors, URLs, and logs.

**Adaptive branch:** If encryption is presented as sufficient, compromise an authorized query identity. If the design is strong, add a legal hold and an analytics vendor requiring minimized data.

**Next:** [Sequence 3 — GCP, Kubernetes, network, and cryptography](03-cloud-platform-network-crypto.md).
