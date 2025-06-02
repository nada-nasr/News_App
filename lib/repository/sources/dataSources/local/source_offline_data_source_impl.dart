import 'package:hive/hive.dart';
import 'package:news_app/model/SourceResponse.dart';
import 'package:news_app/repository/sources/dataSources/local/source_offline_data_source.dart';

class SourceOfflineDataSourceImpl implements SourceOfflineDataSource {
  @override
  Future<SourceResponse?> getSources({
    required String categoryId,
    required String language,
  }) async {
    var box = await Hive.openBox('SourceTabs');

    ///var sourceTap = SourceResponse.fromJson(box.get(categoryId)); //todo: map => object
    var sourceTap = box.get(categoryId);
    return sourceTap;
  }

  @override
  void saveSources(SourceResponse? sourceResponse, String categoryId) async {
    var box = await Hive.openBox('SourceTabs');

    ///await box.put(categoryId, sourceResponse?.toJson()); //todo: object => map
    await box.put(categoryId, sourceResponse);
    await box.close();
  }
}
