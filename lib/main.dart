import 'dart:core';

import 'package:device_preview/device_preview.dart';
import 'package:dictionary_definitions_app/cubit/application_cubit.dart';
import 'package:dictionary_definitions_app/helpers/helpers.dart';
import 'package:dictionary_definitions_app/models/dictionary_entry.dart';
import 'package:dictionary_definitions_app/pages/app_search_bar.dart';
import 'package:dictionary_definitions_app/providers/app_providers.dart';
import 'package:dictionary_definitions_app/providers/dialog_provider.dart';
import 'package:dictionary_definitions_app/widgets/definition_app_bar.dart';
import 'package:dictionary_definitions_app/widgets/search_history_list_view.dart';
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

  runApp(
    DevicePreview(
      enabled: kIsWeb,
      builder: (context) => AppEntryPoint(),
    ),
  );
}

class AppEntryPoint extends StatelessWidget {
  AppEntryPoint({super.key});
  final navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      locale: DevicePreview.locale(context),
      theme: ThemeData(
        primarySwatch: buildMaterialColor(const Color(0xff516b5e)),
        extensions: const [
          FlashToastTheme(),
          FlashBarTheme(),
        ],
      ),
      darkTheme: ThemeData.dark(),
      builder: DevicePreview.appBuilder,
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
    final definitionList = context
        .select<ApplicationCubit, List<MapEntry<String, List<Definition?>>>>(
      (cubit) => cubit.state.culledList,
    );

    return SafeArea(
      child: Scaffold(
        floatingActionButton: definitionList.isNotEmpty
            ? FloatingActionButton(
                child: const Icon(Icons.delete),
                onPressed: () async {
                  final appCubit = context.read<ApplicationCubit>();

                  final confirmation =
                      await context.read<DialogProvider>().showConfirmation(
                            title: 'Clear Search History',
                            content:
                                'Are you certain you want to clear all of your word searches?',
                            confirmLabel: 'Yes',
                          );

                  if (confirmation) {
                    appCubit.clearSearchHistory();
                  }
                },
              )
            : null,
        appBar: const DefinitionAppBar(),
        body: Column(
          children: [
            const SizedBox(height: 12),
            const Center(
              child: Text(
                'Search for a Word to Get a Definition',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            const AppSearchBar(),
            if (definitionList.isNotEmpty) ...[
              const SizedBox(height: 12),
              const Center(
                child: Text(
                  'Search History',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: SearchHistoryListView(definitionList: definitionList),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
