class Repo {
  final String author;
  final String name;
  final String avatar;
  final String url;
  final String description;
  final String language;
  final String languageColor;
  final int stars;
  final int forks;
  final int currentPeriodStars;

  Repo({
    required this.author,
    required this.name,
    required this.avatar,
    required this.url,
    required this.description,
    required this.language,
    required this.languageColor,
    required this.stars,
    required this.forks,
    required this.currentPeriodStars,
  });

  factory Repo.fromJson(Map<String, dynamic> json) {
    return Repo(
      author: json['author'] ?? '',
      name: json['name'] ?? '',
      avatar: json['avatar'] ?? '',
      url: json['url'] ?? '',
      description: json['description'] ?? '',
      language: json['language'] ?? '',
      languageColor: json['languageColor'] ?? '',
      stars: json['stars'] ?? 0,
      forks: json['forks'] ?? 0,
      currentPeriodStars: json['currentPeriodStars'] ?? 0,
    );
  }
}