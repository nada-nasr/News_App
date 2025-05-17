import 'package:flutter/material.dart';
import 'package:news_app/api/api_manager.dart';
import 'package:news_app/ui/home/category_details/source_tab_widget.dart';
import 'package:news_app/utils/app_styles.dart';
import 'package:provider/provider.dart';
import '../../../model/SourceResponse.dart';
import '../../../model/category.dart';
import '../../../utils/app_colors.dart';

class CategoryDetails extends StatefulWidget {
  static const String routeName = 'CategoryDetails';

  Category category;
  CategoryDetails({super.key, required this.category});

  @override
  State<CategoryDetails> createState() => _CategoryDetailsState();
}

class _CategoryDetailsState extends State<CategoryDetails> {

  @override
  Widget build(BuildContext context) {
    //viewModel.getSources(categoryId) => StatelessWidget
    return FutureBuilder<SourceResponse?>(
          future: ApiManager.getSources(widget.category.id),
          builder: (context, snapshot) {
            //todo:loading
            if(snapshot.connectionState == ConnectionState.waiting){
              return Center(
                child: CircularProgressIndicator(
                  color: AppColors.greyColor,
                ),
              );
            }
            //todo: error => client
            else if(snapshot.hasError){
              return Column(
                children: [
                  Text('Something Went Wrong',
                  style: AppStyles.medium20Black),
                  ElevatedButton(
                      onPressed: () {
                        setState(() {
                          ApiManager.getSources(widget.category.id);
                        });
                      },
                      child: Text('Try Again',
                          style: Theme.of(context).textTheme.headlineLarge))
                ],
              );
            }
            //todo: server => response (success, error)
            //todo: error => server
            if(snapshot.data?.status != 'ok'){
              return Column(
                children: [
                  Text(snapshot.data!.message!,
                      style: Theme.of(context).textTheme.headlineLarge),
                  ElevatedButton(
                      onPressed: () {
                        setState(() {
                          ApiManager.getSources(widget.category.id);
                        });
                      },
                      child: Text('Try again',
                        style: AppStyles.medium20Black,))
                ],
              );
            }
            //todo: server => success
            var sourcesList = snapshot.data?.sources ?? [];
            return SourceTabWidget(sourcesList: sourcesList);
          },);
  }
}
