import 'package:crane_plugin/framwork/utils/ConfigUtils.dart';
import 'package:crane_plugin/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class CraneApp extends StatelessWidget {
  Widget homePage;

  CraneApp(this.homePage);


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: (context, child) => MediaQuery(
          // 全局设置字体大小不随系统的设置而变化
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          child: child!),
      debugShowCheckedModeBanner: false,
      title: '',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
//        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: homePage,
//      home: TestPage(),
      localizationsDelegates: [
        // ... app-specific localization delegate[s] here
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        S.delegate
      ],
      supportedLocales: S.delegate.supportedLocales,
//      locale: const Locale('zh'),
      localeResolutionCallback: (deviceLocale, supportedLocales) {
//        S.delegate.resolution(fallback: deviceLocale);
//        print('deviceLocale: $deviceLocale');

        if (S.delegate.isSupported(deviceLocale!)) {
//          return deviceLocale;
        } else {
          deviceLocale = S.delegate.supportedLocales[0];
        }

        ConfigUtils.locale = deviceLocale;
        return deviceLocale;
      },
    );
  }
}
