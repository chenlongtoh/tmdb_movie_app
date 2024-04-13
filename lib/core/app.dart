import 'package:flutter/material.dart';
import 'package:movie_app/core/view/screens/home_page.dart';
import 'package:movie_app/core/view/screens/search_page.dart';

const List<Widget> _kScreens = [HomePage(), SearchPage()];

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  int _index = 0;

  @override
  void initState() {
    super.initState();
  }

  void _onTap(int index) => setState(() => _index = index);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _index,
        children: _kScreens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: _onTap,
        currentIndex: _index,
        type: BottomNavigationBarType.fixed,
        enableFeedback: true,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: "Search",
          ),
        ],
      ),
    );
  }
}
