import 'package:news_app/api/api_manager.dart';
import 'package:news_app/model/NewsResponse.dart';
import 'package:news_app/repository/news/dataSources/remote/news_remote_data_source.dart';

class NewsRemoteDataSourceImpl implements NewsRemoteDataSource {
  ApiManager apiManager;

  NewsRemoteDataSourceImpl({required this.apiManager});

  @override
  Future<NewsResponse?> getNewsBySourceId({
    required String sourceId,
    required String language,
    required int pageSize,
    int page = 1,
  }) async {
    var response = await apiManager.getNewsBySourceId(
      sourceId: sourceId,
      language: language,
      pageSize: pageSize,
    );
    return response;
  }
}
