import 'dart:core';

import 'package:dictionary_definitions_app/cubit/application_cubit.dart';
import 'package:dictionary_definitions_app/helpers/helpers.dart';
import 'package:dictionary_definitions_app/models/dictionary_entry.dart';
import 'package:dictionary_definitions_app/pages/search_page.dart';
import 'package:dictionary_definitions_app/providers/app_providers.dart';
import 'package:dictionary_definitions_app/providers/dialog_provider.dart';
import 'package:flash/flash.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:recase/recase.dart';

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
    final definitionList = context
        .select<ApplicationCubit, List<MapEntry<String, List<Definition?>>>>(
      (cubit) => cubit.state.culledList,
    );

    return Scaffold(
      floatingActionButton: definitionList.isNotEmpty
          ? FloatingActionButton(
              child: const Icon(Icons.delete),
              onPressed: () async {
                final appCubit = context.read<ApplicationCubit>();

                final confirmation =
                    await context.read<DialogProvider>().showConfirmation(
                          title: 'Clear Search History',
                          content:
                              'Are you certain you want to clear your word searches?',
                          confirmLabel: 'Yes',
                        );

                if (confirmation) {
                  appCubit.clearSearchHistory();
                }
              },
            )
          : null,
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.question_mark),
            onPressed: () => context.read<DialogProvider>().showAlert(
                  title: 'Help',
                  content: const Wrap(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(bottom: 8.0),
                        child: Text(
                          'Enter a word to search for and press the search icon:',
                        ),
                      ),
                      Icon(Icons.search),
                    ],
                  ),
                  confirmLabel: 'Ok',
                ),
          ),
        ],
        title: const Text('Dictionary Definitions'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SearchPage(),
          Expanded(
            child: ListView.builder(
              itemCount: definitionList.length,
              itemBuilder: (context, index) {
                var entry = definitionList[index];
                var word = entry.key;
                var definitions = entry.value;

                return ListTile(
                  title: Center(
                    child: Text(
                      word.titleCase,
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (var definition in definitions) ...[
                        if (definition != null) ...[
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Definition: ${definitions.indexOf(definition) + 1}',
                                  style: const TextStyle(color: Colors.black),
                                ),
                                Text(definition.definition!),
                              ],
                            ),
                          ),
                        ],
                      ],
                      const Divider(),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
