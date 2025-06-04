# GitTok Flutter 📱

这是 [GitTok Web App](https://github.com/LeaderOnePro/GitTok) 的 Flutter 实现版本，旨在提供一个原生应用体验，让您像刷 TikTok 一样浏览 GitHub Trending 项目。

## ✨ 当前特性

*   **TikTok 风格界面**: 使用 `PageView` 实现全屏、垂直滚动的 GitHub Trending 项目浏览。
*   **数据获取**: 从原始 GitTok 项目的 Vercel API ([https://gittok-leaderonepro.vercel.app/api](https://gittok-leaderonepro.vercel.app/api)) 获取 Trending 数据。
*   **时间范围选择**: 支持查看今日 (daily)、本周 (weekly) 和本月 (monthly) 的 GitHub Trending 数据。
*   **卡片详情**: 每个仓库卡片显示：
    *   作者头像作为模糊背景 (Android 端正常显示，Web 端可能因 CORS 受限)。
    *   仓库作者和名称。
    *   项目描述。
    *   星标数、Fork 数和主要语言。
    *   当前周期（日/周/月）新增星标数。
*   **AI 总结 (按需加载)**: 每个卡片提供按钮，点击后调用 Vercel API 获取并显示 AI 生成的项目 README 总结。
*   **跨平台基础**: 代码已支持 Web 和 Android 平台。

## 🚀 运行应用

**先决条件:**

*   确保您已安装并配置好 [Flutter SDK](https://docs.flutter.dev/get-started/install)。
*   运行 `flutter doctor` 检查您的开发环境是否满足所有要求。

**步骤:**

1.  **克隆仓库** (如果您尚未克隆):
    ```bash
    # git clone <your-repo-url>
    # cd gittok_flutter
    ```
2.  **获取依赖**:
    ```bash
    flutter pub get
    ```
3.  **运行应用**:

    *   **Web 端:**
        ```bash
        flutter run -d chrome
        # 或者 flutter run -d edge
        ```
        *注意: 在 Web 端，由于浏览器 CORS 限制，仓库作者头像可能无法直接从 github.com 加载。*

    *   **Android 端:**
        1.  确保您已连接 Android 设备或启动了模拟器。
        2.  运行 `flutter devices` 查看设备 ID。
        3.  运行应用 (将 `<your-device-id>` 替换为实际 ID):
            ```bash
            flutter run -d <your-device-id>
            ```
        *注意: 首次在 Android 上构建时，Gradle 可能需要下载大量依赖，耗时较长。如果遇到 Gradle 构建错误 (如此前遇到的 AGP 插件无法找到的问题)，请检查网络连接、代理设置，并尝试运行 `flutter clean` 清理缓存。*

## 📦 构建与打包应用

当您准备好分发您的应用时，您需要为目标平台构建 release 版本。

**通用命令:**

```bash
flutter build <platform>
```
将 `<platform>` 替换为您想构建的平台，例如 `windows`, `apk` (Android), `appbundle` (Android), `ios`, `linux`, `macos`, `web`。

### Windows 桌面应用

1.  **构建应用:**
    ```bash
    flutter build windows
    ```
2.  **查找产物:**
    构建完成后，可执行文件及相关依赖会存放在项目根目录下的 `build\windows\runner\Release\` 文件夹中。
3.  **运行与分发:**
    要运行应用，请执行该目录下的 `.exe` 文件 (例如 `gittok_flutter.exe`)。
    如果您需要分发应用，请将 **整个 `Release` 文件夹** (而不仅仅是 `.exe` 文件) 打包 (例如压缩成 `.zip` 文件) 并提供给用户。用户解压后即可运行。

### Android 应用

1.  **构建 APK (通用安装包):**
    ```bash
    flutter build apk
    ```
    APK 文件会生成在 `build\app\outputs\flutter-apk\app-release.apk`。

2.  **构建 App Bundle (推荐用于 Google Play 发布):**
    ```bash
    flutter build appbundle
    ```
    App Bundle 文件会生成在 `build\app\outputs\bundle\release\app-release.aab`。

### Web 应用

1.  **构建 Web 版本:**
    ```bash
    flutter build web
    ```
2.  **查找产物:**
    构建产物会生成在 `build\web\` 目录下。您可以将此目录下的所有内容部署到任何静态网站托管服务。

### 其他平台 (macOS, Linux, iOS)

对于 macOS, Linux, 和 iOS，构建过程类似：

*   **macOS:**
    ```bash
    flutter build macos
    ```
    产物在 `build/macos/Build/Products/Release/`。

*   **Linux:**
    ```bash
    flutter build linux
    ```
    产物在 `build/linux/<architecture>/release/bundle/`。

*   **iOS:**
    ```bash
    flutter build ios
    ```
    这通常需要在 macOS 环境下进行，并与 Xcode 配合使用以进行签名和分发。产物在 `build/ios/iphoneos/` (或相应的模拟器路径)。

**注意:** 不同平台的构建和分发可能有其特定的要求和最佳实践，建议查阅 Flutter 官方文档获取更详细的指导。

## ⚙️ 后端 API

本 Flutter 应用依赖于原始 GitTok Web 项目部署在 Vercel 上的 Serverless API 来获取数据：
*   `https://gittok-leaderonepro.vercel.app/api/trending`
*   `https://gittok-leaderonepro.vercel.app/api/summarize`

确保该 API 正在运行且可访问。

## ⚠️ 已知问题

*   **Web 图片 CORS**: 在 Web 平台上运行时，直接加载 GitHub 头像图片可能会失败。
*   **Android Gradle 构建**: 用户的网络环境或 Gradle 配置可能导致初始构建时间长或失败 (如插件下载问题)。

## 🔗 原始项目

*   **GitTok Web (原版)**: [https://github.com/LeaderOnePro/GitTok](https://github.com/LeaderOnePro/GitTok)

## 📄 许可证

本项目采用 [MIT 许可证](LICENSE)。
# GitTok - Flutter 版

## 项目概述

本项目是 GitTok 的 Flutter 客户端实现，旨在将浏览 GitHub Trending 仓库的体验变得像刷 TikTok 一样流畅和有趣。本项目主要实现了Web端GitTok的核心功能。

## 主要功能

*   **浏览 GitHub Trending 仓库：** 以列表形式展示 GitHub Trending 仓库，可以查看仓库名称、作者、描述、语言、星星数、Fork 数、今日新增星星数等信息。
*   **时间范围切换：** 支持按今日、本周、本月切换 Trending 列表。
* **点击头像跳转**: 点击项目头像，可以跳转到项目地址。
* **分享按钮**: 点击分享按钮，可以分享到第三方平台，或者复制链接。
*   **AI 总结：** 使用 AI 对每个仓库的 README 文件进行一句话总结，方便用户快速了解项目。
* **毛玻璃效果**: 在主页和项目卡片上添加了毛玻璃效果。
*   **数据加载状态与错误处理：** 在数据加载时显示加载指示器，在数据加载失败时显示错误信息。

## 技术栈

*   **Flutter：** 用于构建跨平台的移动应用。
*   **Dart：** Flutter 的编程语言。
* **http**: 用于网络请求。
* **url_launcher**: 用于跳转url。

## 项目结构

*   **`lib/main.dart`：** 应用的入口文件，配置了 `HomeScreen` 作为应用的首页。
*   **`lib/screens/home_screen.dart`：** 应用的主页，用于展示 GitHub Trending 列表。
*   **`lib/widgets/repo_item.dart`：** 用于展示单个 GitHub Trending 仓库信息的卡片组件。
*   **`lib/models/repo.dart`：** 定义了 `Repo` 数据模型，用于表示 GitHub Trending 仓库信息。
*   **`lib/services/api_service.dart`：** 定义了 `ApiService` 类，用于与后端 API 进行交互。

## 后端 API

本项目使用了两个后端 API（均为 Vercel Serverless Function），这两个 API 来自于 GitTok Web 项目：

*   **`/api/trending`：** 用于获取 GitHub Trending 仓库列表。
*   **`/api/summarize`：** 用于获取仓库的 AI 总结。

## 本地开发说明

1.  **启动后端服务：**
    *   进入 GitTok Web 项目目录。
    *   运行 `npm install` 安装依赖。
    *  运行 `npm run dev` 或者 `node trending.js` 和 `node summarize.js` 启动本地后端服务。

2.  **启动 Flutter 应用**:
    *   进入 Flutter 项目目录。
    *   运行 `flutter run` 启动 Flutter 应用。

## 待办事项

*   **集成 AI 总结：** 在 `RepoItem` 中实现 AI 总结的获取和展示逻辑。
* **完善样式**: 调整样式使其更接近web端的表现。
* **实现分享功能**: 实现分享的功能，点击分享按钮，可以分享对应的项目链接。
* **实现AI总结的懒加载**: 集成 AI 总结懒加载。
* **完善数据来源**: 目前只是调用了本地的后端服务，可以部署到vercel上，并调用vercel的后端服务。
* **添加未来计划**: 实现未来计划的模块，比如筛选器，用户偏好设置等。

## 如何贡献

欢迎提交 Pull Requests 或 Issues 来帮助改进这个项目！

## 许可证

[MIT](LICENSE)
