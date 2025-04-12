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

(待定 - 建议与原始项目保持一致，例如 MIT 许可证)
