# Quick Reference

Use this page for fast recall during planning, reviews, and incident support. It summarizes the most important terms, equations, and decision frames from the guide.

```mermaid
flowchart LR
    A[Identify risk] --> B[Validate exploitability]
    B --> C[Assign ownership]
    C --> D[Verify remediation]

    style A fill:#1976d2,color:#fff
    style B fill:#ff9800,color:#fff
    style C fill:#1976d2,color:#fff
    style D fill:#ff9800,color:#fff
```

## Decision Frames

| Situation | Best First Question | Recommended Action |
|---|---|---|
| New vulnerability report | Is this exploitable in our environment? | Validate and prioritize by business impact |
| Repeated misconfiguration | Why is the control failing repeatedly? | Add preventive policy and automated checks |
| Cross-team remediation delay | Who owns fix and by when? | Set owner, SLA, and escalation path |
| Executive concern on risk trend | Are we reducing meaningful risk? | Show verified risk reduction metrics |

## Formula Reference

| Formula | Purpose |
|---|---|
| `R = L x P x E` | Rank risk by loss, probability, and exposure |
| `C_w = sum(wi x ti) / sum(wi)` | Track weighted coverage of critical assets |
| `H_o = S_c / (S_c + F_h)` | Track operational security health |

## Command Snippets You Will Reuse

```bash
# dependency and image scanning
trivy fs --severity HIGH,CRITICAL .
trivy image --severity HIGH,CRITICAL my-service:latest

# source pattern scanning
semgrep --config auto src/

# secret detection
gitleaks detect --source . --no-banner

# quick GCP posture checks
gcloud projects get-iam-policy "$PROJECT_ID" --format=json | jq '.bindings[] | {role, members_count: (.members|length)}'
gcloud scc findings list "$ORG_ID" --limit=20
```

## GitHub Security Score Quick Start

```bash
# local dry run before opening a PR
trivy fs --format json --output trivy.json .
semgrep --config auto --json --output semgrep.json src/
bash scripts/security-score.sh trivy.json semgrep.json
cat security-score.json
```

## Fast Remediation Playbooks

| Finding Type | First Fix | Verification Step |
|---|---|---|
| Hard-coded secrets | Move to Secret Manager and rotate leaked secret | Secret no longer appears in repo history and runtime env is healthy |
| Vulnerable dependency | Upgrade to patched version with regression tests | CVE no longer reported by scanner |
| Missing authorization check | Add role and tenant boundary validation | Unauthorized request returns `403` |
| Over-privileged role | Scope permissions to minimum required actions | Action fails outside approved scope |

| Developer Note | Practical Reminder |
|---|---|
| High severity is not always high risk | Validate exploitability and asset impact before escalation. |
| Ticket quality drives remediation speed | Include reproduction command and expected secure outcome. |

??? question "What is the one metric that changes behavior fastest?"
    Verified fix throughput usually changes behavior fastest because it aligns engineering work with measurable security outcomes.

??? question "What should I memorize first?"
    Memorize your risk framing, ownership model, and verification workflow. Those are the backbone of strong security decisions.

--8<-- "_abbreviations.md"
