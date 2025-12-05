part of 'news_bloc.dart';

abstract class NewsState extends Equatable {
  const NewsState();

  @override
  List<Object?> get props => [];
}

class NewsInitial extends NewsState {}

class NewsLoading extends NewsState {
  final bool isRefreshing;

  const NewsLoading({this.isRefreshing = false});

  @override
  List<Object?> get props => [isRefreshing];
}

class NewsLoaded extends NewsState {
  final List<Article> articles;
  final String? currentCategory;
  final String? currentQuery;

  const NewsLoaded({
    required this.articles,
    this.currentCategory,
    this.currentQuery,
  });

  @override
  List<Object?> get props => [articles, currentCategory, currentQuery];

  NewsLoaded copyWith({
    List<Article>? articles,
    String? currentCategory,
    String? currentQuery,
  }) {
    return NewsLoaded(
      articles: articles ?? this.articles,
      currentCategory: currentCategory ?? this.currentCategory,
      currentQuery: currentQuery ?? this.currentQuery,
    );
  }
}

class NewsEmpty extends NewsState {
  final String message;

  const NewsEmpty({this.message = 'No Results Found'});

  @override
  List<Object?> get props => [message];
}

class NewsError extends NewsState {
  final String message;

  const NewsError(this.message);

  @override
  List<Object?> get props => [message];
}

