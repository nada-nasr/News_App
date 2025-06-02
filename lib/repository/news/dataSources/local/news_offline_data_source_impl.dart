import 'package:hive/hive.dart';
import 'package:news_app/model/NewsResponse.dart';

import 'news_offline_data_source.dart';

class NewsOfflineDataSourceImpl implements NewsOfflineDataSource {
  @override
  Future<NewsResponse?> getNewsBySourceId({
    required String sourceId,
    required String language,
    required int pageSize,
    int page = 1,
  }) async {
    var box = await Hive.openBox('News');
    var news = NewsResponse.fromJson(box.get(sourceId)); //todo: map => object
    return news;
  }

  @override
  void saveSources(NewsResponse? newsResponse, String sourceId) async {
    var box = await Hive.openBox('News');
    await box.put(sourceId, newsResponse?.toJson()); //todo: object => map
    await box.close();
  }
}
