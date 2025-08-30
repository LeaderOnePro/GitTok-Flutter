# GitTok Flutter 🚀✨

> 像刷 TikTok 一样，沉浸式发现 GitHub Trending 项目！  
> 跨平台 · AI 总结 · 极速体验

---

## 🏗️ 项目结构

```plaintext
GitTok-Flutter/
├── android/         # Android 原生工程
├── ios/             # iOS 原生工程
├── linux/           # Linux 桌面支持
├── macos/           # macOS 桌面支持
├── windows/         # Windows 桌面支持
├── web/             # Web 支持
├── lib/
│   ├── main.dart
│   ├── models/
│   │   └── repository.dart
│   ├── services/
│   │   └── api_service.dart
│   └── ui/
│       ├── home_page.dart
│       ├── screens/
│       │   ├── deepwiki_page.dart
│       │   └── zread_page.dart
│       ├── theme/
│       │   └── language_colors.dart
│       └── widgets/
│           ├── repository_card.dart
│           └── filter_chips.dart
├── test/
│   └── widget_test.dart
├── build/           # 构建产物
├── CLAUDE.md        # Claude Code 开发指南
├── pubspec.yaml     # 依赖与配置
├── README.md
└── ...（省略部分配置文件）
```

---

## ✨ 主要特性

- 🎬 **TikTok 风格全屏滑动**：沉浸式浏览 Trending 项目
- 🔥 **实时数据**：对接 Vercel API，获取 GitHub 热门仓库
- 🕒 **多时间维度**：今日 / 本周 / 本月随心切换
- 🧑‍💻 **视觉设计**：头像毛玻璃背景 + 编程语言渐变色系
- 🤖 **AI 项目总结**：一键获取 AI 生成的 README 精华
- 🌐 **外部集成**：DeepWiki 深度解析 + Zread AI 分析
- 📱 **跨平台支持**：Web、Android、Windows、macOS、Linux、iOS
- 🎯 **智能适配**：移动端 WebView + 桌面端浏览器回退

---

## 🚀 快速开始

### 1. 环境准备

- 安装 [Flutter SDK](https://docs.flutter.dev/get-started/install)  
- 运行 `flutter doctor` 检查环境

### 2. 克隆与依赖

```bash
git clone https://github.com/LeaderOnePro/GitTok-Flutter.git
cd GitTok-Flutter
flutter pub get
```

### 3. 运行应用

- **Web**  
  `flutter run -d chrome`
- **Android**  
  连接设备或模拟器，`flutter run -d <device-id>`
- **Windows 桌面**  
  `flutter run -d windows`

> 💡 首次构建 Android 可能较慢，遇到 Gradle 问题可尝试 `flutter clean`。

---

## 📦 构建与打包

| 平台      | 构建命令                      | 产物路径                                      | 说明                       |
|-----------|-------------------------------|-----------------------------------------------|----------------------------|
| Windows   | `flutter build windows`       | `build/windows/x64/runner/Release/`          | 分发需打包整个 Release 文件夹 |
| Android   | `flutter build apk --release` | `build/app/outputs/flutter-apk/app-release.apk` | 生产版 APK (20MB)         |
| Android   | `flutter build apk --debug`   | `build/app/outputs/flutter-apk/app-debug.apk`   | 调试版 APK (90MB)         |
| Web       | `flutter build web`           | `build/web/`                                  | 静态资源，可部署到任意 Web 服务器 |
| macOS     | `flutter build macos`         | `build/macos/Build/Products/Release/`         |                            |
| Linux     | `flutter build linux`         | `build/linux/<arch>/release/bundle/`          |                            |
| iOS       | `flutter build ios`           | `build/ios/iphoneos/`                         | 需 macOS + Xcode           |

---

## 🛠️ 技术栈

- 🐦 **Flutter** & **Dart**：跨平台高性能 UI 框架
- 🌐 **http**：网络请求与 API 通信
- 📱 **webview_flutter**：跨平台 WebView 组件
- 🔗 **url_launcher**：外部链接与浏览器启动
- 📤 **share_plus**：原生分享功能
- 🧊 **BackdropFilter**：毛玻璃背景特效
- 🎨 **编程语言渐变色系**：基于语言的视觉主题
- 🤖 **AI 总结**：Vercel Serverless API

---

## 🧩 技术架构亮点

### 视觉设计系统
- **沉浸式背景**：用户头像全屏模糊 + 多层渐变遮罩
- **语言色彩**：20+ 编程语言专属渐变色系 (JavaScript 黄、Python 蓝等)
- **排版层次**：48px 粗体标题 + 多层文字阴影确保可读性
- **交互优化**：文本标签按钮替代纯图标，提升用户体验

### 跨平台 WebView 策略
- **移动端**：应用内 WebView，JavaScript 全支持，流畅体验
- **桌面端**：自动检测 WebView2 支持，智能回退至系统浏览器
- **错误处理**：友好的错误页面 + 一键重试 + 外部浏览器选项
- **平台感知**：`defaultTargetPlatform` 检测，确保最佳用户体验

### 性能优化
- **懒加载**：AI 总结按需加载，避免 API 速率限制
- **缓存机制**：头像图片缓存 + 错误回退方案
- **渐变计算**：语言色彩系统减少重复计算
- **内存管理**：PageView 构建器模式，高效滚动体验

---

## ⚙️ 后端 API

- `GET /api/trending?since={daily|weekly|monthly}` —— 获取 Trending 仓库列表
- `GET /api/summarize?author={author}&repo={repo}` —— 获取仓库 AI 总结

> API 由 [GitTok Web](https://github.com/LeaderOnePro/GitTok) 项目提供  
> 部署于: `https://gittok-leaderonepro.vercel.app/api`

---

## 🔧 开发说明

### 平台特性
- **Android**: 统一包名 `com.leaderonepro.gittok`，网络权限完整配置
- **Windows**: WebView2 兼容性处理，自动浏览器回退
- **Web**: CORS 跨域处理，头像加载优雅降级

### 已解决的技术挑战
- ✅ **一加13等OEM设备闪退**: 修复包名冲突和 MainActivity 路径
- ✅ **Windows WebView 空值错误**: 平台检测 + 浏览器回退
- ✅ **按钮交互不直观**: 图标+文字标签设计
- ✅ **Android 网络权限**: TLS 配置 + 明文流量支持

---

## 🐞 已知限制

- 🌐 Web 端可能因 CORS 限制无法加载部分头像图片
- 🛠️ Android 首次构建较慢，建议科学上网加速依赖下载
- 🧪 测试文件仍引用旧包名 (`myapp` → `gittok`)

---

## 🤝 贡献指南

欢迎提交 PR 和 Issue！参与贡献前请阅读 [CLAUDE.md](CLAUDE.md) 了解项目架构。

### 开发流程
1. Fork 本项目
2. 创建功能分支: `git checkout -b feature/amazing-feature`
3. 提交更改: `git commit -m 'Add: 新增某某功能'`
4. 推送分支: `git push origin feature/amazing-feature`
5. 创建 Pull Request

---

## 📄 开源许可

[MIT License](LICENSE) - 自由使用，欢迎贡献

---

**⭐ 觉得不错？给个 Star 支持一下！**
