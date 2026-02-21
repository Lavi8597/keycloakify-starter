#!/bin/bash

###############################################################################
# Verification Script for SumSub Integration
###############################################################################
# This script verifies that SumSub templates are properly integrated into
# the Keycloakify theme JAR.
#
# Usage: ./scripts/verify-integration.sh
###############################################################################

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
JAR_FILE="dist_keycloak/keycloak-theme-for-kc-all-other-versions.jar"

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}SumSub Integration Verification${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

# Check if JAR exists
if [ ! -f "$JAR_FILE" ]; then
    echo -e "${RED}✗ JAR file not found: $JAR_FILE${NC}"
    echo -e "${YELLOW}Please run: npm run build-keycloak-theme${NC}"
    exit 1
fi

echo -e "${GREEN}✓ JAR file found${NC}"
echo ""

# Check for SumSub templates
echo "Checking for SumSub templates in JAR:"
echo ""

if unzip -l "$JAR_FILE" 2>/dev/null | grep -q "sumsub-verification.ftl"; then
    echo -e "${GREEN}✓ sumsub-verification.ftl${NC}"
else
    echo -e "${RED}✗ sumsub-verification.ftl (NOT FOUND)${NC}"
fi

if unzip -l "$JAR_FILE" 2>/dev/null | grep -q "sumsub-pending.ftl"; then
    echo -e "${GREEN}✓ sumsub-pending.ftl${NC}"
else
    echo -e "${YELLOW}○ sumsub-pending.ftl (optional, not found)${NC}"
fi

echo ""

# Check theme structure
echo "Verifying theme structure:"
echo ""

THEME_COUNT=$(unzip -l "$JAR_FILE" 2>/dev/null | grep -c "theme/trustorbs/" || true)
echo -e "${GREEN}✓ Theme entries: $THEME_COUNT${NC}"

if unzip -l "$JAR_FILE" 2>/dev/null | grep -q "theme/trustorbs/login/theme.properties"; then
    echo -e "${GREEN}✓ theme.properties found${NC}"
else
    echo -e "${RED}✗ theme.properties NOT found${NC}"
fi

FTL_COUNT=$(unzip -l "$JAR_FILE" 2>/dev/null | grep -c "\.ftl$" || true)
echo -e "${GREEN}✓ FreeMarker templates: $FTL_COUNT${NC}"

echo ""
echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}Verification Complete${NC}"
echo -e "${BLUE}========================================${NC}"
