class News {
  final String id;
  final String title;
  final String content;
  final String category;
  final String source;
  final String? imageUrl;
  final DateTime publishedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  const News({
    required this.id,
    required this.title,
    required this.content,
    required this.category,
    required this.source,
    this.imageUrl,
    required this.publishedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  News copyWith({
    String? id,
    String? title,
    String? content,
    String? category,
    String? source,
    String? imageUrl,
    DateTime? publishedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return News(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      category: category ?? this.category,
      source: source ?? this.source,
      imageUrl: imageUrl ?? this.imageUrl,
      publishedAt: publishedAt ?? this.publishedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is News &&
        other.id == id &&
        other.title == title &&
        other.content == content &&
        other.category == category &&
        other.source == source &&
        other.imageUrl == imageUrl &&
        other.publishedAt == publishedAt &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      title,
      content,
      category,
      source,
      imageUrl,
      publishedAt,
      createdAt,
      updatedAt,
    );
  }

  @override
  String toString() {
    return 'News(id: $id, title: $title, content: $content, category: $category, source: $source, imageUrl: $imageUrl, publishedAt: $publishedAt, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}

enum NewsCategory {
  cuaca('Cuaca'),
  bencana('Bencana'),
  lainnya('Lainnya');

  const NewsCategory(this.displayName);
  final String displayName;
}
