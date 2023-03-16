import 'package:atk_system_ga/constant/colors.dart';
import 'package:atk_system_ga/functions/api_request.dart';
import 'package:atk_system_ga/layout/admin_setting_layout.dart';
import 'package:atk_system_ga/models/main_model.dart';
import 'package:atk_system_ga/modules/admin_settings/admin_setting_page.dart';
import 'package:atk_system_ga/modules/admin_settings/item/setting_item_page.dart';
import 'package:atk_system_ga/modules/admin_settings/site/setting_site_page.dart';
import 'package:atk_system_ga/modules/admin_settings/user/setting_user_page.dart';
import 'package:atk_system_ga/modules/home/home_page.dart';
import 'package:atk_system_ga/modules/login/login_page.dart';
import 'package:atk_system_ga/modules/settlement_request/approval/approval_settlement_request_page.dart';
import 'package:atk_system_ga/modules/settlement_request/detail/settlement_request_detail_page.dart';
import 'package:atk_system_ga/modules/settlement_request/request/settlement_request_page.dart';
import 'package:atk_system_ga/modules/supplies_request/approval/approval_supplies_req_page.dart';
import 'package:atk_system_ga/modules/supplies_request/detail/supplies_req_detail_page.dart';
import 'package:atk_system_ga/modules/supplies_request/order/supplies_request_page.dart';
import 'package:atk_system_ga/modules/transaction_list/transaction_list_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';

String? jwtToken = "";
bool isTokenValid = false;
bool isSystemAdmin = false;

loginCheck() async {
  var box = await Hive.openBox('userLogin');
  jwtToken = box.get('jwtToken') != "" || box.get('jwtToken') != null
      ? box.get('jwtToken')
      : "";
}

void main() async {
  await Hive.initFlutter();
  await loginCheck();
  ApiService apiService = ApiService();

  apiService.tokenCheck().then((value) {
    if (value["Status"] == "200") {
      isTokenValid = true;
    } else {
      isTokenValid = false;
    }
    apiService.getUserData().then((value) {
      isSystemAdmin = value['Data']['SystemAdmin'];
    }).then((value) {
      runApp(MyApp());
    });
  });
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final GlobalKey<NavigatorState> _rootNavigatorKey =
      GlobalKey<NavigatorState>();
  final GlobalKey<NavigatorState> _shellNavigatorKey =
      GlobalKey<NavigatorState>();
  final GlobalKey<NavigatorState> _rootAdminNavigatorKey =
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
        path: '/supplies_request/:formId',
        pageBuilder: (context, state) {
          return NoTransitionPage<void>(
            key: state.pageKey,
            child: SuppliesRequestPage(
              formId: state.params["formId"].toString(),
            ),
          );
        },
      ),
      GoRoute(
        name: 'settlement_request',
        path: '/settlement_request/:formId',
        pageBuilder: (context, state) {
          return NoTransitionPage<void>(
            key: state.pageKey,
            child: SettlementRequestPage(
              formId: state.params["formId"].toString(),
            ),
          );
        },
      ),
      GoRoute(
        name: 'transaction_list',
        path: '/transaction_list',
        pageBuilder: (context, state) {
          return NoTransitionPage<void>(
            key: state.pageKey,
            child: TransactionListPage(
              formType: state.extra.toString(),
            ),
          );
        },
        routes: [
          GoRoute(
            name: 'request_order_detail',
            path: 'request_detail/:formId',
            pageBuilder: (context, state) {
              return NoTransitionPage<void>(
                key: state.pageKey,
                child: SuppliesReqDetailPage(
                  formId: state.params["formId"].toString(),
                ),
              );
            },
          ),
          GoRoute(
            name: 'settlement_detail',
            path: 'settlement_detail/:formId',
            pageBuilder: (context, state) {
              return NoTransitionPage<void>(
                key: state.pageKey,
                child: DetailApprovalSettlementRequestPage(
                  formId: state.params["formId"].toString(),
                ),
              );
            },
          ),
          GoRoute(
            name: 'approval_request',
            path: 'request_approval/:formId',
            pageBuilder: (context, state) {
              return NoTransitionPage<void>(
                key: state.pageKey,
                child: ApprovalSuppliesReqPage(
                  formId: state.params["formId"].toString(),
                ),
              );
            },
          ),
          GoRoute(
            name: 'approval_settlement',
            path: 'approval_settlement/:formId',
            pageBuilder: (context, state) {
              return NoTransitionPage<void>(
                key: state.pageKey,
                child: ApprovalSettlementRequestPage(
                  formId: state.params["formId"].toString(),
                ),
              );
            },
          ),
        ],
      ),
      GoRoute(
        name: 'admin_setting',
        path: '/admin_setting',
        pageBuilder: (context, state) {
          return NoTransitionPage<void>(
            key: state.pageKey,
            child: const AdminSettingPage(),
          );
        },
        redirect: (context, state) {
          final adminPage = state.subloc == '/admin_setting';
          if (!isSystemAdmin) {
            return adminPage ? '/home' : null;
          }
          return null;
        },
      ),
      // GoRoute(
      //     path: '/setting',
      //     name: 'setting',
      //     pageBuilder: (context, state) {
      //       return NoTransitionPage<void>(
      //         key: state.pageKey,
      //         child: const SizedBox(),
      //       );
      //     },
      //     routes: [
      //       GoRoute(
      //         name: "setting_item",
      //         path: 'item',
      //         pageBuilder: (context, state) {
      //           return NoTransitionPage<void>(
      //             key: state.pageKey,
      //             child: ItemSettingPage(),
      //           );
      //         },
      //       ),
      //       GoRoute(
      //         name: "setting_site",
      //         path: 'site',
      //         pageBuilder: (context, state) {
      //           return NoTransitionPage<void>(
      //             key: state.pageKey,
      //             child: SettingSitePage(),
      //           );
      //         },
      //       ),
      //       GoRoute(
      //         name: "setting_user",
      //         path: 'user',
      //         pageBuilder: (context, state) {
      //           return NoTransitionPage<void>(
      //             key: state.pageKey,
      //             child: UserSettingPage(),
      //           );
      //         },
      //       ),
      //     ]),
      GoRoute(
        path: '/login',
        pageBuilder: (context, state) {
          return NoTransitionPage<void>(
            key: state.pageKey,
            child: const LoginPage(),
          );
        },
        redirect: (context, state) {
          // final home = state.subloc == '/home';

          // if (jwtToken != null || jwtToken != "" || isTokenValid) {
          //   return home ? null : '/home';
          // }
          // return null;
        },
      )
    ],
    initialLocation: '/home',
    redirect: (context, state) {
      final login = state.subloc == '/login';
      final home = state.subloc == '/home';

      if ((jwtToken == null || jwtToken == "") && !isTokenValid) {
        return login ? null : '/login';
      }
      if ((jwtToken != null || jwtToken != "") && isTokenValid) {
        return login ? '/home' : null;
      }
      return null;
    },
  );
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<MainModel>(
          lazy: false,
          create: (_) => MainModel(),
        ),
      ],
      child: MaterialApp.router(
        title: 'ATK Decentralize',
        theme: ThemeData(
          fontFamily: 'Helvetica',
          scaffoldBackgroundColor: white,
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
          // defaultScale: MediaQuery.of(context).size.width < 1100 ? true : false,
          minWidth: 1366,
          defaultScale: false,
          // minWidth: MediaQuery.of(context).size.width < 1100 ? 360 : 1100,
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
      ),
    );
  }
}
