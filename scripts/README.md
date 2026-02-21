# Build and Integration Scripts

This directory contains scripts for building and integrating the Keycloakify theme with custom SumSub templates.

## Available Scripts

### integrate-sumsub-templates.sh

Integrates custom SumSub FreeMarker templates into the Keycloakify-built JAR.

**Usage:**
```bash
./scripts/integrate-sumsub-templates.sh
```

**What it does:**
1. Verifies the Keycloakify JAR exists
2. Checks for SumSub templates in `custom-theme/login/`
3. Extracts the JAR to a temporary directory
4. Copies SumSub templates to the theme
5. Repackages the JAR
6. Verifies integration

**Requirements:**
- `npm run build-keycloak-theme` must be run first
- SumSub templates should be in `custom-theme/login/`

### verify-integration.sh

Verifies that SumSub templates are properly integrated into the JAR.

**Usage:**
```bash
./scripts/verify-integration.sh
```

**What it checks:**
- JAR file exists
- SumSub templates are present
- Theme structure is correct
- FreeMarker templates count

## Usage Workflow

### Complete Build with SumSub Integration

```bash
# 1. Build the Keycloakify theme
npm run build-keycloak-theme

# 2. Integrate SumSub templates
npm run integrate-sumsub

# 3. Verify integration
./scripts/verify-integration.sh
```

### One-Command Build

```bash
# Build everything in one step
npm run build-with-sumsub
```

## Adding Custom Templates

To add your SumSub templates:

1. Create templates in `custom-theme/login/`:
   ```bash
   custom-theme/login/
   ├── sumsub-verification.ftl
   └── sumsub-pending.ftl
   ```

2. Run the integration:
   ```bash
   npm run integrate-sumsub
   ```

## Troubleshooting

### Script Permission Denied

If you get a permission error:
```bash
chmod +x scripts/*.sh
```

### JAR Not Found

Make sure you've built the theme first:
```bash
npm run build-keycloak-theme
```

### Templates Not Found

Ensure templates are in the correct location:
```bash
ls -la custom-theme/login/
```

### Integration Verification Fails

Check the JAR contents manually:
```bash
unzip -l dist_keycloak/keycloak-theme-for-kc-all-other-versions.jar | grep sumsub
```

## CI/CD Integration

These scripts can be integrated into CI/CD pipelines:

```yaml
# Example GitHub Actions
- name: Build Keycloakify theme
  run: npm run build-keycloak-theme

- name: Integrate SumSub templates
  run: npm run integrate-sumsub

- name: Verify integration
  run: ./scripts/verify-integration.sh

- name: Upload artifact
  uses: actions/upload-artifact@v3
  with:
    name: keycloak-theme
    path: dist_keycloak/keycloak-theme-for-kc-all-other-versions.jar
```

## Maintenance

When updating SumSub templates:
1. Update files in `custom-theme/login/`
2. Run integration script again
3. Verify the changes

When updating Keycloakify:
1. Update React components in `src/`
2. Run `npm run build-keycloak-theme`
3. Run integration script to re-add SumSub templates
