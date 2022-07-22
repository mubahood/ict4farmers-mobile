import 'package:flutter/cupertino.dart';
import 'package:ict4farmers/models/LoggedInUserModel.dart';
import 'package:ict4farmers/utils/AppConfig.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class OneSignalModel {
  static Future<void> set_player_id(BuildContext context) async {
    LoggedInUserModel u = new LoggedInUserModel();
    u = await LoggedInUserModel.get_logged_in_user();
    if (u.id < 1) {
      return;
    }

    await OneSignalModel.initPlatformState(context);

    print(" =====INITING===== ");
    OneSignal.shared.setExternalUserId(u.id.toString() ).then((results) {
      print("Setting SUCCESSS ");
      print(results.toString());
    }).catchError((error) {
      print("Setting FAILS ");
      print(error.toString());
    });
  }


  //done



  static Future<void> initPlatformState(context) async {
    String _debugLabelString = "";
    bool _requireConsent = false;

    OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);
    OneSignal.shared.setRequiresUserPrivacyConsent(_requireConsent);

    OneSignal.shared
        .setNotificationOpenedHandler((OSNotificationOpenedResult result) {
      print('NOTIFICATION OPENED HANDLER CALLED WITH: ${result}');
    });

    OneSignal.shared.setNotificationWillShowInForegroundHandler(
        (OSNotificationReceivedEvent event) {
      print('====> FOREGROUND HANDLER CALLED WITH: ${event}');

      /// Display Notification, send null to not display
      event.complete(null);
    });

    OneSignal.shared
        .setInAppMessageClickedHandler((OSInAppMessageAction action) {
      _debugLabelString =
          "In App Message Clicked: \n${action.jsonRepresentation().replaceAll("\\n", "\n")}";
      print(_debugLabelString);
    });

    OneSignal.shared
        .setSubscriptionObserver((OSSubscriptionStateChanges changes) {
      print("SUBSCRIPTION STATE CHANGED: ${changes.jsonRepresentation()}");
    });

    OneSignal.shared.setPermissionObserver((OSPermissionStateChanges changes) {
      print("PERMISSION STATE CHANGED: ${changes.jsonRepresentation()}");
    });

    OneSignal.shared.setEmailSubscriptionObserver(
        (OSEmailSubscriptionStateChanges changes) {
      print("EMAIL SUBSCRIPTION STATE CHANGED ${changes.jsonRepresentation()}");
    });

    OneSignal.shared
        .setSMSSubscriptionObserver((OSSMSSubscriptionStateChanges changes) {
      print("SMS SUBSCRIPTION STATE CHANGED ${changes.jsonRepresentation()}");
    });

    OneSignal.shared.setOnWillDisplayInAppMessageHandler((message) {
      print("ON WILL DISPLAY IN APP MESSAGE ${message.messageId}");
    });

    OneSignal.shared.setOnDidDisplayInAppMessageHandler((message) {
      print("ON DID DISPLAY IN APP MESSAGE ${message.messageId}");
    });

    OneSignal.shared.setOnWillDismissInAppMessageHandler((message) {
      print("ON WILL DISMISS IN APP MESSAGE ${message.messageId}");
    });

    OneSignal.shared.setOnDidDismissInAppMessageHandler((message) {
      print("ON DID DISMISS IN APP MESSAGE ${message.messageId}");
    });

    await OneSignal.shared.setAppId(AppConfig.ONESIGNAL_APP_ID);

    // iOS-only method to open launch URLs in Safari when set to false
    OneSignal.shared.setLaunchURLsInApp(false);

    bool requiresConsent = await OneSignal.shared.requiresUserPrivacyConsent();

    OneSignal.shared.disablePush(false);

    bool userProvidedPrivacyConsent =
        await OneSignal.shared.userProvidedPrivacyConsent();
    print("USER PROVIDED PRIVACY CONSENT: $userProvidedPrivacyConsent");
  }
}
