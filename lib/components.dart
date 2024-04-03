import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class AppData {
  static final AppData _appData = new AppData._internal();

  bool? isPro;

  factory AppData() {
    return _appData;
  }
  AppData._internal();
}

final appData = AppData();

const kColorPrimary = Color(0xff283149);
const kColorPrimaryLight = Color(0xff424B67);
const kColorPrimaryDark = Color(0xff21293E);
const kColorAccent = Colors.blue;
const kColorText = Color(0xffDBEDF3);

var kWelcomeAlertStyle = AlertStyle(
  animationType: AnimationType.grow,
  isCloseButton: false,
  isOverlayTapDismiss: false,
  animationDuration: Duration(milliseconds: 450),
  backgroundColor: kColorPrimaryLight,
  alertBorder: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(10.0),
  ),
  titleStyle: TextStyle(
    color: kColorText,
    fontWeight: FontWeight.bold,
    fontSize: 30.0,
    letterSpacing: 1.5,
  ),
);

TextStyle kSendButtonTextStyle = TextStyle(
  color: kColorText,
  fontWeight: FontWeight.bold,
  fontSize: 20,
);

class TopBarAgnosticNoIcon extends StatelessWidget {
  final String text;

  final TextStyle style;
  final String uniqueHeroTag;
  final Widget child;

  TopBarAgnosticNoIcon({
    required this.text,
    required this.style,
    required this.uniqueHeroTag,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: kColorPrimary,
      navigationBar: CupertinoNavigationBar(
        backgroundColor: kColorPrimaryLight,
        heroTag: uniqueHeroTag,
        transitionBetweenRoutes: false,
        middle: Text(
          text,
          style: style,
        ),
      ),
      child: child,
    );
  }
}
