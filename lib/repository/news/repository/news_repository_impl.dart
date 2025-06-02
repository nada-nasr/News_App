import 'package:news_app/model/NewsResponse.dart';
import 'package:news_app/repository/news/dataSources/remote/news_remote_data_source.dart';

import 'news_repository.dart';

class NewsRepositoryImpl implements NewsRepository {
  NewsRemoteDataSource remoteDataSource;

  NewsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<NewsResponse?> getNewsBySourceId({
    required String sourceId,
    required String language,
    required int pageSize,
    int page = 1,
  }) {
    return remoteDataSource.getNewsBySourceId(
      sourceId: sourceId,
      language: language,
      page: page,
      pageSize: pageSize,
    );
  }
}
