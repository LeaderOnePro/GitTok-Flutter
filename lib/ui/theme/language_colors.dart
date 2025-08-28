import 'package:flutter/material.dart';

/// Language-based gradient system for better readability and visual hierarchy
class LanguageGradients {
  // 主渐变色映射 - 基于编程语言的专业色彩系统
  static const Map<String, List<Color>> _languageGradients = {
    'JavaScript': [Color(0xFFF7DF1E), Color(0xFFE8B600)], // 经典JS黄
    'TypeScript': [Color(0xFF3178C6), Color(0xFF235A9B)], // TS蓝
    'Python': [Color(0xFF3776AB), Color(0xFF2B5A87)], // Python蓝
    'Java': [Color(0xFFED8B00), Color(0xFFCC7700)], // Java橙
    'C++': [Color(0xFF00599C), Color(0xFF004080)], // C++深蓝
    'C': [Color(0xFFA8B9CC), Color(0xFF7B8FA3)], // C灰蓝
    'Go': [Color(0xFF00ADD8), Color(0xFF0099BB)], // Go青
    'Rust': [Color(0xFFDEA584), Color(0xFFB8835A)], // Rust橙褐
    'Swift': [Color(0xFFFA7343), Color(0xFFE85D2D)], // Swift橙红
    'Kotlin': [Color(0xFF0095D5), Color(0xFF007BB5)], // Kotlin蓝
    'PHP': [Color(0xFF777BB4), Color(0xFF5F5F9F)], // PHP紫
    'Ruby': [Color(0xFFCC342D), Color(0xFFB82E27)], // Ruby红
    'C#': [Color(0xFF239120), Color(0xFF1F7A1A)], // C#绿
    'Shell': [Color(0xFF89E051), Color(0xFF6FB83F)], // Shell绿
    'HTML': [Color(0xFFE34F26), Color(0xFFCC3E1F)], // HTML红橙
    'CSS': [Color(0xFF1572B6), Color(0xFF125F99)], // CSS蓝
    'Vue': [Color(0xFF4FC08D), Color(0xFF42A374)], // Vue绿
    'React': [Color(0xFF61DAFB), Color(0xFF4FB3D4)], // React蓝
    'Dart': [Color(0xFF0175C2), Color(0xFF01579B)], // Dart蓝
    'R': [Color(0xFF276DC3), Color(0xFF1F5897)], // R蓝
    'MATLAB': [Color(0xFFE16737), Color(0xFFCC5229)], // MATLAB橙
    'Scala': [Color(0xFFDC322F), Color(0xFFB82B26)], // Scala红
  };

  // 未知语言的默认渐变
  static const List<Color> _defaultGradient = [
    Color(0xFF6C7B7F), // 专业灰蓝
    Color(0xFF4A5568), // 深灰
  ];

  // 获取语言对应的线性渐变
  static LinearGradient getLanguageGradient(String? language) {
    final colors = _languageGradients[language] ?? _defaultGradient;
    
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: colors,
      stops: const [0.0, 1.0],
    );
  }

  // 获取语言的主色调（用于UI元素）
  static Color getLanguagePrimaryColor(String? language) {
    final colors = _languageGradients[language] ?? _defaultGradient;
    return colors[0];
  }

  // 获取语言的次要色调（用于阴影、边框等）
  static Color getLanguageSecondaryColor(String? language) {
    final colors = _languageGradients[language] ?? _defaultGradient;
    return colors[1];
  }

  // 获取适合在该背景上显示的文字颜色（确保可读性）
  static Color getTextColorForLanguage(String? language) {
    // 对于浅色背景使用深色文字，深色背景使用白色文字
    final lightLanguages = ['JavaScript', 'Shell', 'Vue', 'React', 'R'];
    
    if (lightLanguages.contains(language)) {
      return const Color(0xFF1A202C); // 深色文字
    }
    
    return Colors.white; // 白色文字，适用于大部分深色背景
  }

  // 为了更好的视觉层次，提供不同透明度的覆盖层
  static Color getOverlayColor(String? language, {double opacity = 0.1}) {
    return Colors.black.withOpacity(opacity);
  }
}