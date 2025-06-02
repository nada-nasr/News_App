import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/model/SourceResponse.dart';
import 'package:news_app/repository/sources/repository/source_repository.dart';
import 'package:news_app/ui/home/category_details/cubit/source_states.dart';
import 'package:translator/translator.dart';

class SourceViewModel extends Cubit<SourceStates> {
  SourceRepository sourceRepository;

  SourceViewModel({required this.sourceRepository})
    : super(SourceLoadingState()); // Constructor Injection
  /*late SourceRepository sourceRepository;
  late SourceRemoteDataSource remoteDataSource;
  late ApiManager apiManager;
  
  SourceViewModel() : super(SourceLoadingState()){
    apiManager = ApiManager();
    remoteDataSource = SourceRemoteDataSourceImpl(apiManager: apiManager);
    sourceRepository = SourceRepositoryImpl(
        remoteDataSource: remoteDataSource);
  }*/ // Initial state
  //todo: hold data, handle logic
  final googleTranslator = GoogleTranslator();

  //List<Source>? sourcesList;
  //String? errorMessage;

  void getSources(String categoryId, String language) async {
    try {
      //todo: loading
      emit(SourceLoadingState());
      var response = await sourceRepository.getSources(
        categoryId: categoryId,
        language: language,
      );
      if (response?.status == 'error') {
        //todo: error
        emit(SourceErrorState(errorMessage: response!.message!));
        return;
      }
      if (response?.status == 'ok') {
        List<Source> translatedSources = [];
        for (var source in response!.sources!) {
          final translatedName = await translateText(
            source.name ?? '',
            language,
          );
          final translatedDescription = await translateText(
            source.description ?? '',
            language,
          );
          translatedSources.add(
            source.copyWith(
              name: translatedName,
              description: translatedDescription,
            ),
          );
        }
        //todo: success
        emit(SourceSuccessState(sourcesList: translatedSources));
        return;
      }
    } catch (e) {
      emit(SourceErrorState(errorMessage: e.toString()));
    }
  }

  Future<String> translateText(String text, String targetLanguage) async {
    try {
      if (text.isEmpty) {
        return '';
      }
      final translation = await googleTranslator.translate(
        text,
        to: targetLanguage,
      );
      return translation.text;
    } catch (e) {
      e.toString();
      return text;
    }
  }
}
