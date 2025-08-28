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
flutter build windows              # Windows desktop: build/windows/runner/Release/
flutter build apk                  # Android APK: build/app/outputs/flutter-apk/app-release.apk
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
This is a Flutter application that replicates TikTok-style scrolling for GitHub Trending repositories, featuring vertical PageView navigation with immersive full-screen cards.

**Key Components:**
- `HomePage` - Main container with vertical PageView and filtering controls
- `RepositoryCard` - Full-screen cards with blurred background effects using Stack + BackdropFilter
- `FilterChips` - Time range selection (daily/weekly/monthly)
- `ApiService` - Handles all external API communications

### Data Flow Architecture
1. **API Layer**: `ApiService` fetches from Vercel-hosted GitTok API (`https://gittok-leaderonepro.vercel.app/api`)
   - `/trending?since={daily|weekly|monthly}` - Repository lists
   - `/summarize?author={author}&repo={repo}` - AI-generated summaries

2. **Model Layer**: `Repository` and `Contributor` models with robust null-safety JSON parsing

3. **UI Layer**: Stateful widgets with lazy-loading AI summaries using FutureBuilder pattern

### Visual Design Pattern
- **Background**: Repository owner's avatar as full-screen blurred background
- **Foreground**: Clear avatar + repository details + action buttons
- **Navigation**: TikTok-style vertical swiping between repositories
- **Effects**: BackdropFilter blur + semi-transparent overlays

### External Integrations
- **DeepWiki**: Replaces `github.com` with `deepwiki.com` in repository URLs
- **Zread**: Opens `https://zread.ai/{author}/{repo}` for repository analysis
- **Share**: Native sharing via SharePlus package
- **WebView**: In-app browsing for DeepWiki pages

### Key Technical Decisions
- Uses `PageView.builder` with `BouncingScrollPhysics` for smooth vertical scrolling
- AI summaries are lazily loaded on-demand to avoid API rate limits
- Extensive null-safety handling in JSON parsing due to variable API response formats
- Cross-platform URL launching via `url_launcher` package

### Known Limitations
- Web platform may have CORS restrictions for avatar images
- Android builds can be slow on first run due to Gradle dependency downloads
- Test files reference incorrect package name (`myapp` instead of `gittok`)