import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:news_app/ui/home/home_screen.dart';
import 'package:news_app/ui/home/news/news_item.dart';
import 'package:news_app/ui/widget/custom_text_field.dart';
import 'package:provider/provider.dart';

import '../api/api_manager.dart';
import '../model/NewsResponse.dart';
import '../providers/language_provider.dart';
import '../utils/app_colors.dart';

class SearchScreen extends StatefulWidget {
  static const String routeName = 'search_screen';

  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchController = TextEditingController();
  List<News> searchResults = [];
  ScrollController scrollController = ScrollController();
  bool isLoading = false;
  bool hasMore = true;
  int currentPage = 1;
  String currentQuery = '';

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() => scrollListener());
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: width * 0.04,
          vertical: height * 0.07,
        ),
        child: Column(
          children: [
            CustomTextField(
              borderColor: Theme.of(context).indicatorColor,
              hintText: AppLocalizations.of(context)!.search,
              hintStyle: Theme.of(context).textTheme.headlineMedium,
              prefixIcon: Icon(
                Icons.search,
                color: Theme.of(context).indicatorColor,
                size: 30,
              ),
              suffixIcon: InkWell(
                onTap: () {
                  searchController.clear();
                  setState(() {
                    searchResults = [];
                    currentQuery = ''; // Clear
                    isLoading = false;
                    hasMore = true;
                    currentPage = 1;
                  });
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => HomeScreen()),
                    (route) => false,
                  );
                },
                child: Icon(
                  Icons.close,
                  color: Theme.of(context).indicatorColor,
                  size: 25,
                ),
              ),
              controller: searchController,
              onChanged: (query) {
                currentQuery = query;
                fetchDataByPage(isLoadMore: false); // Start new search
              },
              onFieldSubmitted: (query) {
                currentQuery = query;
                fetchDataByPage(isLoadMore: false); // Start new search
              },
            ),
            SizedBox(height: height * 0.02),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () {
                  if (currentQuery.isNotEmpty) {
                    return fetchDataByPage(isLoadMore: false);
                  }
                  return Future.value();
                },
                child:
                    searchResults.isEmpty &&
                            currentQuery.isNotEmpty &&
                            !isLoading &&
                            !hasMore
                        ? Center(
                          child: Text(
                            AppLocalizations.of(context)!.no_results_found,
                            style: Theme.of(context).textTheme.labelMedium,
                          ),
                        )
                        : searchResults.isEmpty &&
                            currentQuery.isEmpty &&
                            !isLoading
                        ? Center(
                          child: Text(
                            AppLocalizations.of(
                              context,
                            )!.start_typing_to_search,
                            style: Theme.of(context).textTheme.labelMedium,
                          ),
                        )
                        : ListView.builder(
                          controller: scrollController,
                          padding: EdgeInsets.zero,
                          itemBuilder: (context, index) {
                            if (index < searchResults.length) {
                              return NewsItem(news: searchResults[index]);
                            } else {
                              return const Padding(
                                padding: EdgeInsets.symmetric(vertical: 16.0),
                                child: Center(
                                  child: CircularProgressIndicator(
                                    color: AppColors.greyColor,
                                  ),
                                ),
                              );
                            }
                          },
                          itemCount:
                              searchResults.length +
                              (hasMore || isLoading ? 1 : 0),
                        ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    scrollController.removeListener(() => scrollListener());
    scrollController.dispose();
    searchController.dispose();
    super.dispose();
  }

  scrollListener() {
    if (scrollController.position.pixels >=
            scrollController.position.maxScrollExtent &&
        searchResults.isNotEmpty &&
        hasMore &&
        !isLoading &&
        currentQuery.isNotEmpty) {
      fetchDataByPage(isLoadMore: true);
      print("Reached bottom, fetching more results.");
    }
  }

  fetchDataByPage({bool isLoadMore = false}) async {
    if (currentQuery.isEmpty) {
      setState(() {
        searchResults = [];
        hasMore = false;
        currentPage = 1;
      });
      return;
    }
    if (isLoading || !hasMore) {
      print(
        "fetchDataByPage skipped. isLoading: $isLoading, hasMore: $hasMore",
      );
      return;
    }

    setState(() {
      isLoading = true;
      if (!isLoadMore) {
        // Clear list
        searchResults.clear();
        currentPage = 1;
        hasMore = true;
      }
    });

    final languageCode =
        Provider.of<LanguageProvider>(context, listen: false).currentLocal;
    final int pageToFetch = isLoadMore ? currentPage : 1;

    try {
      final NewsResponse? results = await ApiManager.searchNews(
        query: currentQuery,
        language: languageCode,
        page: pageToFetch,
      );

      if (results != null &&
          results.articles != null &&
          results.articles!.isNotEmpty) {
        setState(() {
          searchResults.addAll(results.articles!);
          currentPage++;
          if (results.articles!.length < 20) {
            hasMore = false;
            print(" No more data.");
          }
        });
      } else {
        setState(() {
          hasMore = false;
          print("No articles returned from API.");
        });
      }
    } catch (e) {
      print("Error during search: $e");
      setState(() {
        hasMore = false;
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
}
