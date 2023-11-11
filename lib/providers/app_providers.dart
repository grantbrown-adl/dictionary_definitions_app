import 'package:dictionary_definitions_app/cubit/application_cubit.dart';
import 'package:dictionary_definitions_app/cubit/loading_cubit.dart';
import 'package:dictionary_definitions_app/providers/dialog_provider.dart';
import 'package:dictionary_definitions_app/providers/notification_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

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
    return AppNotifications(
      navigatorKey: navigatorKey,
      child: BlocProvider(
        create: (context) => LoadingCubit(),
        child: MultiRepositoryProvider(
          providers: [
            RepositoryProvider<NotificationProvider>(
              create: (context) => AppNotifications.of(context),
            ),
            RepositoryProvider(
              create: (context) => DialogProvider(navigatorKey: navigatorKey),
            ),
            BlocProvider(
              create: (context) => ApplicationCubit(
                notifications: context.read<NotificationProvider>(),
                loadingCubit: context.read<LoadingCubit>(),
                http: http.Client(),
              ),
            ),
          ],
          child: child,
        ),
      ),
    );
  }
}
