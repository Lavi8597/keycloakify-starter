<p align="center">
    <i>🚀 <a href="https://keycloakify.dev">Keycloakify</a> v11 starter 🚀</i>
    <br/>
    <br/>
</p>

# Quick start

```bash
git clone https://github.com/keycloakify/keycloakify-starter
cd keycloakify-starter
yarn install # Or use an other package manager, just be sure to delete the yarn.lock if you use another package manager.
```

# Testing the theme locally

[Documentation](https://docs.keycloakify.dev/testing-your-theme)

# How to customize the theme

[Documentation](https://docs.keycloakify.dev/css-customization)

# Building the theme

You need to have [Maven](https://maven.apache.org/) installed to build the theme (Maven >= 3.1.1, Java >= 7).  
The `mvn` command must be in the $PATH.

-   On macOS: `brew install maven`
-   On Debian/Ubuntu: `sudo apt-get install maven`
-   On Windows: `choco install openjdk` and `choco install maven` (Or download from [here](https://maven.apache.org/download.cgi))

```bash
npm run build-keycloak-theme
```

Note that by default Keycloakify generates multiple .jar files for different versions of Keycloak.  
You can customize this behavior, see documentation [here](https://docs.keycloakify.dev/features/compiler-options/keycloakversiontargets).

# Initializing the account theme

```bash
npx keycloakify initialize-account-theme
```

# Initializing the email theme

```bash
npx keycloakify initialize-email-theme
```

# Initializing the email theme

```bash
npx keycloakify initialize-email-theme
```

# Custom SumSub Integration

This theme includes integration support for custom SumSub verification templates.

## Quick Setup

```bash
# Build theme with SumSub templates (one command)
npm run build-with-sumsub
```

## Manual Integration

If you have custom SumSub FreeMarker templates:

```bash
# 1. Build the Keycloakify theme
npm run build-keycloak-theme

# 2. Integrate SumSub templates
npm run integrate-sumsub

# 3. Verify integration
./scripts/verify-integration.sh
```

## Adding SumSub Templates

Place your templates in `custom-theme/login/`:
```
custom-theme/login/
├── sumsub-verification.ftl
└── sumsub-pending.ftl
```

For complete documentation, see [SUMSUB_INTEGRATION.md](SUMSUB_INTEGRATION.md).

# GitHub Actions

The starter comes with a generic GitHub Actions workflow that builds the theme and publishes
the jars [as GitHub releases artifacts](https://github.com/keycloakify/keycloakify-starter/releases/tag/v10.0.0).
To release a new version **just update the `package.json` version and push**.

To enable the workflow go to your fork of this repository on GitHub then navigate to:
`Settings` > `Actions` > `Workflow permissions`, select `Read and write permissions`.
