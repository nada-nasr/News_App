//todo: Interface => remote / online data sources

import 'package:news_app/model/SourceResponse.dart';

abstract class SourceRemoteDataSource {
  Future<SourceResponse?> getSources({
    required String categoryId,
    required String language,
  });
}
