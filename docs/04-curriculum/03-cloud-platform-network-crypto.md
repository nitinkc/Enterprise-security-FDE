# Sequence 3: GCP, Kubernetes, Network, and Cryptography

**Phases 7–10 · Prerequisite:** Sequence 2 · **Outcome:** constrain cloud and platform blast radius while preserving operability.

## Phase 7 — GCP Security Model

GCP authorization evaluates a principal’s permissions through resource hierarchy and policy. Design organization, folder, project, and resource boundaries to match ownership and blast radius; do not use projects only as billing containers.

| Domain | Enterprise Decisions |
|---|---|
| IAM | Custom/predefined roles, additive membership, conditions, impersonation, access review |
| Organization policy | Domain restriction, approved regions, no SA keys, no default VPC/external IP |
| Network | Shared VPC, subnet boundaries, hierarchical firewall, private access, NAT, PSC |
| Compute | Hardened images, Shielded VM, patching, metadata protection, workload identity |
| Storage | Uniform bucket access, public-access prevention, retention, logging, CMEK need |
| Cloud SQL | Private IP, TLS, database IAM, backups/PITR, audit, maintenance |
| BigQuery | Dataset/table scope, policy tags, row access, export and query monitoring |
| Operations | Admin/Data Access audit logs, SCC, Monitoring, SIEM routing, retention |

DaVita-specific pipelines centrally enforce important policies. Review whether the gate ran and whether suppressions are justified; do not duplicate automated findings. Use Workload Identity Federation instead of service-account keys and resource-level IAM members instead of authoritative project policy replacement.

**Exercise:** Trace a CI identity deploying the API and a runtime identity reading one Secret Manager secret and one database. Export IAM evidence and prove neither identity can perform the other’s job.

### Learning Session 7 — Bound the GCP Blast Radius

**Objective:** Turn GCP hierarchy, IAM, network, compute, data, and logging into enforceable trust boundaries.

**Scenario:** CI and runtime share credentials, projects are billing containers, broad IAM is inherited, and internet access is the default.

**Facilitator flow:** Start with one CI-to-runtime deployment flow. Ask what each identity can do now before discussing target controls.

1. Which organization, folder, project, and resource boundaries match ownership and impact?
2. What exact permissions do CI, deployer, runtime, operator, and auditor identities require?
3. How do federation, impersonation, conditions, and organization policies constrain credential abuse?
4. Which ingress, egress, private-connectivity, and storage decisions limit reachable assets?
5. What can still happen after one runtime identity is compromised?
6. Which IAM export, denied action, audit event, and recovery action prove the boundary?

**Artifact:** GCP resource/identity map and least-privilege CI-to-runtime access design.

**Evidence gate:** CI cannot read runtime data, runtime cannot deploy or administer IAM, public paths are justified, and relevant Admin and Data Access logs support investigation.

**Adaptive branch:** If predefined broad roles are accepted without proof, derive permissions from observed actions. If strong, add a cross-project analytics dependency and emergency operator access.

## Phase 8 — Kubernetes and GKE Security

Assume one pod will eventually be compromised. Prevent that event from becoming node, cluster, project, or data compromise.

- use dedicated Kubernetes and Google service accounts with workload identity;
- restrict RBAC verbs, resources, namespaces, impersonation, and secret access;
- enforce restricted pod security: non-root, no privilege escalation, read-only root filesystem, dropped capabilities, seccomp;
- avoid host PID/network/path, privileged containers, unsafe device mounts, and broad node metadata access;
- apply default-deny ingress and egress NetworkPolicies with DNS and required dependencies allowed;
- scan and pin images by digest; verify signatures/provenance through admission policy;
- separate sensitive workloads and control-plane/node administration;
- encrypt and minimize secrets, rotate them, and prefer managed secret delivery;
- log admission, RBAC, workload identity, exec, and high-risk API activity.

**Exercise:** Given a compromised API pod, map reachable services, mounted data, Kubernetes permissions, cloud permissions, node paths, and egress. Reduce each path and verify denials from inside an authorized test pod.

### Learning Session 8 — Contain a Compromised Pod

**Objective:** Prevent one exploited workload from becoming cluster, project, or data compromise.

**Scenario:** The API pod runs as root, mounts a namespace service-account token, has broad egress, and maps to a Google service account with data access.

**Facilitator flow:** Assume code execution is already achieved. Require the learner to enumerate real post-compromise paths before proposing controls.

1. Which files, environment values, volumes, services, APIs, and metadata can the pod reach?
2. Which Kubernetes RBAC and cloud IAM actions are available to its identities?
3. Can the workload access host namespaces, node resources, privileged devices, or other tenants?
4. Which pod-security, identity, network, secret, image, and admission controls break each path?
5. How would containment affect availability and forensic evidence?
6. Which commands from a test pod prove denied lateral movement and privilege escalation?

**Artifact:** Pod-compromise attack graph and a prioritized containment plan.

**Evidence gate:** Restricted pod settings, dedicated identities, default-deny network policy, minimal RBAC/IAM, trusted images, and auditable exec/admission activity are demonstrated with negative tests.

**Adaptive branch:** If the learner focuses only on pod settings, supply an overprivileged cloud identity. If all paths are constrained, add a compromised node or admission-controller outage.

## Phase 9 — Network Security

A network control changes reachability; it does not prove business authorization. Model source, destination, protocol, port, identity, encryption, direction, purpose, and owner.

| Layer | Security Focus |
|---|---|
| DNS | Resolution trust, private zones, rebinding, exfiltration, logging |
| TCP/IP | Spoofing limits, state, exhaustion, segmentation, flow visibility |
| TLS | Certificate chain, hostname, protocol/cipher policy, expiry, revocation |
| HTTP | Method/path, headers, request smuggling, caching, CORS, security headers |
| Edge | WAF, load balancer, API gateway, DDoS, rate limits, origin protection |
| Service | mTLS/workload identity, authorization, retries, timeouts, circuit breaking |
| Egress | NAT visibility, destination control, proxies, exfiltration and SSRF resistance |

Private IP, VPN, and mTLS reduce specific threats but do not replace application authorization. Segmentation should limit lateral movement and support containment. For every rule ask which attack it prevents, what legitimate flow it enables, how it is tested, and how stale access is removed.

### Learning Session 9 — Design Reachability as a Control

**Objective:** Connect network rules to explicit attack paths, legitimate flows, identity, and containment.

**Scenario:** The API is behind a VPN, services share a flat private network, outbound traffic is unrestricted, and the database accepts all private sources.

**Facilitator flow:** Do not accept “internal” or “encrypted” as authorization. Evaluate one source-to-destination flow at a time.

1. What source, destination, protocol, port, direction, purpose, and owner define the flow?
2. Which attacker position and attack path does each edge, firewall, segmentation, or egress control reduce?
3. What identity and application authorization remain necessary after reachability is granted?
4. How do DNS, TLS validation, HTTP behavior, proxies, and retries change the threat?
5. How does segmentation limit lateral movement and permit incident containment?
6. How is allowed connectivity, denied connectivity, certificate failure, and stale-rule removal tested?

**Artifact:** Connectivity matrix and segmented network/data-flow diagram.

**Evidence gate:** Every allowed path has a business purpose and owner; denied lateral and egress paths are tested; TLS identity is validated; application authorization remains explicit.

**Adaptive branch:** If the learner relies on VPN or private IP, compromise an internal workstation or pod. If successful, add DNS manipulation and a required third-party egress path.

## Phase 10 — Secrets and Cryptography

Use well-reviewed libraries and managed services. Never design custom encryption, signature, password storage, random-number generation, key exchange, certificate validation, or token formats.

| Need | Primitive | Frequent Error |
|---|---|---|
| Password verification | Memory-hard password KDF with unique salt | Fast hash or reversible encryption |
| Confidentiality | Authenticated symmetric encryption | Reused nonce or encryption without integrity |
| Integrity/authenticity | HMAC or digital signature as appropriate | Treating plain hash as authenticity |
| Key establishment | Standard asymmetric/key-exchange protocol | Custom handshake |
| Transport identity | TLS with hostname and chain validation | Disabling verification |
| Service credential | Short-lived federated workload identity | Static API key or SA key |

Manage generation, storage, distribution, use, rotation, revocation, recovery, and destruction. Separate keys from ciphertext and operators from key administration where risk warrants it. Rotation requires consumers, overlap, rollback, and evidence—not only a changed secret version.

**Evidence gate:** Connectivity matrix, GKE escalation test, IAM export, TLS validation, secret inventory, rotation drill, KMS audit trail, and incident containment path.

### Learning Session 10 — Choose and Operate Security Primitives

**Objective:** Select standard cryptographic mechanisms and operate their full key and credential lifecycle.

**Scenario:** The platform stores passwords with a fast hash, signs internal tokens with a shared secret, disables TLS verification for a partner, and rotates credentials without overlap testing.

**Facilitator flow:** Ask what security property and attacker are in scope before selecting any primitive.

1. Is the requirement confidentiality, integrity, authenticity, password verification, transport identity, or key establishment?
2. Which approved primitive or managed service supplies that property, and what assumptions does it make?
3. How would nonce reuse, weak randomness, disabled certificate validation, or shared keys fail?
4. Which secrets can be replaced with short-lived federated identity?
5. How are generation, storage, distribution, use, rotation, revocation, recovery, and destruction handled?
6. What evidence proves rotation overlap, rollback, consumer migration, and key-use auditing?

**Artifact:** Secret and key inventory with purpose, owner, storage, consumers, rotation, revocation, and recovery decisions.

**Evidence gate:** Password storage uses an approved password KDF, transport validates identity, custom cryptography is absent, static credentials are minimized, and a rotation drill succeeds without losing auditability.

**Adaptive branch:** If algorithms are chosen by name alone, change the required property. If the lifecycle is strong, add a compromised key administrator and partial regional outage.

**Next:** [Sequence 4 — Supply chain and secure delivery](04-supply-chain-cicd.md).
