library number_keypad_appi;

import 'package:flutter/material.dart';

class NumberKeypadAppi extends StatelessWidget {
  const NumberKeypadAppi({super.key});

  popSheet({context}) {
    var showText = "sd";
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (BuildContext context, StateSetter mystate) {
            return Container(
              width: MediaQuery.of(context).size.width * .8,
              decoration: const BoxDecoration(borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)), color: Colors.white),
              height: MediaQuery.of(context).size.height * .8,
              child: Center(
                  child: SizedBox(
                width: MediaQuery.of(context).size.width * .8,
                child: Column(
                  children: [
                    Text(showText),
                    Row(
                      children: [
                        FilledButton(
                            onPressed: () {
                              mystate(() {
                                showText = "${showText}1";
                              });
                            },
                            child: const Text("1")),
                        FilledButton(
                            onPressed: () {
                              mystate(() {
                                showText = "${showText}2";
                              });
                            },
                            child: const Text("2")),
                        FilledButton(
                            onPressed: () {
                              mystate(() {
                                showText = "${showText}3";
                              });
                            },
                            child: const Text("3"))
                      ],
                    )
                  ],
                ),
              )),
            );
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      width: 300,
      child: TextFormField(
        onTap: () {
          popSheet(context: context);
        },
      ),
    );
  }
}
