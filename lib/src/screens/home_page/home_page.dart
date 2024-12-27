import 'package:flutter/material.dart';
import 'package:amathia/src/screens/home_page/pages/account_page/account_page.dart';
import 'package:amathia/src/screens/home_page/pages/favorite_page/favorite_page.dart';
import 'package:amathia/src/screens/home_page/pages/itinerari_page/itinerari_page.dart';
import 'package:amathia/src/screens/home_page/pages/search_page/search_Page.dart';
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
    _loadCurrentPage(); // Load current page from SharedPreferences
  }

  Future<void> _loadCurrentPage() async {
    final prefs = await SharedPreferences.getInstance();
    final currentPageIndex = prefs.getInt('currentPageIndex') ?? 0; // Default page is 0
    setState(() {
      bottomSelectedIndex = currentPageIndex; // Update the selected page index
    });
    pageController.jumpToPage(currentPageIndex); // Navigate to the correct page
  }

  Future<void> _saveCurrentPage(int index) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('currentPageIndex', index); // Save the page index
  }

  void pageChanged(int index) {
    if (bottomSelectedIndex != index) {
      _saveCurrentPage(index); // Save the new page index
      setState(() {
        bottomSelectedIndex = index; // Update the selected page index
      });
    }
  }

  void bottomTapped(int index) {
    if (bottomSelectedIndex != index) {
      pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 500),
        curve: Curves.ease,
      );
      _saveCurrentPage(index); // Save the new page index
      setState(() {
        bottomSelectedIndex = index; // Update the selected page index
      });
    }
  }

  Widget buildPageView() {
    return PageView(
      physics: const NeverScrollableScrollPhysics(),
      controller: pageController,
      onPageChanged: pageChanged,
      children: <Widget>[
        SearchPage(userId: widget.userId),
        FavoritePage(userId: widget.userId),
        ItinerariesPage(userId: widget.userId), // Pass userId here to the itineraries page
        const AccountPage(), // AccountPage is now part of the PageView
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    List<BottomNavigationBarItem> buildBottomNavBarItems() {
      return [
        BottomNavigationBarItem(
          icon: const Icon(Icons.search),
          label: 'Esplora',
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.favorite),
          label: 'Preferiti',
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.map),
          label: 'Itinerari',
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.person),
          label: 'Account',
        ),
      ];
    }

    return Scaffold(
      body: buildPageView(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: bottomSelectedIndex, // Sync the BottomNavigationBar with the page index
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey, // Colore degli elementi non selezionati
        showUnselectedLabels: true,
        onTap: (index) {
          bottomTapped(index); // Handle tap on BottomNavigationBar
        },
        items: buildBottomNavBarItems(),
      ),
    );
  }
}
