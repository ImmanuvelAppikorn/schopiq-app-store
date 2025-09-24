class UploadedItem {
  final String title;
  final String description;
  final String apkLink;
  final String imageFileName;

  UploadedItem({
    required this.title,
    required this.description,
    required this.apkLink,
    required this.imageFileName,
  });
  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "description": description,
      "apk": apkLink,
      "image": imageFileName,
    };
  }

}
