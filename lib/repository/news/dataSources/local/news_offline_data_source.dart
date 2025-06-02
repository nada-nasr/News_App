//todo: interface => local data source
import '../../../../model/NewsResponse.dart';

abstract class NewsOfflineDataSource {
  Future<NewsResponse?> getNewsBySourceId({
    required String sourceId,
    required String language,
    required int pageSize,
    int page = 1,
  });

  // save data
  void saveSources(NewsResponse? newsResponse, String sourceId);
}
