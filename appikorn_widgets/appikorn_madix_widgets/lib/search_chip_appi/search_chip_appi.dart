library search_chip_appi;

import 'package:appikorn_madix_widgets/button_appi/button_appi.dart';
import 'package:appikorn_madix_widgets/list_appi/list_appi.dart';
import 'package:appikorn_madix_widgets/text_appi/text_appi.dart';
import 'package:appikorn_madix_widgets/text_field_appi/text_field_appi.dart';
import 'package:appikorn_madix_widgets/utils/global_size.dart';
import 'package:appikorn_madix_widgets/utils/regx.dart';
import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

import '../wrap_appi/wrap_appi.dart';

class SearchChipAppi extends StatefulWidget {
  const SearchChipAppi(
      {Key? key,
      this.lable,
      required this.widgetKey,
      required this.list,
      this.validator,
      required this.height,
      required this.onChanged,
      required this.selected,
      this.heading,
      this.textcolor,
      this.textsize,
      this.mandatory,
      this.suffixIcon,
      this.textStyle})
      : super(key: key);
  final String? lable;
  final GlobalKey<FormFieldState<String>> widgetKey;
  final List<String> list;
  final double height;
  final Function(String) onChanged;
  final String selected;
  final TextStyle? textStyle;
  final String? heading;
  final Color? textcolor;
  final double? textsize;
  final bool? mandatory;
  final String? Function(String?)? validator;
  final Widget? suffixIcon;

  @override
  State<SearchChipAppi> createState() => _SearchChipAppiState();
}

class _SearchChipAppiState extends State<SearchChipAppi> {
  TextEditingController search = TextEditingController();
  var loadMore = false;
  var selectIndex = 0;
  var selected = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 200), () {
      if (widget.selected.toLowerCase().isNotEmpty) {
        loadMore = true;
        selected = true;
        search.text = widget.selected.toLowerCase();
      } else {
        loadMore = false;
        search.text = "";
      }
      setState(() {});
    });
  }

  Widget subCard(dat) {
    return ButtonAppi(
      textStyle: Style.combine([
        if (dat == widget.selected)
          Style(
            $text.style.color(Colors.white),
          ),
        Style($text.style.fontSize(f0))
      ]),
      color: dat == widget.selected ? Theme.of(context).primaryColor : Colors.transparent,
      width: 30,
      onTap: () {
        widget.onChanged(dat);
        selected = true;
        loadMore = true;
        search.text = dat;
      },
      hoveredTextColor: Colors.black,
      hoverBorder: true,
      text: dat,
      height: 40,
    );
  }

  Padding? card(dat) {
    return (search.text.isEmpty)
        ? Padding(
            padding: const EdgeInsets.only(top: 2, bottom: 2),
            child: subCard(dat),
          )
        : (dat.toString().toLowerCase().trim().contains(search.text.toLowerCase().toString().trim()))
            ? Padding(
                padding: const EdgeInsets.only(top: 2, bottom: 2),
                child: subCard(dat),
              )
            : null;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.heading != null && widget.heading!.isNotEmpty)
          Row(
            children: [
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: TextAppi(
                    mandatory: widget.mandatory ?? false,
                    text: widget.heading!,
                    textStyle: Style(
                      $text.style.color(Colors.black),
                      $text.style.fontSize(f0),
                      $text.maxLines(10),
                      $text.style.fontWeight(w400),
                    ),
                  ),
                ),
              )
            ],
          ),
        TextFieldAppi(
          textStyle: widget.textStyle,
          widgetKey: widget.widgetKey,
          validator: widget.validator,
          readOnly: selected,
          onTap: () {
            if (selected) {
              widget.onChanged("");
              search.text = "";
              selected = false;
              loadMore = false;
              setState(() {});
            }
          },
          hint: "Search",
          maxLength: 200,
          regx: allCharacterRegx,
          suffixIcon: widget.suffixIcon,
          lable: widget.lable,
          // controller: search,
          onChanged: (s) {
            if (!loadMore) {
              loadMore = true;
            }
            setState(() {});
          },
        ),
        if (!selected) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                height: 10,
              )
            ],
          ),
          loadMore
              ? SizedBox(
                  height: (selected)
                      ? 60
                      : widget.list.length > 10
                          ? widget.height
                          : 100,
                  child: ListAppi(child: ({index}) => card(widget.list[index]), count: (widget.list.length)),
                )
              : SizedBox(
                  height: widget.list.isEmpty
                      ? 0
                      : widget.list.length > 10
                          ? widget.height
                          : 100,
                  child: WrapAppi(
                    spacing: 10,
                    controller: ScrollController(),
                    children: [
                      for (var k = 0; k <= 20; k++)
                        if (search.text.isEmpty && widget.list.length > k) ...[
                          Padding(
                            padding: const EdgeInsets.all(0.0),
                            child: subCard(widget.list[k]),
                          )
                        ] else if (widget.list.length > k && widget.list[k].toString().toLowerCase().contains(search.text.toLowerCase())) ...[
                          Padding(
                            padding: const EdgeInsets.all(0.0),
                            child: subCard(widget.list[k]),
                          )
                        ]
                    ],
                  ),
                ),
          SizedBox(
            height: s2,
          )
        ],
      ],
    );
  }
}
