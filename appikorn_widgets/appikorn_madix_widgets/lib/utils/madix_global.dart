import 'dart:ui';

class MadixGlobal {
  static final MadixGlobal _instance = MadixGlobal._internal();

  factory MadixGlobal() {
    return _instance;
  }

  MadixGlobal._internal();

  var appVersion = "v7.3";
  var urlHttp = "";
  var rtl = false;
  var dateFormat = "dd/MM/yyyy";
  var localCurrency = "INR";
  var currencyDecimal = 3;

  var phoneCountryCode = "+91";

  Duration pageTransitionDuration = const Duration(milliseconds: 20);

  // Transition page_transition = Transition.noTransition;

  double globalScrollSpeed = 2.0;

  BlendMode shaderBlendMode = BlendMode.dstOut;

  var lifeInsuranceUrl = "";
  var medicalInsuranceUrl = "";
  var logoName = "assets/images/logo.png";

  bool get_rtl() {
    return rtl;
  }

  String get_url() {
    return urlHttp;
  }

  void set_url({required String url}) {
    try {
      urlHttp = url;
    } catch (e) {
      print("Error setting URL: $e");
    }
  }

  static MadixGlobal get instance => _instance; // Define the instance property
}
