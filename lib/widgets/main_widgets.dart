import 'package:appikorn_madix_widgets/box_appi/box_appi.dart';
import 'package:appikorn_madix_widgets/text_appi/text_appi.dart';
import 'package:appikorn_software/core/common_functions.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
import 'package:mix/mix.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:html' as html;

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
      "latest": "true",
      "to": "https://github.com/ImmanSpark/Apk-Download/releases/download/v4.0.1/app-arm64-v8a-release.apk",
      "mbSize": "95.1 MB",
    },
    {
      "version_name": "V1.114.1",
      "date_published": "July 30, 2025",
      "latest": "false",
      "mbSize": "95.1 MB",
    },
  ];

  final mi3ApkList = <Map<String, String>>[
    {
      "version_name": "V2.6.3",
      "date_published": "Oct 10, 2025",
      "latest": "true",
      "mbSize": "72.8 MB",
      "to": "https://github.com/ImmanuvelAppikorn/schopiq-app-store/releases/download/MI3-1/mi3-v2.6.3.apk",
    },
    {
      "version_name": "V2.6.1",
      "date_published": "Aug 1, 2025",
      "latest": "false",
      "mbSize": "70 MB",
      "to": "https://github.com/ImmanuvelAppikorn/schopiq-app-store/releases/download/MI3/mi3-v2.6.1.apk",
    },
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

  List<Map<String, String>> getApkList(String title) {
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

  @override
  Widget build(BuildContext context) {
    final uploadedItems = ref.watch(uploadedItemsProvider);
    final login = ref.watch(loginModelProvider);

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

      final org = login.email.toLowerCase();

      bool matchesOrg = false;
      if (org == "admin@appikorn" || org == "admin@schopiq") {
        matchesOrg = true;
      } else if (org == "admin@fhcl") {
        matchesOrg = ["mi3", "wildbean", "lavazza"].contains(title);
      } else if (org == "admin@anoud") {
        matchesOrg = title == "beema insurance";
      }

      final matchesSearch = title.contains(widget.searchQuery.toLowerCase());
      return matchesSearch && matchesOrg;
      // && matchesOrg;
    }).toList();

    final visibleItems = filteredItems;

    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
      child: BoxAppi(
        fillColor: Color(0xffF5F6FA),
        child: Column(
          children: [
            if (filteredItems.isEmpty)
              Padding(
                padding: const EdgeInsets.all(10),
                child: SizedBox(
                  height: 255,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // SizedBox(
                        //   height: 120,
                        //   child:  BoxAppi(
                        //     radius: 10,
                        //     border: Border.all(color: Colors.black.withOpacity(0.2)),
                        //     child: Padding(
                        //       padding: const EdgeInsets.all(10),
                        //       child: Lottie.asset(
                        //         'assets/Loading.json',
                        //         fit: BoxFit.contain,
                        //         repeat: true,
                        //       ),
                        //     ),
                        //   ),
                        // ),
                        SvgPicture.asset(
                          "assets/svg/empty-box.svg",
                          height: 80,
                          width: 80,
                        ),
                        // ref.watch(emailProvider) == "admin@appikorn"
                        //     ? SvgPicture.asset("assets/svg/empty-box-purple.svg")
                        //     : SvgPicture.asset("assets/svg/empty-box-blue.svg"),
                        SizedBox(height: 20),
                        TextAppi(
                          text: "Currently there are no application available, Try login after sometime!",
                          textStyle: Style($text.fontSize(mediaQuery(context, 600) ? 14 : 18),
                              $text.fontWeight(FontWeight.bold), $text.textAlign(TextAlign.center)),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            else
              BoxAppi(
                fillColor: Color(0xffF5F6FA),
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 40, // horizontal spacing between cards
                        runSpacing: 40, // vertical spacing between lines
                        children: visibleItems.map((item) {
                          return AllCard(
                            itemData: item,
                            onClickItem: updateSelectedItem,
                            apkList: getApkList(item["title"]),
                          );
                        }).toList(),
                      ),
                      // VersionBox(),
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
  final List<Map<String, String>> apkList; // NEW

  const AllCard({
    super.key,
    required this.itemData,
    required this.onClickItem,
    required this.apkList, // NEW
  });

  @override
  ConsumerState<AllCard> createState() => _AllCardState();
}

class _AllCardState extends ConsumerState<AllCard> {
  bool isHovering = false;
  bool isVersionBoxVisible = false;
  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();

  void _showOverlay() {
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);

    double dropdownHeight = 160; // height of dropdown
    final screenHeight = MediaQuery.of(context).size.height;

    // Default offset (your given numbers)
    final defaultOffset = Offset(mediaQuery(context, 600) ? 3 : 0, 40);
    final offsetAbove = Offset(mediaQuery(context, 600) ? 3 : 0, -dropdownHeight - 25);

    // Calculate available space below the button
    final spaceBelow = screenHeight - offset.dy - size.height;

    // Use default offset normally; if not enough space below, show above
    final appliedOffset = (spaceBelow >= dropdownHeight) ? defaultOffset : offsetAbove;

    _overlayEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              onTap: _removeOverlay,
              behavior: HitTestBehavior.translucent,
              child: Container(color: Colors.transparent),
            ),
          ),
          Positioned(
            left: 20,
            top: offset.dy + appliedOffset.dy,
            width: mediaQuery(context, 600) ? 220 : 250,
            child: CompositedTransformFollower(
              link: _layerLink,
              offset: appliedOffset,
              showWhenUnlinked: false,
              child: Material(
                elevation: 4,
                child: VersionBox(
                  apkList: widget.apkList,
                  rootContext: context,
                ),
              ),
            ),
          ),
        ],
      ),
    );

    Overlay.of(context)?.insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    setState(() {}); // to update UI (arrow icon)
  }

  @override
  void dispose() {
    _removeOverlay();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final image = widget.itemData["image"] ?? "";
    final title = widget.itemData["title"] ?? "";
    final login = ref.watch(loginModelProvider);
    final isAppikorn = login.email == "admin@appikorn";
    final apkList = widget.apkList;

    final latestApk = apkList.firstWhere(
      (apk) => apk["latest"] == "true",
      orElse: () => {"version_name": "Unknown"},
    );

    return MouseRegion(
      onEnter: (_) => setState(() => isHovering = true),
      onExit: (_) => setState(() => isHovering = false),
      child: GestureDetector(
        onTap: () => widget.onClickItem(widget.itemData),
        child: SizedBox(
          width: mediaQuery(context, 600) ? 260 : 300,
          height: mediaQuery(context, 600) ? 300 : 330,
          child: BoxAppi(
            radius: 20,
            border: Border.all(color: Colors.grey.shade300),
            // shadowColor:
            // isHovering ? (email == "admin@appikorn" ? Color(0xffc47df3) : Color(0xff44dfe6)) : Colors.transparent,
            // shadowOffset: isHovering ? const Offset(4, 6) : Offset.zero,
            // shadowBlur: isHovering ? 4 : 0,
            child: Padding(
              padding: EdgeInsets.all(mediaQuery(context, 600) ? 16 : 25),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                spacing: 15,
                children: [
                  Row(
                    children: [
                      ClipOval(
                        child: Image.asset(
                          image,
                          height: mediaQuery(context, 600) ? 60 : 70,
                          width: mediaQuery(context, 600) ? 60 : 70,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextAppi(
                            text: title,
                            textStyle: Style(
                              $text.fontSize(mediaQuery(context, 600) ? 16 : 18),
                              $text.fontWeight(FontWeight.bold),
                              $text.textAlign(TextAlign.center),
                            ),
                          ),
                          // TextAppi(
                          //   text: "${latestApk["version_name"] ?? "-"}",
                          //   textStyle: Style($text.fontSize(mediaQuery (context, 600) ? 14 : 13),
                          //       $text.textAlign(TextAlign.center), $text.color(Colors.grey.shade500)),
                          // ),
                        ],
                      )
                    ],
                  ),
                  TextAppi(
                    text: widget.itemData["description"] ?? "",
                    textStyle: Style($text.fontSize(mediaQuery(context, 600) ? 15 : 17),
                        $text.textAlign(TextAlign.justify), $text.color(Colors.grey.shade700)),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            CompositedTransformTarget(
                              link: _layerLink,
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: isAppikorn ? Color(0xff9263b2) : Color(0xff2daba8),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(6), // radius of 20 for rounded corners
                                    ),
                                    elevation: 5,
                                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                    minimumSize: Size(double.infinity, 40),
                                  ),
                                  onPressed: () {
                                    if (_overlayEntry == null) {
                                      _showOverlay();
                                    } else {
                                      _removeOverlay();
                                    }
                                  },
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      TextAppi(
                                        text: "Download APK",
                                        textStyle: Style($text.color(Colors.white),
                                            $text.fontSize(mediaQuery(context, 600) ? 13 : 15)),
                                      ),
                                      SizedBox(width: 5),
                                      Icon(
                                        _overlayEntry == null ? Icons.arrow_drop_down : Icons.arrow_drop_up,
                                        color: Colors.white,
                                        size: 20,
                                      )
                                    ],
                                  )),
                            ),
                            // if (isVersionBoxVisible) VersionBox(),
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class VersionBox extends ConsumerStatefulWidget {
  final List<Map<String, String>> apkList;
  final BuildContext rootContext;

  const VersionBox({
    super.key,
    required this.apkList,
    required this.rootContext,
  });

  @override
  ConsumerState createState() => _VersionBoxState();
}

class _VersionBoxState extends ConsumerState<VersionBox> {
  // Keep track of hovered row by index
  int? hoveringIndex;


  @override
  Widget build(BuildContext context) {
    bool isMobile = mediaQuery(context, 600);
    final login = ref.watch(loginModelProvider);
    final isAppikorn = login.email == "admin@appikorn";

    String tooltipMessage = "This APK version includes the latest features and bug fixes.\n"
        "Make sure to update to stay compatible with other services.\n"
        "For detailed changelog, visit our website or contact support.";

    Widget tooltipIcon = Icon(
      Icons.info,
      color: isAppikorn ? const Color(0xff9263b2) : const Color(0xff2daba8),
      size: isMobile ? 17 : 20,
    );

    return BoxAppi(
      radius: 20,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: SizedBox(
          width: 200,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.only(bottom: 8),
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.grey,
                      width: 0.4,
                    ),
                  ),
                ),
                child: TextAppi(
                  text: "Versions",
                  textStyle: Style(
                    $text.fontSize(isMobile ? 14 : 16),
                    $text.fontWeight(FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: isMobile ? 120 : 150,
                child: ScrollConfiguration(
                  behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
                  child: SingleChildScrollView(
                    child: Column(
                      spacing: 10,
                      children: widget.apkList.asMap().entries.map((entry) {
                        int index = entry.key;
                        Map<String, String> apk = entry.value;

                        bool isHovering = hoveringIndex == index;
                        return MouseRegion(
                          onEnter: (_) {
                            if (!isMobile) {
                              setState(() {
                                hoveringIndex = index;
                              });
                            }
                          },
                          onExit: (_) {
                            if (!isMobile) {
                              setState(() {
                                hoveringIndex = null;
                              });
                            }
                          },
                          cursor: SystemMouseCursors.click,
                          child: GestureDetector(
                            child: Container(
                              decoration: BoxDecoration(
                                color: isHovering ? Colors.grey.withOpacity(0.2) : Colors.transparent,
                                borderRadius: isHovering ? BorderRadius.circular(6) : BorderRadius.circular(0),
                                border: Border(
                                  bottom: BorderSide(
                                    color: Colors.grey,
                                    width: 0.4,
                                  ),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      spacing: 8,
                                      children: [
                                        TextAppi(
                                          text: apk["version_name"] ?? "",
                                          textStyle: Style($text.fontSize(isMobile ? 13 : 15)),
                                        ),
                                        if (apk["latest"] == "true")
                                          BoxAppi(
                                            borderThickness: 1,
                                            borderColor: Colors.yellow[800],
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 1),
                                              child: TextAppi(
                                                text: "Latest",
                                                textStyle: Style(
                                                  $text.color(Colors.yellow.shade800),
                                                  $text.fontSize(isMobile ? 12 : 14),
                                                ),
                                              ),
                                            ),
                                          ),

                                        // Tooltip section (cleaned)
                                        Tooltip(
                                          message: tooltipMessage,
                                          waitDuration: const Duration(milliseconds: 200),
                                          showDuration: const Duration(seconds: 4),
                                          preferBelow: false,
                                          triggerMode: isMobile
                                              ? TooltipTriggerMode.longPress // 👈 mobile long press
                                              : TooltipTriggerMode.tap,
                                          // 👈 desktop tap
                                          child: tooltipIcon,
                                        ),
                                      ],
                                    ),
                                    MouseRegion(
                                      cursor: SystemMouseCursors.click,
                                      child: GestureDetector(
                                        onTap: () async {
                                          final url = apk["to"] ?? "";
                                          if (url.isNotEmpty) {
                                            try {
                                              final fileName = url.split('/').last;

                                              if (kIsWeb) {
                                                // Web download
                                                final anchor = html.AnchorElement(href: url)
                                                  ..setAttribute("download", fileName)
                                                  ..click();
                                                Fluttertoast.showToast(
                                                  msg: "Download started in browser",
                                                  toastLength: Toast.LENGTH_SHORT,
                                                  gravity: ToastGravity.TOP,
                                                  backgroundColor: isAppikorn ? Color(0xff9263b2) : Color(0xff2daba8),
                                                  textColor: Colors.white,
                                                  webBgColor: isAppikorn ? "#9263b2" : "#2daba8",
                                                  webPosition: "center",
                                                  timeInSecForIosWeb: 2,
                                                  fontSize: 14.0,
                                                );
                                              } else {
                                                // Mobile download
                                                final dir = await getApplicationDocumentsDirectory();
                                                final savePath = "${dir.path}/$fileName";

                                                final dio = Dio();
                                                await dio.download(url, savePath);

                                                Fluttertoast.showToast(
                                                  msg: "Downloaded to $savePath",
                                                  toastLength: Toast.LENGTH_SHORT,
                                                  gravity: ToastGravity.TOP,
                                                  backgroundColor: isAppikorn ? Color(0xff9263b2) : Color(0xff2daba8),
                                                  textColor: Colors.white,
                                                  timeInSecForIosWeb: 2,
                                                  fontSize: 14.0,
                                                );
                                              }

                                              Fluttertoast.showToast(
                                                msg: "Downloaded",
                                                toastLength: Toast.LENGTH_SHORT,
                                                gravity: ToastGravity.TOP,
                                                backgroundColor: isAppikorn ? Color(0xff9263b2) : Color(0xff2daba8),
                                                textColor: Colors.white,
                                                webBgColor: isAppikorn ? "#9263b2" : "#2daba8",
                                                webPosition: "center",
                                                timeInSecForIosWeb: 2,
                                                fontSize: 14.0,
                                              );
                                              print("Download complete");
                                            } catch (e) {
                                              Fluttertoast.showToast(
                                                msg: "Download Failed: ${e.toString()}",
                                                toastLength: Toast.LENGTH_SHORT,
                                                gravity: ToastGravity.TOP,
                                                backgroundColor: Colors.red,
                                                textColor: Colors.white,
                                                webBgColor: "#ff0000",
                                                webPosition: "center",
                                                timeInSecForIosWeb: 2,
                                                fontSize: 14.0,
                                              );

                                              print("Download error: $e");
                                            }
                                          } else {
                                            Fluttertoast.showToast(
                                              msg: "No APK Found",
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.TOP,
                                              backgroundColor: isAppikorn ? Color(0xff9263b2) : Color(0xff2daba8),
                                              textColor: Colors.white,
                                              webBgColor: isAppikorn ? "#9263b2" : "#2daba8",
                                              webPosition: "center",
                                              timeInSecForIosWeb: 2,
                                              fontSize: isMobile ? 10.0 : 14.0,
                                            );
                                            print("No APK Found");
                                          }
                                        },
                                        child: SizedBox(
                                          height: isMobile ? 17 : 20,
                                          width: isMobile ? 17 : 20,
                                          child: BoxAppi(
                                            fillColor: isAppikorn ? Color(0xff9263b2) : Color(0xff2daba8),
                                            child: Icon(
                                              Icons.download,
                                              size: isMobile ? 14 : 16,
                                              color: Colors.white,
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
                        );
                      }).toList(),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
