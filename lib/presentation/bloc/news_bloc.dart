import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/article.dart';
import '../../domain/usecases/get_news.dart';

part 'news_event.dart';
part 'news_state.dart';

class NewsBloc extends Bloc<NewsEvent, NewsState> {
  final GetNews getNews;
  
  String? _currentCategory;
  String? _currentQuery;

  NewsBloc({required this.getNews}) : super(NewsInitial()) {
    on<FetchNewsEvent>(_onFetchNews);
    on<RefreshNewsEvent>(_onRefreshNews);
    on<SearchNewsEvent>(_onSearchNews);
    on<FilterByCategoryEvent>(_onFilterByCategory);
    on<ClearSearchEvent>(_onClearSearch);
  }

  Future<void> _onFetchNews(
    FetchNewsEvent event,
    Emitter<NewsState> emit,
  ) async {
    emit(const NewsLoading());
    
    _currentCategory = event.category;
    _currentQuery = event.query;

    final result = await getNews(
      category: _currentCategory,
      query: _currentQuery,
    );

    result.fold(
      (failure) => emit(NewsError(failure.message)),
      (articles) {
        if (articles.isEmpty) {
          emit(const NewsEmpty());
        } else {
          emit(NewsLoaded(
            articles: articles,
            currentCategory: _currentCategory,
            currentQuery: _currentQuery,
          ));
        }
      },
    );
  }

  Future<void> _onRefreshNews(
    RefreshNewsEvent event,
    Emitter<NewsState> emit,
  ) async {
    emit(const NewsLoading(isRefreshing: true));

    final result = await getNews(
      category: _currentCategory,
      query: _currentQuery,
    );

    result.fold(
      (failure) => emit(NewsError(failure.message)),
      (articles) {
        if (articles.isEmpty) {
          emit(const NewsEmpty());
        } else {
          emit(NewsLoaded(
            articles: articles,
            currentCategory: _currentCategory,
            currentQuery: _currentQuery,
          ));
        }
      },
    );
  }

  Future<void> _onSearchNews(
    SearchNewsEvent event,
    Emitter<NewsState> emit,
  ) async {
    emit(const NewsLoading());
    
    _currentQuery = event.query.isNotEmpty ? event.query : null;

    final result = await getNews(
      category: _currentCategory,
      query: _currentQuery,
    );

    result.fold(
      (failure) => emit(NewsError(failure.message)),
      (articles) {
        if (articles.isEmpty) {
          emit(const NewsEmpty());
        } else {
          emit(NewsLoaded(
            articles: articles,
            currentCategory: _currentCategory,
            currentQuery: _currentQuery,
          ));
        }
      },
    );
  }

  Future<void> _onFilterByCategory(
    FilterByCategoryEvent event,
    Emitter<NewsState> emit,
  ) async {
    emit(const NewsLoading());
    
    _currentCategory = event.category;

    final result = await getNews(
      category: _currentCategory,
      query: _currentQuery,
    );

    result.fold(
      (failure) => emit(NewsError(failure.message)),
      (articles) {
        if (articles.isEmpty) {
          emit(const NewsEmpty());
        } else {
          emit(NewsLoaded(
            articles: articles,
            currentCategory: _currentCategory,
            currentQuery: _currentQuery,
          ));
        }
      },
    );
  }

  Future<void> _onClearSearch(
    ClearSearchEvent event,
    Emitter<NewsState> emit,
  ) async {
    _currentQuery = null;
    add(FetchNewsEvent(category: _currentCategory));
  }
}

