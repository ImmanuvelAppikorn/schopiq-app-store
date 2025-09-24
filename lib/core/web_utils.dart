import 'dart:html' as html;

void openLink(String url) {
  final anchor = html.AnchorElement(href: url)
    ..target = 'blank'
    ..click();
}
