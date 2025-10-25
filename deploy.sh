#!/bin/bash

# Biometrics Dashboard Deployment Script
# This script builds and prepares the Flutter web app for deployment

echo "🚀 Building Biometrics Dashboard for Web..."

# Clean previous builds
echo "🧹 Cleaning previous builds..."
flutter clean

# Get dependencies
echo "📦 Getting dependencies..."
flutter pub get

# Generate code
echo "🔧 Generating code..."
flutter packages pub run build_runner build --delete-conflicting-outputs

# Build for web
echo "🏗️ Building for web..."
flutter build web --release

echo "✅ Build complete! Files are in build/web/"
echo "📁 You can now deploy the contents of build/web/ to any static hosting service:"
echo "   - GitHub Pages"
echo "   - Netlify"
echo "   - Vercel"
echo "   - Firebase Hosting"
echo ""
echo "🌐 To test locally, run:"
echo "   cd build/web && python3 -m http.server 8000"
echo "   Then open http://localhost:8000 in your browser"
