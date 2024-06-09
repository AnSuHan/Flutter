import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';

import 'l10n/app_localization.dart';

void main() {
  runApp(const MyHomePage());
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Locale _locale = const Locale('ko');

  void _changeLanguage(String languageCode) {
    setState(() {
      _locale = Locale(languageCode);
      Intl.defaultLocale = languageCode;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: _locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        ...GlobalMaterialLocalizations.delegates, // 전체 로케일 델리게이트 추가
        GlobalCupertinoLocalizations.delegate, // Cupertino 로케일 델리게이트 추가
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('ko'),
      ],
      home: Builder(
        builder: (BuildContext context) {
          return Scaffold(
            body: Center(
              child: Column(
                children: [
                  Text(AppLocalizations.of(context)!.translate('helloWorld'),
                    style: TextStyle(fontSize: 24),),
                  Text(AppLocalizations.of(context)!.translate('welcomeMessage'),
                    style: TextStyle(fontSize: 24),),
                  TextButton(onPressed: () {
                    _changeLanguage(_locale.languageCode == 'en' ? 'ko' : 'en');
                  }, child: Text("change language", style: TextStyle(fontSize: 24),))
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
