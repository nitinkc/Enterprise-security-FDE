# Sequence 5: Security Operations, Vulnerabilities, and Governance

**Phases 13–16 · Prerequisite:** Sequence 4 · **Outcome:** detect and manage risk continuously, respond safely, and translate governance into engineering behavior.

## Phase 13 — Incident Response

```text
Prepare → Detect → Triage → Contain → Eradicate → Recover → Learn
```

Preserve safety and evidence while limiting impact. Record timestamps, observations, hypotheses, decisions, commands/actions, actors, and results. Do not place PHI or secrets in incident tickets or chat; use approved restricted systems and communication paths.

| Scenario | First Questions | Likely Containment |
|---|---|---|
| Compromised service account | Keys/tokens? permissions? use timeline? affected resources? | Disable/revoke, block paths, preserve audit evidence |
| Secret in Git | Was it valid, copied, used, or present in history/logs? | Rotate first, then remove source and history per process |
| Stolen JWT | Issuer/audience/subject/expiry/session and observed actions? | Revoke session/key as appropriate, restrict account/resource |
| Compromised pod | Namespace, SA/RBAC, cloud IAM, mounts, node and egress reach? | Isolate workload, block identity/network, preserve runtime evidence |
| BigQuery export | Principal, query/job, destination, data classification, authorization? | Stop jobs/access and protect destination evidence |
| Suspicious PostgreSQL | Account, source, queries, rows, privilege changes, exfiltration? | Disable path, isolate DB as needed, preserve database/audit logs |

Recovery means restored service with compromised paths removed and controls revalidated. Close only after an owner accepts residual risk and prevention work is tracked.

### Learning Session 13 — Lead an Incident Under Uncertainty

**Objective:** Contain business impact while preserving evidence, safety, and recoverability.

**Scenario:** An alert shows a runtime service account exporting unusual BigQuery data shortly after an interactive pod exec. Token source and affected records are unknown.

**Facilitator flow:** Reveal only the initial alert. Provide additional facts only when the learner asks a precise investigative question.

1. What is known, assumed, and unknown, and which assets may be affected?
2. Which first actions reduce harm without destroying evidence or causing avoidable outage?
3. Which identity, Kubernetes, BigQuery, network, and audit timelines must be correlated?
4. How will the learner test competing hypotheses and bound scope?
5. What containment, eradication, recovery, and communication decisions require which owners?
6. Which controls must be revalidated before closure, and what residual risk remains?

**Artifact:** Timestamped incident log, hypothesis table, containment decision record, and recovery checklist.

**Evidence gate:** Actions identify actor and rationale, avoid sensitive ticket content, preserve approved evidence, constrain the compromised paths, validate recovery, and assign prevention work.

**Adaptive branch:** If the learner rotates everything immediately, introduce evidence loss and availability impact. If response is disciplined, add incomplete logs and a customer-facing deadline.

## Phase 14 — Security Observability

Build **logs → normalized events → signal → detection → alert → investigation → response**. Collect authentication failures, authorization denials, privilege changes, service-account use, secret access, admin activity, configuration changes, network anomalies, unusual API use, database access, and data exports.

A production detection states threat, data source, query/logic, threshold or behavioral model, expected false positives, severity, owner, runbook, privacy treatment, test event, and freshness objective. Correlation IDs should support tracing without embedding sensitive identifiers. Protect logs from alteration and excessive access; retain them according to approved requirements.

**Exercise:** Replay synthetic events for cross-tenant denials, new IAM grant, secret read, unusual BigQuery export, pod exec, and blocked egress. Confirm alert delivery and first runbook action.

### Learning Session 14 — Turn Telemetry Into Investigation

**Objective:** Build detections that express a threat, produce actionable context, and lead to a tested response.

**Scenario:** The platform stores many logs but only alerts on raw error counts. Privilege grants, cross-tenant denials, pod exec, secret reads, and data exports are not correlated.

**Facilitator flow:** Start with one threat and ask for the minimum decision-relevant telemetry. Do not begin with a SIEM query or product.

1. Which actor, precondition, behavior, and impact define the detection objective?
2. Which application, IAM, GKE, network, secret, database, and analytics events are required?
3. Which fields support correlation without exposing sensitive data?
4. What logic, threshold, freshness, severity, and expected false positives make the signal actionable?
5. Who owns triage, what is the first runbook action, and when should the alert escalate?
6. How will a synthetic event prove collection, correlation, delivery, investigation, and response?

**Artifact:** Detection specification and runbook for one complete attack path.

**Evidence gate:** A replayed event reaches the correct owner with sufficient context, protected logs, measured latency, understood false positives, and a verified first action.

**Adaptive branch:** If the learner proposes “log everything,” impose privacy and cost constraints. If successful, remove one data source and require confidence-aware investigation.

## Phase 15 — Vulnerability Management

```text
Discover → validate → prioritize → assign → remediate → verify → track
```

| Factor | Question |
|---|---|
| Exploitability | Is exploitation practical and is code available/observed? |
| Exposure | Is the path internet, partner, workforce, or workload reachable? |
| Asset criticality | Could it affect PHI, care operations, credentials, or platform control? |
| Privilege/blast radius | What can the attacker reach after success? |
| Compensating controls | Which independent controls materially reduce likelihood or impact? |
| Business impact | What are safety, privacy, operational, financial, and trust outcomes? |

CVSS is an input, not the decision. Every actionable item needs asset, evidence, attack path, owner, risk-based SLA, remediation, exception state, re-test, and closure proof. Track recurrence and aging, not only volume.

**Exercise:** Prioritize a backlog containing a public medium SSRF, isolated critical library CVE, cross-tenant authorization defect, stale admin account, and expiring certificate. Defend the order and state missing facts.

### Learning Session 15 — Prioritize the Vulnerability Backlog

**Objective:** Make defensible remediation decisions from attack path and business risk rather than scanner severity alone.

**Scenario:** The backlog contains a public medium SSRF, isolated critical library CVE, cross-tenant authorization defect, stale administrator account, and expiring production certificate.

**Facilitator flow:** Withhold convenient facts. Require the learner to state what evidence would materially change priority.

1. Which asset, principal, exposure, and business process does each issue affect?
2. Is exploitation reachable and practical, and what privilege or lateral movement follows?
3. Which compensating controls independently reduce likelihood or impact?
4. How should safety, privacy, availability, financial, and trust impact affect ordering?
5. What owner, SLA, remediation, exception, and verification evidence does each item need?
6. Which issue is first, and which missing fact could reverse that decision?

**Artifact:** Ranked backlog with rationale, uncertainty, owners, SLAs, and verification plans.

**Evidence gate:** Priority is reproducible from documented factors, exceptions are authorized and expiring, fixes are re-tested, and closure records prove the attack path is removed.

**Adaptive branch:** If CVSS determines ordering, swap severity labels while retaining exposure. If prioritization is strong, add an active exploit report and a certificate expiry during a freeze.

## Phase 16 — Governance and Compliance Engineering

Policies state intent; standards define mandatory outcomes; procedures describe execution; controls change risk; evidence demonstrates operation. Risk acceptance belongs to an authorized business/risk owner, not the implementer. Exceptions are narrow, justified, compensated, approved, monitored, and time-bound.

| Framework | Engineering Use |
|---|---|
| NIST CSF | Organize govern, identify, protect, detect, respond, and recover outcomes |
| NIST SP 800-53 | Select and assess detailed control families |
| CIS Controls/Benchmarks | Prioritize safeguards and hardening baselines |
| OWASP | Model application/API risks and verification practices |
| ISO 27001 | Operate a risk-based information security management system |
| SOC 2 | Demonstrate controls relevant to trust-services commitments |
| HIPAA | Protect ePHI through administrative, physical, and technical safeguards |

Use current authoritative DaVita policy and control sources. Do not infer compliance from cloud defaults or this training guide. Map requirement → risk → control objective → implementation → owner → evidence → cadence → exception.

**Evidence gate:** Tested incident timeline, detection catalog, prioritized backlog, access review, control mapping, audit evidence sample, and time-bound exception.

### Learning Session 16 — Translate Governance Into Engineering

**Objective:** Convert authoritative obligations into risk-reducing controls, evidence, ownership, and review cadence.

**Scenario:** A customer says “HIPAA requires encryption,” an audit asks for access-review evidence, and delivery requests a six-month exception to MFA.

**Facilitator flow:** Do not invent policy. Require an authoritative requirement or explicitly labeled assumption before designing implementation.

1. What authoritative requirement, policy, standard, or contract applies, and who owns interpretation?
2. Which asset and risk motivate the control objective?
3. What engineering behavior and implementation satisfy the objective?
4. Which owner, evidence, frequency, test, and failure response demonstrate operation?
5. Who may accept residual risk, and what makes an exception narrow, compensated, monitored, and time-bound?
6. How would the learner explain the requirement without overstating compliance or creating security theater?

**Artifact:** Requirement-to-control mapping, access-review evidence sample, and completed exception record.

**Evidence gate:** The mapping traces authoritative source to risk, objective, implementation, owner, evidence, cadence, and expiry; assumptions and unresolved interpretations are explicit.

**Adaptive branch:** If a framework name is treated as proof, ask for operating evidence. If strong, introduce conflicting delivery, privacy, and availability objectives.

**Next:** [Sequence 6 — Architecture, AI security, and FDE leadership](06-architecture-ai-fde.md).
