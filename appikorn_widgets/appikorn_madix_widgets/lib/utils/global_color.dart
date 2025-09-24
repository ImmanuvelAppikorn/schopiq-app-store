class madix_global_color {
  static final madix_global_color _instance = madix_global_color._internal();

  factory madix_global_color() {
    return _instance;
  }

  madix_global_color._internal();

  static madix_global_color get instance => _instance; // Define the instance property
}
