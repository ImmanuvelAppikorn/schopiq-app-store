import 'package:appikorn_madix_widgets/text_appi/text_appi.dart';
import 'package:appikorn_software/provider/login_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:appikorn_software/common_widgets/navBar.dart';
import 'package:mix/mix.dart';
import '../core/common_functions.dart';
import '../widgets/main_widgets.dart';

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  String searchQuery = "";
  bool isSearchBoxVisible = false;


  void updateSearch(String query) {
    setState(() {
      searchQuery = query.toLowerCase();
    });
  }

  void handleSearchChanged(String query) {
    if (query == "__toggle_search__") {
      setState(() {
        isSearchBoxVisible = !isSearchBoxVisible;
        if (!isSearchBoxVisible) searchQuery = "";
      });
    } else {
      setState(() {
        searchQuery = query.toLowerCase();
      });
    }
  }

  void toggleSearchBox() {
    setState(() {
      isSearchBoxVisible = !isSearchBoxVisible;
      if (!isSearchBoxVisible) {
        updateSearch("");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Watch the provider here
    final bgImage =
        ref.watch(emailProvider) == "admin@appikorn" ? "assets/jpg/purple55.jpg" : "assets/jpg/schopiq34.jpg";

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(bgImage),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Navbar(onSearchChanged: handleSearchChanged),

              // Search box below navbar only if visible
              isSearchBoxVisible
                  ? Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: searchBox(
                        context,
                        () {
                          setState(() {
                            isSearchBoxVisible = false;
                            searchQuery = "";
                          });
                        },
                        handleSearchChanged,
                      ),
                    )
                  : Padding(
                      padding: EdgeInsets.symmetric(vertical: mediaQuery(context, 600)? 15 : 25, horizontal: 20),
                      child:      mediaQuery(context, 700) ?  Column(
                        spacing: 6,
                        children: [

                          TextAppi(
                            text:
                                "All your software applications, in one place",
                            textStyle: Style(
                              $text.fontSize(mediaQuery(context, 600) ? 16 : 18),
                              $text.fontWeight(FontWeight.w600),
                              $text.textAlign(TextAlign.center),
                            ),
                          ),
                          TextAppi(
                            text:
                            "Ready to explore, download, and boost your productivity.",
                            textStyle: Style(
                              $text.fontSize(mediaQuery(context, 600) ? 14 : 16),
                              $text.fontWeight(FontWeight.w400),
                              $text.textAlign(TextAlign.center),
                            ),
                          )
                        ],
                      ) : TextAppi(
                        text:
                        "All your software applications, in one place - Ready to explore, download, and boost your productivity.",
                        textStyle: Style(
                          $text.fontSize(mediaQuery(context, 600) ? 12 : 14),
                          $text.fontWeight(FontWeight.w600),
                          $text.textAlign(TextAlign.center),
                        ),
                      )
                    ),

              CardRow(key: ValueKey(searchQuery), searchQuery: searchQuery),
              if (mediaQuery(context, 700))
                SizedBox(
                  height: 60,
                )
            ],
          ),
        ),
      ),
    );
  }
}
