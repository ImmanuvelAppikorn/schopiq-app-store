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
  Map<String, dynamic>? selectedItem;
  int startIndex = 0;

  void updateSelectedItem(Map<String, dynamic> item) {
    setState(() {
      selectedItem = item;
    });
  }

  final List<Map<String, dynamic>> allItems = [
    {
      "title": "Beema Insurance",
      "image": "assets/png/beema.png",
      "description":
          "Beema is a modern insurance web application designed to simplify policy management, claims, and renewals with an intuitive user experience."
    },
    {
      "title": "MI3",
      "image": "assets/png/Fresh & Honest.png",
      "description":
          "Fresh & Honest MI3 coffee machine platform designed for premium coffee dispensing with efficient KIOSK vending app solution and software support."
    },
    {
      "title": "Wildbean",
      "image": "assets/png/wildbean.png",
      "description":
          "Wild-Bean is an MI-2 coffee machine platform designed for smooth operation, beverage customization, and easy service management."
    },
    {
      "title": "Bestea",
      "image": "assets/png/Bestea.png",
      "description":
          "BesTea is a refreshing tea brand website built to highlight unique blends, simplify ordering, and engage customers digitally."
    },
    {
      "title": "Lavazza",
      "image": "assets/png/Lavazza.png",
      "description":
          "We provide an IoT kit with a touchscreen interface for Lavazza black-and-white coffee machines, enabling smart control and real-time monitoring."
    },
  ];

  final beemaApkList = <Map<String, String>>[
    {
      "version_name": "V1.114.1",
      "date_published": "July 30, 2025",
      "latest": "false",
      "mbSize": "95.1 MB",
    },
    {
      "version_name": "V1.114.1",
      "date_published": "July 30, 2025",
      "latest": "true",
      "to": "https://github.com/ImmanSpark/Apk-Download/releases/download/v4.0.1/app-arm64-v8a-release.apk",
      "mbSize": "95.1 MB",
    }
  ];

  final mi3ApkList = <Map<String, String>>[
    {
      "version_name": "V2.6.1",
      "date_published": "Aug 1, 2025",
      "latest": "true",
      "mbSize": "70 MB",
      "to": "https://github.com/ImmanuvelAppikorn/schopiq-app-store/releases/download/MI3/mi3-v2.6.1.apk",
    }
  ];

  final wildbeanApkList = <Map<String, String>>[
    {
      "version_name": "V1.23.1",
      "date_published": "Jan 13, 2025",
      "latest": "true",
      "mbSize": "60.3 MB",
    }
  ];

  final besteaApkList = <Map<String, String>>[
    {
      "version_name": "V1.18.2",
      "date_published": "May 11, 2025",
      "latest": "true",
      "mbSize": "55.67 MB",
    }
  ];

  final lavazzaApkList = <Map<String, String>>[
    {
      "version_name": "V2.11.3",
      "date_published": "Mar 18, 2025",
      "latest": "true",
      "mbSize": "40 MB",
    }
  ];

  List<Map<String, dynamic>> getApkList(String title) {
    switch (title.toLowerCase()) {
      case "beema insurance":
        return beemaApkList;
      case "mi3":
        return mi3ApkList;
      case "wildbean":
        return wildbeanApkList;
      case "bestea":
        return besteaApkList;
      case "lavazza":
        return lavazzaApkList;
      default:
        return [];
    }
  }

  int getVisibleCardCount(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    if (width >= 1200) return 5;
    if (width >= 800) return 3;
    return 1;
  }

  @override
  Widget build(BuildContext context) {
    final uploadedItems = ref.watch(uploadedItemsProvider);
    final email = ref.watch(emailProvider);

    final combinedItems = [
      ...allItems,
      ...uploadedItems.map((item) => {
            "title": item.title,
            "image": item.imageFileName,
            "to": item.apkLink,
            "description": item.description,
          }),
    ];

    final filteredItems = combinedItems.where((item) {
      final title = (item["title"] ?? "").toLowerCase();
      final org = email.toLowerCase();

      bool matchesOrg = false;
      if (org == "admin@appikorn.com" || org == "admin@schopiq.com") {
        matchesOrg = true;
      } else if (org == "fresh&honest@appikorn.com") {
        matchesOrg = ["mi3", "wildbean", "lavazza"].contains(title);
      } else if (org == "admin@anoud.com") {
        matchesOrg = title == "beema insurance";
      }

      final matchesSearch = title.contains(widget.searchQuery.toLowerCase());
      return matchesSearch && matchesOrg;
    }).toList();

    final visibleCount = getVisibleCardCount(context);
    final visibleItems = filteredItems.skip(startIndex).take(visibleCount).toList();
    final mobileScreen = mediaQuery(context, 700);

    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
      child: BoxAppi(
        fillColor: Colors.transparent,
        child: Column(
          children: [
            if (filteredItems.isEmpty)
              Padding(
                padding: const EdgeInsets.all(10),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (!mobileScreen) Flexible(flex: 2, child: SizedBox()),
                  Flexible(
                    flex: mediaQuery(context, 1100) ? 3 : 2,
                    child: Column(
                      children: [
                        SizedBox(
                          height: mediaQuery(context, 700) ? 320 : 550,
                          child: mediaQuery(context, 700)
                              ? Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Column(
                                    mainAxisAlignment:
                                        visibleItems.length == 1 ? MainAxisAlignment.center : MainAxisAlignment.start,
                                    children: [
                                      Column(
                                        mainAxisAlignment: visibleItems.length == 1
                                            ? MainAxisAlignment.center
                                            : MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: visibleItems.map((item) {
                                          return AllCard(
                                            itemData: item,
                                            onClickItem: updateSelectedItem,
                                          );
                                        }).toList(),
                                      ),
                                      // ✅ Buttons now belong to the same column as the cards
                                      if (filteredItems.length > visibleCount &&
                                          MediaQuery.of(context).size.width < 800)
                                        Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              ElevatedButton(
                                                style: ButtonStyle(
                                                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
                                                    (Set<MaterialState> states) {
                                                      if (states.contains(MaterialState.disabled)) {
                                                        // 👇 Color when disabled
                                                        return Colors.grey.shade400;
                                                      }
                                                      // 👇 Normal color (when enabled)
                                                      return ref.watch(emailProvider) == "admin@appikorn.com"
                                                          ? Color(0xffc47df3)
                                                          : Color(0xff44dfe6);
                                                    },
                                                  ),
                                                ),
                                                onPressed: startIndex > 0
                                                    ? () => setState(() {
                                                          startIndex = (startIndex - getVisibleCardCount(context))
                                                              .clamp(0, combinedItems.length);
                                                          selectedItem = null;
                                                        })
                                                    : null,
                                                child: Icon(
                                                  Icons.arrow_back_ios,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              const SizedBox(width: 20),
                                              ElevatedButton(
                                                style: ButtonStyle(
                                                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
                                                    (Set<MaterialState> states) {
                                                      if (states.contains(MaterialState.disabled)) {
                                                        // 👇 Color when disabled
                                                        return Colors.grey.shade400;
                                                      }
                                                      // 👇 Normal color (when enabled)
                                                      return ref.watch(emailProvider) == "admin@appikorn.com"
                                                          ? Color(0xffc47df3)
                                                          : Color(0xff44dfe6);
                                                    },
                                                  ),
                                                ),
                                                onPressed:
                                                    startIndex + getVisibleCardCount(context) < filteredItems.length
                                                        ? () => setState(() {
                                                              startIndex += getVisibleCardCount(context);
                                                              selectedItem = null;
                                                            })
                                                        : null,
                                                child: Icon(
                                                  Icons.arrow_forward_ios,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                    ],
                                  ),
                                )
                              : SingleChildScrollView(
                                  child: ConstrainedBox(
                                    constraints: BoxConstraints(
                                      minHeight: mediaQuery(context, 600) ? 400 : 550,
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(20),
                                      child: Column(
                                        mainAxisAlignment: visibleItems.length == 1
                                            ? MainAxisAlignment.center
                                            : MainAxisAlignment.start,
                                        children: [
                                          Column(
                                            mainAxisAlignment: visibleItems.length == 1
                                                ? MainAxisAlignment.center
                                                : MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            spacing: 20,
                                            children: visibleItems.map((item) {
                                              return AllCard(
                                                itemData: item,
                                                onClickItem: updateSelectedItem,
                                              );
                                            }).toList(),
                                          ),
                                          // ✅ Buttons now belong to the same column as the cards
                                          if (filteredItems.length > visibleCount &&
                                              MediaQuery.of(context).size.width < 800)
                                            Padding(
                                              padding: const EdgeInsets.all(10),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  ElevatedButton(
                                                    style: ButtonStyle(
                                                      backgroundColor: MaterialStateProperty.resolveWith<Color>(
                                                        (Set<MaterialState> states) {
                                                          if (states.contains(MaterialState.disabled)) {
                                                            // 👇 Color when disabled
                                                            return Colors.grey.shade400;
                                                          }
                                                          // 👇 Normal color (when enabled)
                                                          return ref.watch(emailProvider) == "admin@appikorn.com"
                                                              ? Color(0xffc47df3)
                                                              : Color(0xff44dfe6);
                                                        },
                                                      ),
                                                    ),
                                                    onPressed: startIndex > 0
                                                        ? () => setState(() {
                                                              startIndex = (startIndex - getVisibleCardCount(context))
                                                                  .clamp(0, combinedItems.length);
                                                              selectedItem = null;
                                                            })
                                                        : null,
                                                    child: Icon(
                                                      Icons.arrow_back_ios,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 20),
                                                  ElevatedButton(
                                                    style: ButtonStyle(
                                                      backgroundColor: MaterialStateProperty.resolveWith<Color>(
                                                        (Set<MaterialState> states) {
                                                          if (states.contains(MaterialState.disabled)) {
                                                            // 👇 Color when disabled
                                                            return Colors.grey.shade400;
                                                          }
                                                          // 👇 Normal color (when enabled)
                                                          return ref.watch(emailProvider) == "admin@appikorn.com"
                                                              ? Color(0xffc47df3)
                                                              : Color(0xff44dfe6);
                                                        },
                                                      ),
                                                    ),
                                                    onPressed:
                                                        startIndex + getVisibleCardCount(context) < filteredItems.length
                                                            ? () => setState(() {
                                                                  startIndex += getVisibleCardCount(context);
                                                                  selectedItem = null;
                                                                })
                                                            : null,
                                                    child: Icon(
                                                      Icons.arrow_forward_ios,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ),
                  if (!mobileScreen)
                    Flexible(
                      flex: mediaQuery(context, 1100) ? 4 : 6,
                      child: Column(
                        children: [
                          ShowContainer(text: selectedItem?["description"]),
                          const SizedBox(height: 15),
                          if (selectedItem != null)
                            SizedBox(
                              width: mediaQuery(context, 600) ? 450 : 700,
                              child: DynamicVersionBox(
                                appItem: selectedItem!,
                                apkList: getApkList(selectedItem!["title"] ?? ""),
                              ),
                            ),
                        ],
                      ),
                    ),
                ],
              ),
            if (mobileScreen)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SizedBox(
                  child: Column(
                    children: [
                      ShowContainer(text: selectedItem?["description"]),
                      const SizedBox(height: 15),
                      if (selectedItem != null)
                        SizedBox(
                          width: mediaQuery(context, 600) ? 450 : 700,
                          child: DynamicVersionBox(
                            appItem: selectedItem!,
                            apkList: getApkList(selectedItem!["title"]),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class AllCard extends ConsumerStatefulWidget {
  final Map<String, dynamic> itemData;
  final Function(Map<String, dynamic>) onClickItem;

  const AllCard({
    super.key,
    required this.itemData,
    required this.onClickItem,
  });

  @override
  ConsumerState<AllCard> createState() => _AllCardState();
}

class _AllCardState extends ConsumerState<AllCard> {
  bool isHovering = false;


  @override
  Widget build(BuildContext context) {
    final image = widget.itemData["image"] ?? "";
    final title = widget.itemData["title"] ?? "";
    final email = ref.watch(emailProvider); // Correct

    return MouseRegion(
      onEnter: (_) => setState(() => isHovering = true),
      onExit: (_) => setState(() => isHovering = false),
      child: GestureDetector(
        onTap: () => widget.onClickItem(widget.itemData),
        child: BoxAppi(
          radius: 20,
          border: Border.all(color: Colors.grey.shade300),
          shadowColor:
              isHovering ? (email == "admin@appikorn.com" ? Color(0xffc47df3) : Color(0xff44dfe6)) : Colors.transparent,
          shadowOffset: isHovering ? const Offset(4, 6) : Offset.zero,
          shadowBlur: isHovering ? 4 : 0,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              spacing: 10,
              children: [
                image.startsWith("assets/")
                    ? Image.asset(
                        image,
                        height: 150,
                        width: 160,
                        fit: BoxFit.cover,
                      )
                    : Image.network(
                        image,
                        height: 150,
                        width: 160,
                        fit: BoxFit.cover,
                      ),
                TextAppi(
                  text: title,
                  textStyle: Style(
                    $text.fontSize(mediaQuery(context, 600) ? 16 : 20),
                    $text.fontWeight(FontWeight.bold),
                    $text.textAlign(TextAlign.center),
                  ),
                ),
              ],
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
      child: SizedBox(
        height: mediaQuery(context, 600) ? 170 : 220,
        width: mediaQuery(context, 600) ? 450 : 700,
        child: BoxAppi(
          shadowColor: Colors.black.withOpacity(0.3),
          shadowBlur: 6,
          shadowOffset: const Offset(4, 4),
          fillColor:
              ref.watch(emailProvider) == "admin@appikorn.com" ? Color(0xffc47df3) : Color(0xff44dfe6),
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
                    text: text ?? "Click a card to see details",
                    textStyle: Style(
                      $text.fontSize(mediaQuery(context, 600) ? 14 : 16),
                      $text.textAlign(TextAlign.center),
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

class DynamicVersionBox extends ConsumerStatefulWidget {
  final Map<String, dynamic> appItem;
  final List<Map<String, dynamic>> apkList;

  const DynamicVersionBox({
    super.key,
    required this.appItem,
    required this.apkList,
  });

  @override
  ConsumerState<DynamicVersionBox> createState() => _DynamicVersionBoxState();
}

class _DynamicVersionBoxState extends ConsumerState<DynamicVersionBox> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return BoxAppi(
      radius: 4,
      child: Column(
        children: [
          GestureDetector(
            onTap: () => setState(() => isExpanded = !isExpanded),
            child: BoxAppi(
              fillColor: Colors.grey.shade500,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextAppi(
                      text: "All Versions available for ${widget.appItem["title"]}",
                      textStyle: Style($text.fontSize(mediaQuery(context, 600) ? 12 : 14), $text.color(Colors.white)),
                    ),
                    Icon(
                      isExpanded ? Icons.arrow_upward : Icons.arrow_downward,
                      size: 20,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (isExpanded)
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                children: widget.apkList.map((apk) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            widget.appItem["image"].startsWith("assets/")
                                ? Image.asset(
                                    widget.appItem["image"],
                                    fit: BoxFit.cover,
                                    height: 50,
                                    width: 50,
                                  )
                                : Image.network(
                                    widget.appItem["image"],
                                    fit: BoxFit.cover,
                                    height: 50,
                                    width: 50,
                                  ),
                            const SizedBox(width: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    TextAppi(
                                      text: apk["version_name"] ?? "",
                                      textStyle: Style($text.fontWeight(FontWeight.bold)),
                                    ),
                                    const SizedBox(width: 8),
                                    BoxAppi(
                                      borderThickness: 1,
                                      borderColor: Colors.red,
                                      child: Padding(
                                        padding: const EdgeInsets.all(1),
                                        child: TextAppi(
                                          text: "Apk",
                                          textStyle: Style($text.color(Colors.red)),
                                        ),
                                      ),
                                    ),
                                    if (apk["latest"] == "true") ...[
                                      const SizedBox(width: 8),
                                      BoxAppi(
                                        borderThickness: 1,
                                        borderColor: Colors.yellow[800],
                                        child: Padding(
                                          padding: const EdgeInsets.all(1),
                                          child: TextAppi(
                                            text: "Latest",
                                            textStyle: Style(
                                              $text.color(Colors.yellow.shade800),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                                const SizedBox(height: 3),
                                Row(
                                  children: [
                                    TextAppi(
                                      text: apk["date_published"] ?? "",
                                    ),
                                    const SizedBox(width: 8),
                                    TextAppi(
                                      text: apk["mbSize"] ?? "",
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                        BoxAppi(
                          fillColor: ref.watch(emailProvider) == "admin@appikorn.com" ? Color(0xffc47df3) : Color(0xff44dfe6),
                          radius: 20,
                          child: Padding(
                            padding: EdgeInsets.only(right: mediaQuery(context, 400) ? 0 : 20),
                            child: MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: GestureDetector(
                                onTap: () {
                                  final link = apk["to"]?.toString() ?? "";
                                  if (link.isNotEmpty) {
                                    openUrl(link);
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                        content: TextAppi(
                                      text: "No Apk Found!",
                                      textStyle: Style($text.fontSize(16)),
                                    )));
                                  }
                                },
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        final link = apk["to"]?.toString() ?? "";
                                        if (link.isNotEmpty) {
                                          openUrl(link);
                                        } else {
                                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                              content: TextAppi(
                                            text: "No Apk Found!",
                                            textStyle: Style($text.fontSize(14)),
                                          )));
                                        }
                                      },
                                      icon: Icon(
                                        Icons.download,
                                        color: Colors.white,
                                        size: 15,
                                      ),
                                    ),
                                    if (!mediaQuery(context, 400))
                                      TextAppi(
                                        text: "Download",
                                        textStyle: Style($text.color(Colors.white)),
                                      )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }
}
