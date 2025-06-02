//todo: interface => local data source
import '../../../../model/NewsResponse.dart';

abstract class NewsLocalDataSource {
  Future<NewsResponse?> getNewsBySourceId({
    required String sourceId,
    required String language,
    required int pageSize,
    int page = 1,
  });
}
