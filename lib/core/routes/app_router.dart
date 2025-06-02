import 'package:flutter/material.dart';
import 'package:yakiyo/core/constants/routes_constants.dart';
import 'package:yakiyo/features/auth/presentation/screens/login_screen.dart';
import 'package:yakiyo/features/home/presentation/screens/main_navigation_screen.dart';
import 'package:yakiyo/features/event_log/presentation/screens/event_log_screen.dart';
import 'package:yakiyo/features/intake_log/presentation/screens/intake_log_screen.dart';
import 'package:yakiyo/features/device_status/presentation/screens/device_status_screen.dart';
import 'package:yakiyo/features/pill_schedule/presentation/screens/pill_schedule_screen.dart';
import 'package:yakiyo/features/pill_schedule/presentation/screens/add_pill_screen.dart';
import 'package:yakiyo/features/settings/presentation/screens/settings_screen.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutesConstants.login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());

      case RoutesConstants.eventLog:
        return MaterialPageRoute(builder: (_) => const EventLogScreen());

      case RoutesConstants.deviceStatus:
        return MaterialPageRoute(builder: (_) => const DeviceStatusScreen());

      case RoutesConstants.intakeLog:
        return MaterialPageRoute(builder: (_) => const IntakeLogScreen());

      case RoutesConstants.pillSchedule:
        return MaterialPageRoute(builder: (_) => const PillScheduleScreen());

      case RoutesConstants.addPill:
        return MaterialPageRoute(builder: (_) => const AddPillScreen());

      case RoutesConstants.settings:
        return MaterialPageRoute(builder: (_) => const SettingsScreen());

      case RoutesConstants.home:
        return MaterialPageRoute(builder: (_) => const MainNavigationScreen());

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }

  // Navigation methods
  static void push(BuildContext context, String routeName) {
    Navigator.pushNamed(context, routeName);
  }

  static void pushReplacement(BuildContext context, String routeName) {
    Navigator.pushReplacementNamed(context, routeName);
  }

  static void pop(BuildContext context) {
    Navigator.pop(context);
  }

  static void popUntil(BuildContext context, String routeName) {
    Navigator.popUntil(
      context,
      (route) => route.settings.name == routeName,
    );
  }
}
