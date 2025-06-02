//todo: Interface => Repository

import '../../../model/SourceResponse.dart';

abstract class SourceRepository {
  Future<SourceResponse?> getSources({
    required String categoryId,
    required String language,
  });
}
