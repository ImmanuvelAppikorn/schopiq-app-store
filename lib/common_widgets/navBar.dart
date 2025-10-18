import 'package:appikorn_madix_widgets/box_appi/box_appi.dart';
import 'package:appikorn_madix_widgets/text_appi/text_appi.dart';
import 'package:appikorn_software/core/common_functions.dart';
import 'package:appikorn_software/provider/login_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mix/mix.dart';
// import 'dart:html';

class Navbar extends ConsumerStatefulWidget {
  final ValueChanged<String>? onSearchChanged;

  const Navbar({super.key, this.onSearchChanged});

  @override
  ConsumerState createState() => _NavbarState();
}

class _NavbarState extends ConsumerState<Navbar> {
  bool isHovering = false;

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 660;
    return BoxAppi(
      // fillColor: Colors.grey,
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(22),
        bottomRight: Radius.circular(22),
      ),
      shadowColor: Colors.black26,
      shadowOffset: const Offset(0, 3),
      shadowBlur: 6,
      fillColor: Colors.white,
      height: 60,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Tooltip(
                    message: ref.watch(emailProvider) == "admin@appikorn"
                        ? "Appikorn Software Consultancy"
                        : "Schopiq Automation",
                    child: GestureDetector(
                      onTap: () {
                        context.go("/main");
                      },
                      child: ref.watch(emailProvider) == "admin@appikorn"
                          ? Image.asset("assets/png/appikorn-logo.png",
                              height: mediaQuery(context, 600) ? 30 : 50, width: mediaQuery(context, 600) ? 30 : 50)
                          : Image.asset("assets/png/schopiq_logo.png",
                              height: mediaQuery(context, 600) ? 30 : 50, width: mediaQuery(context, 600) ? 30 : 50),
                    )),

                SizedBox(
                  width: 3,
                ),
                // if (!mediaQuery(context, 670))
                TextAppi(
                  text: ref.watch(emailProvider) == "admin@appikorn" ? "Appikorn" : "Schopiq Automation",
                  textStyle: Style(
                    $text.style.fontSize(mediaQuery(context, 370)
                        ? 9
                        : mediaQuery(context, 400)
                            ? 12
                            : mediaQuery(context, 430)
                                ? 13
                                : mediaQuery(context, 500)
                                    ? 14
                                    : mediaQuery(context, 750)
                                        ? 17
                                        : 20),
                    $text.fontWeight(FontWeight.bold),
                  ),
                )
              ],
            )),

            // Center: Apps text or search for small screen
            // Expanded(
            //   child: Center(
            //     child: widget.onSearchChanged != null
            //         ? Tooltip(
            //       message: "Search",
            //       child: IconButton(
            //         icon: Icon(
            //           Icons.search,
            //           size: mediaQuery(context, 600) ? 18 : 26,
            //         ),
            //         onPressed: () {
            //           // Send toggle signal to MainScreen
            //           widget.onSearchChanged?.call("__toggle_search__");
            //         },
            //       ),
            //     )
            //         : TextAppi(
            //       text: "Apps",
            //       textStyle: Style(
            //         $text.fontSize(mediaQuery(context, 600) ? 17 : 20),
            //         $text.fontWeight(FontWeight.bold),
            //         $text.color(ref.watch(organisationNameProvider) == "Appikorn"
            //             ? Color(0xff9e6bc0)
            //             : Color(0xff3faeb3)),
            //       ),
            //     ),
            //   ),
            // ),

            Expanded(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              spacing: 10,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Search icon (all screen sizes)
                    if (widget.onSearchChanged != null)
                      Tooltip(
                        message: "Search",
                        child: IconButton(
                          icon: Icon(
                            Icons.search,
                            color: ref.watch(emailProvider) == "admin@appikorn" ? Color(0xff9263b2) : Color(0xff2dacab),
                            size: mediaQuery(context, 600) ? 18 : 26,
                          ),
                          onPressed: () {
                            widget.onSearchChanged?.call("__toggle_search__");
                          },
                        ),
                      ),

                    // Right side icons (Contact + Logout, only large screens)
                    if (!isSmallScreen)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Tooltip(
                            message: "Support Us",
                            child: IconButton(
                              onPressed: () => context.go("/contactus"),
                              icon: Icon(
                                Icons.support_agent,
                                color: ref.watch(emailProvider) == "admin@appikorn"
                                    ? Color(0xff9263b2)
                                    : Color(0xff2dacab),
                              ),
                            ),
                          ),
                          SizedBox(width: 6),
                          Tooltip(
                            message: "Logout",
                            child: IconButton(
                              onPressed: () {
                                // Reset providers
                                ref.read(emailProvider.notifier).update((_) => "");
                                ref.read(passwordProvider.notifier).update((_) => "");
                                context.go("/");
                              },
                              icon: Icon(
                                Icons.logout,
                                color: ref.watch(emailProvider) == "admin@appikorn"
                                    ? Color(0xff9263b2)
                                    : Color(0xff2dacab),
                              ),
                            ),
                          ),
                        ],
                      ),

                    // Small screen: menu button
                    if (isSmallScreen)
                      IconButton(
                        icon: Icon(
                          Icons.menu,
                          color: ref.watch(emailProvider) == "admin@appikorn" ? Color(0xff9263b2) : Color(0xff2dacab),
                        ),
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (_) => Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ListTile(
                                  leading: GestureDetector(
                                      onTap: () => context.go("/contactus"),
                                      child: Icon(
                                        Icons.support_agent,
                                        color: ref.watch(emailProvider) == "admin@appikorn"
                                            ? Color(0xff9263b2)
                                            : Color(0xff2dacab),
                                      )),
                                  title: Text(
                                    "Support",
                                  ),
                                  onTap: () => context.go("/contactus"),
                                ),
                                ListTile(
                                  leading: Icon(
                                    Icons.logout,
                                    color: ref.watch(emailProvider) == "admin@appikorn"
                                        ? Color(0xff9263b2)
                                        : Color(0xff2dacab),
                                  ),
                                  title: Text(
                                    "Logout",
                                  ),
                                  onTap: () => context.go("/"),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                  ],
                )
              ],
            )),
          ],
        ),
      ),
    );
  }
}

class SearchToggleWidget extends ConsumerStatefulWidget {
  final ValueChanged<String>? onSearchChanged;

  const SearchToggleWidget({super.key, this.onSearchChanged});

  @override
  ConsumerState<SearchToggleWidget> createState() => _SearchToggleWidgetState();
}

class _SearchToggleWidgetState extends ConsumerState<SearchToggleWidget> {
  bool _isSearchBoxVisible = false;

  void toggleSearchBox() {
    setState(() {
      _isSearchBoxVisible = !_isSearchBoxVisible;
      widget.onSearchChanged?.call("");
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isSearchBoxVisible
        ? searchBox(
            context,
            toggleSearchBox,
            widget.onSearchChanged,
          ) // pass toggle to search box
        : IconButton(
            icon: Icon(
              Icons.search,
              color: Color(0xff44dfe6),
            ),
            onPressed: toggleSearchBox,
          );
  }
}

Widget searchBox(
  BuildContext context,
  VoidCallback onClose,
  ValueChanged<String>? onSearchChanged,
) {
  final bool isSmall = MediaQuery.of(context).size.width < 1140;
  final bool isMobile = MediaQuery.of(context).size.width < 660;

  return Consumer(builder: (context, ref, child) {
    return BoxAppi(
      radius: 6,
      child: Padding(
        padding: EdgeInsets.all(10),
        child: SizedBox(
          width: 280,
          height: 40,
          child: BoxAppi(
            borderColor: Colors.black,
            radius: 6,
            child: TextField(
              onChanged: (val) {
                onSearchChanged?.call(val);
              },
              decoration: InputDecoration(
                hintText: 'Search for apps...',
                fillColor: Colors.white,
                prefixIcon: Padding(
                  padding: mediaQuery(context, 600) ? EdgeInsets.zero : EdgeInsets.only(right: 10, left: 15),
                  child: Icon(Icons.search,
                      color: ref.watch(emailProvider) == "admin@appikorn" ? Color(0xff9263b2) : Color(0xff2dacab)),
                ),
                suffixIcon: BoxAppi(
                  fillColor: ref.watch(emailProvider) == "admin@appikorn" ? Color(0xff9263b2) : Color(0xff2dacab),
                  child: IconButton(
                    icon: Icon(Icons.close, color: Colors.white),
                    onPressed: onClose, // closes the search box
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
              ),
              style: const TextStyle(fontSize: 14, color: Colors.black),
            ),
          ),
        ),
      ),
    );
  });
}
