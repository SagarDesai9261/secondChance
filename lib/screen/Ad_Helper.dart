import 'dart:io';
class AdHelper{
  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-1815733895558819/9755984443';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-1815733895558819/9897824366';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }
}