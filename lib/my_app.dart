import 'package:atk_system_ga/constant/colors.dart';
import 'package:atk_system_ga/main.dart';
import 'package:atk_system_ga/models/main_model.dart';
import 'package:atk_system_ga/view/admin_settings/admin_setting_page.dart';
import 'package:atk_system_ga/view/dashboard/main_page_dashboard.dart';
import 'package:atk_system_ga/view/home/home_page.dart';
import 'package:atk_system_ga/view/login/login_page.dart';
import 'package:atk_system_ga/view/settlement_request/approval/approval_settlement_request_page.dart';
import 'package:atk_system_ga/view/settlement_request/detail/settlement_request_detail_page.dart';
import 'package:atk_system_ga/view/settlement_request/request/settlement_request_page.dart';
import 'package:atk_system_ga/view/supplies_request/approval/approval_supplies_req_page.dart';
import 'package:atk_system_ga/view/supplies_request/detail/supplies_req_detail_page.dart';
import 'package:atk_system_ga/view/supplies_request/order/supplies_request_page.dart';
import 'package:atk_system_ga/view/transaction_list/transaction_list_page.dart';
import 'package:atk_system_ga/view_model/dashboard_view_model.dart/chart_view_model.dart';
import 'package:atk_system_ga/view_model/dashboard_view_model.dart/recent_transaction_view_model.dart';
import 'package:atk_system_ga/view_model/dashboard_view_model.dart/summary_cost_view_model.dart';
import 'package:atk_system_ga/view_model/dashboard_view_model.dart/total_requested_item_view_model.dart';
import 'package:atk_system_ga/view_model/global_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:atk_system_ga/constant/key.dart';

class MyApp extends StatelessWidget {
  MyApp({super.key});

  late final _router = GoRouter(
    navigatorKey: navigatorKey,
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
      GoRoute(
        path: '/dashboard',
        pageBuilder: (context, state) {
          return NoTransitionPage<void>(
            key: state.pageKey,
            child: const DashboardPage(),
          );
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
      )
    ],
    initialLocation: '/home',
    redirect: (context, state) {
      final login = state.subloc == '/login';
      final home = state.subloc == '/home';

      if ((jwtToken == null || jwtToken == "") || !isTokenValid) {
        return login ? null : '/login';
      }
      if ((jwtToken != null || jwtToken != "") || isTokenValid) {
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
        ChangeNotifierProvider<CostSummaryBarChartModel>(
          lazy: false,
          create: (_) => CostSummaryBarChartModel(),
        ),
        ChangeNotifierProvider<TotalCostStatModel>(
          lazy: false,
          create: (_) => TotalCostStatModel(),
        ),
        ChangeNotifierProvider<RecentTransactionViewModel>(
          lazy: false,
          create: (_) => RecentTransactionViewModel(),
        ),
        ChangeNotifierProvider<TopReqItemsViewModel>(
          lazy: false,
          create: (_) => TopReqItemsViewModel(),
        ),
        ChangeNotifierProvider<GlobalModel>(
          lazy: false,
          create: (_) => GlobalModel(),
        ),
      ],
      child: MaterialApp.router(
        title: 'ATK Decentralize',
        theme: ThemeData(
          fontFamily: 'Helvetica',
          scaffoldBackgroundColor: white,
        ),
        debugShowCheckedModeBanner: false,
        routeInformationParser: _router.routeInformationParser,
        routerDelegate: _router.routerDelegate,
        routeInformationProvider: _router.routeInformationProvider,
        builder: (context, child) => ResponsiveWrapper.builder(
          child,
          minWidth: 1366,
          defaultScale: MediaQuery.of(context).size.width < 1100 ? true : false,
          breakpoints: [],
        ),
      ),
    );
  }
}
