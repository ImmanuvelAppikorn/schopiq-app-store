import 'package:appikorn_madix_widgets/text_appi/text_appi.dart';
import 'package:appikorn_software/provider/login_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:appikorn_software/common_widgets/navBar.dart';
import 'package:go_router/go_router.dart';
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
    // ✅ CHANGED: watch the login provider to get hydrated email/password
    final login = ref.watch(loginModelProvider); // ✅ CHANGED

    // ✅ CHANGED: optional redirect if no email found (not logged in)
    // if (login.email.isEmpty) {
    //   WidgetsBinding.instance.addPostFrameCallback((_) {
    //     context.go('/'); // redirect to login screen
    //   });
    //   return const SizedBox.shrink(); // temporary empty widget
    // }
    // Watch the provider here
    // final bgImage =
    //     ref.watch(emailProvider) == "admin@appikorn" ? "assets/jpg/purple55.jpg" : "assets/jpg/schopiq34.jpg";

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(color: Color(0xffF5F6FA)),
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
                      // padding: EdgeInsets.symmetric(vertical: mediaQuery(context, 600) ? 15 : 25, horizontal: 20),
                      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        spacing: 6,
                        children: [
                          SizedBox(
                            height: 4,
                          ),
                          TextAppi(
                            text: "All your software applications, in one place",
                            textStyle: Style(
                                $text.fontSize(mediaQuery(context, 600) ? 20 : 26),
                                $text.fontWeight(FontWeight.w600),
                                $text.textAlign(TextAlign.center),
                                $text.fontFamily("Axiforma")),
                          ),
                          SizedBox(
                            height: 1,
                          ),
                          TextAppi(
                            text: "Ready to explore, download, and boost your productivity.",
                            textStyle: Style(
                                $text.fontSize(mediaQuery(context, 600) ? 12 : 14),
                                $text.fontWeight(FontWeight.w400),
                                $text.textAlign(TextAlign.center),
                                $text.fontFamily("Axiforma")),
                          )
                        ],
                      )),
              // ✅ CHANGED: pass searchQuery as before, CardRow will filter using login.email automatically
              CardRow(key: ValueKey(searchQuery), searchQuery: searchQuery), // ✅ CHANGED
            ],
          ),
        ),
      ),
    );
  }
}
