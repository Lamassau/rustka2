#!/usr/bin/env bash

##############################################################################
# Rustka Health Check Script
#
# Verifies that the Rustka broker is running and responsive.
# Useful for development, CI/CD, and production monitoring.
#
# Usage:
#   ./scripts/health-check.sh                    # Check local broker
#   ./scripts/health-check.sh localhost 9092    # Explicit host/port
#   ./scripts/health-check.sh my-broker.local    # Remote broker
#
##############################################################################

set -euo pipefail

# Configuration
HOST="${1:-localhost}"
PORT="${2:-9092}"
DASHBOARD_PORT="${3:-8080}"
TIMEOUT=3
RETRIES=1

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

##############################################################################
# Functions
##############################################################################

print_header() {
    echo -e "${BLUE}╔════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║              Rustka Health Check                           ║${NC}"
    echo -e "${BLUE}╚════════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

print_section() {
    echo ""
    echo -e "${BLUE}▶ $1${NC}"
}

##############################################################################
# Checks
##############################################################################

check_broker_connectivity() {
    print_section "Checking Broker Connectivity"
    
    # Try multiple methods to check connectivity
    if command -v nc &> /dev/null; then
        # Using netcat (most common)
        if nc -z -w "$TIMEOUT" "$HOST" "$PORT" &>/dev/null; then
            print_success "Connected to $HOST:$PORT"
            return 0
        fi
    elif command -v timeout &> /dev/null; then
        # Fallback: using timeout with bash TCP connection
        if timeout "$TIMEOUT" bash -c "cat < /dev/null > /dev/tcp/$HOST/$PORT" 2>/dev/null; then
            print_success "Connected to $HOST:$PORT"
            return 0
        fi
    else
        print_warning "Neither 'nc' nor 'timeout' available, skipping connectivity check"
        return 0
    fi
    
    print_error "Cannot connect to broker at $HOST:$PORT"
    print_info "Is the broker running? Try: make dev"
    return 1
}

check_dashboard() {
    print_section "Checking Dashboard"
    
    if command -v curl &> /dev/null; then
        if curl -s -m "$TIMEOUT" "http://$HOST:$DASHBOARD_PORT/" > /dev/null 2>&1; then
            print_success "Dashboard accessible at http://$HOST:$DASHBOARD_PORT"
            return 0
        else
            print_warning "Dashboard not responding (broker might be starting up)"
            return 0
        fi
    else
        print_warning "'curl' not available, skipping dashboard check"
        return 0
    fi
}

check_metrics_endpoint() {
    print_section "Checking Metrics API"
    
    if ! command -v curl &> /dev/null; then
        print_warning "'curl' not available, skipping metrics check"
        return 0
    fi
    
    response=$(curl -s -m "$TIMEOUT" "http://$HOST:$DASHBOARD_PORT/api/metrics" 2>/dev/null || echo "{}")
    
    # Check if we got valid JSON (simple check)
    if echo "$response" | grep -q '"' 2>/dev/null; then
        print_success "Metrics API responding"
        return 0
    else
        print_warning "Metrics API not responding (broker might be starting up)"
        return 0
    fi
}

check_memory_stats() {
    print_section "Checking Memory"
    
    if ! command -v curl &> /dev/null; then
        print_warning "'curl' not available, skipping memory check"
        return 0
    fi
    
    response=$(curl -s -m "$TIMEOUT" "http://$HOST:$DASHBOARD_PORT/api/memory-stats" 2>/dev/null || echo "{}")
    
    # Check if we got valid JSON
    if echo "$response" | grep -q '"' 2>/dev/null; then
        print_success "Memory stats retrieved"
        
        # Try to extract memory usage if jq is available
        if command -v jq &> /dev/null; then
            estimated_mb=$(echo "$response" | jq -r '.estimated_usage_mb // "unknown"' 2>/dev/null || echo "unknown")
            if [ "$estimated_mb" != "unknown" ] && [ "$estimated_mb" != "null" ]; then
                print_info "Estimated memory usage: ${estimated_mb}MB"
            fi
        fi
        return 0
    else
        print_warning "Memory stats endpoint not responding"
        return 0
    fi
}

print_summary() {
    print_section "Summary"
    echo ""
    echo -e "  ${BLUE}Broker:${NC}     $HOST:$PORT"
    echo -e "  ${BLUE}Dashboard:${NC}  http://$HOST:$DASHBOARD_PORT"
    echo ""
    echo -e "${GREEN}✅ Broker appears healthy and ready for use${NC}"
    echo ""
    echo "Quick start commands:"
    echo "  make run          # Run with default logging"
    echo "  make dev          # Run with debug logging"
    echo "  make test         # Run test suite"
    echo ""
}

print_error_summary() {
    print_section "Summary"
    echo ""
    echo -e "${RED}❌ Broker is not responding${NC}"
    echo ""
    echo "Troubleshooting steps:"
    echo "  1. Check if broker is running:"
    echo "       make health"
    echo "  2. Start the broker:"
    echo "       make dev"
    echo "  3. Check if ports are in use:"
    echo "       lsof -i :9092"
    echo "  4. Review logs (check stderr above)"
    echo ""
    echo "Still having issues? See DEVELOPMENT.md for troubleshooting."
    echo ""
}

##############################################################################
# Main Execution
##############################################################################

main() {
    print_header
    
    print_info "Target: $HOST:$PORT (dashboard: :$DASHBOARD_PORT)"
    echo ""
    
    # Run checks
    local failed=0
    
    check_broker_connectivity || failed=1
    check_dashboard || failed=1
    check_metrics_endpoint || failed=1
    check_memory_stats || failed=1
    
    # Print summary
    if [ $failed -eq 0 ]; then
        print_summary
        exit 0
    else
        print_error_summary
        exit 1
    fi
}

# Run main function
main "$@"
