#!/bin/bash

# DayTask Supabase Integration Quick Start
# This script guides you through setting up Supabase integration

echo "╔════════════════════════════════════════════════════════════╗"
echo "║     DayTask - Supabase Integration Setup Guide             ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""

# Check if running from project root
if [ ! -f "pubspec.yaml" ]; then
    echo "❌ Error: Not in DayTask project directory"
    echo "   Please cd into the DayTask folder first"
    exit 1
fi

echo "✅ Found project in: $(pwd)"
echo ""

# Check Flutter
echo "📦 Checking Flutter installation..."
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter not found. Please install Flutter first"
    exit 1
fi
echo "✅ Flutter version: $(flutter --version | head -n1)"
echo ""

# Check if .env exists
echo "🔑 Checking .env file..."
if [ ! -f ".env" ]; then
    echo "❌ .env file not found"
    echo "   Creating from .env.example..."
    if [ -f ".env.example" ]; then
        cp .env.example .env
        echo "⚠️  Please edit .env with your Supabase credentials"
        echo "   SUPABASE_URL=your_url"
        echo "   SUPABASE_ANON_KEY=your_key"
        exit 1
    fi
else
    echo "✅ .env file exists"
    
    # Check if URL and KEY are set
    if grep -q "^SUPABASE_URL=.*supabase.co" .env && \
       grep -q "^SUPABASE_ANON_KEY=ey" .env; then
        echo "✅ Supabase credentials configured"
    else
        echo "❌ Supabase credentials missing or invalid"
        echo "   Please update .env with valid credentials"
        exit 1
    fi
fi
echo ""

# Check dependencies
echo "📚 Installing dependencies..."
flutter pub get > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo "✅ Dependencies installed"
else
    echo "❌ Failed to install dependencies"
    exit 1
fi
echo ""

# Run analysis
echo "🔍 Running code analysis..."
flutter analyze > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo "✅ No code issues found"
else
    echo "⚠️  Some code issues found (see below)"
    flutter analyze
fi
echo ""

echo "╔════════════════════════════════════════════════════════════╗"
echo "║              Next Steps: Database Setup                    ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""
echo "1️⃣  Go to https://supabase.com/dashboard"
echo "2️⃣  Select your project: bgrryhkqlyuhqwvbekeh"
echo "3️⃣  Click 'SQL Editor' → 'New Query'"
echo "4️⃣  Paste and run the SQL from: SUPABASE_SETUP.md"
echo "5️⃣  Run the app:"
echo ""
echo "    flutter run --dart-define-from-file=.env"
echo ""
echo "✨ That's it! Authentication and tasks should work."
echo ""

# Offer to run
read -p "Ready to run the app? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "🚀 Starting app..."
    flutter run --dart-define-from-file=.env
fi
