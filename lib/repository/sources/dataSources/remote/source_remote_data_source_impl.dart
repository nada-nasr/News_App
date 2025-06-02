import 'package:news_app/api/api_manager.dart';
import 'package:news_app/model/SourceResponse.dart';
import 'package:news_app/repository/sources/dataSources/remote/source_remote_data_source.dart';

class SourceRemoteDataSourceImpl implements SourceRemoteDataSource {
  ApiManager apiManager;

  SourceRemoteDataSourceImpl({required this.apiManager});

  @override
  Future<SourceResponse?> getSources({
    required String categoryId,
    required String language,
  }) async {
    //todo: http
    var response = await apiManager.getSources(
      categoryId: categoryId,
      language: language,
    );
    return response;
  }
}
