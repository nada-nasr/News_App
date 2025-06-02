import 'package:news_app/model/SourceResponse.dart';
import 'package:news_app/repository/sources/dataSources/remote/source_remote_data_source.dart';
import 'package:news_app/repository/sources/repository/source_repository.dart';

class SourceRepositoryImpl implements SourceRepository {
  SourceRemoteDataSource remoteDataSource;

  SourceRepositoryImpl({required this.remoteDataSource});

  @override
  Future<SourceResponse?> getSources({
    required String categoryId,
    required String language,
  }) {
    return remoteDataSource.getSources(
      categoryId: categoryId,
      language: language,
    );
  }
}
