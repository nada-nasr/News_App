import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:news_app/model/SourceResponse.dart';
import 'package:news_app/repository/sources/dataSources/local/source_offline_data_source.dart';
import 'package:news_app/repository/sources/dataSources/remote/source_remote_data_source.dart';
import 'package:news_app/repository/sources/repository/source_repository.dart';

class SourceRepositoryImpl implements SourceRepository {
  SourceRemoteDataSource remoteDataSource;
  SourceOfflineDataSource offlineDataSource;

  SourceRepositoryImpl(
      {required this.remoteDataSource, required this.offlineDataSource});

  @override
  Future<SourceResponse?> getSources(
      {required String categoryId, required String language,}) async {
    final List<ConnectivityResult> connectivityResult = await (Connectivity()
        .checkConnectivity());
    if (connectivityResult.contains(ConnectivityResult.mobile) ||
        connectivityResult.contains(ConnectivityResult.wifi)) {
      //todo: internet => remote data source
      var sourceResponse = await remoteDataSource.getSources(
          categoryId: categoryId, language: language);
      //todo: save sources
      offlineDataSource.saveSources(sourceResponse, categoryId);
      return sourceResponse;
    }

    //todo: no internet => offline data source
    var sourceResponse = await offlineDataSource.getSources(
        categoryId: categoryId, language: language);
    return sourceResponse;
  }
}
