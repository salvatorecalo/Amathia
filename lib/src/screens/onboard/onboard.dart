import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../costants/costants.dart';
import './Model/onboard_model.dart';
import 'package:amathia/src/screens/login_page/login_page.dart';

class OnBoard extends StatefulWidget {
  final Future<void> Function() onComplete;

  const OnBoard({super.key, required this.onComplete});

  @override
  _OnBoardState createState() => _OnBoardState();
}

class _OnBoardState extends State<OnBoard> {
  int currentIndex = 0;
  late PageController _pageController;
  late List<OnboardModel> screens;
  bool _isCompleting = false;
  Future<void> completeOnBoarding(bool isCompleting) async {
    if (_isCompleting) return;
    _isCompleting = true;
    await widget.onComplete();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }
  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;

    screens = <OnboardModel>[
      OnboardModel(
        img: "assets/santAndrea_onboard.webp",
        text: localizations!.explore,
        desc: localizations.exploredesc,
        bg: isDarkTheme ? Colors.black : Colors.white,
        button: Colors.white,
      ),
      OnboardModel(
        img: 'assets/chiesa_lecce_onboard.webp',
        text: localizations.visit,
        desc: localizations.visitdesc,
        bg: isDarkTheme ? const Color(0xFF4756DF) : Colors.white,
        button: Colors.white,
      ),
      OnboardModel(
        img: 'assets/pomodoro_onboard.webp',
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
                // Immagine di sfondo
                Image.asset(
                  screens[index].img,
                  fit: BoxFit.fill,
                  width: double.infinity,
                  height: 500,
                  alignment: Alignment.center,
                ),
                // Contenuto
                SizedBox(
                  height: double.infinity,
                  child: FractionallySizedBox(
                    alignment: Alignment.bottomCenter,
                    heightFactor: 0.5,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                        color: isDarkTheme ? Colors.black : Colors.white,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 30.0),
                            child: Text(
                              screens[index].text,
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall // Titolo più grande
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
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
                          const SizedBox(height: 100,), // Spazio flessibile
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              // Bottone "Skip"
                              TextButton(
                                onPressed: () async {
                                  await completeOnBoarding;
                                },
                                child: Text(
                                  localizations.skip,
                                  style: TextStyle(
                                    color: isDarkTheme ? Colors.white : black,
                                  ),
                                ),
                              ),
                              // Bottone "Next" o "Done"
                              InkWell(
                                onTap: () async {
                                  if (index == screens.length - 1) {
                                    await completeOnBoarding;
                                  } else {
                                    _pageController.nextPage(
                                      duration:
                                          const Duration(milliseconds: 300),
                                      curve: Curves.ease,
                                    );
                                  }
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 30.0,
                                    vertical: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    color: blue,
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        index == screens.length - 1
                                            ? localizations.done
                                            : localizations.next,
                                        style: const TextStyle(
                                          fontSize: 16.0,
                                          color: white,
                                        ),
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
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
