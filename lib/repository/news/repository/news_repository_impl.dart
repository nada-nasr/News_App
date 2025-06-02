import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:news_app/model/NewsResponse.dart';
import 'package:news_app/repository/news/dataSources/remote/news_remote_data_source.dart';

import '../dataSources/local/news_offline_data_source.dart';
import 'news_repository.dart';

class NewsRepositoryImpl implements NewsRepository {
  NewsRemoteDataSource remoteDataSource;
  NewsOfflineDataSource offlineDataSource;

  NewsRepositoryImpl(
      {required this.remoteDataSource, required this.offlineDataSource});

  @override
  Future<NewsResponse?> getNewsBySourceId({
    required String sourceId,
    required String language,
    required int pageSize,
    int page = 1,
  }) async {
    final List<ConnectivityResult> connectivityResult = await (Connectivity()
        .checkConnectivity());
    if (connectivityResult.contains(ConnectivityResult.mobile) ||
        connectivityResult.contains(ConnectivityResult.wifi)) {
      //todo: internet => remote data source
      var newsResponse = await remoteDataSource.getNewsBySourceId(
        sourceId: sourceId,
        language: language,
        page: page,
        pageSize: pageSize,
      );
      //todo: save sources
      offlineDataSource.saveSources(newsResponse, sourceId);
      return newsResponse;
    }

    //todo: no internet => offline data source
    var newsResponse = await offlineDataSource.getNewsBySourceId(
      sourceId: sourceId,
      language: language,
      page: page,
      pageSize: pageSize,
    );
    return newsResponse;

  }
}
