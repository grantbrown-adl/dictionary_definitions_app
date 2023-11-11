import 'package:dictionary_definitions_app/providers/dialog_provider.dart';
import 'package:dictionary_definitions_app/providers/notification_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppProviders extends StatelessWidget {
  const AppProviders({
    super.key,
    required this.child,
    required this.navigatorKey,
  });

  final Widget child;
  final GlobalKey<NavigatorState> navigatorKey;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) =>
              AppNotifications(navigatorKey: navigatorKey, child: child),
        ),
        RepositoryProvider(
          create: (context) => DialogProvider(navigatorKey: navigatorKey),
        ),
      ],
      child: child,
    );
  }
}
