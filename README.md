# GitTok Flutter 🚀✨

> 像刷 TikTok 一样，沉浸式发现 GitHub Trending 项目！  
> 跨平台 · AI 总结 · 极速体验

---

## 🏗️ 项目结构

```plaintext
GitTok-Flutter/
├── lib/
│   ├── main.dart                # 应用入口
│   ├── models/
│   │   └── repository.dart      # Trending 仓库数据模型
│   ├── services/
│   │   └── api_service.dart     # API 网络请求与数据处理
│   ├── screens/
│   │   ├── home_page.dart       # TikTok 风格主页面
│   │   ├── screens/
│   │   │   └── deepwiki_page.dart
│   │   └── widgets/
│   │       └── repository_card.dart
├── test/
│   └── widget_test.dart         # 测试用例
├── android/                     # Android 原生工程
├── web/                         # Web 支持
├── build/                       # 构建产物
├── pubspec.yaml                 # 依赖与配置
└── README.md
```

---

## ✨ 主要特性

- 🎬 **TikTok 风格全屏滑动**：沉浸式浏览 Trending 项目
- 🔥 **实时数据**：对接 Vercel API，获取 GitHub 热门仓库
- 🕒 **多时间维度**：今日 / 本周 / 本月随心切换
- 🧑‍💻 **卡片详情**：头像毛玻璃背景、描述、语言、Star、Fork
- 🤖 **AI 项目总结**：一键获取 AI 生成的 README 精华
- 🌐 **多端支持**：Web、Android、Windows（可扩展到 macOS、Linux、iOS）

---

## 🚀 快速开始

### 1. 环境准备

- 安装 [Flutter SDK](https://docs.flutter.dev/get-started/install)  
- 运行 `flutter doctor` 检查环境

### 2. 克隆与依赖

```bash
git clone <your-repo-url>
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
| Windows   | `flutter build windows`       | `build/windows/runner/Release/`               | 分发需打包整个 Release 文件夹 |
| Android   | `flutter build apk`           | `build/app/outputs/flutter-apk/app-release.apk` | 直接安装 APK               |
| Web       | `flutter build web`           | `build/web/`                                  | 静态资源，可部署到任意 Web 服务器 |
| macOS     | `flutter build macos`         | `build/macos/Build/Products/Release/`         |                            |
| Linux     | `flutter build linux`         | `build/linux/<arch>/release/bundle/`          |                            |
| iOS       | `flutter build ios`           | `build/ios/iphoneos/`                         | 需 macOS + Xcode           |

---

## 🛠️ 技术栈

- 🐦 **Flutter** & **Dart**：跨平台高性能 UI
- 🌐 **http**：网络请求
- 🔗 **url_launcher**：外部链接跳转
- 🧊 **BackdropFilter**：毛玻璃特效
- 🤖 **AI 总结**：Vercel Serverless API

---

## 🧩 技术细节亮点

- **PageView + Stack** 实现 TikTok 风格滑动与毛玻璃背景
- **FutureBuilder** 异步加载数据，流畅体验
- **自定义卡片组件**，支持 AI 总结懒加载
- **多平台打包**，一套代码多端运行

---

## ⚙️ 后端 API

- `GET /api/trending` —— 获取 Trending 仓库列表
- `GET /api/summarize` —— 获取仓库 AI 总结

> API 由 [GitTok Web](https://github.com/LeaderOnePro/GitTok) 项目提供

---

## 🐞 已知问题

- 🌐 Web 端头像图片可能因 CORS 受限无法显示
- 🛠️ Android 首次构建依赖下载慢，建议科学上网

---

## 📝 待办与展望

- [ ] 分享功能完善
- [ ] AI 总结懒加载优化
- [ ] 样式进一步对齐 Web 端
- [ ] 支持更多平台（如 HarmonyOS）
- [ ] 用户偏好与筛选器

---

## 🤝 贡献指南

欢迎 PR、Issue，一起让 GitTok 更好用！

---

## 📄 License

[MIT](LICENSE)
