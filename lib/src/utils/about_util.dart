import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:package_info/package_info.dart';

class _LinkTextSpan extends TextSpan {
  _LinkTextSpan({TextStyle style, String url, String text})
      : super(
            style: style,
            text: text ?? url,
            recognizer: TapGestureRecognizer()
              ..onTap = () async {
                if (await canLaunch(url)) {
                  await launch(url, forceSafariVC: true);
                } else {
                  throw 'Could not launch $url';
                }
              });
}

void showGalleryAboutDialog(BuildContext context) async {
  final ThemeData themeData = Theme.of(context);
  final TextStyle titleTextStyle = themeData.textTheme.headline;
  final TextStyle aboutTextStyle = themeData.textTheme.body1;
  final TextStyle linkStyle =
      themeData.textTheme.body1.copyWith(color: themeData.accentColor);

  PackageInfo packageInfo = await PackageInfo.fromPlatform();

  LicenseRegistry.addLicense(() {
    return Stream<LicenseEntry>.fromIterable(<LicenseEntry>[
      const LicenseEntryWithLineBreaks(
          <String>['Pirate package '], 'Pirate license'),
    ]);
  });

  showAboutDialog(
    context: context,
    applicationVersion: 'Version ${packageInfo.version}',
    applicationIcon: Image.asset(
      'assets/ic_launcher.png',
      width: 48,
      height: 48,
    ),
    applicationLegalese: null,
    children: <Widget>[
      RichText(
        text: TextSpan(
          children: <TextSpan>[
            TextSpan(
                style: aboutTextStyle,
                text:
                    'A simple note app to keep track of your tasks. Write by '),
            _LinkTextSpan(
              text: 'Flutter',
              style: linkStyle,
              url: 'https://flutter.io',
            ),
            TextSpan(
              style: aboutTextStyle,
              text: '.',
            ),
          ],
        ),
      ),
      Padding(
        padding: EdgeInsets.only(top: 16.0, bottom: 8.0),
        child: Text('Developer info', style: titleTextStyle),
      ),
      RichText(
        text: TextSpan(
          children: <TextSpan>[
            TextSpan(style: aboutTextStyle, text: 'Tran Khac Vy \t'),
            _LinkTextSpan(
              text: '@trankhacvy',
              style: linkStyle,
              url: 'https://www.facebook.com/trankhacvy',
            ),
            TextSpan(
              style: aboutTextStyle,
              text: '/',
            ),
            _LinkTextSpan(
              text: 'Github',
              style: linkStyle,
              url: 'https://github.com/Levi-ackerman',
            ),
            TextSpan(
              style: aboutTextStyle,
              text: '.',
            ),
          ],
        ),
      ),
      Padding(
        padding: EdgeInsets.only(top: 16.0, bottom: 8.0),
        child: Text('Donation', style: titleTextStyle),
      ),
      RichText(
        text: TextSpan(
          children: <TextSpan>[
            TextSpan(
                style: aboutTextStyle,
                text:
                    "I don't click a button to create an app. I have to write a ton of code to develop one. Poor me :((. If you love me, please consider buying me a coffee. Thank you for your support!\t"),
            _LinkTextSpan(
              text: '@buymeacoffee',
              style: linkStyle,
              url: 'https://www.buymeacoffee.com/g3iPlSQRe',
            ),
            TextSpan(
              style: aboutTextStyle,
              text: '.',
            ),
          ],
        ),
      ),
    ],
  );
}
