class AppConfig {
  static const String appName = 'PDPA Management Platform';
  static const String baseUrl = 'https://pdpa-300.web.app';
  static const String defaultLanguage = 'th-TH';
  static const int generatePasswordLength = 6;

  //? Google Sign-In
  static const String webClientId =
      '336013362570-eno456l69gfsf0ulk6porsffvrg8hhhu.apps.googleusercontent.com';

  //? Bitly
  static const String accessTokenBitly =
      '1a4228869e688dba97d940375d04122e2341ec40';

  //? Email JS
  static const String emailJsUrl =
      'https://api.emailjs.com/api/v1.0/email/send';
  static const String serviceId = 'service_yu0bzoh';
  static const String templateId = 'template_638hul8';
  static const String userId = 'zAusZtWTuLIJ5NRsW';
  static const String notificationEmail = 'notifications.wisework@gmail.com';
}

class AppPreferences {
  static const String rememberEmail = 'remember_email';
  static const String isFirstLaunch = 'is_first_launch';
}

class UiConfig {
  static const double appBarTitleSpacing = 10.0;
  static const double defaultPaddingSpacing = 15.0;
  static const double lineSpacing = 15.0;
  static const double lineGap = 10.0;
  static const double paragraphSpacing = 15.0;
  static const double textSpacing = 6.0;
  static const double textLineSpacing = 4.0;
  static const double actionSpacing = 10.0;
  static const Duration toastDuration = Duration(milliseconds: 1500);
}
