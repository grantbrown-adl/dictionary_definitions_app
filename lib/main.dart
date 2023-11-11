import 'package:dictionary_definitions_app/helpers/helpers.dart';
import 'package:dictionary_definitions_app/providers/app_providers.dart';
import 'package:dictionary_definitions_app/providers/dialog_provider.dart';
import 'package:dictionary_definitions_app/providers/notification_provider.dart';
import 'package:flash/flash.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorage.webStorageDirectory
        : await getApplicationSupportDirectory(),
  );

  runApp(AppEntryPoint());
}

class AppEntryPoint extends StatelessWidget {
  AppEntryPoint({super.key});
  final navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: buildMaterialColor(const Color(0xff516b5e)),
        extensions: const [
          FlashToastTheme(),
          FlashBarTheme(),
        ],
      ),
      home: AppProviders(
        navigatorKey: navigatorKey,
        child: const MainApp(),
      ),
    );
  }
}

class MainApp extends StatelessWidget {
  const MainApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.question_mark),
            onPressed: () => context.read<DialogProvider>().showAlert(
                  title: 'Help',
                  content:
                      'Enter a word to search for and press the search icon',
                  confirmLabel: 'Ok',
                ),
          ),
        ],
        title: const Text('Dictionary Definitions'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () {
                AppNotifications.of(context).success(message: 'Success');
              },
              child: const Text('Show Success'),
            ),
            TextButton(
              onPressed: () {
                AppNotifications.of(context).error(message: 'Error');
              },
              child: const Text('Show Error'),
            ),
            TextButton(
              onPressed: () {
                AppNotifications.of(context).info(message: 'Info');
              },
              child: const Text('Show Info'),
            ),
          ],
        ),
      ),
    );
  }
}
