import 'dart:io';

class AdHelper {
  static String get rewardedAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-6375063666523698/5898185430';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-6375063666523698/6668040304';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }
  // static String get bannerAdUnitId {
  //   if (Platform.isAndroid) {
  //     return 'ca-app-pub-6375063666523698/9255519081';
  //   } else if (Platform.isIOS) {
  //     return 'ca-app-pub-6375063666523698/3864948849';
  //   } else {
  //     throw UnsupportedError('Unsupported platform');
  //   }
  // }

  // static String get interstitialAdUnitId {
  //   if (Platform.isAndroid) {
  //     return 'ca-app-pub-6375063666523698/3238262881';
  //   } else if (Platform.isIOS) {
  //     return 'ca-app-pub-6375063666523698/6299540493';
  //   } else {
  //     throw UnsupportedError('Unsupported platform');
  //   }
  // }
}