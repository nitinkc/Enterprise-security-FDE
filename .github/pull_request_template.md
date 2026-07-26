## Summary

Describe what changed and why.

## Security Risk Context

- Risk level: [ ] Low [ ] Medium [ ] High
- Internet-facing impact: [ ] Yes [ ] No
- Touches auth/authz, secrets, PII, payments, or admin actions: [ ] Yes [ ] No

## Security Checklist (Author)

- [ ] Authentication is enforced for protected endpoints.
- [ ] Authorization checks are enforced at route and service/domain levels.
- [ ] Tenant and ownership boundaries are enforced for data access.
- [ ] Input validation is implemented with DTO constraints.
- [ ] No hardcoded secrets or tokens were introduced.
- [ ] Logs do not include credentials, tokens, or sensitive payloads.
- [ ] Error responses do not leak internals.
- [ ] API responses expose only allow-listed fields.

## Verification Evidence

- [ ] Auth regression tests (401/403, wrong scope, cross-tenant) pass.
- [ ] `semgrep --config auto src/` passed.
- [ ] `trivy fs --severity HIGH,CRITICAL .` reviewed.
- [ ] `gitleaks detect --source . --no-banner` passed.
- [ ] `bash scripts/security-score.sh trivy.json semgrep.json` executed for risky changes.

## Reviewer Checklist

- [ ] Security-sensitive files were reviewed deeply.
- [ ] No authz bypass paths were introduced.
- [ ] Merge is blocked if critical findings or score policy violations exist.

## Links to Internal Standards

- docs/reference/05-pr-secure-code-review-checklist.md
- docs/reference/06-api-security-regression-test-pack.md
- docs/reference/08-secure-coding-standards-spring-boot.md
