import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:news_app/utils/app_colors.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../model/NewsResponse.dart';
import '../../widget/custom_elevated_button.dart';
import 'article_web_view.dart';

class NewsItem extends StatelessWidget {
  News news;
   NewsItem({super.key, required this.news});
  final fifteenAgo = DateTime.now().subtract(Duration(minutes: 15));

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return InkWell(
      child: Container(
        margin:EdgeInsets.symmetric(
          horizontal: width*0.02,
          vertical: height*0.01
        ),
        padding:EdgeInsets.symmetric(
            horizontal: width*0.02,
            vertical: height*0.01
        ) ,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Theme.of(context).indicatorColor,
            width: 2
          )
        ),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CachedNetworkImage(
                imageUrl: news.urlToImage ?? '',
                placeholder: (context, url) => CircularProgressIndicator(
                  color: AppColors.greyColor,
                ),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
            ),
            SizedBox(height: height*0.02),
            Text(news.title??'',
            style: Theme.of(context).textTheme.labelLarge),
            SizedBox(height: height*0.02),
            Row(
              children: [
                Expanded(
                  child: Text('By: ${news.author??''}',
                      style: Theme.of(context).textTheme.labelSmall),
                ),
                Text(timeago.format(fifteenAgo),
                    style: Theme.of(context).textTheme.labelSmall
                )
                /*Text('15 minutes ago',
                    style: Theme.of(context).textTheme.labelSmall),*/
              ])

          ],
        ),
      ),
      onTap: () {
        showModalBottomSheet(
          backgroundColor: Theme.of(context).indicatorColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            context: context,
            builder: (context) {
              return Container(
                ////height: height*0.49,
                /*margin:EdgeInsets.symmetric(
                    horizontal: width*0.02,
                    vertical: height*0.01
                ),*/
                padding:EdgeInsets.symmetric(
                    horizontal: width*0.02,
                    vertical: height*0.01
                ) ,
                decoration: BoxDecoration(
                  color: Theme.of(context).indicatorColor,
                    borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: CachedNetworkImage(
                        imageUrl: news.urlToImage ?? '',
                        placeholder: (context, url) => CircularProgressIndicator(
                          color: AppColors.greyColor,
                        ),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                    ),
                    SizedBox(height: height*0.02),
                    Text(news.content??'',
                        style: Theme.of(context).textTheme.displaySmall),
                    Spacer(),
                    CustomElevatedButton(
                      text: "View Full Articel",
                      onButtonClick: () => displayNews(context, news)
                    ),
                    SizedBox(height: height*0.03),

                  ],
                ),
              );

            });
      },
    );
  }

  void displayNews(BuildContext context, News currentNews) {
    if (currentNews.url != null && currentNews.url!.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ArticleWebView(articleUrl: currentNews.url!),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No URL available for this article.')),
      );
    }
  }
}
