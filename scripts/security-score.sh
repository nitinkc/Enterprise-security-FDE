#!/usr/bin/env bash
set -euo pipefail

# Usage: security-score.sh <trivy.json> <semgrep.json>
# Produces security-score.json with raw counts and computed score.

if [[ $# -ne 2 ]]; then
  echo "Usage: $0 <trivy.json> <semgrep.json>" >&2
  exit 1
fi

TRIVY_JSON="$1"
SEMGREP_JSON="$2"

if [[ ! -f "$TRIVY_JSON" ]]; then
  echo "Missing file: $TRIVY_JSON" >&2
  exit 1
fi

if [[ ! -f "$SEMGREP_JSON" ]]; then
  echo "Missing file: $SEMGREP_JSON" >&2
  exit 1
fi

# Count vulnerabilities by severity from Trivy output.
critical=$(jq '[.Results[]?.Vulnerabilities[]? | select(.Severity == "CRITICAL")] | length' "$TRIVY_JSON")
high=$(jq '[.Results[]?.Vulnerabilities[]? | select(.Severity == "HIGH")] | length' "$TRIVY_JSON")
medium=$(jq '[.Results[]?.Vulnerabilities[]? | select(.Severity == "MEDIUM")] | length' "$TRIVY_JSON")

# Count high-confidence security findings from Semgrep.
# Includes rules marked error severity.
semgrep_error=$(jq '[.results[]? | select(.extra.severity == "ERROR")] | length' "$SEMGREP_JSON")

# Model: Score = max(0, 100 - (12C + 6H + 2M + 8S))
# where S is Semgrep ERROR findings.
penalty=$((12 * critical + 6 * high + 2 * medium + 8 * semgrep_error))
score=$((100 - penalty))
if (( score < 0 )); then
  score=0
fi

cat > security-score.json <<EOF
{
  "critical": $critical,
  "high": $high,
  "medium": $medium,
  "semgrep_error": $semgrep_error,
  "score": $score,
  "formula": "max(0, 100 - (12*C + 6*H + 2*M + 8*S))"
}
EOF

cat security-score.json
