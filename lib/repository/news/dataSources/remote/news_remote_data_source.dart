//todo: interface => remote data source
import '../../../../model/NewsResponse.dart';

abstract class NewsRemoteDataSource {
  Future<NewsResponse?> getNewsBySourceId({
    required String sourceId,
    required String language,
    required int pageSize,
    int page = 1,
  });
}
