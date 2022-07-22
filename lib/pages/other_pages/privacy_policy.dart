import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutx/utils/spacing.dart';
import 'package:flutx/widgets/text/text.dart';
import 'package:flutx/widgets/widgets.dart';
import 'package:ict4farmers/theme/app_theme.dart';
import 'package:ict4farmers/utils/AppConfig.dart';
import 'package:provider/provider.dart';

import '../../theme/app_notifier.dart';
import '../../utils/Utils.dart';

class PrivacyPolicy extends StatefulWidget {
  @override
  State<PrivacyPolicy> createState() => PrivacyPolicyState();
}

late CustomTheme customTheme;
String title = "Our Privacy Policy";
bool is_loading = false;

class PrivacyPolicyState extends State<PrivacyPolicy> {
  late ThemeData theme;

  @override
  void initState() {
    super.initState();
    Utils.ini_theme();
    customTheme = AppTheme.customTheme;
    theme = AppTheme.theme;
  }

  @override
  void dipose() {}

  @override
  Widget build(BuildContext context) {
    return Consumer<AppNotifier>(
        builder: (BuildContext context, AppNotifier value, Widget? child) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: CustomTheme.primary,
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: CustomTheme.primary,
            statusBarIconBrightness: Brightness.light,
            statusBarBrightness: Brightness.light, // For iOS (dark icons)
          ),
          elevation: .5,
          iconTheme: IconThemeData(
            color: Colors.white, // <= You can change your color here.
          ),
          title: Text(
            "Our Privacy Policy",
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: SafeArea(
            child: ListView(
          children: [
            SingleWidget(
              "Collection",
              "In order for the website to provide a safe and useful service, it is important for ${AppConfig.AppName} to collect, use, and share personal information."
                  "\n\nInformation posted on ${AppConfig.AppName} is publicly available. If you choose to provide us with personal information, you are consenting to the transfer and storage of that information on our servers. We collect and store the following personal information:"
                  "\n\n- Email address, contact information, and (depending on the service used) sometimes financial information."
                  "\n\n- Computer sign-on data, statistics on page views, traffic to and from ${AppConfig.AppName} and response to advertisements."
                  "\n\n- Other information, including users' IP address and standard web log information.",
              false,
            ),
            SingleWidget(
              "Use",
              "We use users' personal information to:"
                  "\n\n- Provide our services"
                  "\n\n- Resolve disputes, collect fees, and troubleshoot problems"
                  "\n\n- Encourage safe trading and enforce our policies"
                  "\n\n- Customize users experience, measure interest in our services"
                  "\n\n- Improve our services and inform users about services and updates"
                  "\n\n- Do other things for users as described when we collect the information"
                  "",
              false,
            ),
            SingleWidget(
              "Disclosure",
              "We don't sell or rent users' personal information to third parties for their marketing purposes without users' explicit consent."
                  "\n\nWe may disclose personal information to respond to legal requirements, enforce our policies, respond to claims that a posting or other content violates other's rights, or protect anyone's rights, property, or safety.",
              false,
            ),
            SingleWidget(
              "Communication and email tools",
              "You agree to receive marketing communications about consumer goods and services on behalf of our third party advertising partners unless you tell us that you prefer not to receive such communications. "
                  "\n\nIf you don't wish to receive marketing communications from us, simply indicate your preference by following directions provided with the communication."
                  "\n\nYou may not use our site or communication tools to harvest addresses, send spam or otherwise breach our Terms of Use or Privacy Policy. "
                  "\n\nWe may automatically scan and manually filter email messages sent via our communication tools for malicious activity or prohibited content. "
                  "\n\nIf you use our tools to send content to a friend, we don't permanently store your friends' addresses or use or disclose them for marketing purposes. "
                  "\n\nTo report spam from other users, please contact customer support.",
              false,
            ),
            SingleWidget(
              "Security",
              "We use lots of tools (encryption, passwords, physical security) to protect your personal information against unauthorized access and disclosure."
                  "\n\nAll personal electronic details will be kept private by the Service except for those that you wish to disclose."
                  "\n\nIt is unacceptable to disclose the contact information of others through the Service."
                  "\n\nIf you violate the laws of your country of residence and/or the terms of use of the Service you forfeit your privacy rights over your personal information.",
              true,
            ),
          ],
        )),
      );
    });
  }

  SingleWidget(String title, String body, bool is_last) {
    return Container(
      padding: EdgeInsets.only(left: 25, right: 25),
      child: Column(
        children: [
          FxSpacing.height(10),
          FxText.h5(
            title,
            textAlign: TextAlign.center,
            color: Colors.black,
          ),
          FxSpacing.height(5),
          FxText.b1(
            body,
          ),
          FxSpacing.height(20),
          is_last
              ? Container()
              : Container(
                  child: Padding(
                  padding: const EdgeInsets.only(left: 50, right: 50),
                  child: Divider(
                      height: 10, color: CustomTheme.primary.withAlpha(40)),
                )),
          FxSpacing.height(10),
        ],
      ),
    );
  }
}
