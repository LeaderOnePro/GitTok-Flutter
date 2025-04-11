import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/repo.dart';

class RepoItem extends StatefulWidget {
  final Repo repo;

  const RepoItem({Key? key, required this.repo}) : super(key: key);

  @override
  State<RepoItem> createState() => _RepoItemState();
}

class _RepoItemState extends State<RepoItem> {
  bool _summaryLoaded = false;
  String _summary = 'AI 总结加载中...';

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      throw Exception('Could not launch $uri');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // 0. 模糊背景层
        Positioned.fill(
          child: ImageFiltered(
            imageFilter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Image.network(
              '${widget.repo.avatar}?s=600',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey[300],
                  child: const Icon(Icons.error, size: 50, color: Colors.grey),
                );
              },
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.all(10.0),
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2), // 毛玻璃效果
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 1. 主要内容图片 (居中显示，点击跳转)
              GestureDetector(
                onTap: () => _launchUrl(widget.repo.url),
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(widget.repo.avatar),
                    ),
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // 2. 底部信息
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // 项目名称
                  Text(
                    widget.repo.name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 5),
                  // 作者
                  Text(
                    'Author: ${widget.repo.author}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  const SizedBox(height: 5),
                  // 语言和星星
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (widget.repo.language.isNotEmpty)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Color(int.tryParse(
                                        '0xFF${widget.repo.languageColor.substring(1)}') ??
                                    0xFFCCCCCC)
                                .withOpacity(0.8),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            widget.repo.language,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      const SizedBox(width: 10),
                      const Icon(Icons.star, color: Colors.yellow, size: 18),
                      Text('${widget.repo.stars}',
                          style: const TextStyle(color: Colors.white)),
                      const SizedBox(width: 10),
                      const Icon(Icons.fork_right, color: Colors.grey, size: 18),
                      Text('${widget.repo.forks}',
                          style: const TextStyle(color: Colors.white)),
                    ],
                  ),
                  const SizedBox(height: 5),
                  // 今日 Star
                  Text(
                    'Today Stars: ${widget.repo.currentPeriodStars}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const SizedBox(height: 10),
                  // 描述
                  Text(
                    widget.repo.description,
                    textAlign: TextAlign.center,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 10),
                  // AI Summary Placeholder
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: Text(
                      _summary,
                      key: ValueKey<bool>(_summaryLoaded),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontStyle:
                            _summaryLoaded ? FontStyle.normal : FontStyle.italic,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        // 分享按钮 (右下角)
        Positioned(
          bottom: 10,
          right: 10,
          child: IconButton(
            icon: const Icon(Icons.share, color: Colors.white),
            onPressed: () {
              // Share Functionality (To be implemented)
              print('Share button pressed for ${widget.repo.name}');
            },
          ),
        ),
      ],
    );
  }
}