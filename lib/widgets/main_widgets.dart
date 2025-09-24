import 'package:appikorn_madix_widgets/box_appi/box_appi.dart';
import 'package:appikorn_madix_widgets/text_appi/text_appi.dart';
import 'package:appikorn_software/core/common_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mix/mix.dart';

import '../provider/login_provider.dart';
import '../provider/uploaded_items_provider.dart';

class CardRow extends ConsumerStatefulWidget {
  final String searchQuery;

  const CardRow({super.key, required this.searchQuery});

  @override
  ConsumerState createState() => _CardRowState();
}

class _CardRowState extends ConsumerState<CardRow> {
  String? hoveredText;
  int startIndex = 0;

  void updateHoveredText(String? text) {
    setState(() {
      hoveredText = text;
    });
  }

  final List<Map<String, String>> allItems = [
    {
      "title": "Beema Insurance",
      "image": "assets/png/beema.png",
      "to": "https://github.com/ImmanSpark/Apk-Download/releases/download/v4.0.1/app-arm64-v8a-release.apk",
      "onHoverText":
          "Beema is a modern insurance web application designed to simplify policy management, claims, and renewals with an intuitive user experience."
    },
    {
      "title": "Kiosk",
      "image": "assets/png/Fresh & Honest.png",
      "onHoverText":
          "Fresh & Honest has the MI series coffee machine platform designed for premium coffee dispensing with efficient KIOSK vending app solution and software support"
    },
    {
      "title": "Wildbean",
      "image": "assets/png/wildbean.png",
      "onHoverText":
          "Wild-Bean is an MI-2 coffee machine platform designed for smooth operation, beverage customization, and easy service management."
    },
    {
      "title": "Bestea",
      "image": "assets/png/Bestea.png",
      "onHoverText":
          "BesTea is a refreshing tea brand website built to highlight unique blends, simplify ordering, and engage customers digitally."
    },
    {
      "title": "Lavazza",
      "image": "assets/png/Lavazza.png",
      "onHoverText":
          "We provide an IoT kit with a touchscreen interface for Lavazza black-and-white coffee machines, enabling smart control and real-time monitoring.."
    },
  ];

  int getVisibleCardCount(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    if (width >= 1200) return 5;
    if (width >= 800) return 3;
    return 1;
  }

  void _next(int visibleCount, int totalItems) {
    if (startIndex + visibleCount < totalItems) {
      setState(() {
        startIndex++;
        if (MediaQuery.of(context).size.width < 600) {
          hoveredText = null; // reset text on mobile
        }
      });
    }
  }

  void _prev() {
    if (startIndex > 0) {
      setState(() {
        startIndex--;
        if (MediaQuery.of(context).size.width < 600) {
          hoveredText = null; // reset text on mobile
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final uploadedItems = ref.watch(uploadedItemsProvider);
    final organizationName = ref.read(organisationNameProvider); // 👈 get from provider

    // Merge hardcoded and uploaded items
    final combinedItems = [
      ...allItems,
      ...uploadedItems.map((item) => <String, String?>{
            "title": item.title,
            "image": item.imageFileName,
            "to": item.apkLink,
            "onHoverText": item.description,
          }),
    ];

    // Filter based on organization and search query
    final filteredItems = combinedItems.where((item) {
      final title = (item["title"] ?? "").toLowerCase();
      final org = organizationName.toLowerCase();

      bool matchesOrg = false;
      if (org == "schopiq(admin)" || org == "appikorn") {
        matchesOrg = true;
      } else if (org == "fresh&honest") {
        matchesOrg = ["kiosk", "wildbean", "lavazza"].contains(title);
      } else if (org == "anoud") {
        matchesOrg = title == "beema insurance";
      }

      final matchesSearch = title.contains(widget.searchQuery.toLowerCase());

      // Return true if search matches, regardless of org
      return matchesSearch; // <-- remove '&& matchesOrg' to allow search globally
    }).toList();

    final visibleCount = getVisibleCardCount(context);
    final visibleItems = filteredItems.skip(startIndex).take(visibleCount).toList();

    return Expanded(
      child: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
        child: SingleChildScrollView(
          child: SizedBox(
            width: double.infinity,
            child: BoxAppi(
              fillColor: Colors.transparent,
              // image: ref.watch(organisationNameProvider) == "Appikorn"
              //     ? "assets/jpg/purple55.jpg"
              //     : "assets/jpg/schopiq11.jpg",
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: Column(
                  children: [
                    if (filteredItems.isEmpty)
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: SizedBox(
                          height: 255,
                          child: Center(
                            child: TextAppi(
                              text: "No Card found",
                              textStyle: Style(
                                $text.fontSize(mediaQuery(context, 600) ? 14 : 18),
                                $text.fontWeight(FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      )
                    else
                      Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: mediaQuery(context, 600) ? 0 : 20),
                            child: Row(
                              spacing: 10,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Tooltip(
                                  message: "Go to Prev Card",
                                  child: IconButton(
                                    icon: const Icon(Icons.arrow_left, size: 40),
                                    onPressed: _prev,
                                  ),
                                ),
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: visibleItems.map((item) {
                                      return AllCard(
                                        image: item["image"]!,
                                        title: item["title"]!,
                                        to: item["to"],
                                        hoverDescription: item["onHoverText"],
                                        onHoverText: updateHoveredText,
                                      );
                                    }).toList(),
                                  ),
                                ),
                                Tooltip(
                                  message: "Go to Next Card",
                                  child: IconButton(
                                    icon: const Icon(Icons.arrow_right, size: 40),
                                    onPressed: () => _next(visibleCount, filteredItems.length),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    const SizedBox(height: 20),
                    ShowContainer(text: hoveredText),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ShowContainer extends ConsumerWidget {
  final String? text;

  const ShowContainer({super.key, this.text});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: SizedBox(
          height: mediaQuery(context, 600) ? 150 : 250,
          width: mediaQuery(context, 600) ? 450 : 700,
          child: BoxAppi(
            shadowColor: Colors.black.withOpacity(0.3),
            shadowBlur: 6,
            shadowOffset: Offset(4, 4),
            fillColor: ref.watch(organisationNameProvider) == "Appikorn" ? Color(0xffc888f3) : Color(0xff51e0e6),
            radius: 30,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: BoxAppi(
                radius: 30,
                border: Border.all(color: Colors.grey.shade200),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextAppi(
                      text: text ??
                          (mediaQuery(context, 600) ? "Click a card to see details" : "Hover a card to see details"),
                      textStyle: Style($text.fontSize(16), $text.textAlign(TextAlign.center)),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AllCard extends ConsumerStatefulWidget {
  final String image;
  final String title;
  final String? to;
  final String? hoverDescription;
  final Function(String?)? onHoverText;

  const AllCard({
    super.key,
    required this.image,
    required this.title,
    this.to,
    this.onHoverText,
    this.hoverDescription,
  });

  @override
  ConsumerState<AllCard> createState() => _AllCardState();
}

class _AllCardState extends ConsumerState<AllCard> {
  bool isHovering = false;
  bool isButtonHovering = false;


  @override
  Widget build(BuildContext context) {
    bool isMobile = MediaQuery.of(context).size.width < 600;
    final organisationName = ref.watch(organisationNameProvider);

    return MouseRegion(
      onEnter: (_) {
        setState(() => isHovering = true);
        widget.onHoverText?.call(widget.hoverDescription);
      },
      onExit: (_) {
        setState(() => isHovering = false);
        widget.onHoverText?.call(null);
      },
      child: BoxAppi(
        radius: 20,
        shadowColor: isHovering
            ? (organisationName == "Appikorn" ? const Color(0xff9e6bc0) : const Color(0xff3faeb3))
            : Colors.transparent,
        shadowOffset: isHovering ? const Offset(4, 6) : Offset.zero,
        shadowBlur: isHovering ? 2 : 0,
        border: Border.all(color: Colors.grey.shade300),
        child: MouseRegion(
          onEnter: (_) {
            if (!isMobile) {
              setState(() => isHovering = true);
              widget.onHoverText?.call(widget.hoverDescription);
            }
          },
          onExit: (_) {
            if (!isMobile) {
              setState(() => isHovering = false);
              widget.onHoverText?.call(null);
            }
          },
          child: GestureDetector(
            onTap: (){
              // Update ShowContainer on mobile
              if (isMobile) {
                widget.onHoverText?.call(widget.hoverDescription);
              }
            },
            child: SizedBox(
              width: mediaQuery(context, 600) ? 140 : 200,
              height: mediaQuery(context, 600) ? 205 : 282,
              child: BoxAppi(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    spacing: 10,
                    children: [
                      BoxAppi(
                        child: widget.image.startsWith("assets/")
                            ? Image.asset(
                                widget.image,
                                height: mediaQuery(context, 600) ? 100 : 160,
                                width: mediaQuery(context, 600) ? 100 : 170,
                                fit: BoxFit.cover,
                              )
                            : Image.network(
                                widget.image,
                                height: mediaQuery(context, 600) ? 100 : 170,
                                width: mediaQuery(context, 600) ? 100 : 170,
                                fit: BoxFit.cover,
                              ),
                      ),
                      Center(
                        child: TextAppi(
                          text: widget.title,
                          textStyle: Style(
                            $text.fontSize(mediaQuery(context, 600) ? 16 : 20),
                            $text.fontWeight(FontWeight.bold),
                            $text.textAlign(TextAlign.center),
                            $text.maxLines(1),
                            $text.color(Colors.black),
                          ),
                        ),
                      ),
                      Center(
                        child: MouseRegion(
                          onEnter: (_) => setState(() => isButtonHovering = true),
                          onExit: (_) => setState(() => isButtonHovering = false),
                          child: GestureDetector(
                            onTap: () {
                              if ((widget.to ?? '').isNotEmpty) {
                                openUrl(widget.to!);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("No download available for this app")),
                                );
                              }
                            },
                            child: SizedBox(
                              width: mediaQuery(context, 600) ? 85 : 120,
                              child: BoxAppi(
                                fillColor: organisationName == "Appikorn"
                                    ? (isButtonHovering ? Color(0xff9e6bc0) : Color(0xffc888f3))
                                    : (isButtonHovering ? Color(0xff3faeb3) : Color(0xff51e0e6)),
                                height: mediaQuery(context, 600) ? 30 : 40,
                                radius: 22,
                                child: Center(
                                  child: TextAppi(
                                    text: "Download",
                                    textStyle: Style(
                                      $text.color(isButtonHovering ? Colors.white : Colors.black),
                                      $text.fontSize(mediaQuery(context, 600) ? 13 : 15),
                                      $text.fontWeight(FontWeight.w600),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
