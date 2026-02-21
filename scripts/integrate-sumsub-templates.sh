#!/bin/bash

###############################################################################
# SumSub Template Integration Script
###############################################################################
# This script integrates custom SumSub FreeMarker templates into the
# Keycloakify-built theme JAR file.
#
# Usage: ./scripts/integrate-sumsub-templates.sh
###############################################################################

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
THEME_NAME="trustorbs"
JAR_FILE="dist_keycloak/keycloak-theme-for-kc-all-other-versions.jar"
TEMP_DIR="dist_keycloak/temp_integration"
CUSTOM_THEME_DIR="custom-theme"

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}SumSub Template Integration Script${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

# Function to print colored messages
print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if JAR file exists
if [ ! -f "$JAR_FILE" ]; then
    print_error "JAR file not found: $JAR_FILE"
    print_info "Please run 'npm run build-keycloak-theme' first"
    exit 1
fi

print_success "Found JAR file: $JAR_FILE"

# Check if custom theme directory exists
if [ ! -d "$CUSTOM_THEME_DIR" ]; then
    print_error "Custom theme directory not found: $CUSTOM_THEME_DIR"
    exit 1
fi

print_success "Found custom theme directory: $CUSTOM_THEME_DIR"

# Check if SumSub templates exist
SUMSUB_TEMPLATES=("$CUSTOM_THEME_DIR/login/sumsub-verification.ftl" "$CUSTOM_THEME_DIR/login/sumsub-pending.ftl")

for template in "${SUMSUB_TEMPLATES[@]}"; do
    if [ ! -f "$template" ]; then
        print_warning "Template not found: $template"
        print_info "You can add SumSub templates to: $template"
    else
        print_success "Found template: $template"
    fi
done

# Create temporary directory
print_info "Creating temporary directory..."
rm -rf "$TEMP_DIR"
mkdir -p "$TEMP_DIR"

# Extract JAR
print_info "Extracting JAR file..."
unzip -q "$JAR_FILE" -d "$TEMP_DIR"
print_success "JAR extracted successfully"

# Copy custom templates
print_info "Copying custom templates to theme..."

# Ensure the login directory exists in the theme
LOGIN_DIR="$TEMP_DIR/theme/$THEME_NAME/login"
if [ ! -d "$LOGIN_DIR" ]; then
    print_error "Login directory not found in theme: $LOGIN_DIR"
    rm -rf "$TEMP_DIR"
    exit 1
fi

# Copy each template if it exists
TEMPLATE_COUNT=0
for template in "${SUMSUB_TEMPLATES[@]}"; do
    if [ -f "$template" ]; then
        cp "$template" "$LOGIN_DIR/"
        TEMPLATE_COUNT=$((TEMPLATE_COUNT + 1))
        print_success "Copied: $(basename "$template")"
    fi
done

if [ $TEMPLATE_COUNT -eq 0 ]; then
    print_warning "No SumSub templates found to copy"
    print_info "Add templates to: $CUSTOM_THEME_DIR/login/"
    rm -rf "$TEMP_DIR"
    exit 0
fi

# Repackage JAR
print_info "Repackaging JAR file..."
cd "$TEMP_DIR"
zip -qr "../keycloak-theme-for-kc-all-other-versions.jar" *
cd - > /dev/null
print_success "JAR repackaged successfully"

# Clean up
print_info "Cleaning up temporary files..."
rm -rf "$TEMP_DIR"
print_success "Cleanup complete"

# Verify integration
print_info "Verifying integration..."
if unzip -l "$JAR_FILE" | grep -q "sumsub-verification.ftl"; then
    print_success "sumsub-verification.ftl found in JAR"
else
    print_error "sumsub-verification.ftl NOT found in JAR"
    exit 1
fi

if unzip -l "$JAR_FILE" | grep -q "sumsub-pending.ftl"; then
    print_success "sumsub-pending.ftl found in JAR"
else
    print_warning "sumsub-pending.ftl not found in JAR (optional)"
fi

# Display summary
echo ""
echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}Integration Complete!${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""
echo -e "Integrated ${TEMPLATE_COUNT} template(s)"
echo ""
echo -e "JAR file: ${BLUE}$JAR_FILE${NC}"
echo ""
echo -e "To verify the integration:"
echo -e "  ${YELLOW}unzip -l $JAR_FILE | grep sumsub${NC}"
echo ""
echo -e "To deploy to Keycloak:"
echo -e "  ${YELLOW}docker run -v \"$(pwd)/$JAR_FILE\":/opt/keycloak/providers/keycloak-theme.jar ...${NC}"
echo ""
