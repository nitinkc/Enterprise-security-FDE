# Secure Coding Standards for Spring Boot APIs

Use this page as an engineering standard during implementation and code review. Each section shows a common insecure pattern and a secure replacement you can adopt immediately.

## 1. Authentication and Authorization

Rule:

1. Every protected endpoint must enforce both authentication and authorization.
2. Authorization must include business and resource constraints, not only route-level roles.

Bad pattern:

```java
@GetMapping("/api/orders/{id}")
public Order getOrder(@PathVariable String id) {
    // No authz check; any authenticated caller can reach this path.
    return repository.findById(id).orElseThrow();
}
```

Good pattern:

```java
@GetMapping("/api/orders/{id}")
@PreAuthorize("hasAuthority('SCOPE_orders.read')")
public Order getOrder(@PathVariable String id, JwtAuthenticationToken auth) {
    String tenantId = auth.getToken().getClaimAsString("tenant_id");
    return repository.findByIdAndTenantId(id, tenantId)
        .orElseThrow(() -> new AccessDeniedException("Order not accessible"));
}
```

## 2. Input Validation and DTO Safety

Rule:

1. Validate all external input at API boundaries.
2. Never bind request payloads directly to persistence entities.

Bad pattern:

```java
@PostMapping("/api/users")
public User create(@RequestBody User user) {
    return userRepository.save(user);
}
```

Good pattern:

```java
public record CreateUserRequest(
    @NotBlank String email,
    @NotBlank String displayName
) {}

@PostMapping("/api/users")
@PreAuthorize("hasAuthority('SCOPE_users.write')")
public UserDto create(@Valid @RequestBody CreateUserRequest req) {
    User user = new User();
    user.setEmail(req.email());
    user.setDisplayName(req.displayName());
    return mapper.toDto(userRepository.save(user));
}
```

## 3. Data Access and Tenant Isolation

Rule:

1. Sensitive reads and writes must be tenant-aware.
2. Do not load broad datasets and filter in memory.

Bad pattern:

```java
Order order = repository.findById(id).orElseThrow();
if (!order.getTenantId().equals(tenantId)) {
    throw new AccessDeniedException("Denied");
}
```

Good pattern:

```java
Order order = repository.findByIdAndTenantId(id, tenantId)
    .orElseThrow(() -> new AccessDeniedException("Not found or not allowed"));
```

Repository standard:

```java
public interface OrderRepository extends JpaRepository<Order, String> {
    Optional<Order> findByIdAndTenantId(String id, String tenantId);
}
```

## 4. Secrets and Configuration Hygiene

Rule:

1. No secrets in source code, YAML, or workflow files.
2. Use environment injection and Secret Manager.

Bad pattern:

```yaml
# application-prod.yaml
payment:
  apiKey: sk_live_123456
```

Good pattern:

```yaml
# application-prod.yaml
payment:
  apiKey: ${PAYMENT_API_KEY}
```

Operational standard:

1. Store secrets in GCP Secret Manager.
2. Grant access with least privilege service identity.
3. Rotate on schedule and on incident.

## 5. Logging and Error Handling

Rule:

1. Logs should support incident response without leaking sensitive values.
2. Error responses should be safe and consistent.

Bad pattern:

```java
log.info("User token: {}", bearerToken);
return ResponseEntity.status(500).body(e.getMessage());
```

Good pattern:

```java
log.warn("Authorization failed. traceId={} path={}", traceId, request.getRequestURI());
return ResponseEntity.status(HttpStatus.FORBIDDEN)
    .body(Map.of("error", "forbidden", "traceId", traceId));
```

## 6. Serialization and Data Exposure

Rule:

1. Never return persistence entities directly to API clients.
2. Use response DTOs with explicit allow-list fields.

Bad pattern:

```java
@GetMapping("/api/accounts/{id}")
public Account get(@PathVariable String id) {
    return accountRepository.findById(id).orElseThrow();
}
```

Good pattern:

```java
public record AccountResponse(String id, String displayName, String tier) {}

@GetMapping("/api/accounts/{id}")
public AccountResponse get(@PathVariable String id) {
    Account a = accountRepository.findById(id).orElseThrow();
    return new AccountResponse(a.getId(), a.getDisplayName(), a.getTier());
}
```

## 7. HTTP Security Defaults

Rule:

1. Explicitly configure CORS, CSRF policy, and security headers per API profile.
2. Do not use broad CORS wildcard in production APIs.

Bad pattern:

```java
http.cors(cors -> {}); // default wildcard config from framework or proxy
```

Good pattern:

```java
@Bean
CorsConfigurationSource corsConfigurationSource() {
    CorsConfiguration c = new CorsConfiguration();
    c.setAllowedOrigins(List.of("https://app.example.com"));
    c.setAllowedMethods(List.of("GET", "POST", "PUT", "DELETE"));
    c.setAllowedHeaders(List.of("Authorization", "Content-Type"));

    UrlBasedCorsConfigurationSource s = new UrlBasedCorsConfigurationSource();
    s.registerCorsConfiguration("/**", c);
    return s;
}
```

## 8. CI Security Gates for Every Change

Minimum gate before merge:

```bash
semgrep --config auto src/
trivy fs --severity HIGH,CRITICAL .
gitleaks detect --source . --no-banner
```

Score gate (already in this repo):

```bash
trivy fs --format json --output trivy.json .
semgrep --config auto --json --output semgrep.json .
bash scripts/security-score.sh trivy.json semgrep.json
cat security-score.json
```

## 9. Definition of Done for Secure Features

A feature is not done until all are true:

1. AuthN and authZ controls are implemented.
2. Negative tests cover unauthorized and cross-tenant paths.
3. Input validation is enforced with DTO constraints.
4. Secrets are externalized.
5. CI security checks pass.
6. Security-relevant logs include correlation identifiers.

## 10. Team Adoption Plan

1. Add this checklist to PR templates.
2. Start with high-risk APIs first (auth, billing, data export, admin).
3. Convert repeated review comments into automated tests or static rules.
4. Review exceptions weekly and attach expiry dates.

Related pages:

- [PR Secure Code Review Checklist](05-pr-secure-code-review-checklist.md)
- [API Security Regression Test Pack](06-api-security-regression-test-pack.md)
- [GCP Incident Runbooks](07-gcp-incident-runbooks.md)

--8<-- "_abbreviations.md"
