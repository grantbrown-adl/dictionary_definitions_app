import 'package:dictionary_definitions_app/cubit/application_cubit.dart';
import 'package:dictionary_definitions_app/models/dictionary_entry.dart';
import 'package:dictionary_definitions_app/providers/dialog_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recase/recase.dart';

class SearchHistoryListView extends StatelessWidget {
  const SearchHistoryListView({
    super.key,
    required this.definitionList,
  });

  final List<MapEntry<String, List<Definition?>>> definitionList;

  @override
  Widget build(BuildContext context) {
    final displaySingleDefinition = context.select<ApplicationCubit, bool>(
      (cubit) => cubit.state.singleDefinitionDisplay,
    );

    return ListView.builder(
      itemCount: definitionList.length,
      itemBuilder: (context, index) {
        var entry = definitionList[index];
        var word = entry.key;
        var definitions = entry.value;

        return ListTile(
          title: Stack(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: () async {
                    final cubit = context.read<ApplicationCubit>();

                    final confirmed =
                        await context.read<DialogProvider>().showConfirmation(
                              confirmLabel: 'Yes',
                              title: 'Remove searched definition?',
                              content:
                                  'Are you sure you want to remove this word definition?',
                            );

                    if (confirmed) {
                      cubit.removeSearchItem(word);
                    }
                  },
                  icon: const Icon(Icons.remove_circle),
                  color: Colors.red,
                ),
              ),
              Center(
                child: Text(
                  word.titleCase,
                  style: const TextStyle(fontSize: 20),
                ),
              ),
            ],
          ),
          subtitle: displaySingleDefinition
              ? Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Definition:',
                      ),
                      Text(entry.value.first!.definition.toString()),
                    ],
                  ),
                )
              : Column(
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
                                'Definition ${definitions.indexOf(definition) + 1}:',
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
    );
  }
}
