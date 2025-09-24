library stateful_wrapper_appi;

import 'package:flutter/cupertino.dart';

class StatefulWrapperAppi extends StatefulWidget {
  final Function()? onInit;
  final Function()? onDispose;
  final Function()? didChangeDependencies;
  final Widget child;

  const StatefulWrapperAppi({
    super.key,
    this.onInit,
    this.onDispose,
    this.didChangeDependencies,
    required this.child,
  });

  @override
  StatefulWrapperAppiState createState() => StatefulWrapperAppiState();
}

class StatefulWrapperAppiState extends State<StatefulWrapperAppi> {
  @override
  void initState() {
    super.initState();
    widget.onInit?.call(); // Call onInit if it's not null
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    widget.didChangeDependencies?.call(); // Call didChangeDependencies if it's not null
  }

  @override
  void dispose() {
    widget.onDispose?.call(); // Call onDispose if it's not null
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
