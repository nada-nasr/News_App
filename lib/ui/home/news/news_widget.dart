import 'package:flutter/material.dart';
import 'package:news_app/api/api_manager.dart';
import 'package:news_app/model/NewsResponse.dart';
import 'package:news_app/model/SourceResponse.dart';
import 'package:news_app/ui/home/category_details/source_tab_widget.dart';
import 'package:news_app/ui/home/news/news_view_model.dart';
import 'package:provider/provider.dart';

import '../../../utils/app_colors.dart';
import '../../../utils/app_styles.dart';
import 'news_item.dart';

class NewsWidget extends StatefulWidget {
  Source source;
  NewsWidget({required this.source});

  @override
  State<NewsWidget> createState() => _NewsWidgetState();
}

class _NewsWidgetState extends State<NewsWidget> {

  NewsViewModel viewModel = NewsViewModel();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    viewModel.getNewsBySourceId(widget.source.id??'');
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => viewModel,
      child: Consumer<NewsViewModel>(
          builder: (context, value, child) {
            if(viewModel.errorMessage != null){
              return Column(
                children: [
                  Text(viewModel.errorMessage!,
                      style: Theme.of(context).textTheme.headlineMedium),
                  ElevatedButton(
                      onPressed: () {
                       viewModel.getNewsBySourceId(widget.source.id??'');

                      },
                      child: Text('Try Again',
                          style: AppStyles.medium20Black))
                ],
              );
            }
            else if(viewModel.newsList == null){
              //todo:loading
              return Center(
                child: CircularProgressIndicator(
                  color: AppColors.greyColor,
                ),
              );
            }
            else{
              //todo: success => data
              return ListView.builder(
                itemBuilder: (context, index) {
                  return NewsItem(
                    news: viewModel.newsList![index],
                  );
                },
                itemCount: viewModel.newsList!.length,
              );
            }
          },
      )
      /*FutureBuilder<NewsResponse?>(
        future: ApiManager.getNewsBySourceId(widget.source.id ?? ''),
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
                        ApiManager.getNewsBySourceId(widget.source.id??'');
                        setState(() {});

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
                        ApiManager.getNewsBySourceId(widget.source.id??'');
                        setState(() {});

                    },
                    child: Text('Try again',
                      style: AppStyles.medium20Black,))
              ],
            );
          }
          //todo: server => success
          var newsList = snapshot.data?.articles ?? [];
          return ListView.builder(
              itemBuilder: (context, index) {
                return NewsItem(
                  news: newsList[index],
                );
              },
            itemCount: newsList.length,
          );


        },
      ),*/
    );
  }
}

