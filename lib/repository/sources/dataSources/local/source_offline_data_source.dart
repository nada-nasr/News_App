//todo: interface => local data source (offline)
import '../../../../model/SourceResponse.dart';

abstract class SourceOfflineDataSource {
  Future<SourceResponse?> getSources({
    required String categoryId,
    required String language,
  });

  // save data
  void saveSources(SourceResponse? sourceResponse, String categoryId);
}
