//todo: viewModel => object Repository
//todo: Repository => object RemoteDataSource
//todo: RemoteDataSource => object ApiManager

import 'package:news_app/api/api_manager.dart';
import 'package:news_app/repository/news/dataSources/remote/news_remote_data_source.dart';
import 'package:news_app/repository/news/dataSources/remote/news_remote_data_source_impl.dart';
import 'package:news_app/repository/news/repository/news_repository_impl.dart';
import 'package:news_app/repository/sources/dataSources/local/source_offline_data_source.dart';
import 'package:news_app/repository/sources/dataSources/local/source_offline_data_source_impl.dart';
import 'package:news_app/repository/sources/dataSources/remote/source_remote_data_source.dart';
import 'package:news_app/repository/sources/dataSources/remote/source_remote_data_source_impl.dart';
import 'package:news_app/repository/sources/repository/source_repository.dart';
import 'package:news_app/repository/sources/repository/source_repository_impl.dart';

import '../repository/news/repository/news_repository.dart';

//Source
SourceRepository injectSourceRepository() {
  return SourceRepositoryImpl(
      remoteDataSource: injectSourceRemoteDataSource(),
      offlineDataSource: injectSourceOfflineDataSource());
}

SourceRemoteDataSource injectSourceRemoteDataSource() {
  return SourceRemoteDataSourceImpl(apiManager: injectApiManager());
}

SourceOfflineDataSource injectSourceOfflineDataSource() {
  return SourceOfflineDataSourceImpl();
}


ApiManager injectApiManager() {
  return ApiManager();
}

//News
NewsRepository injectNewsRepository() {
  return NewsRepositoryImpl(remoteDataSource: injectNewsRemoteDataSource());
}

NewsRemoteDataSource injectNewsRemoteDataSource() {
  return NewsRemoteDataSourceImpl(apiManager: injectApiManager());
}
