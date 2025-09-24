library table_appi;

import 'package:appikorn_madix_widgets/button_appi/button_appi.dart';
import 'package:appikorn_madix_widgets/circle_loader_appi/circle_loader_appi.dart';
import 'package:appikorn_madix_widgets/text_appi/text_appi.dart';
import 'package:appikorn_madix_widgets/text_field_appi/text_field_appi.dart';
import 'package:appikorn_madix_widgets/utils/global_size.dart';
import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

import '../../utils/regx.dart';

class TableOneAppi extends StatefulWidget {
  const TableOneAppi({
    super.key,
    required this.titleWidget,
    // required this.widgetKey,
    required this.contentWidget,
    required this.count,
    this.headerColor,
    this.divider,
    this.width,
    this.previousOntap,
    this.nextOntap,
    this.pageNo,
    this.border,
    this.borderColor,
    this.enablePagination,
    this.radius,
    this.mainBorder,
    this.loader,
    required this.maxCel,
    this.currentPage,
    this.selected, this.textStyle,
  });

  final List titleWidget;
  final List contentWidget;
  final Color? headerColor;
  final int count;
  final int? divider;
  final double? width;
  final double? radius;
  final Function()? previousOntap;
  final Function()? nextOntap;
  final String? pageNo;
  final bool? border;
  final bool? enablePagination;
  final Color? borderColor;
  final bool? mainBorder;
  final bool? loader;
  final int maxCel;
  final int? currentPage;
  final TextStyle? textStyle;
  final int? selected;
  // final GlobalKey<FormFieldState<String>> widgetKey;

  @override
  State<TableOneAppi> createState() => _TableOneAppiState();
}

class _TableOneAppiState extends State<TableOneAppi> {
  var localCurrentPage = 1;
  TextEditingController pageController = TextEditingController(text: "1");

  var totalPage;

  @override
  void initState() {
    totalPage = (widget.count / widget.maxCel).ceil();
    pageController.text = "1";
    // TODO: implement initState
    super.initState();
  }

  Widget pagination(context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.9,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const SizedBox(
            width: 10,
          ),
          IconButton(
              splashRadius: 20,
              onPressed: () {
                if (localCurrentPage > 1) {
                  setState(() {
                    localCurrentPage = localCurrentPage - 1;
                    pageController.text = localCurrentPage.toString();
                  });
                }
              },
              icon: Icon(
                Icons.arrow_circle_left_outlined,
                color: Theme.of(context).primaryColor,
              )),
          TextAppi(
            text: "Prev",
            textStyle: Style(
              $text.style.fontSize(f0),
              $text.style.color(Theme.of(context).primaryColor),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          TextAppi(
            text: "|",
            textStyle: Style(
              $text.style.fontSize(f1),
              $text.style.color(Theme.of(context).primaryColor),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          TextAppi(
            text: "Next",
            textStyle: Style(
              $text.style.fontSize(f0),
              $text.style.color(Theme.of(context).primaryColor),
            ),
          ),
          IconButton(
              splashRadius: 20,
              onPressed: () {
                setState(() {
                  // print(widget.maxCel * localCurrentPage);
                  // print(widget.count);

                  if (widget.maxCel * localCurrentPage >= widget.count) {
                    return;
                  } else {
                    localCurrentPage = localCurrentPage + 1;
                    pageController.text = localCurrentPage.toString();
                  }
                });
              },
              icon: Icon(
                Icons.arrow_circle_right_outlined,
                color: Theme.of(context).primaryColor,
              )),
          const SizedBox(
            width: 10,
          ),
          TextAppi(
            text: "Go to Page:",
            textStyle: Style(
              $text.style.fontSize(f0),
              $text.style.color(Theme.of(context).primaryColor),
            ),
          ),
          const SizedBox(
            width: 5,
          ),
          SizedBox(
            width: 40,
            height: 35,
            child: TextFieldAppi(
              textStyle: widget.textStyle,
              widgetKey: GlobalKey<FormFieldState<String>>(),
              // controller: page_controller,
              contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              maxLines: 1,
              regx: numberRegx,
            ),
          ),
          const SizedBox(
            width: 5,
          ),
          TextAppi(
            text: "/ ${(widget.count / widget.maxCel).ceil()}",
            textStyle: Style(
              $text.style.fontSize(f1),
            ),
          ),
          const SizedBox(
            width: 5,
          ),
          SizedBox(
            width: 48,
            height: 30,
            child: ButtonAppi(
                width: 40,
                height: 40,
                onTap: () {
                  if (pageController.text.isNotEmpty) {
                    setState(() {
                      if (widget.maxCel * int.parse(pageController.text.trim()) - widget.maxCel >= widget.count) {
                        return;
                      } else {
                        localCurrentPage = int.parse(pageController.text.trim());
                        pageController.text = localCurrentPage.toString();
                      }
                    });
                  }
                },
                text: "Go"),
          ),
          const SizedBox(
            width: 20,
          ),
        ],
      ),
    );
  }

  final ScrollController _scroll = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Scrollbar(
            controller: _scroll,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              controller: _scroll,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                      width: (widget.mainBorder == null || widget.mainBorder!) ? 1 : 0,
                      color: (widget.mainBorder == null || widget.mainBorder!) ? Theme.of(context).primaryColor.withOpacity(.8) : Colors.transparent),
                  borderRadius: BorderRadius.circular(widget.radius ?? 0),
                ),
                child: widget.count == 0
                    // ? appikorn_text(text: "No Data Found", size: f1).centered()
                    ? Column(
                        children: [
                          Table(
                            columnWidths: {
                              for (var s = 0; s < widget.titleWidget.length; s++) s: FixedColumnWidth(widget.titleWidget[s][1]),
                            },
                            children: [
                              TableRow(
                                  decoration: BoxDecoration(
                                    color: widget.headerColor ?? Theme.of(context).primaryColor,
                                    borderRadius: BorderRadius.circular(widget.radius ?? 0),
                                  ),
                                  children: [
                                    for (var ind = 0; ind < widget.titleWidget.length; ind++)
                                      Padding(
                                        padding: const EdgeInsets.only(left: 15.0),
                                        child: SizedBox(
                                          height: 45,
                                          child: Align(alignment: Alignment.centerLeft, child: widget.titleWidget[ind][0]),
                                        ),
                                      )
                                  ]),
                            ],
                          ),
                          Expanded(
                            child: SingleChildScrollView(
                              child: Table(
                                border:
                                    TableBorder.all(color: (widget.border == null || widget.border!) ? (widget.borderColor ?? Theme.of(context).primaryColor.withOpacity(0.3)) : Colors.transparent),
                                columnWidths: {
                                  for (var s = 0; s < widget.titleWidget.length; s++) s: FixedColumnWidth(widget.titleWidget[s][1]),
                                },
                                children: [
                                  for (var k = 0; k < 1; k++)
                                    TableRow(children: [
                                      for (var l = 0; l < widget.contentWidget.length; l++)
                                        Container(
                                          color: widget.selected == k ? Colors.grey.withOpacity(0.3) : Colors.transparent,
                                          constraints: const BoxConstraints(minHeight: 45),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(left: 20),
                                                child: Container(),
                                              ),
                                            ],
                                          ),
                                        ),
                                    ])
                                ],
                              ),
                            ),
                          )
                        ],
                      )
                    : Column(
                        children: [
                          Table(columnWidths: {
                            for (var s = 0; s < widget.titleWidget.length; s++) s: FixedColumnWidth(widget.titleWidget[s][1]),
                          }, children: [
                            TableRow(
                                decoration: BoxDecoration(
                                  color: widget.headerColor ?? Theme.of(context).primaryColor,
                                  borderRadius: BorderRadius.circular(widget.radius ?? 0),
                                ),
                                children: [
                                  for (var ind = 0; ind < widget.titleWidget.length; ind++)
                                    Padding(
                                      padding: const EdgeInsets.only(left: 15.0),
                                      child: SizedBox(
                                        height: 45,
                                        child: Align(alignment: Alignment.centerLeft, child: widget.titleWidget[ind][0]),
                                      ),
                                    )
                                ])
                          ]),
                          (widget.loader != null && widget.loader == true)
                              ? const Expanded(
                                  child: Center(child: CircleLoaderAppi(size: 30)),
                                )
                              : Expanded(
                                  child: SingleChildScrollView(
                                    child: Table(
                                      border: TableBorder.all(
                                          color: (widget.border == null || widget.border!) ? (widget.borderColor ?? Theme.of(context).primaryColor.withOpacity(0.3)) : Colors.transparent),
                                      columnWidths: {
                                        for (var s = 0; s < widget.titleWidget.length; s++) s: FixedColumnWidth(widget.titleWidget[s][1]),
                                      },
                                      children: [
                                        for (var k = ((widget.maxCel * localCurrentPage) - widget.maxCel); (k < widget.maxCel * localCurrentPage && k < widget.count); k++)
                                          TableRow(children: [
                                            for (var l = 0; l < widget.contentWidget.length; l++)
                                              Container(
                                                color: widget.selected == k ? Colors.grey.withOpacity(0.3) : Colors.transparent,
                                                constraints: const BoxConstraints(minHeight: 45),
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets.only(left: 20),
                                                      child: widget.contentWidget[l](index: k),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                          ])
                                      ],
                                    ),
                                  ),
                                ),
                        ],
                      ),
              ),
            ),
          ),
        ),
        (widget.enablePagination == null || widget.enablePagination == true) ? pagination(context) : Container()
      ],
    );
  }
}
