# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Development Commands

### Environment Setup
```bash
flutter pub get                    # Install dependencies
flutter doctor                     # Check Flutter environment
```

### Running the Application
```bash
flutter run -d chrome              # Run on web browser
flutter run -d windows             # Run on Windows desktop
flutter run -d <device-id>         # Run on Android device/emulator
```

### Build Commands
```bash
flutter build windows              # Windows desktop: build/windows/x64/runner/Release/
flutter build apk --release        # Android release APK: build/app/outputs/flutter-apk/app-release.apk
flutter build apk --debug          # Android debug APK (larger, with debugging info)
flutter build web                  # Web: build/web/
flutter build macos                # macOS: build/macos/Build/Products/Release/
flutter build linux                # Linux: build/linux/<arch>/release/bundle/
flutter build ios                  # iOS: build/ios/iphoneos/ (requires macOS + Xcode)
```

### Analysis and Testing
```bash
flutter analyze                    # Static code analysis
flutter test                       # Run unit tests
flutter clean                      # Clean build cache (helpful for Gradle issues)
```

## Architecture Overview

### Core Application Structure
TikTok-style GitHub Trending repository browser with vertical PageView navigation and immersive full-screen cards. The app fetches trending repositories from a Vercel-hosted API and presents them in a social media-like interface.

**Key Components:**
- `HomePage` - Main container with vertical PageView and time-based filtering (daily/weekly/monthly)
- `RepositoryCard` - Full-screen cards with blurred avatar backgrounds using Stack + BackdropFilter
- `DeepWikiPage` & `ZreadPage` - Platform-aware WebView screens for external integrations
- `FilterChips` - Time range selection widget with visual feedback
- `ApiService` - Centralized API client with error handling and timeout management
- `LanguageGradients` - Programming language-based color system for visual consistency

### Data Flow Architecture
1. **API Layer**: `ApiService` communicates with GitTok API at `https://gittok-leaderonepro.vercel.app/api`
   - `GET /trending?since={daily|weekly|monthly}` - Repository lists with metadata
   - `GET /summarize?author={author}&repo={repo}` - AI-generated repository summaries
   - Handles network errors, timeouts, and malformed responses

2. **Model Layer**: 
   - `Repository` model with comprehensive null-safety for inconsistent GitHub API data
   - `Contributor` model for repository maintainer information
   - Robust JSON parsing handling missing or null fields

3. **UI Layer**: 
   - Stateful widgets with lazy-loading patterns for performance
   - AI summaries loaded on-demand via FutureBuilder to avoid rate limiting
   - Language-based theming system using `LanguageGradients`

### Cross-Platform WebView Strategy
- **Mobile (Android/iOS)**: Uses in-app WebView with full JavaScript support
- **Desktop (Windows/macOS/Linux)**: Platform detection automatically falls back to system browser
- **Error Handling**: Graceful degradation with user-friendly error messages and retry options
- **Platform Detection**: Uses `defaultTargetPlatform` to determine appropriate WebView behavior

### Visual Design System
- **Background**: Repository owner's avatar as full-screen blurred background with gradient overlay
- **Foreground**: Clear avatar circle with shadow effects floating above blurred background  
- **Typography**: 48px bold repository names with multi-layer text shadows for readability
- **Language Colors**: Programming language-specific gradients from `LanguageGradients` class
- **Interactive Elements**: Text-labeled buttons instead of icon-only for better UX

### External Integrations
- **DeepWiki**: Transforms GitHub URLs to DeepWiki.com for enhanced repository browsing
- **Zread**: Integrates with Zread.ai for AI-powered repository analysis
- **Share**: Native sharing via SharePlus package for cross-platform compatibility
- **URL Launcher**: Handles external links with platform-appropriate behavior

### Performance Optimizations
- AI summaries loaded lazily to avoid API rate limits and improve initial load time
- Image caching and error fallbacks for avatar loading
- Language gradient system reduces repetitive color calculations
- Platform-specific WebView handling prevents crashes on unsupported systems

### Platform-Specific Considerations
- **Android**: Unified package name `com.leaderonepro.gittok` with network permissions
- **Windows**: WebView2 compatibility issues resolved with browser fallback
- **Web**: CORS restrictions may affect avatar image loading
- **Build Performance**: Android builds slow on first run due to Gradle dependency downloads

### Known Technical Debt
- Test files still reference legacy package name (`myapp` instead of `gittok`)
- API service URL hardcoded (should be environment-configurable)
- Some legacy commented code in WebView components that could be cleaned up