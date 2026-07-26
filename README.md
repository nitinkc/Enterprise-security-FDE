# Enterprise Security Learning Path for Forward Deployed Engineers

This project is a ready-to-run MkDocs Material learning site for senior software developers transitioning into enterprise security and forward deployed engineering roles.

It provides a CISO-style progression from fundamentals to production operations, with practical testing workflows, governance controls, and interview-ready reasoning patterns.

## Run locally

```bash
pip install -r requirements.txt
mkdocs serve
```

## Build static site

```bash
mkdocs build
```

## GitHub Security Automation

After pushing this project to GitHub, follow the actionable setup runbook:

- docs/reference/04-github-security-automation.md

It includes:

- workflow onboarding (`.github/workflows/security-score.yml`)
- branch protection requirements
- merge-blocking score policy
- weekly operations routine
