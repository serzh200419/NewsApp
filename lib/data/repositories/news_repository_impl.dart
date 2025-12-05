import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../core/error/failures.dart';
import '../../core/network/network_info.dart';
import '../../domain/entities/article.dart';
import '../../domain/repositories/news_repository.dart';
import '../datasources/news_remote_data_source.dart';
import '../models/article_model.dart';

class NewsRepositoryImpl implements NewsRepository {
  final NewsRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;
  
  // Cache for offline search
  List<ArticleModel> _cachedArticles = [];

  NewsRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<Article>>> getTopHeadlines({
    String? category,
    String? query,
  }) async {
    final isConnected = await networkInfo.isConnected;
    
    if (isConnected) {
      try {
        final articles = await remoteDataSource.getTopHeadlines(
          category: category,
          query: query,
        );
        
        // Cache articles if no search query (full list)
        if (query == null || query.isEmpty) {
          _cachedArticles = articles;
        }
        
        return Right(articles);
      } on DioException catch (e) {
        return Left(ServerFailure(e.message ?? 'Server error'));
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      // Offline: perform local search if we have cached data
      if (_cachedArticles.isNotEmpty && query != null && query.isNotEmpty) {
        final filteredArticles = _cachedArticles.where((article) {
          final searchLower = query.toLowerCase();
          return article.title.toLowerCase().contains(searchLower) ||
              article.description.toLowerCase().contains(searchLower) ||
              article.author.toLowerCase().contains(searchLower);
        }).toList();
        
        return Right(filteredArticles);
      }
      
      // Return cached articles if available
      if (_cachedArticles.isNotEmpty) {
        return Right(_cachedArticles);
      }
      
      return const Left(NetworkFailure('No internet connection'));
    }
  }
}

