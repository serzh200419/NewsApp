import 'package:dartz/dartz.dart';

import '../../core/error/failures.dart';
import '../entities/article.dart';
import '../repositories/news_repository.dart';

class GetNews {
  final NewsRepository repository;

  GetNews(this.repository);

  Future<Either<Failure, List<Article>>> call({
    String? category,
    String? query,
  }) async {
    return await repository.getTopHeadlines(
      category: category,
      query: query,
    );
  }
}

