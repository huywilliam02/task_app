import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:test_interview/core/routers/app_route_name.dart';
import 'package:test_interview/core/routers/app_route_path.dart';
import 'package:test_interview/modules/home/screens/home_screens.dart';

class AppRouterConfig {
  final GoRouter router = GoRouter(
    initialLocation: AppRoutePath.home,
    errorBuilder: (context, state) => ErrorPage(error: state.error),
    routes: <RouteBase>[
      GoRoute(
        path: AppRoutePath.home,
        name: AppRouteName.home,
        builder: (BuildContext context, GoRouterState state) {
          return const HomeScreen();
        },
      ),
    ],
  );
}

class ErrorPage extends StatelessWidget {
  final Exception? error;
  const ErrorPage({super.key, this.error});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Error')),
      body: Center(child: Text(error?.toString() ?? 'Unknown error occurred')),
    );
  }
}
