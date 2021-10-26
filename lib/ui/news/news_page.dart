import 'package:flutter/material.dart';

import '../../data/repository/news_repository.dart';
import '../../models/news_model.dart';
import '../../utils/list_utils.dart';
import '../app_colors.dart';
import '../_shared/progress_widget.dart';
import 'news_item_widget.dart';

class NewsPage extends StatefulWidget {
  final NewsRepository newsRepository;
  const NewsPage({Key? key, required this.newsRepository}) : super(key: key);

  @override
  _NewsPageState createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  late List<NewsModel> news;
  bool isLoading = true;

  //TODO: Preserve News State on tab change

  void setNewsState(
    List<NewsModel> newNewsState, {
    bool shouldSavePageStorage = true,
  }) {
    if (mounted) {
      setState(() {
        news = newNewsState;
        isLoading = false;
      });
    }
  }

  Future<void> fetchNews() async {
    try {
      final fetchedNews = await widget.newsRepository.fetchTopNews();
      final shuffledNews = ListUtils.shuffle(fetchedNews) as List<NewsModel>;
      setNewsState(shuffledNews);
    } on Exception catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error while fetching the news!'),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    fetchNews();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondaryColor,
      body: isLoading ? const ProgressWidget() : buildNewsList(),
    );
  }

  ListView buildNewsList() {
    return ListView(
      children: news
          .map(
            (newsItem) => NewsItemWidget(
              newsItem: newsItem,
            ),
          )
          .toList(),
    );
  }
}
