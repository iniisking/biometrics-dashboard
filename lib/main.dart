import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'controller/dashboard_controller.dart';
import 'controller/theme_controller.dart';
import 'views/dashboard_view.dart';
import 'config/app_theme.dart';

void main() {
  runApp(const BiometricsDashboardApp());
}

class BiometricsDashboardApp extends StatelessWidget {
  const BiometricsDashboardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeController()),
        ChangeNotifierProvider(create: (context) => DashboardController()),
      ],
      child: Consumer<ThemeController>(
        builder: (context, themeController, child) {
          return MaterialApp(
            title: 'Biometrics Dashboard',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeController.themeMode,
            home: const DashboardView(),
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}
