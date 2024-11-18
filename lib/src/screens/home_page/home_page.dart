import 'package:amathia/src/costants/costants.dart';
import 'package:amathia/src/screens/home_page/pages/account_page/account_page.dart';
import 'package:amathia/src/screens/home_page/pages/favorite_page/favorite_page.dart';
import 'package:amathia/src/screens/home_page/pages/search_page/search_Page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  final String userId;

  const HomePage({super.key, required this.userId});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int bottomSelectedIndex = 0; // Default index
  late PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: bottomSelectedIndex);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isFirstLoad) {
      _loadCurrentPage();
      _isFirstLoad = false;
    }
  }

  bool _isFirstLoad = true;

  Future<void> _loadCurrentPage() async {
    final prefs = await SharedPreferences.getInstance();
    final currentPageIndex =
        prefs.getInt('currentPageIndex') ?? 0; // Default page is 0

    if (bottomSelectedIndex != currentPageIndex) {
      setState(() {
        bottomSelectedIndex = currentPageIndex; // Update state
      });
      pageController
          .jumpToPage(currentPageIndex); // Navigate to the correct page
    }
  }

  Future<void> _saveCurrentPage(int index) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('currentPageIndex', index); // Save the page index
  }

  Widget buildPageView() {
    return PageView(
      physics: const NeverScrollableScrollPhysics(),
      controller: pageController,
      onPageChanged: (index) {
        pageChanged(index);
      },
      children: <Widget>[
        SearchPage(userId: widget.userId),
        FavoritePage(userId: widget.userId),
        const AccountPage(),
      ],
    );
  }

  void pageChanged(int index) {
    // Salva la pagina solo se l'indice cambia
    if (bottomSelectedIndex != index) {
      _saveCurrentPage(index);
      setState(() {
        bottomSelectedIndex = index;
      });
    }
  }

  void bottomTapped(int index) {
    // Evita di fare il salto a pagina se già selezionata
    if (bottomSelectedIndex != index) {
      pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 500),
        curve: Curves.ease,
      );
      _saveCurrentPage(index);
      setState(() {
        bottomSelectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    List<BottomNavigationBarItem> buildBottomNavBarItems() {
      return [
        BottomNavigationBarItem(
          icon: const Icon(Icons.search),
          label: localizations!.explore,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.favorite),
          label: localizations.favorite,
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Account',
        ),
      ];
    }

    return Scaffold(
      body: buildPageView(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: bottomSelectedIndex,
        selectedItemColor: blue,
        onTap: (index) {
          bottomTapped(index);
        },
        items: buildBottomNavBarItems(),
      ),
    );
  }
}
