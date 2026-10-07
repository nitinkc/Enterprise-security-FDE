# PR Secure Code Review Checklist

Use this checklist on every pull request to catch security defects before merge. Keep it lightweight, repeatable, and tied to concrete code evidence.

## 1. Fast Triage in 3 Minutes

1. Identify the blast radius:
   - Is this internet-facing?
   - Does it touch auth, payments, personal data, admin actions, or secrets?
2. Identify change type:
   - new endpoint
   - authorization logic change
   - dependency update
   - infrastructure/pipeline change
3. Set review depth:
   - standard for low-risk
   - deep review for high-risk paths

## 2. Controller and API Surface Checks

| Check | What to Verify | Red Flag |
|---|---|---|
| AuthN present | Protected routes require token/session | Endpoint accepts anonymous traffic by accident |
| AuthZ present | Scope/role checks + resource ownership checks exist | Only authentication is checked |
| Input validation | DTO constraints and allow-lists for updates | Raw request maps directly to persistence model |
| Error behavior | No sensitive internals in error payloads | Stack traces or policy internals returned |
| Idempotency and replay | Sensitive writes handle retries safely | Duplicate write risk with no guard |

Spring-focused example:

```java
@PostMapping("/api/orders")
@PreAuthorize("hasAuthority('SCOPE_orders.write')")
public ResponseEntity<OrderDto> create(@Valid @RequestBody CreateOrderRequest req) {
    return ResponseEntity.ok(service.create(req));
}
```

## 3. Service and Domain Authorization Checks

You should see domain-level checks even if controller annotations exist.

| Check | Good Pattern | Red Flag |
|---|---|---|
| Tenant boundary | Query or check includes tenant ID | `findById(id)` without tenant boundary |
| Ownership checks | User can act only on owned resources | Admin-like behavior for all authenticated users |
| State transition rules | Action allowed only in valid states | Blind state changes on user request |

```java
Order order = repository.findByIdAndTenantId(id, tenantId)
    .orElseThrow(() -> new AccessDeniedException("Not accessible"));
```

## 4. Data and Secrets Checks

| Check | What to Verify |
|---|---|
| Secrets | No hardcoded keys, tokens, passwords, or certificates in code |
| Logging | No secrets or full tokens written to logs |
| Encryption | Sensitive fields protected in transit and at rest |
| PII minimization | Response excludes unnecessary personal data |

Quick command:

```bash
gitleaks detect --source . --no-banner
```

## 5. Dependency and Supply Chain Checks

| Check | Action |
|---|---|
| Vulnerable dependency risk | Run Trivy and review HIGH/CRITICAL findings |
| New package trust | Validate package source, maintenance, and update history |
| Lockfile integrity | Ensure lockfile changes are intentional and reviewed |

```bash
trivy fs --severity HIGH,CRITICAL .
```

## 6. Infrastructure and Pipeline Checks

| Check | What to Verify |
|---|---|
| Workflow permissions | GitHub Actions use least privilege permissions |
| Merge policy | Security status checks are required |
| Secret handling | No plain secrets in workflow logs or environment dumps |
| Deployment identity | Keyless identity preferred over static credentials |

## 7. Reviewer Decision Matrix

| Outcome | When to Use |
|---|---|
| Approve | All required controls present; no high-risk gaps |
| Request changes | Missing authz, tenant checks, validation, or secret hygiene |
| Block and escalate | Critical exploitable risk in internet-facing or high-value path |

## 8. PR Comment Template (Copy-Paste)

```markdown
Security review summary:

- Scope reviewed: <endpoint/service/module>
- Risk level: <low/medium/high>
- Findings:
  1. <finding + location>
  2. <finding + location>
- Required fixes before merge:
  1. <fix>
  2. <fix>
- Verification steps:
  - <test command>
  - <expected result>
```

## 9. Minimal Verification Before Merge

Run these in CI or locally for risky changes:

```bash
semgrep --config auto src/
trivy fs --format json --output trivy.json .
semgrep --config auto --json --output semgrep.json .
bash scripts/security-score.sh trivy.json semgrep.json
```

## 10. Weekly Improvement Loop

1. Track top recurring review findings.
2. Convert repeated findings into automated checks.
3. Publish one secure coding example per team sprint.

--8<-- "_abbreviations.md"
