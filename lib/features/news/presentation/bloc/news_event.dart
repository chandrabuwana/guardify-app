import 'package:equatable/equatable.dart';
import '../../domain/entities/news.dart';

abstract class NewsEvent extends Equatable {
  const NewsEvent();

  @override
  List<Object?> get props => [];
}

class NewsLoadNews extends NewsEvent {
  const NewsLoadNews();
}

class NewsLoadMoreNews extends NewsEvent {
  const NewsLoadMoreNews();
}

class NewsRefreshNews extends NewsEvent {
  const NewsRefreshNews();
}

class NewsLoadNewsById extends NewsEvent {
  final String id;

  const NewsLoadNewsById(this.id);

  @override
  List<Object?> get props => [id];
}

class NewsSearchNews extends NewsEvent {
  final String query;

  const NewsSearchNews(this.query);

  @override
  List<Object?> get props => [query];
}

class NewsFilterByCategory extends NewsEvent {
  final NewsCategory category;

  const NewsFilterByCategory(this.category);

  @override
  List<Object?> get props => [category];
}

class NewsCreateNews extends NewsEvent {
  final News news;

  const NewsCreateNews(this.news);

  @override
  List<Object?> get props => [news];
}

class NewsUpdateNews extends NewsEvent {
  final News news;

  const NewsUpdateNews(this.news);

  @override
  List<Object?> get props => [news];
}

class NewsDeleteNews extends NewsEvent {
  final String id;

  const NewsDeleteNews(this.id);

  @override
  List<Object?> get props => [id];
}

class NewsClearSearch extends NewsEvent {
  const NewsClearSearch();
}

class NewsClearFilter extends NewsEvent {
  const NewsClearFilter();
}
