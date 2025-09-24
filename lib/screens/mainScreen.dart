import 'package:appikorn_software/provider/login_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:appikorn_software/common_widgets/navBar.dart';
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
        ref.watch(organisationNameProvider) == "Appikorn" ? "assets/jpg/purple55.jpg" : "assets/jpg/schopiq34.jpg";

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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Navbar(onSearchChanged: handleSearchChanged),

            // Search box below navbar only if visible
            isSearchBoxVisible
                ? Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
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
                : SizedBox(
                    height: 40,
                  ),

            CardRow(key: ValueKey(searchQuery), searchQuery: searchQuery),
          ],
        ),
      ),
    );
  }
}
