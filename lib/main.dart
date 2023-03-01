import 'package:atk_system_ga/modules/home/home_page.dart';
import 'package:atk_system_ga/modules/login/login_page.dart';
import 'package:atk_system_ga/modules/settlement_request/settlement_request_page.dart';
import 'package:atk_system_ga/modules/supplies_request/supplies_request_class.dart';
import 'package:atk_system_ga/modules/supplies_request/supplies_request_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';

String jwtToken = "";
bool isValid = false;

loginCheck() async {
  var box = await Hive.openBox('userLogin');
  jwtToken = box.get('jwtToken') != "" || box.get('jwtToken') != null
      ? box.get('jwtToken')
      : "";
}

void main() async {
  await Hive.initFlutter();
  // await loginCheck();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final GlobalKey<NavigatorState> _rootNavigatorKey =
      GlobalKey<NavigatorState>();
  final GlobalKey<NavigatorState> _shellNavigatorKey =
      GlobalKey<NavigatorState>();
  late final _router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    routes: [
      // ShellRoute(
      //   navigatorKey: _shellNavigatorKey,
      // ),
      GoRoute(
        name: 'home',
        path: '/home',
        pageBuilder: (context, state) {
          return NoTransitionPage<void>(
            key: state.pageKey,
            child: const HomePage(),
          );
        },
      ),
      GoRoute(
        name: 'supplies_request',
        path: '/supplies_request',
        pageBuilder: (context, state) {
          return NoTransitionPage<void>(
            key: state.pageKey,
            child: SuppliesRequestPage(),
          );
        },
      ),
      GoRoute(
        path: '/login',
        pageBuilder: (context, state) {
          return NoTransitionPage<void>(
            key: state.pageKey,
            child: const LoginPage(),
          );
        },
      )
    ],
    initialLocation: '/home',
  );
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'ATK Decentralize',
      theme: ThemeData(
        fontFamily: 'Helvetica',
      ),
      debugShowCheckedModeBanner: false,
      //routeInformationParser: BeamerParser(),
      routeInformationParser: _router.routeInformationParser,
      //routerDelegate: routerDelegate,
      routerDelegate: _router.routerDelegate,
      routeInformationProvider: _router.routeInformationProvider,
      builder: (context, child) => ResponsiveWrapper.builder(
        child,
        // maxWidth: 1366,
        defaultScale: MediaQuery.of(context).size.width < 1100 ? true : false,
        minWidth: MediaQuery.of(context).size.width < 1100 ? 360 : 1100,
        breakpoints: [
          // ResponsiveBreakpoint.resize(360, name: MOBILE),
          // ResponsiveBreakpoint.resize(480, name: MOBILE),
          // ResponsiveBreakpoint.resize(600, name: TABLET),
          // ResponsiveBreakpoint.autoScale(800, name: TABLET),
          // ResponsiveBreakpoint.resize(1100, name: DESKTOP),
          // ResponsiveBreakpoint.autoScale(1200, name: DESKTOP),
          // ResponsiveBreakpoint.resize(1366, name: DESKTOP),
        ],
      ),
      // builder: (context, child) => ResponsiveWrapper.builder(
      //   child,
      //   maxWidth: 2560,
      //   minWidth: 480,
      //   breakpoints: [
      //     ResponsiveBreakpoint.resize(360, name: PHONE),
      //     ResponsiveBreakpoint.resize(480, name: PHONE),
      //     ResponsiveBreakpoint.resize(600, name: TABLET),
      //     // ResponsiveBreakpoint.autoScale(800, name: TABLET),
      //     ResponsiveBreakpoint.autoScale(1024, name: DESKTOP),
      //     // ResponsiveBreakpoint.autoScale(1200, name: DESKTOP),
      //     // ResponsiveBreakpoint.autoScale(1440, name: DESKTOP),
      //   ],
      // ),
    );
  }
}
