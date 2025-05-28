import 'package:news_app/model/SourceResponse.dart';

abstract class SourceStates {} //todo: parent class

class SourceLoadingState extends SourceStates {}

class SourceErrorState extends SourceStates {
  String errorMessage;

  SourceErrorState({required this.errorMessage});
}

class SourceSuccessState extends SourceStates {
  List<Source> sourcesList;

  SourceSuccessState({required this.sourcesList});
}
