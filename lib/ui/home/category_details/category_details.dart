import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/ui/home/category_details/cubit/source_states.dart';
import 'package:news_app/ui/home/category_details/cubit/source_view_model.dart';
import 'package:provider/provider.dart';

import '../../../model/category.dart';
import '../../../providers/language_provider.dart';
import '../../../utils/app_colors.dart';
import '../category_details/source_tab_widget.dart';

class CategoryDetails extends StatefulWidget {
  static const String routeName = 'CategoryDetails';

  final Category category;

  const CategoryDetails({super.key, required this.category});

  @override
  State<CategoryDetails> createState() => _CategoryDetailsState();
}

class _CategoryDetailsState extends State<CategoryDetails> {
  SourceViewModel viewModel = SourceViewModel();

  @override
  void initState() {
    final languageProvider = Provider.of<LanguageProvider>(
        context, listen: false);
    final currentLanguage = languageProvider.currentLocal;
    // TODO: implement initState
    super.initState();
    viewModel.getSources(widget.category.id, currentLanguage);
  }

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    final currentLanguage = languageProvider.currentLocal;
    return BlocProvider<SourceViewModel>(
      create: (context) => viewModel,
      child: BlocBuilder<SourceViewModel, SourceStates>(
          builder: (context, state) {
            //todo:loading
            if (state is SourceLoadingState) {
              return Center(
                child: CircularProgressIndicator(
                  color: AppColors.greyColor,
                ),
              );
            }
            //todo: error => client
            else if (state is SourceErrorState) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.errorMessage,
                      style: Theme
                          .of(context)
                          .textTheme
                          .headlineMedium),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      viewModel.getSources(widget.category.id, currentLanguage);
                    },
                    child: Text('Try Again', style: Theme
                        .of(context)
                        .textTheme
                        .headlineLarge),
                  ),
                ],
              );
            }
            else if (state is SourceSuccessState) {
              return SourceTabWidget(sourcesList: state.sourcesList);
            }
            return Container(); // un reachable
          }
      ),
    );
  }
}