import 'package:dictionary_definitions_app/cubit/application_cubit.dart';
import 'package:dictionary_definitions_app/providers/dialog_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DefinitionAppBar extends StatefulWidget implements PreferredSizeWidget {
  const DefinitionAppBar({
    super.key,
  });

  @override
  State<DefinitionAppBar> createState() => _DefinitionAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _DefinitionAppBarState extends State<DefinitionAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      actions: const [
        HelpAction(),
        SettingsAction(),
      ],
      title: const Text('Dictionary Definitions'),
      centerTitle: true,
    );
  }
}

class HelpAction extends StatelessWidget {
  const HelpAction({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
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
    );
  }
}

class SettingsAction extends StatefulWidget {
  const SettingsAction({
    super.key,
  });

  @override
  State<SettingsAction> createState() => _SettingsActionState();
}

class _SettingsActionState extends State<SettingsAction> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ApplicationCubit, ApplicationState>(
      builder: (context, state) {
        return IconButton(
          icon: const Icon(Icons.settings),
          onPressed: () => context
              .read<DialogProvider>()
              .showSettingsDialog(context: context),
        );
      },
    );
  }
}
