import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrivacyService {
  PrivacyService._();

  static final PrivacyService instance =
      PrivacyService._();

  static const String _privacyNoticeSeenKey =
      'privacy_notice_seen';

  final ValueNotifier<bool> privacyNoticeSeen =
      ValueNotifier<bool>(false);

  Future<void> initialize() async {
    final SharedPreferences prefs =
        await SharedPreferences.getInstance();

    privacyNoticeSeen.value =
        prefs.getBool(
          _privacyNoticeSeenKey,
        ) ??
        false;
  }

  Future<void> markPrivacyNoticeSeen() async {
    final SharedPreferences prefs =
        await SharedPreferences.getInstance();

    await prefs.setBool(
      _privacyNoticeSeenKey,
      true,
    );

    privacyNoticeSeen.value = true;
  }
}