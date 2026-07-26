# GitHub Security Automation Runbook

Use this runbook when onboarding a repository so security checks run automatically from day one.

## 1. Add Required Files

1. Add workflow file: `.github/workflows/security-score.yml`
2. Add score script: `scripts/security-score.sh`
3. Add PR template: `.github/pull_request_template.md`
4. Ensure script is executable:

```bash
chmod +x scripts/security-score.sh
```

## 2. Push and Validate Workflow

1. Push repository to GitHub.
2. Open a test pull request.
3. Confirm PR template auto-populates with security checklist.
4. Confirm the workflow `Security Score (Trivy + Semgrep)` runs.
5. Download artifact and verify `security-score.json` exists.

Command path if you use `gh` CLI:

```bash
# from project root
git init
git add .
git commit -m "Initialize security automation"
gh repo create <repo-name> --private --source=. --remote=origin --push
```

Command path without `gh` CLI:

```bash
git init
git add .
git commit -m "Initialize security automation"
git branch -M main
git remote add origin <your-github-repo-url>
git push -u origin main
```

## 3. Configure Branch Protection

For your default branch:

1. Require pull request reviews.
2. Require status checks to pass before merge.
3. Add required check: `Security Score (Trivy + Semgrep)`.
4. Restrict direct pushes to administrators only if your team policy allows.

Branch protection with `gh` CLI (optional):

```bash
gh api \
	-X PUT \
	repos/<owner>/<repo>/branches/main/protection \
	-H "Accept: application/vnd.github+json" \
	-f required_status_checks.strict=true \
	-f enforce_admins=true \
	-f required_pull_request_reviews.required_approving_review_count=1 \
	-f restrictions=
```

## 4. Apply Security Merge Policy

Use this baseline policy:

- Block merge if critical vulnerabilities are greater than 0.
- Block merge if `score < 75`.
- Allow temporary exception only with owner, expiry, and mitigation plan.

## 5. Weekly Operations Routine

| Day | Action | Outcome |
|---|---|---|
| Monday | Review latest `security-score.json` artifacts | See week-over-week trend |
| Tuesday | Triage new critical/high findings | Owner-assigned remediation tickets |
| Wednesday | Re-test closed tickets | Verified fixes only |
| Thursday | Review IAM and SCC drift indicators | Detect cloud posture regressions |
| Friday | Publish 1-page security summary | Team alignment on risk delta |

## 6. Local Dry Run Before PR

```bash
trivy fs --format json --output trivy.json .
semgrep --config auto --json --output semgrep.json .
bash scripts/security-score.sh trivy.json semgrep.json
cat security-score.json
```

## 7. Optional GCP Extensions

If your pipeline has GCP permissions:

```bash
gcloud projects get-iam-policy "$PROJECT_ID" --format=json > iam-policy.json
gcloud scc findings list "$ORG_ID" --limit=200 --format=json > scc-findings.json
```

Then ingest those signals into a central dashboard with your weekly score trend.

## 8. Required Repository Settings Checklist

1. Actions are enabled for the repository.
2. Default branch is `main`.
3. Branch protection includes required status checks.
4. Code owners are configured if your team requires mandatory review paths.
5. Dependabot alerts are enabled.

--8<-- "_abbreviations.md"
