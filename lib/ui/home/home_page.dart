import 'package:flutter/material.dart';

import '../../data/data_sources/news_remote_data_source.dart';
import '../../data/data_sources/todos_local_data_source.dart';
import '../../data/repository/news_repository.dart';
import '../../data/repository/todos_repository.dart';
import '../../ui/news/news_page.dart';
import '../../ui/todos/todos_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentTab = 0;
  // TODO: Preserve Scroll Position on tab change

  final pages = <Widget>[
    TodosPage(
      todosRepository: TodosRepository(
        localDataSource: TodosLocalDataSource(),
      ),
    ),
    NewsPage(
      newsRepository: NewsRepository(
        remoteDataSource: NewsRemoteDataSource(),
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: buildAppBar(textTheme),
      body: pages[currentTab],
      bottomNavigationBar: buildBottomNavigationBar(),
    );
  }

  AppBar buildAppBar(TextTheme textTheme) {
    return AppBar(
      centerTitle: true,
      title: Text(
        'The Morning App',
        style: textTheme.headline6!.copyWith(
          color: Colors.white,
          fontSize: 24,
        ),
      ),
    );
  }

  BottomNavigationBar buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: currentTab,
      onTap: (int index) {
        setState(() {
          currentTab = index;
        });
      },
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.today_outlined),
          label: 'Todos',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.article),
          label: 'News',
        ),
      ],
    );
  }
}
