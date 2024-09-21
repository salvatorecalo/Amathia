import 'package:amathia/src/screens/login_page/login_page.dart';
import 'package:flutter/material.dart';
import '../../costants/costants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './Model/onboard_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class OnBoard extends StatefulWidget {
  const OnBoard({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _OnBoardState createState() => _OnBoardState();
}

class _OnBoardState extends State<OnBoard> {
  int currentIndex = 0;
  late PageController _pageController;
  late List<OnboardModel> screens;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(); // Inizializzazione del PageController
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  _storeOnboardInfo() async {
    int isViewed = 0;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('onBoard', isViewed);
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;

    screens = <OnboardModel>[
      OnboardModel(
        img: "assets/santAndrea_onboard.png",
        text: localizations!.explore,
        desc: localizations.exploredesc,
        bg: isDarkTheme ? Colors.black : Colors.white, // Usa il colore del tema
        button: Colors.white,
      ),
      OnboardModel(
        img: 'assets/chiesa_lecce_onboard.png',
        text: localizations.visit,
        desc: localizations.visitdesc,
        bg: isDarkTheme ? const Color(0xFF4756DF) : Colors.white,
        button: Colors.white,
      ),
      OnboardModel(
        img: 'assets/pomodoro_onboard.png',
        text: localizations.discover,
        desc: localizations.discovertext,
        bg: isDarkTheme ? Colors.black : Colors.white,
        button: const Color(0xFF4756DF),
      ),
    ];

    return SafeArea(
      child: Scaffold(
        body: PageView.builder(
          itemCount: screens.length,
          controller: _pageController,
          onPageChanged: (int index) {
            setState(() {
              currentIndex = index;
            });
          },
          itemBuilder: (_, index) {
            return Stack(
              children: [
                Image.asset(
                  screens[index].img,
                  fit: BoxFit.fill,
                  width: double.infinity,
                  height: 500,
                  alignment: Alignment.center,
                ),
                SizedBox(
                  height: double.infinity,
                  child: FractionallySizedBox(
                    alignment: Alignment.bottomCenter,
                    heightFactor: 0.5,
                    widthFactor: 1,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                        color: isDarkTheme
                            ? Colors.black
                            : Colors.white, // Colore di sfondo
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 50.0),
                            child: Text(
                              screens[index].text,
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                          ),
                          SizedBox(
                            width: 300,
                            child: Text(
                              screens[index].desc,
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                          SizedBox(
                            height: 100.0,
                            child: ListView.builder(
                              itemCount: screens.length,
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 3.0, vertical: 10),
                                      width: currentIndex == index ? 30 : 12,
                                      height: 8,
                                      decoration: BoxDecoration(
                                        color: currentIndex == index
                                            ? blue
                                            : isDarkTheme
                                                ? white
                                                : black,
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 30.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    _storeOnboardInfo();
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const LoginPage()),
                                    );
                                  },
                                  child: Text(
                                    localizations.skip,
                                    style: TextStyle(
                                        color:
                                            isDarkTheme ? Colors.white : black),
                                  ),
                                ),
                                InkWell(
                                  onTap: () async {
                                    if (index == screens.length - 1) {
                                      await _storeOnboardInfo();
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const LoginPage()),
                                      );
                                    }
                                    _pageController.nextPage(
                                      duration:
                                          const Duration(milliseconds: 300),
                                      curve: Curves.ease,
                                    );
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 30.0, vertical: 10),
                                    decoration: BoxDecoration(
                                      color: blue, // Colore del pulsante
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          localizations.next,
                                          style: const TextStyle(
                                              fontSize: 16.0, color: white),
                                        ),
                                        const SizedBox(width: 15.0),
                                        const Icon(
                                          Icons.arrow_forward_sharp,
                                          color: white,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
