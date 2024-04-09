import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:kbops/models/userdata.dart';
import 'package:kbops/state_management/web_view_expension.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ExpensionWebView extends StatelessWidget {
  final EventsInfo eventsInfo;

  const ExpensionWebView({Key? key, required this.eventsInfo})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: const Text('Event Description ▷'),
      children: [
        Stack(
          children: [
            SizedBox(
              height: 355,
              width: MediaQuery.of(context).size.width * 1,
              child: Center(
                child: WebView(
                  gestureRecognizers: Set()
                    ..add(Factory<OneSequenceGestureRecognizer>(
                        () => EagerGestureRecognizer())),
                  javascriptMode: JavascriptMode.unrestricted,
                  initialUrl: '${eventsInfo.EventDescription}',
                  onPageStarted: (value) {
                    Provider.of<WebViewLoadingProvider>(context, listen: false)
                        .setWebviewLoad(true);
                  },
                  onPageFinished: (value) {
                    Provider.of<WebViewLoadingProvider>(context, listen: false)
                        .setWebviewLoad(false);
                  },
                ),
              ),
            ),
            Consumer<WebViewLoadingProvider>(
              builder: (context, webViewLoadingProvider, _) {
                return webViewLoadingProvider.webviewLoad
                    ? Container(
                        margin: const EdgeInsets.only(top: 40),
                        color: Colors.white,
                        child: const Center(
                          child: CircularProgressIndicator(
                            color: Color.fromRGBO(196, 38, 64, 1),
                          ),
                        ),
                      )
                    : Container();
              },
            ),
          ],
        ),
      ],
    );
  }
}
