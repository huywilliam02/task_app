import 'package:flutter/material.dart';
import 'package:test_interview/core/constants/app_theme.dart';
import 'package:test_interview/core/routers/app_route_config.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Huy Interview',
      theme: ThemeConstants().theme,
      routerConfig: AppRouterConfig().router,
      debugShowCheckedModeBanner: false,
    );
  }
}
