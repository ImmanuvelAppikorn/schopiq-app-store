library circle_web_image_appi;

import 'package:appikorn_madix_widgets/circle_loader_appi/circle_loader_appi.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CircleWebImageAppi extends StatelessWidget {
  const CircleWebImageAppi({Key? key, this.url, this.size}) : super(key: key);

  final String? url;
  final double? size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size ?? 30,
      height: size ?? 30,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(1000.0),
        child: CachedNetworkImage(
          imageUrl: url ?? "https://images.unsplash.com/photo-1633332755192-727a05c4013d?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8dXNlcnxlbnwwfHwwfHw%3D&w=1000&q=80",
          placeholder: (context, url) => const CircleLoaderAppi(size: 15),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
