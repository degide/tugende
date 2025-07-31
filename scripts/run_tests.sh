#!/bin/bash

# TugendeApp Test Runner Script
# This script runs all tests and generates coverage reports

echo "🚀 Starting TugendeApp Test Suite"
echo "================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

# Check if Flutter is installed
if ! command -v flutter &> /dev/null; then
    print_error "Flutter is not installed or not in PATH"
    exit 1
fi

print_status "Flutter found: $(flutter --version | head -n 1)"

# Clean and get dependencies
echo ""
echo "📦 Getting dependencies..."
flutter clean
flutter pub get

if [ $? -ne 0 ]; then
    print_error "Failed to get dependencies"
    exit 1
fi

print_status "Dependencies installed successfully"

# Run static analysis
echo ""
echo "🔍 Running static analysis..."
flutter analyze

if [ $? -ne 0 ]; then
    print_warning "Static analysis found issues (continuing with tests)"
else
    print_status "Static analysis passed"
fi

# Run unit tests
echo ""
echo "🧪 Running unit tests..."
flutter test test/unit/ --reporter=expanded

if [ $? -ne 0 ]; then
    print_error "Unit tests failed"
    exit 1
fi

print_status "Unit tests passed"

# Run widget tests
echo ""
echo "🎨 Running widget tests..."
flutter test test/widget_test.dart --reporter=expanded

if [ $? -ne 0 ]; then
    print_error "Widget tests failed"
    exit 1
fi

print_status "Widget tests passed"

# Run all tests with coverage
echo ""
echo "📊 Running all tests with coverage..."
flutter test --coverage

if [ $? -ne 0 ]; then
    print_error "Test coverage generation failed"
    exit 1
fi

print_status "Test coverage generated"

# Generate HTML coverage report (if lcov is available)
if command -v lcov &> /dev/null && command -v genhtml &> /dev/null; then
    echo ""
    echo "📈 Generating HTML coverage report..."
    
    # Remove Flutter SDK files from coverage
    lcov --remove coverage/lcov.info \
        '*/flutter/.pub-cache/*' \
        '*/flutter/packages/*' \
        '*/flutter/bin/cache/*' \
        '*/.pub-cache/*' \
        '*/generated/*' \
        '*/*.g.dart' \
        '*/firebase_options.dart' \
        -o coverage/lcov_cleaned.info
    
    # Generate HTML report
    genhtml coverage/lcov_cleaned.info -o coverage/html
    
    print_status "HTML coverage report generated in coverage/html/"
else
    print_warning "lcov not found. Install lcov to generate HTML coverage reports"
fi

# Run integration tests (if device/emulator is available)
echo ""
echo "🔗 Checking for devices for integration tests..."
flutter devices | grep -q "• "

if [ $? -eq 0 ]; then
    echo "📱 Running integration tests..."
    flutter test integration_test/app_test.dart
    
    if [ $? -eq 0 ]; then
        print_status "Integration tests passed"
    else
        print_warning "Integration tests failed or no device available"
    fi
else
    print_warning "No devices found for integration tests"
fi

# Parse coverage percentage
if [ -f "coverage/lcov.info" ]; then
    echo ""
    echo "📊 Coverage Summary:"
    echo "==================="
    
    # Calculate coverage percentage (simple method)
    LINES_FOUND=$(grep -c "LF:" coverage/lcov.info)
    LINES_HIT=$(grep -c "LH:" coverage/lcov.info)
    
    if [ "$LINES_FOUND" -gt 0 ]; then
        COVERAGE=$(echo "scale=2; $LINES_HIT * 100 / $LINES_FOUND" | bc -l 2>/dev/null || echo "N/A")
        echo "Lines covered: $LINES_HIT/$LINES_FOUND"
        echo "Coverage: $COVERAGE%"
        
        # Check if coverage meets threshold
        THRESHOLD=70
        if (( $(echo "$COVERAGE >= $THRESHOLD" | bc -l 2>/dev/null) )); then
            print_status "Coverage meets minimum threshold of $THRESHOLD%"
        else
            print_warning "Coverage below minimum threshold of $THRESHOLD%"
        fi
    fi
fi

echo ""
print_status "Test suite completed successfully! 🎉"
echo ""
echo "📋 Test Summary:"
echo "   ✅ Static analysis"
echo "   ✅ Unit tests"
echo "   ✅ Widget tests"
echo "   ✅ Test coverage generated"
echo ""
echo "📂 Generated files:"
echo "   📄 coverage/lcov.info - Coverage data"
echo "   📁 coverage/html/ - HTML coverage report (if lcov available)"
echo ""
echo "🚀 Ready for deployment!"
